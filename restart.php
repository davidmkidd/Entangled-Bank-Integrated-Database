<?php
$config = parse_ini_file('../../../passwords/entangled_bank.ini');
$index_path = "http://" . $config['host'] . "/" . $config['eb_path'] . '/index.php';
echo "index: $index_path";
session_start();
session_unset();
session_destroy();
echo '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">';
echo "<html><head>";
echo '<meta http-equiv="REFRESH" content="0;url=' . $index_path . '"></HEAD>';
echo '<BODY></BODY></HTML>';
?>

