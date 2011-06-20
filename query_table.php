<?php

session_start();

include "config_setup.php";
include $config['apt_to_ini_path'] . "/eb_connect_pg.php";
include "html_utils.php";
include "php_utils.php";
include "php_query.php";

$eb_path = "http://" . $config['host'] . "/" . $config['eb_path'] . '/';
$html_path = "http://" . $config['host'] . "/" . $config['html_path'] . '/';
$share_path = "http://" . $config['host'] . "/" . $config['share_path'] . '/';

#HTML 
echo '<html>';

#HEAD
echo '<head>';
echo "<title>Names in Queries</title>";
echo '<link type="text/css" rel="stylesheet" href="' . $share_path . 'entangled_bank.css">';
echo '</head>';
#BODY

html_entangled_bank_header($eb_path, $html_path, $share_path, false);

#CONNECT TO DATABASE
$db_handle = eb_connect_pg($config);

$names = $_SESSION['names'];
$sources = $_SESSION['sources'];
$qobjects = $_SESSION['qobjects'];

$arr = array_to_postgresql($names, "text");
$allqnames = array();
$qarr = array();

foreach ($qobjects as $qobject) {
	$qnames = query($db_handle, $qobject, $qobjects, null, $sources);
	$qnames = $qnames[1];
	# Append to allqnames
	$allqnames = array_unique(array_merge($allqnames, $qnames));
	$qarr = add_key_val($qarr, $qobject['name'], $qnames);
	}
	
echo "count " . count($qnames) . "<br>";	
sort($allqnames);

# WIKIPEDIA LINKS
$wikipedia_links = array();
foreach ($allqnames as $name) {
	$link = "<a href='http://en.wikipedia.org/wiki/" . str_replace(" ","_",$name) . "' target='_blank'>$name</a>";
	array_push($wikipedia_links, $link);
	}
	
$mat = array();
$mat = add_key_val($mat, 'name (click for Wikipedia)', $wikipedia_links);
$i = 0;

# HEADING
$q = count($qobjects);
$c = count($allqnames);

echo "<img src='shoppingCartIcon.gif' alt='Shopping Cart' />";
echo '<big>Shopping Cart </big>';
echo "- $c names in $q ";
if ($q == 1) {
	echo " query";
	} else {
	echo " queries";
	}
echo "<br>";
#echo "allqnames: " . count($allqnames) . "<br>";
foreach ($qarr as $key=>$values) {
	$qnames= array();
	foreach ($allqnames as $qname) {
		if (in_array($qname, $values)) {
			array_push($qnames, 'Yes');
			} else {
			array_push($qnames, '<FONT color="Red">No</FONT>');
			}
		}
		//echo "Query " . $key . " contains " . count($values) . " of the " . count($allqnames) . " selected names<br>";
		$mat = add_key_val($mat, $key, $qnames);
		$i++;
	}	

	
echo "<br>";
html_arr_to_table($mat);
echo "<br>";

html_entangled_bank_footer();

#Close db handle
pg_close($db_handle);
	
?>

