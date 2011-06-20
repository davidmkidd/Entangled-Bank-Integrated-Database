<?php

session_start();

include "config_setup.php";
include $config['apt_to_ini_path'] . "/eb_connect_pg.php";
include "html_utils.php";
include "php_utils.php";
#include "php_interface_subs.php";
$eb_path = "http://" . $config['host'] . "/" . $config['eb_path'] . '/';
$html_path = "http://" . $config['host'] . "/" . $config['html_path'] . '/';
$share_path = "http://" . $config['host'] . "/" . $config['share_path'] . '/';

#HTML 
echo '<html>';

#HEAD
echo '<head>';
echo "<title>All SQL</title>";
echo '<link type="text/css" rel="stylesheet" href="' . $share_path . 'entangled_bank.css">';
echo '</head>';
#BODY

html_entangled_bank_header($eb_path, $html_path, $share_path);

echo "<img src='shoppingCartIcon.gif' alt='Shopping Cart' />";
echo '<big>Shopping Cart </big>';
echo "- SQL<br><br>";

$qobjects = $_SESSION['qobjects'];
//print_r($qobjects);
#$str = qobjs_to_sql($qobjects);
if($qobjects && !empty($qobjects)){
	$qobject = $qobjects[count($qobjects) - 1];
	if ($qobject['status'] == 'valid') {
		$str = $qobject['sql_names'];
	} else {
		if (count($qobjects) > 1) {
			$qobject = $qobjects[count($qobjects) - 2];
			$str = $qobject['sql_names'];
		} else {
			$str = "No queries, so no SQL!";
		}
	}
}
	
echo $str;

echo "<br>";
html_entangled_bank_footer();
	
?>

