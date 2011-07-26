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
echo "<title>Series SQL</title>";
echo '<link type="text/css" rel="stylesheet" href="' . $share_path . 'entangled_bank.css">';
echo '</head>';
#BODY

html_entangled_bank_header($eb_path, $html_path, $share_path, false);

echo "<img src='shoppingCartIcon.gif' alt='Shopping Cart' />";
echo '<big>Shopping Cart </big>';
echo "- Series SQL<br><br>";

$qobjects = $_SESSION['qobjects'];
//print_r($qobjects);
#$str = qobjs_to_sql($qobjects);
if($qobjects && !empty($qobjects)){
	$qobject = $qobjects[count($qobjects) - 1];
	if ($qobject['status'] == 'valid') {
		$str = $qobject['sql_series'];
	} else {
		if (count($qobjects) > 1) {
			$qobject = $qobjects[count($qobjects) - 2];
			$str = $qobject['sql_series'];
		} else {
			$str = "No SQL";
		}
	}
}
	
echo "<textarea readonly='readonly' rows='25' cols='100'>$str</textarea>";

echo "<br>";
html_entangled_bank_footer();
	
?>

