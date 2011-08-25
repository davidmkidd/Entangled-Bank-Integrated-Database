<?php
# EDIT FOR LOCAL SETUP
$config = parse_ini_file('../../../passwords/entangled_bank.ini');
include "../" . $config['apt_to_ini_path'] . "/eb_connect_pg.php";
?>