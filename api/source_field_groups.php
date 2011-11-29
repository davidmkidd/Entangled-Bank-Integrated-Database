<?php

	# RETURNS EB TYPE OF FIELD
	# A QUERY MAY BE APPLIED
	session_start();
	include "../lib/php_utils.php";
	$sid = $_GET['sid'];
	$field = $_GET['field'];
	$sources = $_SESSION['sources'];
	$source = get_obj($sources, $sid);
	$colorhex = $source['colorhex'];
	
	
	$fields = $source['fields'];
	//print_r($fields);
	if ($field) {
		foreach ($fields as $f) {
			//echo $f['name'], ", $field<br>";
			if ($f['name'] == $field) $group = $f['group'];
		}
	}
	
	//echo "$group<br>";
	
	if ($group) {
		foreach ($colorhex as $key => $value) {
			if ($key == $group) $c = $value;
		}
		if ($c) {
			echo json_encode($c);
			return;
		} else {
			return false;
		}
	}
	echo json_encode($colorhex);

?>