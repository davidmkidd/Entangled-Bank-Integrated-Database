<?php
//File: eb_connect_pg.php
//Connection details for the database.  This file should be kept private.
// move configuration file to secrue location below htdocs dir

Function eb_connect_pg($config) {
	$connect_string = "host=" . $config['host'];
	$connect_string = $connect_string . " port=" . $config['port'];
	$connect_string = $connect_string . " user=" . $config['user']; 
	$connect_string = $connect_string . " password=" . $config['password'];
	$connect_string = $connect_string . " dbname=" . $config['dbname'];
	#echo "str: $connect_string";
	$db_handle = pg_connect($connect_string);
	return $db_handle;
}

?>