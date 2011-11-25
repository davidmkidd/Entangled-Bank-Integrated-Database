<?php

	# RETURNS EB TYPE OF FIELD
	# A QUERY MAY BE APPLIED
	session_start();
	include "../lib/php_utils.php";
	$sid = $_GET['sid'];
	$field = $_GET['field'];
	$sources = $_SESSION['sources'];
	$source = get_obj($sources, $sid);
	$fields = $source['fields'];
	if ($fields) {
		$i = 0;
		for ($i = 0; $i <= (count($fields) - 1); $i++) {
			$f = $fields[$i];
			if ($f['name'] == $field) $f2 = $f;
		}
		echo json_encode($f2);
	} else {
		return false;
	}

?>