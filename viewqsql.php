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
echo "<title>Query SQL</title>";
echo '<link type="text/css" rel="stylesheet" href="' . $share_path . 'entangled_bank.css">';
echo '</head>';
#BODY

html_entangled_bank_header($eb_path, $html_path, $share_path);


$qid = $_GET['qid'];
#echo "qid: $qid<br>";

$qobjects = $_SESSION['qobjects'];
$qobject = $qobjects[$qid];
echo "<img src='shoppingCartIcon.gif' alt='Shopping Cart' />";
echo '<big>Shopping Cart </big>';
echo "- SQL " . $qobject['name'] . "<br><br>";

$str = qobj_to_sql($qobject);
	
echo "$str<br>";

html_entangled_bank_footer();
	
?>

