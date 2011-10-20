<?php

session_start();

include "config_setup.php";
include $config['apt_to_ini_path'] . "/eb_connect_pg.php";
include "html_utils.php";
include "php_utils.php";
#include "php_interface_subs.php";

$eb_path = "http://" . $config['ebhost'] . "/" . $config['eb_path'] . '/';
$html_path = "http://" . $config['ebhost'] . "/" . $config['html_path'] . '/';
$share_path = "http://" . $config['ebhost'] . "/" . $config['share_path'] . '/';

$sid = $_GET['id'];
//echo "sid: $sid<br>";
$sources = $_SESSION['sources'];
$names = $_SESSION['names'];
$arr = array_to_postgresql($names,'text');

$source = get_obj($sources, $sid);
$sname = $source['name'];
$sterm = $source['term'];
$snamefield = $source['namefield'];
$sdbloc = $source['dbloc'];
$treeid = $source['tree_id'];

$db_handle = eb_connect_pg($config);

#HTML 
echo '<html>';

#HEAD
echo '<head>';
echo "<title>", $source['name'] , " Info</title>";
echo '<link type="text/css" rel="stylesheet" href="' . $share_path . 'entangled_bank.css">';
echo '</head>';
#BODY
echo "<div class='main'>";
html_entangled_bank_header($eb_path, $html_path, $share_path, false);

# Names in query
switch ($sterm) {
	case 'biotree' :
		$str = "SELECT biosql.pdb_labels_in_tree($treeid, $arr);";
		break;
	case 'biotable':
	case 'biogeographic':
		$str = "SELECT $snamefield FROM $sdbloc WHERE $snamefield = ANY($arr)";
		break;
	case 'biorelational':
		$str = "SELECT \"binomial\" FROM gpdd.taxon WHERE \"binomial\" = ANY($arr)";
		break;
}
$res = pg_query($db_handle, $str);
$names_in_query = pg_fetch_all_columns($res);

# Tree tips
if ($sterm == 'biotree') {
	$str = "SELECT COUNT(*) FROM biosql.node n WHERE n.tree_id = $treeid AND n.left_idx = (n.right_idx - 1) AND n.label = ANY($arr);";
	$res = pg_query($db_handle, $str);
	$row = pg_fetch_row($res);
	$tips_in_query = $row[0];
}

# GPDD Time Series
if ($sterm == 'biorelational') {
	$mids = $_SESSION['mids'];
	$marr = array_to_postgresql($mids, 'numeric');
	$str = "SELECT COUNT(*) FROM gpdd.data d, gpdd.main m WHERE m.\"MainID\" = ANY($marr)";
	$res = pg_query($db_handle, $str);
	$row = pg_fetch_row($res);
	$datapoints = $row[0];
}



echo "<table>";
echo "<tr>";
echo "<td class='query_title'>Source</td>";
echo "<td>", $source['name'], "</td>";
echo "</tr>";

echo "<tr>";
echo "<td class='query_title'>Has</td>";
echo "<td>", number_format($source['n']), " names </td>";
echo "</tr>";

echo "<tr>";
echo "<td class='query_title'>Query</td>";
echo "<td>", count($names), " names</td>";
echo "</tr>";

echo "<tr>";
echo "<td class='query_title'>Selected</td>";
echo "<td>", count($names_in_query), " names</td>";
echo "</tr>";

if ($sterm == 'biotree') {
	echo "<tr>";
	echo "<td class='query_title'></td>";
	echo "<td>", $tips_in_query, " tip OTUs</td>";
	echo "</tr>";
	
	echo "<tr>";
	echo "<td class='query_title'></td>";
	echo "<td>", count($names_in_query) - $tips_in_query, " internal nodes</td>";
	echo "</tr>";
}

if ($sterm == 'biorelational') {
	echo "<tr>";
	echo "<td class='query_title'>Time Series</td>";
	echo "<td>", count($mids), " series</td>";
	echo "</tr>";
	echo "<tr>";
	echo "<td class='query_title'></td>";
	echo "<td>", $datapoints, " data pints</td>";
	echo "</tr>"
}


$i = 0;
$str = "";
foreach($names_in_query as $name) {
	if ($i == 0) {
		$str = $name;
	} else {
		$str = $str . "\n$name";
	}
	$i++;
}
echo "<tr>";
echo "<td class='query_title'>Names</td>";
echo "<td>";
echo "<textarea rows='15' cols='45'>$str</textarea>";
echo "</td>";
echo "</tr>";
echo "<table>";

html_entangled_bank_footer();
echo "</div>";
echo "</body>";
echo '</html>';
#Close db handle

pg_close($db_handle);


?>
