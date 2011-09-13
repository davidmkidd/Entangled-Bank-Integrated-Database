<?php

session_start();
include "config_setup.php";
include $config['apt_to_ini_path'] . "/eb_connect_pg.php";
include "html_utils.php";
include "php_utils.php";
include "php_query.php";

$eb_path = "http://" . $config['ebhost'] . "/" . $config['eb_path'] . '/';
$html_path = "http://" . $config['ebhost'] . "/" . $config['html_path'] . '/';
$share_path = "http://" . $config['ebhost'] . "/" . $config['share_path'] . '/';
#CONNECT TO DATABASE
$db_handle = eb_connect_pg($config);

#HTML 
echo '<html>';

#HEAD
echo '<head>';
echo "<title>Series by Name</title>";
echo '<link type="text/css" rel="stylesheet" href="' . $share_path . 'entangled_bank.css">';
echo '</head>';
#BODY
echo "<div class='main'>";
html_entangled_bank_header($eb_path, $html_path, $share_path, false);

$qobjects = $_SESSION['qobjects'];
$names = $_SESSION['names'];
//print_r($names);
//print_r($names);
//echo $qobjects[count($qobjects) - 1] . "<br>";
$mids = query_get_mids($qobjects);
$c = count($mids);
if ($names) {
	$nc = count($names);
} else {
	$nc = 0;
}
//echo $qobjects[count($qobjects) - 2]['series_sql'] . "<br>";

$arr = array_to_postgresql($mids, 'numeric');
$narr = array_to_postgresql($names, 'text');

$str = "SELECT t.binomial, COUNT(*) AS n
	 FROM gpdd.taxon t,
	 gpdd.main m
	 WHERE m.\"TaxonID\" = t.\"TaxonID\"";
	if ($mids) $str = $str . "AND m.\"MainID\" = ANY($arr)";
	 $str = $str . " AND t.binomial IS NOT NULL
	 GROUP BY t.binomial
	 ORDER BY t.binomial";
//echo "$str<br>";
$res = pg_query($str);
$n = pg_num_rows($res);
$snames = pg_fetch_all_columns($res, 0);
$count = pg_fetch_all_columns($res, 1);
$wikipedia_links = array();
foreach ($snames as $sname) {
	$link = "<a href='http://en.wikipedia.org/wiki/" . str_replace(" ","_",$name) . "' target='_blank'>$sname</a>";
	array_push($wikipedia_links, $link);
	}

$mat = array();
$mat = add_key_val($mat, 'Name', $wikipedia_links);
$mat = add_key_val($mat, 'n series', $count);

echo "<img src='./image/shoppingCartIcon.gif' alt='Shopping Cart' />";
echo '<big>Shopping Cart </big>';
echo "- $c time series for $n of $nc names<br>";
echo "<br>";
html_arr_to_table($mat);
echo "<br>";

html_entangled_bank_footer();
echo "</div>";
echo "</body>";
echo '</html>';

#Close db handle
pg_close($db_handle)
	
?>

