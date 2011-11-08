<?php

	# RESTFUL API FOR QUERYING NAMES IN SOURCES
	session_start();
	include "config_setup.php";
	include "../php_utils.php";
	
	#$config = parse_ini_file('../../../passwords/entangled_bank.ini');
	$db_handle = eb_connect_pg($config);
	
	$query = $_GET['query'];
	$sids = $_GET['sids'];
	//echo "$sids<br>";
	$sids = explode(' ', $sids);
	//print_r($sids);
	//echo '<br>';
	$n = $_GET['n'];
	$op = $_GET['op'];
	$op = str_replace("'", "", stripslashes($op));
	$sources = $_SESSION['sources'];
	
	$str = "SELECT names FROM (";
	$i = 0;
	foreach ($sources as $source) {
		$id = $source['id'];
		//$id = $id + 0;
		//echo $id . "," . is_numeric($id) . "<br>";
		//echo $source['name'], ", ", $id . ", " . in_array($id, $sids) . "<br>";
		if (in_array($id, $sids)) {
			if ($i > 0) $str = $str . " UNION ALL";
			switch ($source['term']) {
				case 'biotable':
				case 'biogeographic':
					$str = $str . " SELECT DISTINCT " . $source['namefield'] . " AS name FROM " . $source['dbloc'];
					$str = $str . " WHERE " . $source['namefield'] . " LIKE '%$query%'";
					break;
				case 'biotree':
					$str = $str . " SELECT DISTINCT label AS name FROM biosql.node WHERE tree_id=" . $source['tree_id'];
					$str = $str . " AND label LIKE '%$query%'";
					break;
				case 'biorelational':
					$str = $str. " SELECT DISTINCT t.binomial AS name FROM gpdd.taxon t, gpdd.main m WHERE m.\"TaxonID\"=t.\"TaxonID\"";
					$str = $str. " AND t.binomial IS NOT NULL AND t.binomial LIKE '%$query%'";
					break;
			}	
		$i++;
		}
	}
	$str = $str . ") as names GROUP BY names HAVING COUNT(*) $op $n";
	//echo "$str<br>";
	$res = pg_query($db_handle, $str);
	$names = pg_fetch_all_columns($res);

	echo json_encode($names);

?>