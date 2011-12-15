<?php

session_start();

include "./lib/config.php";
include "./lib/html_utils.php";
include "./lib/php_utils.php";

$eb_path = "http://" . $config['ebhost'] . "/" . $config['eb_path'] . '/';
$html_path = "http://" . $config['ebhost'] . "/" . $config['html_path'] . '/';
$share_path = "http://" . $config['ebhost'] . "/" . $config['share_path'] . '/';

$db_handle = eb_connect_pg($config);

$names = $_SESSION['names'];
$sources = $_SESSION['sources'];
$c = count($sources);
$nmids = -1;

foreach($sources as $source) {
	if ($source['id'] == 23) {
		$qobjects = $_SESSION['qobjects'];
		$mids = $qobjects[count($qobjects) - 1]['series'];
	}
}
	
$s_id = array();
$s_name = array();
$s_type = array();
$s_n = array();
$s_ns = array();
$s_code = array();

foreach ($sources as $source) {

	array_push($s_id, $source['id']);
	$val = "<a href= " . $source['www'] . "target=_blank> " . $source['name'] . "</a>";
	array_push($s_name, $val);
	array_push($s_type, html_query_image($source['term'], 'non-active',null, 'source', true));
	array_push($s_code, $source['code']);
		
	if ($names) $arr = array_to_postgresql($names, "text");
					
	switch ($source['term']) {
		
		case 'biotree':
			
			#INTERNAL
			$str = "SELECT COUNT(*)
				FROM biosql.node
				WHERE tree_id = " . $source['tree_id']
				. " AND right_idx - left_idx <> 1";
			$res = pg_query($db_handle, $str);
			$row = pg_fetch_row($res);
			$int = $row[0];
			if ($arr) {
				$str = $str . " AND label = ANY($arr)";
				$res = pg_query($db_handle, $str);
				$row = pg_fetch_row($res);
				$nint = $row[0];
			} else {
				$nint = $int;
			}

			#TIP
			$str = "SELECT COUNT(*)
				FROM biosql.node
				WHERE tree_id = " . $source['tree_id']
				. " AND right_idx - left_idx = 1";
			$res = pg_query($db_handle, $str);
			$row = pg_fetch_row($res);
			$tip = $row[0];
			if ($arr) {
				$str = $str . " AND label = ANY($arr)";
				$res = pg_query($db_handle, $str);
				$row = pg_fetch_row($res);
				$ntip = $row[0];
			} else {
				$ntip = $tip;
			}
			$val = number_format($tip) . "/" . number_format($int)  . " (" . number_format($int + $tip) . ")";
			array_push($s_n, $val);
			$val = number_format($ntip) . "/" . number_format($nint) . " (" .  number_format($nint + $ntip) . ")";
			array_push($s_ns, $val);
			break;
			
		case 'biotable':
		case 'biogeographic':
			$str = "SELECT COUNT(*) FROM " . $source['dbloc'];
			$res = pg_query($db_handle, $str);
			$row = pg_fetch_row($res);
			$val = number_format($row[0]);
			array_push($s_n, $val);
			if ($arr) $str = $str . " WHERE " . $source['namefield'] . " = ANY($arr)";
			$res = pg_query($db_handle, $str);
			$row = pg_fetch_row($res);
			$val = number_format($row[0]);
			array_push($s_ns, $val);
			break;
			
		case 'biorelational':
			//GPDD HARDCODE
			# NAMES
			$str = "SELECT COUNT(*) FROM (
				 SELECT DISTINCT t.binomial
				 FROM gpdd.main m, gpdd.taxon t, gpdd.datasource ds
				 WHERE t.\"TaxonID\" = m.\"TaxonID\"
				 AND ds.\"DataSourceID\" = m.\"DataSourceID\"
				 AND ds.\"Availability\" <> 'Restricted') AS foo";
			$res = pg_query($db_handle, $str);
			$row = pg_fetch_row($res);
			$taxa = number_format($row[0]);
	
			
			$str = "SELECT COUNT(*) FROM (
				 SELECT DISTINCT t.binomial
				 FROM gpdd.main m, gpdd.taxon t, gpdd.datasource ds
				 WHERE t.\"TaxonID\" = m.\"TaxonID\"
				 AND ds.\"DataSourceID\" = m.\"DataSourceID\"
				 AND ds.\"Availability\" <> 'Restricted'";			
			if ($arr) $str = $str . " AND t.binomial = ANY ($arr)";
			$str = $str . ") AS foo";
			$res = pg_query($db_handle, $str);
			$row = pg_fetch_row($res);
			$ntaxa = number_format($row[0]);

			# SERIES
			$str = "SELECT COUNT(*) FROM (
				 SELECT m.\"MainID\"
				 FROM gpdd.main m, gpdd.taxon t, gpdd.datasource ds
				 WHERE t.\"TaxonID\" = m.\"TaxonID\"
				 AND ds.\"DataSourceID\" = m.\"DataSourceID\"
				 AND ds.\"Availability\" <> 'Restricted') AS foo";
			$res = pg_query($db_handle, $str);
			$row = pg_fetch_row($res);
			$nmids = number_format($row[0]);
			
			$val = "$taxa/$nmids";
			array_push($s_n, $val);
			if ($mids) $nmids = count($mids);
			$val = "$taxa/$nmids";
			array_push($s_ns, $val);
			break;
			
		default:
			echo $source['term'] . " is not a recognised source:term";
			break;
		}
	
	}
	
$arr = array('id'=>$s_id, 'type'=>$s_type, 'name'=>$s_name, 'code'=>$s_code, 'in source*'=>$s_n, 'selected*'=>$s_ns);

#HTML 
echo '<html>';

#HEAD
echo '<head>';
echo "<title>Info - Sources</title>";
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
echo "<td class='query_title'>";
echo "<image src='./image/logo-small.gif' alt='small logo' width='45px' />";
echo "</td>";
echo "<td id='info_header_title'>Info: Datasets</td>";
echo "</tr>";
echo "</table>";
echo "</div>";

echo "<br>";
html_info_sources_table($arr);
echo "<br>";
echo "*Table - names <br>";
echo "*Tree - names at tip/internal (all)<br>";
echo "*Global Population Dynamics Database - names/time-series<br>";

html_entangled_bank_footer();
echo "</div>";
echo "</body>";
echo '</html>';
#Close db handle
pg_close($db_handle);


function html_info_sources_table($arr) {
	
	$keys = array_keys($arr);

	# Check same number of keys in each subarray
	$first = true;
	foreach ($keys as $key) {
		if ($first) {
			$c = count($arr[$key]);
			$first = false;
			} else {
			if (count($arr[$key]) != $c) {
				echo "html_arr_to_table: different sized subarray $key";
				}
			}
		}
	
	$sids = $arr['id'];
	# TABLE
	echo "<TABLE BORDER='0'>";
	
	# TABLE HEADERS
	echo "<tr >";
	//echo "<th></th>";
	echo "<th class='source_table_header'>id</th>";
	echo "<th class='source_table_header'>Name</th>";
	echo "<th class='source_table_header'>Code</th>";
	echo "<th class='source_table_header'>Has*</th>";
	echo "<th class='source_table_header'>Selected*</th>";
	//foreach ($keys as $key) echo "<th>$key</th>";
	echo "</tr>";
	
	$i = 0;
	foreach ($sids as $sid) {
		echo "<tr>";
		echo "<td class='query_title'>", $arr['type'][$i], "&nbsp;$sid</td>";
		//echo "<td>", , "</td>";
		echo "<td>", $arr['name'][$i], "</td>";
		echo "<td>", $arr['code'][$i], "</td>";
		echo "<td>", $arr['in source*'][$i], "</td>";
		echo "<td>", $arr['selected*'][$i], "</td>";
		echo "</tr>";
		$i++;
	}
	echo "</TABLE>";
}

?>
