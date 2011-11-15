<?php

session_start();

include "./lib/config_setup.php";
include $config['apt_to_ini_path'] . "/eb_connect_pg.php";
include "./lib/html_utils.php";
include "./lib/php_utils.php";
include "./lib/php_query.php";


$eb_path = "http://" . $config['ebhost'] . "/" . $config['eb_path'] . '/';
$html_path = "http://" . $config['ebhost'] . "/" . $config['html_path'] . '/';
$share_path = "http://" . $config['ebhost'] . "/" . $config['share_path'] . '/';

$sid = $_GET['id'];
$sources = $_SESSION['sources'];
$names = $_SESSION['names'];

if ($names && !empty($names)) $arr = array_to_postgresql($names,'text');

$db_handle = eb_connect_pg($config);
$source = get_obj($sources, $sid);
$sname = $source['name'];
$sterm = $source['term'];
$snamefield = $source['namefield'];
$sdbloc = $source['dbloc'];
$treeid = $source['tree_id'];
#HTML 
echo '<html>';

#HEAD
echo '<head>';
echo '<script src="./scripts/utils.js" type="text/javascript"></script>';

echo "<title>Info - ", $source['name'] , "</title>";
echo '<link type="text/css" rel="stylesheet" href="' . $share_path . 'entangled_bank.css">';
echo '</head>';
#BODY
echo "<div class='main'>";
html_entangled_bank_header($eb_path, $html_path, $share_path, false);
//echo "<br>";

echo "<table>";

# Names in query
switch ($sterm) {
	case 'biotree' :
		if (!$arr) {
			$str = "SELECT label FROM biosql.node WHERE tree_id = $treeid";
		} else {
			$str = "SELECT biosql.pdb_labels_in_tree($treeid, $arr)";
		}
		break;
	case 'biotable':
	case 'biogeographic':
		$str = "SELECT $snamefield FROM $sdbloc";
		if ($arr) $str = $str . " WHERE $snamefield = ANY($arr)";
		break;
	case 'biorelational':
		$str = "SELECT t.\"binomial\" 
			FROM gpdd.taxon t, gpdd.main m 
			WHERE m.\"TaxonID\" = t.\"TaxonID\"
			AND t.\"binomial\" IS NOT NULL";
		if ($arr) $str = $str .  " AND \"binomial\" = ANY($arr)";
		break;
}
$res = pg_query($db_handle, $str);
$names_in_query = pg_fetch_all_columns($res);

# Tree tips
if ($sterm == 'biotree') {
	# TREE TYPE
	$str = "SELECT biosql.pdb_tree_type($treeid)";
	//echo "str: $str<br>";
	$res = pg_query($db_handle, $str);
	$row = pg_fetch_row($res);
	$type = $row[0];
	//echo "type: $type<br>";
	if ($type == 'phylogeny') {
		$str = "SELECT COUNT(*) FROM biosql.node n WHERE n.tree_id = $treeid AND n.left_idx = (n.right_idx - 1)";
		if ($arr) $str = $str .  " AND n.label = ANY($arr)";
		$res = pg_query($db_handle, $str);
		$row = pg_fetch_row($res);
		$tips_in_query = $row[0];
	} else {
		# Taxonomy
		$str = "SELECT t.name, COUNT(*) AS n
			FROM biosql.node n,
			biosql.term t,
			biosql.node_qualifier_value nq
			WHERE nq.node_id = n.node_id
			AND nq.term_id = t.term_id
			AND n.tree_id = $treeid";
		if ($arr) $str = $str . "	AND n.label = ANY($arr)";
		$str = $str . "GROUP BY t.name, t.identifier ORDER BY t.identifier DESC;";
		$res = pg_query($db_handle, $str);
		$levels = pg_fetch_all($res);
		//print_r($levels);
	}
}

# GPDD MIDS AND DATA POINTS
if ($sterm == 'biorelational') {
	$mids = query_get_mids($qobjects);
	if ($mids) {
		$marr = array_to_postgresql($mids, 'numeric');
		$str = "SELECT COUNT(*) FROM gpdd.data d, gpdd.main m WHERE m.\"MainID\" = d.\"MainID\" AND m.\"MainID\" = ANY($marr)";
	} else {
		$str = "SELECT m.\"MainID\"
			FROM gpdd.main m, gpdd.taxon t 
			WHERE m.\"TaxonID\" = t.\"TaxonID\"
			AND t.\"TaxonID\" IS NOT NULL";
		$res = pg_query($db_handle, $str);
		$mids = pg_fetch_all_columns($res);
		$str = "SELECT COUNT(*) 
			FROM gpdd.data d, gpdd.main m, gpdd.taxon t 
			WHERE m.\"MainID\" = d.\"MainID\" 
			AND m.\"TaxonID\" = t.\"TaxonID\"
			AND t.\"TaxonID\" IS NOT NULL";
	}
	
	$res = pg_query($db_handle, $str);
	$row = pg_fetch_row($res);
	$datapoints = $row[0];
}

//echo "<tr><td class='query_title'>" . html_query_image($source['term'], 'non-active', null, 'source', false) . "</td></tr>";

echo "<tr>";
echo "<td class='query_title'>Source</td>";
echo "<td>", html_query_image($source['term'], 'non-active', null, 'source', false), "&nbsp;&nbsp;", $source['name'], "</td>";
echo "</tr>";

echo "<tr>";
echo "<td class='query_title'>Has</td>";
echo "<td>", number_format($source['n']), " names </td>";
echo "</tr>";

# NAMES IN QUERY
if ($names) {
	$n = count($names);
} else {
	$n = $source['n'];
}
echo "<tr>";
echo "<td class='query_title'>Query</td>";
echo "<td>", number_format($n), " names</td>";
echo "</tr>";

echo "<tr>";
echo "<td class='query_title'>Selected</td>";
echo "<td>", number_format(count($names_in_query)), " names</td>";
echo "</tr>";

if ($sterm == 'biotree') {
	if ($type == 'phylogeny') {
		echo "<tr>";
		echo "<td class='query_title'></td>";
		echo "<td>", number_format($tips_in_query), " tip OTUs</td>";
		echo "</tr>";
		echo "<tr>";
		echo "<td class='query_title'></td>";
		echo "<td>", number_format(count($names_in_query) - $tips_in_query), " internal OTUs</td>";
		echo "</tr>";
	} else {
		foreach ($levels as $level) {
			echo "<tr>";
			echo "<td class='query_title'>", ucwords($level['name']), "</td>";
			echo "<td>", number_format($level['n']), " names</td>";
			echo "</tr>";	
		}
	}
}

if ($sterm == 'biorelational') {
	echo "<tr>";
	echo "<td class='query_title'>Time Series</td>";
	echo "<td>", number_format(count($mids)), " series</td>";
	echo "</tr>";
	echo "<tr>";
	echo "<td class='query_title'></td>";
	echo "<td>", number_format($datapoints), " observations</td>";
	echo "</tr>";
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
echo "<textarea id='names_list' class='names_list' >$str</textarea>";
echo "</td>";
echo "</tr>";

echo "<tr>";
$t = "Names list format";
echo "<td class='query_title' title='$t'>Names Format</td>";
echo "<td>";
echo "<SELECT id='names_format' class='eb_info' onChange='textareaFormat(\"names_list\")'>";
echo "<OPTION value='0'>Not Delineated with New Line Separator</OPTION>";
echo "<OPTION value='1'>Delineated with New Line Separator</OPTION>";
echo "<OPTION value='2'>Not Delineated with Comma Separator</OPTION>";
echo "<OPTION value='3'>Delineated with Comma Separator</OPTION>";
echo "</SELECT>";
echo "<td>";
echo "</tr>";


if ($sterm == 'biorelational') {
	
	$i = 0;
	$str = "";
	foreach($mids as $mid) {
		if ($i == 0) {
			$str = $mid;
		} else {
			$str = $str . "\n$mid";
		}
		$i++;
	}
	echo "<tr>";
	echo "<td class='query_title'>Series</td>";
	echo "<td>";
	echo "<textarea id='series_list' class='names_list' >$str</textarea>";
	echo "</td>";
	echo "</tr>";
	
	echo "<tr>";
	$t = "Series list format";
	echo "<td class='query_title' title='$t'>Series Format</td>";
	echo "<td>";
	echo "<SELECT id='series_format' class='eb_info' onChange='textareaFormat(\"series_list\")'>";
	echo "<OPTION value='0'>Not Delineated with New Line Separator</OPTION>";
	echo "<OPTION value='1'>Delineated with New Line Separator</OPTION>";
	echo "<OPTION value='2'>Not Delineated with Comma Separator</OPTION>";
	echo "<OPTION value='3'>Delineated with Comma Separator</OPTION>";
	echo "</SELECT>";
	echo "<td>";
	echo "</tr>";
}	


echo "<table>";
echo "<br>";
html_entangled_bank_footer();
echo "</div>";
echo "</body>";
echo '</html>';
#Close db handle

pg_close($db_handle);


?>
