<?php

session_start();
include "./lib/config.php";
include "./lib/html_utils.php";
include "./lib/php_utils.php";

$eb_path = "http://" . $config['ebhost'] . "/" . $config['eb_path'] . '/';
$html_path = "http://" . $config['ebhost'] . "/" . $config['html_path'] . '/';
$share_path = "http://" . $config['ebhost'] . "/" . $config['share_path'] . '/';

$names = $_SESSION['names'];

if (!$names) {
	$db_handle = eb_connect_pg($config);
	$names = array();
	$sources = $_SESSION['sources'];
	$str = "SELECT DISTINCT(name) FROM (";
	$i = 0;
	foreach ($sources as $source) {
		if ($i > 0) $str = $str . " UNION ALL";
		switch ($source['term']) {
			case 'biotable':
			case 'biogeographic':
				$str = $str . " SELECT " . $source['namefield'] . " AS name FROM " . $source['dbloc'];
				break;
			case 'biotree':
				$str = $str . " SELECT label  AS name FROM biosql.node WHERE tree_id=" . $source['tree_id'];
				break;
			case 'biorelational':
				$str = $str . " SELECT t.binomial AS name FROM gpdd.taxon t, gpdd.main m WHERE m.\"TaxonID\"=t.\"TaxonID\"";
				break;
		}
		$i++;
	}
	$str = $str . ") AS name";
	//echo "$str<br>";
	$res = pg_query($db_handle, $str);
	$names = pg_fetch_all_columns($res);
}

sort($names);
$c = count($names);


#HTML 
echo '<html>';

#HEAD
echo '<head>';
echo "<title>Names Info</title>";
echo '<link type="text/css" rel="stylesheet" href="' . $share_path . 'entangled_bank.css">';
echo '</head>';
echo '<script src="./scripts/utils.js" type="text/javascript"></script>';

#BODY
echo "<body>";
echo "<div id='page'>";
html_entangled_bank_header($stage, $eb_path, $html_path, $share_path);

# HEADER
echo "<div id='info_header_div' class='header_div'>";
echo "<table border='0'>";
echo "<tr>";
echo "<td class='query_title'>", html_query_image('bionames', 'non-active', null, 'source', false), "</td>";
echo "<td id='query_header_title'>Names</td>";
echo "</tr>";
echo "</table>";
echo "</div>";

# INFO
echo "<table>";
echo "<tr>";
$t = "Names list format";
echo "<td class='query_title' title='$t'>Names</td>";
echo "<td>$c</td>";
echo "</tr>";

$i = 0;
$str = "";
//sort($names);
foreach($names as $name) {
	if ($i == 0) {
		$str = $name;
	} else {
		$str = $str . "\n$name";
	}
	$i++;
}
echo "<tr>";
echo "<td class='query_title' title='$t'>Names</td>";
echo "<td>";
echo "<textarea id='names_list' class='names_list'>$str</textarea>";
echo "</td>";
echo "</tr>";

html_queries_sql($_SESSION['qobjects']);
echo "</table>";
echo "<br>";
html_entangled_bank_footer();
echo "</div>";
echo "</body>";
echo '</html>';
	
?>

