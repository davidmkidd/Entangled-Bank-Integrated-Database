<?php

// Starting the session
session_start();

//$mytimes = array("page_begin" => microtime(True));

# LIBRARIES
//include "./lib/config_setup.php";
//include $config['apt_to_ini_path'] . "/eb_connect_pg.php";
include "./lib/config.php";
include "./lib/html_utils.php";
include "./lib/php_utils.php";
include "./lib/php_query.php";
include "./lib/php_process.php";
include "./lib/php_write.php";
include "./lib/html_info.php";

$eb_path = "http://" . $config['ebhost'] . "/" . $config['eb_path'] . '/';
$html_path = "http://" . $config['htmlhost'] . "/";
if($config['html_path']) $html_path = $html_path . $config['html_path'] . '/';
$share_path = "http://" . $config['ebhost'] . "/" . $config['share_path'] . '/';
$_SESSION['tmp_path'] = $config['tmp_path'];
$_SESSION['full_tmp_path'] = "http://" . $config['ebhost'] . '/' . $config['tmp_path'] . '/';

# EB PATH
echo "<input type='hidden' id='eb_path' value='$eb_path' />";
# ---------------------------------------------------------------------------------------------------
#                                                _POST AND SESSION
# ---------------------------------------------------------------------------------------------------

# POST TOKENS
$oldtoken = $_SESSION['token'];
$newtoken = $_POST['token'];


# POST => SESSION
foreach ($_POST as $key =>$value) {
	//echo "$key => $value<br>";
	$_SESSION[$key] = $value;
	}

# STAGE
$stage = $_SESSION['stage'];					// Form Stage
if (!$stage) $stage = 'sources';
# LAST ACTION - dealing with the back button
if ($_SESSION['lastaction']) $lastaction = $_SESSION['lastaction'];
if ($lastaction == 'doc') $stage = 'main';
$sources = $_SESSION['sources'];
if ((!$sources || empty($sources)) && $stage == 'main') $stage = 'sources';
$lastid = $_SESSION['lastid'];

# SOURCES
$sourceids = $_SESSION['sourceids'];			//ids of the sources

# QUERY
$qobjid = $_SESSION['qobjid'];			// The qobj to process. Is null if new query or repost
//echo "qobjid: $qobjid<br>";		
$qterm = $_SESSION['qterm'];            // the type of query
$qsources = $_SESSION['qsources'];      // the sources the query applies to
if (!is_array($qsources)) $qsources = array($qsources);

# OUTPUT
$output_sid = $_SESSION['output_sid'];        // OUTPUT SOURCE
$output_id = $_SESSION['output_id'];          // OUTPUT ID
if ($oldtoken != $newtoken) unset($_SESSION['output_sid']);
if ($_SESSION['outputs']) $outputs = $_SESSION['outputs'];

#echo "oldtoken: $oldtoken, oldtoken: $newtoken<br>";
//echo "stage: $stage<br>";
//print_r($sources);
//echo "lastaction: $lastaction, lastid: $lastid<br>";
//echo $_SESSION['zip'], "<br>";

# ------------------------------------------------------------------------------------------------
#                                         HTML HEADERS
# ------------------------------------------------------------------------------------------------

#HTML headers
echo '<html>';

#HEAD includes Javascript
echo '<head>';
echo "<title>Entangled Bank Integrated Database</title>";
echo '<link type="text/css" rel="stylesheet" href="' . $share_path . 'entangled_bank.css">';
echo '</head>';
#END HEAD

#BODY
echo '<script src="./scripts/utils.js" type="text/javascript"></script>';
echo "<body onload='loadScript()'>";
	
# --------------------------------------------------------------------------------------------------
#                                     DATABASE CONNECTION
# --------------------------------------------------------------------------------------------------

echo "<div id='page'>";

set_time_limit(1200);

$db_handle = eb_connect_pg($config);

if ($db_handle == false) {
	$stage = 'dbfail';
	html_entangled_bank_header($stage, $eb_path);
	# FOOTER
	html_entangled_bank_footer();
	#CLOSE MAIN DIV
	echo "</div>";
	echo "</body>";
	echo '</html>';
	echo exit;
}

# -----------------------------------------------------------------------------------------------------
#                                         PRE-FORM PROCESSING
# -----------------------------------------------------------------------------------------------------

# NAME SEARCH
if ($stage == 'find') {
	$name_search = query_name_search($db_handle);
	$stage = 'main';
}

# EXIT QUERYING THROUGH QTERM
if ($qterm == 'finish') $stage = 'finish';

# AFTER SOURCES
if ($stage == 'getsources') 
	$stage = process_get_sources($db_handle, $sourceids, $lastaction);

# CANCELLING A QUERY
if ($stage == 'qcancel') {
	$qobjid = null;
	$stage = 'main';
}
	
# DELETE A QUERY
if ($stage == 'qdelete') {
	process_delete_query($db_handle, $qobjid);
	$qobjid = null;
	$stage = 'main';
	}

# DELETE ALL QUERIES
if ($stage == 'querydeleteall') {
	unset ($_SESSION['qobjects']);	
	unset ($_SESSION['names']);
	unset ($_SESSION['info']);
	$stage = 'main';
	}
	
# QSET - CREATE NEW QUERY, MANAGE QUERIES OR END QUERYING
if ($stage == 'qset') 
	$qobjid = process_new_query($qobjid, $qterm, $oldtoken, $newtoken, $lastaction, $lastid);

# QVERIFY - VERIFY QUERY
if ($stage == 'qverify') 
	$stage = process_query($db_handle, $qobjid, $qsources);
	
# PREPARE AND EXECUTE A QUERY
if ($stage == 'query') {
	query($db_handle, $qobjid);
	$qobjid = null;
	unset ($_SESSION['qobjid']);
	$stage = 'main';
}
	
# NEW OUTPUT
if ($stage == 'newoutput') {
	$output_id = process_new_output($oldtoken, $newtoken, $output_sid);
	$stage = 'setoutput';
}

# CANCEL OUTPUT
if ($stage == 'outputcancel') {
	$c = count($outputs) - 1;
	if ($outputs[$c]['status'] == 'new') unset($outputs[$c]);
	$output_id = null;
	$stage = 'main';
}

# DELETE OUTPUT
if ($stage == 'outputdelete') {
	process_delete_output ($output_id);
	$stage = 'main';
}

# DELETE ALL OUTPUTs
if ($stage == 'outputdeleteall') {
	unset ($outputs);
	$_SESSION['outputs'] = $outputs;	
	if ($_SESSION['zip']) {
		$zip = $_SESSION['zip'];
		$file = $config['out_path'] . "/$zip";
		if (file_exists($file)) {
			unlink($file);
		}
	unset ($_SESSION['zip']);
	}
	$stage = 'main';
}
	

# VERIFY OUTPUT POSTED DATA TO OUTPUT
if ($stage == 'outputvalidate' && $output_id) {
	process_output($db_handle, $output_id);
	$stage = 'main';
	$output_id = null;
}

# WRITE OUTPUT FILES
if ($stage == 'write') {
	write_outputs($db_handle, $config);
	# DELETE OLD FILES - COULD BE BETTER MANAGED
	process_cleanup($config);
	$stage = 'main';
}


# ----------------------------------------------------------------------------------
#                                       FORM
# ----------------------------------------------------------------------------------

echo '<form method="post" name="ebankform" action="' . $eb_path . 'index.php" 
	onsubmit="document.getElementById(\'submit-button\').disabled = true;">';

# HEADER
html_entangled_bank_header($stage, $eb_path, $html_path, $share_path);

# SELECT SOURCES
if ($stage == 'sources') 
	html_entangled_bank_sources($db_handle);	

# MAIN INTERFACE
if ($stage == 'main' || $stage == 'write') 
	html_entangled_bank_main($db_handle, $oldtoken, $newtoken, $name_search, $output_id);

# QUERY SETUP
if ($stage == 'qset')
	html_query($db_handle, $qobjid);

# OUTPUT DIALOGS
if ($stage == 'setoutput') 
	html_output($db_handle, $output_id);

# UNIQUE ID FOR FORM INSTANCE
echo '<input type="hidden" name="token" value=' . md5(uniqid()) .'>';

#CLOSE FORM
echo '</form>';

# ----------------------------------------------------------------------------------
#                                     FOOOTER
# ----------------------------------------------------------------------------------


html_entangled_bank_footer();
pg_close($db_handle);

#CLOSE MAIN DIV
echo "</div>";
echo "</body>";
echo '</html>';

?>