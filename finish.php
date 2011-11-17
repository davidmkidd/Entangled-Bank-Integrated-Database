<?php

session_start();
session_unset();
session_destroy();

include "./lib/config_setup.php";
include $config['apt_to_ini_path'] . "/eb_connect_pg.php";
include "./lib/html_utils.php";
include "./lib/php_utils.php";
$index = "http://" . $config['ebhost'] . "/" . $config['eb_path'] . '/index.php';

$eb_path = "http://" . $config['ebhost'] . "/" . $config['eb_path'] . '/';
$html_path = "http://" . $config['ebhost'] . "/" . $config['html_path'] . '/';
$share_path = "http://" . $config['ebhost'] . "/" . $config['share_path'] . '/';

#HTML 
echo '<html>';

#HEAD
echo '<head>';
echo "<title>Finish Entangled Bank</title>";
echo '<link type="text/css" rel="stylesheet" href="' . $share_path . 'entangled_bank.css">';
echo '</head>';
echo '<script src="./scripts/utils.js" type="text/javascript"></script>';
#BODY
echo "<div class='main'>";
html_entangled_bank_header('finish',$eb_path, $html_path, $share_path);
echo "<br>";
echo "<p id='exit_blurb'>Thank you for using The Entangled Bank</p>";
echo "<br>";
html_entangled_bank_footer();
echo "</div>";
echo "</body>";
echo '</html>';
	
?>

