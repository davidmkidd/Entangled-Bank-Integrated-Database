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
echo "<title>Entangled Bank</title>";
echo '<link type="text/css" rel="stylesheet" href="' . $share_path . 'entangled_bank.css">';
echo '</head>';
#END HEAD

#BODY
#<body>
echo '<body>';
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
	#echo "$key => $value<br>";
	$_SESSION[$key] = $value;
	}

# Recover SESSION variables
$stage = $_SESSION['stage'];					// Form Stage
if (!$stage) $stage = 'sources';
#echo "POST stage: $stage<br>";

# SOURCES
$sourceids = $_SESSION['sourceids'];			//ids of the sources
//echo "sids: $sourceids<br>";
$sources = $_SESSION['sources'];				//Array or sources

# MANAGEMENT
if ($_SESSION['names']) $names = $_SESSION['names'];	//currently selected names
$qobjects = $_SESSION['qobjects'];           			// Array of query objects
# echo "session n qobjects " . count($qobjects) . "<br>";
$qobjid = $_SESSION['qobjid'];							// The qobj to process. Is null if new query or repost				


$qterm = $_SESSION['qterm'];               // the type of query
$qset = $_SESSION['qset'];
$qsources = $_SESSION['qsources'];         // the sources the query applies to
if (!is_array($qsources)) $qsources = array($qsources);
$qsources_mode = $_SESSION['qsources_mode'];
$cancel = $_SESSION['cancel'];
unset ($_SESSION['cancel']);
#$qaction = $_SESSION['qaction'];                // Action on query being managed
if ($_SESSION['maction']) $maction = $_SESSION['maction'];

# TABULAR QUERY
#$table = $_SESSION['table'];				// The biotable to query

# TABULAR QUERY & OUTPUT
if ($_SESSION['allfields']) $allfields = $_SESSION['allfields'];  # flag to display all fields
$tablefields = $_SESSION['tablefields'];	//Fields of the biotable to **query or output**

# OUTPUT
$output_sid = $_SESSION['output_sid'];        // OUTPUT SOURCE
$output_id = $_SESSION['output_id'];          // OUTPUT ID
if ($oldtoken != $newtoken) unset($_SESSION['output_sid']);
if ($_SESSION['outputs']) $outputs = $_SESSION['outputs'];

//echo "<br>";

$files_to_delete = $_SESSION['files_to_delete'];
#unset($_SESSION['format']);
#unset($_SESSION['$outsubtree']);


# ---------------------------------------------------------------------------------------------------------------------------------------------
#                                                                            PRE-FORM PROCESSING
# ---------------------------------------------------------------------------------------------------------------------------------------------

#echo "Pre-processing<br>";
#if ($outputs) print_r($outputs);
#echo "<br>";

# Get Current qobjects
if ($qobjid) $qobject = get_obj($qobjects, $qobjid);
#echo "output_id: $output_id, output:";
if ($output_id) $output = get_obj($outputs, $output_id);
#if ($output) print_r($output);
#echo "<br>";
# echo "after get current qobject<br>";

# NAME SEARCH
if ($stage == 'qset' && $qterm == 'name_search') {
	$name_search = query_name_search($db_handle, $sources);
	$stage = 'qbegin';
}


# CANCELLING A QUERY
if ($cancel == 'yes') {
	$c = count($qobjects) - 1;
	unset($qobjects[$c]);
	$stage = 'selectby';
	#echo "<FONT color=red>Query Cancelled</FONT><br>";
	$qobjid = null;
	$stage = 'qbegin';
	}

# EXIT QUERYING THROUGH QTERM
if ($qterm == 'finish') $stage = 'finish';

# AFTER SOURCES
if ($stage == 'getsources') {
	#echo "Pre-form: begin getsources<br>";
	#$sources = get_sources($db_handle, $sourceids, 'bio');
	$sources = get_sources($db_handle, $sourceids, 'bio');
	if ($sources) {
		$_SESSION['sources'] = $sources;
//		echo "after get_sources";
//		print_r($sources);
//		echo "<br>";
		$stage = 'qbegin';
		} else {
		echo "<FONT COLOR='red'><b>Select one or more sources</FONT></b>";
		$stage = 'getsources';
		}
	}


# QSET - CREATE NEW QUERY, MANAGE QUERIES OR END QUERYING
//echo "qobjid: $qobjid<br>";
//if ($qobjects) foreach ($qobjects as $obj) echo $obj['id'] . "; ";
//echo "<BR>";
if ($stage == 'qset') {
	//echo "Old qobjid: $qobjid<br>";
	switch (true) {
		case ($qterm == 'qend'):
			$stage = 'outputs';
			break;
		case ($qterm == 'manage'):
			$stage = 'manage';
			break;
		default :
			# GET EXISTING QOBJECT	
			if (($qobjects && ($qobjects[count($qobjects) - 1]['status'] == 'new') || 
				($qobjects[count($qobjects) - 1]['status'] == 'new') && $newtoken == $oldtoken)) {
				$qobject = $qobjects[count($qobjects) - 1];
				$qobjid = $qobject['id'];
			}  else {
			if (!$qobjects) $qobjects = array();
			# CREATE NEW QOBJECT
			$qname = get_next_name($qobjects, $qterm);
			$qobjid = md5(uniqid());
			$qobject = array(
				'id' => $qobjid,
				'term' => $qterm,
				'name' => $qname,
				'status' => 'new'
				);
			array_push($qobjects, $qobject);
			$_SESSION['qobjects'] = $qobjects;
			#echo "new qobjid $qobjid<br>";
			break;
			}
	}
}

//if ($qobjects) foreach ($qobjects as $obj) echo $obj['id'] . "; ";
//echo "<BR>";

# QSET2 - ADD SOURCE TO QUERY
# Only for biotree and biotables as must be selected query interface
if ($stage == 'qset2') {
	$qobject = get_obj($qobjects,$qobjid);
	//echo "qset2: adding " . $qsources[0] . "<br>";
	$qobject = add_key_val($qobject,'sources', $qsources);
	$qobjects = save_obj($qobjects, $qobject);
	$_SESSION['qobjects'] = $qobjects;
	#$stage = $qobject['term'];
	}
	
	
# MANAGE - MANAGEMENT
if ($stage == 'maction') {
	//echo "maction: $maction, qobjid: $qobjid<br>";
	$qobjects = $_SESSION['qobjects'];
	//print_r($qobjects);
	if (($maction == 'delete' or $maction == 'edit') and !$qobjid) $_err = true;
	if (!$qmanage_err) {
		switch ($maction) {
			case 'return':
				$stage = 'qbegin';
				break;
			case 'delete':
				# DELETE A QUERY
				#echo "Delete query $qobjid<br>";
				$idx = obj_idx($qobjects,$qobjid);
				unset ($qobjects[$idx]);
				array_values($qobjects);
				$_err = false;
				# If no queries unset names
				$names = null;
				# If re-run queries 
				foreach ($qobjects as $qobject) {
					$out = query($db_handle, $qobject, $qobjects, $names, $sources);
					$qobjects = save_obj($qobjects,$out[0]);
					$names = $out[1];
				}
				$_SESSION['qobjects'] = $qobjects;	
				$_SESSION['names'] = $names;	
				$stage = 'qbegin';
				break;
			case 'edit':
				$stage = 'qset';
				break;
		}
	}
	$_SESSION['qobjects'] = $qobjects;	
	$_SESSION['names'] = $names;	
}

	
# QVERIFY - VERIFY QUERY
if ($stage == 'qverify') {
	# fix for resubmission
	#echo "Begin qverify: $qobjid<br>";
	if ($qobjid && $newtoken == $oldtoken) $qobject = get_obj($qobjects, $qobjid);
	//echo "pre-validate n qobjects " . count($qobjects) . "<br>";
	$qobject = validate_query($db_handle, $qobject, $sources, $qsources, $names);
	//echo "post-validate n qobjects " . count($qobjects) . "<br>";
	if ($qobject['status'] == 'valid') {
		$stage = 'query';
	} else {
		if ($qobject['term'] == 'biotree' || $qobject['term'] == 'biotable')  {
			$stage = 'qset2';
		} else {
			$stage = 'qset';
		}
	}
	$qobjects = save_obj($qobjects, $qobject);
	$_SESSION['qobjects'] = $qobjects;
}

	
# PREPARE AND EXECUTE A QUERY
if ($stage == 'query') {
	//$qobjects = $_SESSION['qobjects'];
	//$qobject = get_obj($qobjects, $qobjid);
	# FIX for resubmission of first query
	//echo count($names) . ", " . count($qobjects) . " before fix<br>";
	if (count($qobjects) == 1) $names = null;
	//echo count($names) . " after fix<br>";
	# QUERY
	//echo "pre-query n qobjects " . count($qobjects) . "<br>";
	$out = query($db_handle, $qobject, $qobjects, $names, $sources);
	//print_r($out);
	$qobject = $out[0];
	$names = $out[1];
	$qobjects = save_obj($qobjects, $qobject);
	#echo "post-save_obj " . count($qobjects) . "<br>";
	$_SESSION['names'] = $names;
	$_SESSION['qobjects'] = $qobjects;
	$stage = 'qbegin';
	unset ($_SESSION['qobjid']);
	#echo "post-query n qobjects " . count($qobjects) . "<br>";
	//echo count($_SESSION['mids']) . " mids<br>";
	}
	
# NEW OUTPUT
if ($stage == 'outputset') {
	//if(!$output_id && $newtoken == $oldtoken) $output_id = "*";
	switch ($output_sid) {
		case 'end':
			$stage = 'write';
			break;
		case 'manage':
			$stage = 'outmanage';
			break;
		default:
			#echo "before outputset <br>";
			#print_r($outputs);
			echo "<br>";
			switch (true) {
				case ($outputs && $outputs[count($outputs) - 1]['status'] == 'new'):
				case ($outputs && $newtoken == $oldtoken):
					$output = $outputs[count($outputs) - 1];
					$output_id = $output['id'];
					break;
				default;
					if (!$outputs) $outputs = array();
					$output = array();
					$output = add_key_val($output, 'sourceid', $output_sid);
					$output = add_key_val($output, 'id', md5(uniqid()));
					$output = add_key_val($output, 'status', 'new');
					$source = get_obj($sources, $output_sid);
					$output['term'] = $source['term'];
					$output_id = $output['id'];
					//if (!$outputs) $outputs = array();
					array_push($outputs, $output);
					
					break;
			}
			$_SESSION['outputs'] = $outputs;
			#echo "post outputset, output_id: $output_id<br>";
			#print_r($outputs);
			#echo "<br>";
			break;
			
	}
}

# VERIFY OUTPUT POSTED DATA TO OUTPUT
if ($stage == 'verify_output' && $output_id) {
	$output = validate_output($db_handle, $output, $outputs, $sources);
	$outputs = save_obj($outputs, $output);
	$_SESSION['outputs'] = $outputs;
	$stage = 'outputs';
}

	
# OUTPUT MANAGEMENT
if ($stage == 'output_manage_action') {
	switch ($manage_action) {
		case 'return':
			$stage = 'outputs';
			break;
		case 'delete':
			# DELETE OUTPUT
			if (!$output_id) {
				$manage_err = true;
				} else {
				$i = 0;
				foreach ($outputs as $output) {
					if ($output['id'] == $output_id) {
						$d = $i;
						$i++;
						}
					}
				#echo "$manage_action, $output_id, $d<br>";
				unset($outputs[$d]);
				array_values($outputs);
				// print_r($outputs);
				// echo "<br>";
				$manage_err = false;
				}
			$stage = 'outmanage';
			break;
		case 'edit':
			$stage = 'setoutput';
			break;
		}
	}
	
if ($names) $_SESSION['names'] = $names;
if ($outputs) $_SESSION['outputs'] = $outputs;

# ---------------------------------------------------------------------------------------------------------------------------------------------
#                                                                            SHOPPING CART
# ---------------------------------------------------------------------------------------------------------------------------------------------

if ($stage != 'finish') { 
	//print_r($names);
	html_cart($db_handle, $qobjects, $sources, $names, $outputs, $cancel);
	}	

# ---------------------------------------------------------------------------------------------------------------------------------------------
#                                                                                 FORM
# ---------------------------------------------------------------------------------------------------------------------------------------------

//echo "html stage: $stage<br>";
	
if ($qterm == 'finish') $stage = 'finish';

if ($stage == 'sources') {
	# Select name source or input names
	#$mytimes = add_key_val($mytimes, "begin_select_sources", microtime(TRUE));
	html_select_sources($db_handle);
	echo "<input type = 'hidden' name ='stage' value='getsources'>";
	#$mytimes = add_key_val($mytimes, "end_select_sources", microtime(TRUE));
	}
	
#MANAGE QUERIES
if ($stage == 'manage') {
	$stage = html_manage($qobjects, $qmanage_err);
	echo "<input type = 'hidden' name ='stage' value='maction'>";
}	

# NEW QUERY
if ($stage == 'qbegin') {
	html_query_type($db_handle, $qobjects, $sources, $names, $name_search);
	echo "<input type = 'hidden' name ='stage' value='qset'>";
	}
	//print_r($qobjects);
# QUERY SETUP
if ($stage == 'qset') html_query_set($db_handle, $qobjid, $qobjects, $sources, $names);

# QUERY SETUP2 FOR BIOTREE AND BIOTABLE
if ($stage == 'qset2') html_query_set2($db_handle, $qobjid, $qobjects, $sources, $names);
	
# SELECT SOURCE TO OUTPUT
if ($stage == 'outputs') html_output_source($sources, $outputs);

# SET OUTPUT DIALOGS
if ($stage == 'outputset') {
	html_output_set($db_handle, $output, $outputs, $qobjects, $sources);
	#echo "post html_output_biotree<br>";
	#print_r($outputs);
}
	
# MANAGE OUTPUTS
if ($stage == 'outmanage') {
	html_manage('output_id', 'manage_action', $outputs, 'manage_err');
	echo "<input type = 'hidden' name='stage' value='output_manage_action'>";
	}
				
if ($stage == 'write') {
	$zip = html_write($db_handle, $config, $names, $qobjects, $outputs, $sources);
	echo '<input type="hidden" name="stage" value="finish">';
	}
	

# Unique id for each form instance
echo '<input type ="hidden" name="token" value=' . md5(uniqid()) .'>';

//echo "end form n qobjects " . count($qobjects) . "<br>";

if ($stage == 'finish') {
	# clean up
	if ($files_to_delete) {
		foreach ($files_to_delete as $file) unlink($file);
		}
	session_destroy();
	echo "<br>";
	echo '<h2>Thank you for using the Entangled Bank</h2>';
	echo '<input id="submit-button" type="submit" value="Another query?"><br/>';
	#echo '<input type="hidden" name=finish value="no">';
	echo "<br>";	
	} else {
		switch (true) {
			case ($stage == 'qset2' || $stage == 'outputset'):
				echo '<input id="submit-button" type="submit" value="Next >" onClick="selAll()">';
				break;
			case ($stage == 'qset' && $qobject['term'] == 'biogeographic'):
				echo '<input id="submit-button" type="submit" value="Next >" onClick="return serialize_layer();">';
				break;
			default:
				echo '<input id="submit-button" type="submit" value="Next >">';
				break;
		}
//		if ($stage == 'qset2' || $stage == 'outputset') {
//			echo '<input id="submit-button" type="submit" value="Next >" onClick="selAll()">';
//		} else {
//			echo '<input id="submit-button" type="submit" value="Next >">';
//		}
	}

echo '</form>';
#Print mytimes array
$mytimes = add_key_val($mytimes, "end_page", microtime(TRUE));
#print_arr($mytimes);
//echo "endform<br>";
//print_r($outputs);

html_entangled_bank_footer();

#Close db handle
pg_close($db_handle);
echo "</body>";

?>