<?php
session_start();
session_unset();
session_destroy();
include 'config.php';
$path = "http://" . $config['ebhost'];
if (!empty($config['eb_path'])) $path = $path . "/" . $config['eb_path'];
$path = $path . '/index.php';
echo $path;
echo '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">';
echo "<html><head>";
echo '<meta http-equiv="REFRESH" content="0;url=' . $path . '"></HEAD>';
echo '<BODY>';
//echo "index: $index_path";
echo '</BODY></HTML>';
?>

