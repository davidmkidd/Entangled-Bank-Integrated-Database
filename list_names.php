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
echo "<title>Names</title>";
echo '<link type="text/css" rel="stylesheet" href="' . $share_path . 'entangled_bank.css">';
echo '</head>';
#BODY

html_entangled_bank_header($eb_path, $html_path, $share_path, false);

$names = $_SESSION['names'];
sort($names);
$c = count($names);

echo "<img src='shoppingCartIcon.gif' alt='Shopping Cart' />";
echo '<big>Shopping Cart </big>';
echo "- $c names<br><br>";

$i = 0;
$str = "";
foreach($names as $name) {
	if ($i == 0) {
		$str = $name;
	} else {
		$str = $str . "\n$name";
	}
	$i++;
}

echo "<textarea rows='25' cols='40'>$str</textarea>";

html_entangled_bank_footer();

	
?>

