<?php

session_start();
include "config_setup.php";
include $config['apt_to_ini_path'] . "/eb_connect_pg.php";
include "html_utils.php";
include "php_utils.php";

$eb_path = "http://" . $config['host'] . "/" . $config['eb_path'] . '/';
$html_path = "http://" . $config['host'] . "/" . $config['html_path'] . '/';
$share_path = "http://" . $config['host'] . "/" . $config['share_path'] . '/';
#CONNECT TO DATABASE
$db_handle = eb_connect_pg($config);

#HTML 
echo '<html>';

#HEAD
echo '<head>';
echo "<title>Series</title>";
echo '<link type="text/css" rel="stylesheet" href="' . $share_path . 'entangled_bank.css">';
echo '</head>';
#BODY

html_entangled_bank_header($eb_path, $html_path, $share_path);

$qobjects = $_SESSION['qobjects'];
$mids = get_mids($qobjects);
$c = count($mids);
if ($names) {
	$nc = count($names);
} else {
	$nc = 0;
}
//echo $qobjects[count($qobjects) - 2]['series_sql'] . "<br>";

echo "<img src='shoppingCartIcon.gif' alt='Shopping Cart' />";
echo '<big>Shopping Cart </big>';
echo "- $c series<br>";

if ($mids)  {
	$i = 0;
	foreach ($mids as $mid) {
		if ($i == 0) {
			$str = $mid;
		} else {
			$str = $str . "\n$mid";
		}
		$i++;
	}
}

echo "<br>";
echo "<TEXTAREA rows='25' cols='15'>$str</TEXTAREA>";
echo "<br>";

html_entangled_bank_footer();

	
?>

