<?php

// Starting the session to pass variables to PERL
#ini_set('session.save_path', realpath('C:\tmp'));
#session_name('Private');
session_start();

$mytimes = array("page_begin" => microtime(True));

include "config_setup.php";
#$config = parse_ini_file('../../passwords/entangled_bank.ini');

include $config['apt_to_ini_path'] . "/eb_connect_pg.php";

include "html_utils.php";
include "php_utils.php";
include "php_query.php";
include "php_validate.php";
include "php_write.php";
include "html_cart.php";
#include "../../passwords/eb_connect_pg.php";

$eb_path = "http://" . $config['ebhost'] . "/" . $config['eb_path'] . '/';
$html_path = "http://" . $config['htmlhost'] . "/";
if($config['html_path']) $html_path = $html_path . $config['html_path'] . '/';
$share_path = "http://" . $config['ebhost'] . "/" . $config['share_path'] . '/';
$_SESSION['tmp_path'] = $config['tmp_path'];

/*
echo "eb_path: $eb_path<br>";
echo "html_path: $html_path<br>";
echo "share_path: $share_path<br>";
*/
set_time_limit(1200);

# ---------------------------------------------------------------------------------------------------------------------------------------------
#                                                                            HTML HEADERS
# ---------------------------------------------------------------------------------------------------------------------------------------------

#HTML headers
echo '<html>';

#HEAD includes Javascript
echo '<head>';
echo "<title>Entangled Bank Integrated dDatabase</title>";
echo '<link type="text/css" rel="stylesheet" href="' . $share_path . 'entangled_bank.css">';
echo '</head>';
#END HEAD

#BODY
echo '<script src="./scripts/utils.js" type="text/javascript"></script>';
//echo '<script src="./scripts/cart_utils.js" type="text/javascript"></script>';
echo "<body onload='loadScript()'>";
echo "<div class='main'>";
html_entangled_bank_header($eb_path, $html_path, $share_path, true);

# BEGIN FORM

echo '<form method="post" name="ebankform" action="' . $eb_path . 'index.php" 
	onsubmit="document.getElementById(\'submit-button\').disabled = true;">';
	
# ---------------------------------------------------------------------------------------------------------------------------------------------
#                                                                           DATABASE
# ---------------------------------------------------------------------------------------------------------------------------------------------

#CONNECT TO DATABASE
$db_handle = eb_connect_pg($config);
##echo "$db_handle<br>";
# ---------------------------------------------------------------------------------------------------------------------------------------------
#                                                                            _POST AND SESSION
# ---------------------------------------------------------------------------------------------------------------------------------------------

# POST TOKENS
$oldtoken = $_SESSION['token'];
$newtoken = $_POST['token'];
//echo "old: $oldtoken, new: $newtoken<br>";

# Save submitted data to session variables
foreach ($_POST as $key =>$value) {
	//echo "$key => $value<br>";
	$_SESSION[$key] = $value;
	}

# Recover SESSION variables
$stage = $_SESSION['stage'];					// Form Stage
if (!$stage) $stage = 'sources';
//echo "POST stage: $stage<br>";

# SOURCES
$sourceids = $_SESSION['sourceids'];			//ids of the sources
$sources = $_SESSION['sources'];				//Array or sources

# MANAGEMENT
if ($_SESSION['names']) $names = $_SESSION['names'];	//currently selected names
$qobjects = $_SESSION['qobjects'];           			// Array of query objects
$qobjid = $_SESSION['qobjid'];				// The qobj to process. Is null if new query or repost				
$qedit_objid = $_SESSION['qedit_objid'];    // Query to be edited
$qterm = $_SESSION['qterm'];               // the type of query
$qset = $_SESSION['qset'];
$qsources = $_SESSION['qsources'];         // the sources the query applies to
if (!is_array($qsources)) $qsources = array($qsources);

$qsources_mode = $_SESSION['qsources_mode'];
$cancel = $_SESSION['cancel'];
unset ($_SESSION['cancel']);
if ($_SESSION['maction']) $maction = $_SESSION['maction'];

# TABULAR QUERY & OUTPUT
if ($_SESSION['allfields']) $allfields = $_SESSION['allfields'];  # flag to display all fields
$tablefields = $_SESSION['tablefields'];	//Fields of the biotable to **query or output**

# OUTPUT
$output_sid = $_SESSION['output_sid'];        // OUTPUT SOURCE
$output_id = $_SESSION['output_id'];          // OUTPUT ID
if ($oldtoken != $newtoken) unset($_SESSION['output_sid']);
if ($_SESSION['outputs']) $outputs = $_SESSION['outputs'];

$files_to_delete = $_SESSION['files_to_delete'];

# ---------------------------------------------------------------------------------------------------------------------------------------------
#                                                                            PRE-FORM PROCESSING
# ---------------------------------------------------------------------------------------------------------------------------------------------

//echo "Pre-form processing: ";
//if ($qobjects) print_r($qobjects);
//echo "stage: $stage";
//echo ", qobjid: $qobjid<br>";
//echo "<br>";

//echo "names: " . !empty($names);
//print_r($names);
//echo "<br>";

# Get Current qobject
if ($qobjid) $qobject = get_obj($qobjects, $qobjid);
if ($output_id) $output = get_obj($outputs, $output_id);

# BIOTREE AND BIOTTRIBUTE FIX
if (empty($qobjects)) $qobjid = null;

#echo "output_id: $output_id, output:";#if ($output) print_r($output);
#echo "<br>";
#echo "after get current qobject<br>";

# NAME SEARCH
if ($stage == 'qset' && $qterm == 'find') {
	$name_search = query_name_search($db_handle, $sources);
	$stage = 'main';
}

# EXIT QUERYING THROUGH QTERM
if ($qterm == 'finish') $stage = 'finish';

# AFTER SOURCES
if ($stage == 'getsources') {
	$sources = get_sources($db_handle, $sourceids, 'bio');
	if ($sources) {
		$_SESSION['sources'] = $sources;
		$stage = 'main';
	} else {
		echo "<FONT COLOR='red'><b>Select one or more sources</FONT></b>";
		$stage = 'getsources';
	}
}
	
# EDIT QUERY
if ($stage == 'qedit') {
	$stage = 'qset';
	$qobjid = $qedit_objid;
}

# CANCELLING A QUERY
if ($stage == 'qcancel') {
	$c = count($qobjects) - 1;
	if ($qobjects[$c]['status'] == 'new') unset($qobjects[$c]);
	$qobjid = null;
	$stage = 'main';
}
	
# DELETE A QUERY
if ($stage == 'qdelete') {
	$idx = obj_idx($qobjects,$qobjid);
	unset ($qobjects[$idx]);
	array_values($qobjects);
	# If no queries unset names
	$names = null;
	# If re-run queries 
	//echo "Query $idx deleted, ", count($qobjects) , " in stack";
	foreach ($qobjects as $qobject) {
		echo ", running queries";
		$out = query($db_handle, $qobject, $qobjects, $names, $sources);
		$qobjects = save_obj($qobjects,$out[0]);
		$names = $out[1];
	}
	$_SESSION['qobjects'] = $qobjects;	
	$_SESSION['names'] = $names;	
	$stage = 'main';
	}

# QSET - CREATE NEW QUERY, MANAGE QUERIES OR END QUERYING
//echo "pre qset qobjid: $qobjid<br>";
if ($stage == 'qset' && !$qobjid) {
	if ($oldtoken == $newtoken) {
		$qobject = $qobjects[count($qobjects) - 1];
		$qobjid = $qobject['id'];
	} else {
		if (!$qobjects) $qobjects = array();
		//echo "Creating new qobject<br>";
		# CREATE NEW QOBJECT
		$qname = get_next_name($qobjects, $qterm);
		$qobjid = md5(uniqid());
		$qobject = array(
			'id' => $qobjid,
			'term' => $qterm,
			'name' => $qname,
			'status' => 'new'
			);
		
		# ADD SOURCE TO BIOTREE/BIOTABLE QUERY
		if ($qterm == 'biotree') $qobject['sources'] = array($_SESSION['biotree_sid']);
		if ($qterm == 'biotable') $qobject['sources'] = array($_SESSION['attribute_sid']);
		//if ($_SESSION['query_sid']) $qobject['sources'] = array($_SESSION['query_sid']);
		//$qobjid = $qobject['id'];
		array_push($qobjects, $qobject);
		$_SESSION['qobjects'] = $qobjects;
	}
}
	
# QVERIFY - VERIFY QUERY
if ($stage == 'qverify') {
	# fix for resubmission
	if ($qobjid && $newtoken == $oldtoken) $qobject = get_obj($qobjects, $qobjid);
	$qobject = validate_query($db_handle, $qobject, $sources, $qsources, $names);

	if ($qobject['status'] === 'valid') {
		$stage = 'query';
	} else {
		$stage = 'qset';
	}
	$qobjects = save_obj($qobjects, $qobject);
	$_SESSION['qobjects'] = $qobjects;
}
	
# PREPARE AND EXECUTE A QUERY
if ($stage == 'query') {
	if (count($qobjects) == 1) $names = null;
	$out = query($db_handle, $qobject, $qobjects, $names, $sources);
	$qobject = $out[0];
	$names = $out[1];
	$qobjects = save_obj($qobjects, $qobject);
	$_SESSION['names'] = $names;
	$_SESSION['qobjects'] = $qobjects;
	$stage = 'main';
	$qobjid = null;
	unset ($_SESSION['qobjid']);
	}
	
# NEW OUTPUT
if ($stage == 'newoutput') {
	switch (true) {
		case ($outputs && $outputs[count($outputs) - 1]['status'] == 'new'):
		case ($outputs && $newtoken == $oldtoken):
			$output = $outputs[count($outputs) - 1];
			$output_id = $output['id'];
			break;
		default;
			if (!$outputs) $outputs = array();
			$output = array();
			$output['sourceid'] = $output_sid;
			$output['id'] =  md5(uniqid());
			$output['status'] = 'new';
			$source = get_obj($sources, $output_sid);
			$output['term'] = $source['term'];
			$output_id = $output['id'];
			//if (!$outputs) $outputs = array();
			array_push($outputs, $output);
			break;
	}
	$stage = 'setoutput';
	$_SESSION['outputs'] = $outputs;
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
	$idx = obj_idx($outputs, $output_id);
	unset ($outputs[$idx]);
	array_values($outputs);
	$_SESSION['outputs'] = $outputs;	
	$stage = 'main';
	}

# VERIFY OUTPUT POSTED DATA TO OUTPUT
if ($stage == 'outputvalidate' && $output_id) {
	$output = validate_output($db_handle, $output, $outputs, $sources);
	$outputs = save_obj($outputs, $output);
	if ($output['status'] == 'valid') {
		//echo $output['name'], " validated<br>";
		$stage = 'main';
	} else {
		$stage = 'newoutput';
	}
	$_SESSION['outputs'] = $outputs;
	$output_id = null;
}

# WRITE OUTPUT FILES
if ($stage == 'write') {
	$zip = write_outputs($db_handle, $config, $names, $qobjects, $outputs, $sources);
} else {
	$zip = null;
}

if ($names) $_SESSION['names'] = $names;
//if ($outputs) $_SESSION['outputs'] = $outputs;

# ---------------------------------------------------------------------------------------------------------------------------------------------
#                                                                            SHOPPING CART
# ---------------------------------------------------------------------------------------------------------------------------------------------
//echo "pre-cart stage: $stage<br>";
//if ($stage != 'finish' && $stage != 'sources')  
	//html_cart($db_handle, $qobjid, $qobjects, $sources, $names, $object_id, $outputs, $stage);

# ---------------------------------------------------------------------------------------------------------------------------------------------
#                                                                                 FORM
# ---------------------------------------------------------------------------------------------------------------------------------------------

//echo "html stage: $stage<br>";

/*echo "post processing: ";
print_r($qobjects);
echo "<br/>";	*/
	
/*echo "post processing: ";
print_r($output);
echo "<br/>";
print_r($outputs);
echo "<br/>";*/
	
/*echo "sources:<br>";
print_r($sources);
echo "<BR>";
	*/
//if ($qterm == 'finish') $stage = 'finish';

if ($stage == 'sources') {
	html_select_sources($db_handle);
	echo "<input type = 'hidden' name ='stage' value='getsources'>";
	}
	
#MANAGE QUERIES
if ($stage == 'manage') {
	$stage = html_manage($qobjects, $qmanage_err);
	echo "<input id='stage' type='hidden' name ='stage' value='maction'>";
}	

# NEW QUERY
if ($stage == 'main' || $stage == 'write') {
	html_entangled_bank_main($db_handle, $qobjects, $sources, $names, $name_search, $output_id, $outputs, $zip);
	echo "<input type = 'hidden' id='stage' name ='stage' value='qset'>";
	}

# QUERY SETUP
if ($stage == 'qset') {
	echo "<div id='ebtool'>";
	html_query_set($db_handle, $qobjid, $qobjects, $sources, $names);
	echo "</div>";
}

# OUTPUT DIALOGS
if ($stage == 'setoutput') html_output_set($db_handle, $output, $outputs, $sources);

# UNIQUE ID FOR FORM INSTANCE
echo '<input type="hidden" name="token" value=' . md5(uniqid()) .'>';

#CLOSE FORM
echo '</form>';

#Print mytimes array
$mytimes = add_key_val($mytimes, "end_page", microtime(TRUE));

# FOOTER
html_entangled_bank_footer();

#Close db handle
pg_close($db_handle);

#CLOSE MAIN DIV
echo "</div>";
echo "</body>";
echo '</html>';

?>