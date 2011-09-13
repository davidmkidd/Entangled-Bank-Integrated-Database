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

#HTML 
echo '<html>';

#HEAD
echo '<head>';
echo "<title>Sources</title>";
echo '<link type="text/css" rel="stylesheet" href="' . $share_path . 'entangled_bank.css">';
echo '</head>';
#BODY
echo "<div class='main'>";
html_entangled_bank_header($eb_path, $html_path, $share_path, false);

$db_handle = eb_connect_pg($config);

$names = $_SESSION['names'];
$sources = $_SESSION['sources'];
	//echo "qobject: ";
//print_r($_SESSION['qobjects']);
	//echo "<br>";
$c = count($sources);
$nmids = -1;
foreach($sources as $source) {
	if ($source['id'] == 23) {
		$qobjects = $_SESSION['qobjects'];
		$mids = $qobjects[count($qobjects) - 1]['series'];
		//echo count($mids);
		$nmids = count($mids);
	}
}
//echo "$nmids<br>";
//echo "<h3>Sources</h3>";

echo "<img src='./image/shoppingCartIcon.gif' alt='Shopping Cart' />";
echo '<big>Shopping Cart </big>';


if (!$names) {
	echo " - 0 names from $c sources";
	} else {
		if ($nmids !== -1) {
			echo " - " .count($names) . " names and " . $nmids . " series from $c sources";
		} else {
			echo " - " .count($names) . " names from $c sources";	
		}
	}
//echo "<HR>";
echo "<br>";
	
$s_id = array();
$s_name = array();
$s_type = array();
$s_n = array();
$s_ns = array();
$s_code = array();

foreach ($sources as $source) {

//	echo "source: ";
//	print_r($source);
//	echo "<br>";
	
	array_push($s_id, $source['id']);

	$val = "<a href= " . $source['www'] . "target=_blank> " . $source['name'] . "</a>";
	array_push($s_name, $val);
	array_push($s_type, html_query_image($source, 30, null, 'source', true));
	// array_push($s_type, $source['term']);
	array_push($s_code, $source['code']);
	
		
	switch ($source['term']) {
		case 'biotree':
			$val = number_format($source['ntip']) . "/" . number_format($source['nint'])  . " (" . number_format($source['n']) . ")";
			break;
		case 'biotable':
		case 'biogeographic':
			$val = number_format($source['n']);
			break; 
		case 'biorelational':
			$val = "1,522/" . number_format($source['n']);
			break;
		default:
			echo "Not recognised source:term";
			break;
	}

	array_push($s_n, $val);
		
		if ($names) {
		
			$arr = array_to_postgresql($names, "text");
					
			switch ($source['term']) {
				
				case 'biotree':
					#Internal nodes
					$str = "SELECT COUNT(*)
						FROM biosql.node
						WHERE label = ANY($arr)
						AND tree_id = " . $source['tree_id']
						. "AND right_idx - left_idx <> 1";
					$res = pg_query($db_handle, $str);
					$row = pg_fetch_row($res);
					$nint = $row[0];
					#Tip nodes
					$str = "SELECT COUNT(*)
						FROM biosql.node
						WHERE label = ANY($arr)
						AND tree_id = " . $source['tree_id']
						. "AND right_idx - left_idx = 1";
					$res = pg_query($db_handle, $str);
					$row = pg_fetch_row($res);						
					$val = number_format($row[0]) . "/" . number_format($nint) . " (" .  number_format($row[0] + $nint) . ")";
					break;
					
				case 'biotable':
				case 'biogeographic':
					$str = "SELECT COUNT(*)
						FROM " . $source['dbloc']
						. " WHERE " . $source['namefield'] . " = ANY($arr)";
					#echo $str . "<br>";
					$res = pg_query($db_handle, $str);
					$row = pg_fetch_row($res);
					$val = number_format($row[0]);
					break;
					
				case 'biorelational':
					//GPDD HARDCODE
					# Names
					$str = "SELECT COUNT(*) FROM (
						 SELECT DISTINCT t.binomial 
						 FROM gpdd.main m, gpdd.taxon t
						 WHERE t.\"TaxonID\" = m.\"TaxonID\"
						 AND t.binomial = ANY ($arr)
						 ) AS foo";
					//echo $str . "<br>";
					$res = pg_query($db_handle, $str);
					$row = pg_fetch_row($res);
					$val = number_format($row[0]);
					# Series
					if ($nmids) $val = "$val/" . number_format($nmids);
					break;
					
				default:
					echo $source['term'] . " is not a recognised source:term";
					break;
				}
			array_push($s_ns, $val);
		} else {
		array_push($s_ns, "0");
		}

	}
	
$arr = array('id'=>$s_id, 'type'=>$s_type, 'name'=>$s_name, 'code'=>$s_code, 'in source*'=>$s_n, 'selected*'=>$s_ns);

echo "<br>";
html_arr_to_table($arr);
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


?>
