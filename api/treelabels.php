<?php

include "config_setup.php";
#$config = parse_ini_file('../../../passwords/entangled_bank.ini');
$db_handle = eb_connect_pg($config);

$qstr = $_GET['query'];
$tree_id = $_GET['tree'];

$str = "SELECT label 
	FROM biosql.node 
	WHERE tree_id = $tree_id
	AND label LIKE '%$qstr%'";
$res = pg_query($db_handle, $str);
$labels = pg_fetch_all_columns($res);

print "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n";
print "<labels>\n\t";
foreach ($labels as $label) print "<label>$label</label>\n\t";
print "</labels>\n\t";

?>