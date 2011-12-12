<?php

	# RETURNS TRUE IF FIELD HAS NULL VALUES
	# A NAMES QUERY MAY BE APPLIED
	session_start();
	include "../lib/config.php";
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
		$str = 'SELECT COUNT(*)
			FROM ' . $source['dbloc'] .
			" WHERE \"$field\" IS NULL";
		#Get min and max of given names
		if ($arr) $str = $str . " AND " . $source['namefield'] . " = ANY($arr)";
	} else {
		# GPDD
		if ($field == 'nseries') {
			# NSERIES
			$str = "SELECT (0)";
		} else {
			# OTHER FIELDS
			$str = "SELECT COUNT(*)
				FROM gpdd.main m, gpdd.taxon t
				WHERE m.\"TaxonID\" = t.\"TaxonID\"
				AND m.\"$field\" IS NULL";
			if ($arr) $str = $str . " AND t.binomial = ANY($arr)";
			if ($field == 'StartYear') $str = $str . " AND m.\"StartYear\" > 1500";
			if ($field == 'EndYear') $str = $str . " AND m.\"EndYear\" > 1500";
		}

	}

	//echo "$str<br>";	
	$res = pg_query($db_handle, $str);
	$row = pg_fetch_row($res);
	if ($row[0] > 0) {
		$ret = true;
	} else {
		$ret = false;
	}

	echo json_encode($ret);
?>