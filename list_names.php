<?php

session_start();
include "config_setup.php";
include $config['apt_to_ini_path'] . "/eb_connect_pg.php";
include "html_utils.php";
include "php_utils.php";


$eb_path = "http://" . $config['ebhost'] . "/" . $config['eb_path'] . '/';
$html_path = "http://" . $config['ebhost'] . "/" . $config['html_path'] . '/';
$share_path = "http://" . $config['ebhost'] . "/" . $config['share_path'] . '/';

#HTML 
echo '<html>';

#HEAD
echo '<head>';
echo "<title>Names Info</title>";
echo '<link type="text/css" rel="stylesheet" href="' . $share_path . 'entangled_bank.css">';
echo '</head>';
echo '<script src="./scripts/utils.js" type="text/javascript"></script>';
#BODY
echo "<div class='main'>";
html_entangled_bank_header($eb_path, $html_path, $share_path, false);

$names = $_SESSION['names'];
sort($names);
$c = count($names);

//echo "<img src='./image/shoppingCartIcon.gif' alt='Shopping Cart' />";
//echo '<big>Shopping Cart </big>';

echo "<h4>Names in Query</h4>";

echo "<table>";
echo "<tr>";
$t = "Names list format";
echo "<td class='query_title' title='$t'>Names</td>";
echo "<td>$c</td>";
echo "</tr>";

echo "<tr>";
$t = "Names list format";
echo "<td class='query_title' title='$t'>Format</td>";
echo "<td>";
echo "<SELECT id='format' class='eb_info' onChange='textareaFormat(\"names_list\")'>";
echo "<OPTION value='0'>Not Delineated with New Line Separator</OPTION>";
echo "<OPTION value='1'>Delineated with New Line Separator</OPTION>";
echo "<OPTION value='2'>Not Delineated with Comma Separator</OPTION>";
echo "<OPTION value='3'>Delineated with Comma Separator</OPTION>";
echo "</SELECT>";
echo "<td>";
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

echo "</table>";
echo "<br>";
html_entangled_bank_footer();
echo "</div>";
echo "</body>";
echo '</html>';
	
?>

