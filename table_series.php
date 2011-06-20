<?php

session_start();
include "config_setup.php";
include $config['apt_to_ini_path'] . "/eb_connect_pg.php";
include "html_utils.php";
include "php_utils.php";

$eb_path = "http://" . $config['host'] . "/" . $config['eb_path'] . '/';
$html_path = "http://" . $config['host'] . "/" . $config['html_path'] . '/';
$share_path = "http://" . $config['host'] . "/" . $config['share_path'] . '/';
#CONNECT TO DATABASE
$db_handle = eb_connect_pg($config);

#HTML 
echo '<html>';

#HEAD
echo '<head>';
echo "<title>Series Table</title>";
echo '<link type="text/css" rel="stylesheet" href="' . $share_path . 'entangled_bank.css">';
echo '</head>';
#BODY

html_entangled_bank_header($eb_path, $html_path, $share_path);

$qobjects = $_SESSION['qobjects'];
#$names = $_SESSION['names'];
//print_r($names);
//print_r($names);
//echo $qobjects[count($qobjects) - 1] . "<br>";
$mids = get_mids($qobjects);
$c = count($mids);
if ($names) {
	$nc = count($names);
} else {
	$nc = 0;
}
//echo $qobjects[count($qobjects) - 2]['series_sql'] . "<br>";

echo "<img src='shoppingCartIcon.gif' alt='Shopping Cart' />";
echo '<big>Shopping Cart </big>';
echo "- $c series<br>";

if ($mids) $marr = array_to_postgresql($mids, 'numeric');
#if ($names) $narr = array_to_postgresql($names, 'text');

$str = "SELECT m.\"MainID\" AS mid,
 t.binomial AS name,
 l.\"ExactName\",
 m.\"StartYear\", 
 m.\"EndYear\", 
 m.\"DatasetLength\",
 l.\"Country\"
 FROM gpdd.taxon t, gpdd.main m, gpdd.location l
 WHERE m.\"TaxonID\" = t.\"TaxonID\"
 AND m.\"LocationID\" = l.\"LocationID\"";
if ($mids) $str = $str . "AND m.\"MainID\" = ANY($marr)";
$str = $str . " AND t.binomial IS NOT NULL
 ORDER BY t.binomial, m.\"MainID\"";
//echo "$str<br>";
$res = pg_query($str);
$mids = pg_fetch_all_columns($res, 0);
$names = pg_fetch_all_columns($res, 1);
$locs = pg_fetch_all_columns($res, 2);
$locs_country = pg_fetch_all_columns($res, 6);
$start = pg_fetch_all_columns($res, 3);
$finish = pg_fetch_all_columns($res, 4);
$obs = pg_fetch_all_columns($res, 5);

#$nyear = $finish - $start;
//foreach ($start as $s) if ($s == -9999) $s = null;
//foreach ($finish as $f) if ($f == -9999) $f = null;
//$time = (int)$s - (int)$f;


$wikipedia_links = array();
foreach ($names as $name) {
	$link = "<a href='http://en.wikipedia.org/wiki/" . str_replace(" ","_",$name) . "' target='_blank'>$name</a>";
	array_push($wikipedia_links, $link);
	}

$mat = array();
$mat = add_key_val($mat, 'Name', $wikipedia_links);
$mat = add_key_val($mat, 'MainID', $mids);
$mat = add_key_val($mat, 'Start', $start);
$mat = add_key_val($mat, 'Finish', $finish);
$mat = add_key_val($mat, 'Obs', $obs);
//$mat = add_key_val($mat, 'Period', $time);
$mat = add_key_val($mat, 'Location', $locs);
$mat = add_key_val($mat, 'Country', $locs_country);
echo "<br>";
html_arr_to_table($mat);
echo "<br>";

html_entangled_bank_footer();

	
?>

