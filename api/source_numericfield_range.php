<?php

	# RETURNS DISTINCT VALUES OF A TABLE FIELD
	# A QUERY MAY BE APPLIED
	session_start();
	include "config_setup.php";
	include "../lib/php_utils.php";
	
	$db_handle = eb_connect_pg($config);
	
	$sid = $_GET['sid'];
	$field = $_GET['field'];
	$qnames = $_GET['names'];       # FILTER NAMES
	
	if (!$qnames || $qnames !== 'yes') $qnames = 'no';
	
	if ($qnames == 'yes') {
		if ($_SESSION['names'])
			$arr = array_to_postgresql($_SESSION['names'],'text');
	}

	if (!$sid || !$field) exit("sid=source_id and filed=\$field required");

	$sources = $_SESSION['sources'];
	$source = get_obj($sources, $sid);
	
	
	if ($source['id'] <> 23) {
		# Get min and max of all names
		$str = 'SELECT MIN("' . $field . '"), MAX("' . $field . '")
			FROM ' . $source['dbloc'] .
			" WHERE \"$field\" IS NOT NULL";
		#Get min and max of given names
		if ($arr) $str = $str . " AND " . $source['namefield'] . " = ANY($arr)";
	} else {
		# GPDD
		if ($field == 'nseries') {
			# NSERIES
			$str = "SELECT MIN(n), MAX(n) FROM (
				 SELECT t.binomial, COUNT(*) AS n
				 FROM gpdd.main m,
				 gpdd.taxon t
				 WHERE m.\"TaxonID\" = t.\"TaxonID\"
				 AND t.binomial IS NOT NULL";
			if($arr) $str = $str . " AND t.binomial = ANY($arr)";
			$str = $str . " GROUP BY t.binomial) AS myquery";
		} else {
			# OTHER FIELDS
			$str = "SELECT MIN(m.\"$field\"), MAX(m.\"$field\")
				FROM gpdd.main m, gpdd.taxon t
				WHERE m.\"TaxonID\" = t.\"TaxonID\"
				AND m.\"$field\" IS NOT NULL";
			if ($arr) $str = $str . " AND t.binomial = ANY($arr)";
			if ($field == 'StartYear') $str = $str . " AND m.\"StartYear\" > 1500";
			if ($field == 'EndYear') $str = $str . " AND m.\"EndYear\" > 1500";
		}

	}

	//echo "$str<br>";	
	$res = pg_query($db_handle, $str);
	$vals = pg_fetch_row($res);

	echo json_encode($vals);
?>