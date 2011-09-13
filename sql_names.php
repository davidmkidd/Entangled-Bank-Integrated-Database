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
echo "<title>Names SQL</title>";
echo '<link type="text/css" rel="stylesheet" href="' . $share_path . 'entangled_bank.css">';
echo '</head>';
#BODY
echo "<div class='main'>";
html_entangled_bank_header($eb_path, $html_path, $share_path, false);

echo "<img src='./image/shoppingCartIcon.gif' alt='Shopping Cart' />";
echo '<big>Shopping Cart </big>';
echo "- Names SQL<br><br>";

$qobjects = $_SESSION['qobjects'];

if($qobjects && count($qobjects > 0)){
	$qobject = $qobjects[count($qobjects) - 1];
	if ($qobject['status'] == 'new') $qobject = $qobjects[count($qobjects) - 2];
	//print_r($qobject);
	$str = $qobject['sql_names'];
} else {
	$str = "No SQL";;
}
	
echo "<textarea readonly='readonly' rows='25' cols='103'>$str</textarea>";
echo "<br>";
html_entangled_bank_footer();
echo "</div>";
echo "</body>";
echo '</html>';

?>

