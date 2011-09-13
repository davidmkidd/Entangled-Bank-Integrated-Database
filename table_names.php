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

#HTML 
echo '<html>';

#HEAD
echo '<head>';
echo "<title>Names in Sources</title>";
echo '<link type="text/css" rel="stylesheet" href="' . $share_path . 'entangled_bank.css">';
echo '</head>';
#BODY
echo "<div class='main'>";
html_entangled_bank_header($eb_path, $html_path, $share_path, false);

$names = $_SESSION['names'];
$cn = count($names);
#print_r($names);
sort($names);
$sources = $_SESSION['sources'];
$c = count($sources);
$qobjects = $_SESSION['qobjects'];

$mids = query_get_mids($qobjects);

$mc = count($mids);
#CONNECT TO DATABASE
$db_handle = eb_connect_pg($config);

echo "<img src='./image/shoppingCartIcon.gif' alt='Shopping Cart' />";
echo '<big>Shopping Cart </big>';
if ($cn == 1) {
	echo " - $cn name";
} else {
	echo " - $cn names";
}
if ($mids) echo " and $mc series";
echo " selected across $c sources";

# WIKIPEDIA LINKS
$wikipedia_links = array();
foreach ($names as $name) {
	$link = "<a href='http://en.wikipedia.org/wiki/" . str_replace(" ","_",$name) . "' target='_blank'>$name</a>";
	array_push($wikipedia_links, $link);
	}
	
$mat = array();
$mat = add_key_val($mat, 'name (Wikipedia)', $wikipedia_links);

#print_r($names);
$narr = array_to_postgresql($names, "text");

foreach ($sources as $source) {
//	print_r($source);
//	echo "<br>";
	$snames = array();
	$term = $source['term'];
	
	switch ($term) {
		case 'biotable':
		case 'biogeographic':
			$str = "SELECT " . $source['namefield'] . " FROM "
				. $source['dbloc'] . " WHERE " . $source['namefield']
				. " = ANY($narr)";
			break;
		case 'biotree':
			$str = "SELECT label FROM biosql.node WHERE 
				 tree_id = " . $source['tree_id']
				 . " AND label = ANY($narr)";
			break;
		case 'biorelational':
			# GPDD HARDCODE
			if ($mids) $sarr = array_to_postgresql($mids, 'numeric');
			$str = "SELECT t.binomial, COUNT(*) AS n
				 FROM gpdd.taxon t,
				 gpdd.main m
				 WHERE m.\"TaxonID\" = t.\"TaxonID\"";
			if ($sarr) $str = $str." AND m.\"MainID\" = ANY($sarr)";
				 $str = $str."AND t.binomial = ANY($narr)
				 GROUP BY t.binomial";
			break;
		default:
			echo "listnames: " . $source['term'] . "not implemented";
			exit;
			break;
		}
		
	//echo "$str<br>";
	$res = pg_query($db_handle, $str);
	$res_names = pg_fetch_all_columns($res, 0);
	if ($term == 'biorelational') $res_count = pg_fetch_all_columns($res, 1);
	
	foreach ($names as $name) {
		if (in_array($name, $res_names)) {
			if ($term !== 'biorelational') {
				array_push($snames, "<img src='./image/green-dot.gif' />");
			} else {
				$n = $res_count[array_search($name, $res_names)];
				array_push($snames, "<FONT color='green' style='font-style:bold;'>$n</font>");
			}

		} else {
			//array_push($snames, '<FONT color="Red">No</FONT>');
			array_push($snames, "<img src='./image/red-dot.gif' />");
		}
	}
	$mat = add_key_val($mat, $source['name'],$snames);
}
	
echo "<br><br>";
html_arr_to_table($mat);
echo "<br>";

html_entangled_bank_footer();
echo "</div>";
echo "</body>";
echo '</html>';
#Close db handle
pg_close($db_handle);
	
?>

