<?php

session_start();
include "config_setup.php";
include $config['apt_to_ini_path'] . "/eb_connect_pg.php";
include "html_utils.php";
include "php_utils.php";

$eb_path = "http://" . $config['host'] . "/" . $config['eb_path'] . '/';
$html_path = "http://" . $config['host'] . "/" . $config['html_path'] . '/';
$share_path = "http://" . $config['host'] . "/" . $config['share_path'] . '/';

#HTML 
echo '<html>';

#HEAD
echo '<head>';
echo "<title>Outputs</title>";
echo '<link type="text/css" rel="stylesheet" href="' . $share_path . 'entangled_bank.css">';
echo '</head>';
#BODY

html_entangled_bank_header($eb_path, $html_path, $share_path);

echo "<img src='shoppingCartIcon.gif' alt='Shopping Cart' />";
echo '<big>Shopping Cart </big>';
echo "- $c series<br><br>";

$outputs = $_SESSION['outputs'];
$i = 0;
foreach($outputs as $output) {
	if ($output['status'] == 'valid') {
	$i++;
	echo "#$i " . $output['name'] . ": ";
	echo $output['as_string'] . "<br>";	
	}

}

html_entangled_bank_footer();

	
?>

