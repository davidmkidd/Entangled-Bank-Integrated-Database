<?php
session_start();
$_SESSION['lastaction'] = 'doc';
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="content-type">
  <title>Entangled Bank Discovery</title>
  <meta content="webmaster@entangled-bank.org" name="author">
  <meta content="Index page" name="description">
  <link type="text/css" rel="stylesheet" href="../share/entangled_bank.css">
</head>

<body>
<div id='page'>

<?php 
include("../lib/html_utils.php"); 
$stage = html_entangled_bank_header('doc', '../');
include("./contents.html");
?>

<div id='content'>

<a name='discovery'></a><h3>Entangled Bank Discovery</h3>

<p>
Entangled Bank Discovery (EBDD): a web-based tool for discovering and preserving data. 
Search for datasets by taxonomy, space, time and type. Enter metadata and upload data to the Microsoft Azurus cloud.
For further information on the EBD contact Microsoft Research <a href = "mailto:ricw@microsoft.com">??email??</a>.
</p>
<center>
<a href="./image/ebdd.gif"><img src="./image/ebdd.gif" height=350px/></a><br>
<p class="legend">Entangled Bank Data Discovery Tool</p>
</center>

</div>
<?php html_entangled_bank_footer(); ?>
</div>
</body>
</html>
