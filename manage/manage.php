<?php 
include "../../../../passwords/entangled_bank_localhost_connect_pg.php";
include "../php_interface_subs.php";
include "../php_utils.php";
#CONNECT TO DATABASE
$db_handle = pg_connect ($connect_string);
# GET SOURCES INTO PHP ARRAY
$sources = get_sources($db_handle, 'all', TRUE, NULL);
$serialized = serialize($sources)
#echo $test;
?>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=Cp1252">
<title>Entangled Bank Data</title>
<link type="text/css" rel="stylesheet" href="entangled_bank.css">
<script language="javascript" type="text/javascript" src="../utils/php_js.js"></script>
<script language="javascript" type="text/javascript" src="../utils/manage.js"></script>
<script language="javascript" type="text/javascript">
function manageSources() {
		// new PHP_Serializer variable
		var php = new PHP_Serializer();
		// get PHP sources array
		var jsSources = php.unserialize("<?php echo str_replace('"', '\\"', $serialized); ?>");
		// look at dump :-)
		//document.write(jsSources + "<br>");
		writeSources(jsSources, 0);
		//document.write(showObject(jsSources, 0));
	}

</script>
</head>

<body>
<h2>Sources</h2>

<script language="javascript" type="text/javascript">
	manageSources();
</script>

<?php
/*foreach ($sources as $s) {
	echo "id: " . $s['id'] . ", ";
	echo "name: <input " . $s['name'] . ", ";
	echo "type: " . $s['term']. "<br>";
	echo "schema: ". $s['schema'] . ", ";
	echo "tablename: " . $s['tablename'] . ", ";
	echo "dbloc: " . $s['dbloc'] . "<br>";
	echo "n: " . $s['n']. ", ";
	echo "www: " . $s['www'] . "<br>";
	
	echo "<br>";
}*/
?>

</body>
</html>