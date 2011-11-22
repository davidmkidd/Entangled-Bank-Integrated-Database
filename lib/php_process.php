<?php

function process_qset($qobjid, $qterm, $oldtoken, $newtoken, $lastaction, $lastid) {
	
	# BACK BUTTON
	if ($lastaction == 'run') {
		echo "process_qset last action 'run'<br>";
		$qobjid = $lastid;
		return $qobjid;
	}	
	
	# CREATE NEW OR UPDATE EXISTING QUERY
	$qobjects = $_SESSION['qobjects'];
	
	# REFRESH
	if ($oldtoken == $newtoken && $qobjects[count($qobjects) - 1]['status'] == 'new') {
		$qobject = $qobjects[count($qobjects) - 1];
		return $qobject['id'];
	} 
	
	if ($qobjid) return $qobjid;
	
	if (!$qobjects) $qobjects = array();
		
	# CREATE NEW QOBJECT
	$qname = get_next_name($qobjects, $qterm);
	$qobjid = md5(uniqid());
	echo "Creating new $qterm qobject, id $qobjid<br>";
	$qobject = array(
		'id' => $qobjid,
		'term' => $qterm,
		'name' => $qname,
		'status' => 'new'
		);
	
	# ADD SOURCE TO BIOTREE/BIOTABLE QUERY
	if ($qterm == 'biotree') $qobject['sources'] = array($_SESSION['biotree_sid']);
	if ($qterm == 'biotable') $qobject['sources'] = array($_SESSION['attribute_sid']);

	array_push($qobjects, $qobject);
	$_SESSION['qobjects'] = $qobjects;

	return $qobjid;
}


#=====================================================================================================

function process_get_sources($db_handle, $sourceids, $lastaction) {
	
	if($lastaction == 'selectsources') {
		unset ($_SESSION['qobjects']);
		unset ($_SESSION['names']);
		unset ($_SESSION['outputs']);
	}
	
	//echo "process_get_sources: before get_sources<br>";
	$sources = get_sources($db_handle, $sourceids, 'bio');
	//echo "process_get_sources: after get_sources<br>";
	
	# WHICH TYPES OF QUERY ARE AVAILABLE?
	$bioname = Array();
	$biotable = Array();
	$biotree = Array();
	$biogeographic = Array();
	$biotemporal = Array();
	
	foreach($sources as $source) {
		array_push($bioname,$source['name']);
		if ($source['term'] == 'biotable') array_push($biotable,$source['name']);
		if ($source['term'] == 'biotree') array_push($biotree,$source['name']);
		if ($source['term'] == 'biogeographic') {
			array_push($biogeographic, $source['name']);
			array_push($biotable,$source['name']);
		}
		
		// GPDD HARDCODE
		if ($source['term'] == 'biorelational') {
			array_push($biotemporal,$source['name']);
			array_push($biogeographic, $source['name']);
			array_push($biotable, $source['name']);
		}
	}
	$_SESSION['sources'] = $sources;
	$_SESSION['bioname'] = $bioname;
	$_SESSION['biotable'] = $biotable;
	$_SESSION['biotree'] = $biotree;
	$_SESSION['biogeographic'] = $biogeographic;
	$_SESSION['biotemporal'] = $biotemporal;
	return 'main';
}

#=====================================================================================================

function process_delete_query($db_handle, $qobjid) {
	
	$qobjects = $_SESSION['qobjects'];
	$idx = obj_idx($qobjects, $qobjid);

	if (isset($idx)) {
		unset ($qobjects[$idx]);
		//echo "query $qobjid deleted, " . count($queries) . " in stack<br>";
		array_values($qobjects);
		$_SESSION['qobjects'] = $qobjects;
		# RUN QUERIES
		if (!empty($qobjects)) {
			unset($_SESSION['names']);
			unset($_SESSION['mids']);
			foreach ($qobjects as $qobject) query($db_handle, $qobject['id']);
		} else {
			unset($_SESSION['names']);
			unset($_SESSION['qobjects']);
			unset($_SESSION['mids']);
		}
	} else {
		# ELSE DO NOTHING AS QUERY ALREADY DELETED
		//echo "query $qobjid not found in stack of " . count($queries) . " queries<br>";
	}
	
}

#=====================================================================================================

function process_new_output ($newtoken, $newtoken, $output_sid) {
	
	$outputs = $_SESSION['outputs'];
	$sources = $_SESSION['sources'];
	
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
			array_push($outputs, $output);
			break;
	}
	
	$_SESSION['outputs'] = $outputs;
	return($output['id']);
	
}

#=====================================================================================================

function process_delete_output ($oid) {
	
	$outputs = $_SESSION['outputs'];
	
	$idx = obj_idx($outputs, $oid);
	unset ($outputs[$idx]);
	array_values($outputs);
	
	$_SESSION['outputs'] = $outputs;
	
}

#=====================================================================================================

function process_query ($db_handle, $qobjid, $qsources) {
	
	//echo "begin process_query $qobjid<br>";

	$qobjects = $_SESSION['qobjects'];
	
	$sources = $_SESSION['sources'];
	if ($_SESSION['names']) $names = $_SESSION['names'];
	if ($qobjid) $qobject = get_obj($qobjects, $qobjid);
	unset ($qobject['errs']);
	$qobject['status'] = 'valid';
	$term = $qobject['term'];
	
	# --------
	# ADD KEYS
	# --------

	# GENERAL
	$qobject['name'] = $_SESSION['objname'];
	if ($_SESSION['queryoperator']) $qobject['queryoperator'] = $_SESSION['queryoperator'];
    
    # MULTIPLE SOURCES
    if ($term == 'biogeographic' || $term =='biotemporal' || $term == 'bionames') {
    	$qobject['sources'] = $qsources;
    	$qobject['nsources'] = $_SESSION['nsources'];
    	$qobject['noperator'] = $_SESSION['noperator'];
    }
    
    
	# PROCESS QUERY BY TERM
	switch ($term) {
		case 'bionames':
			process_bionames($db_handle, $qobject, $sources);
			break;
		case 'biotable':
			process_biotable($db_handle, $qobject, $sources, $names);
			break;
		case 'biotree':
			process_biotree($db_handle, $qobject, $sources);
			break;
		case 'biotemporal':
			process_biotemporal($qobject, $sources);
			break;
		case 'biogeographic':
			process_biogeographic($qobject);
			break;	
		default:
			echo "validate_query: unrecognised query type $term";
			break;
		}
	
/*	if (!$qobject['errs']) {
		$stage = 'query';
		$qobject['status'] = 'valid';
	}  else {
		$qobject['status'] = 'invalid';
	}*/
	
	if ($qobject['status'] === 'valid') {
		$stage = 'query';
	} else {
		$stage = 'qset';
	}
	
	$qobjects = save_obj($qobjects, $qobject);
	$_SESSION['qobjects'] = $qobjects;
	
	//print_r($qobject);
	//echo "<br>finish process_query: $stage<br>";
	
	return $stage;
	
}

#=================================================================================================================

function process_cleanup($config) {
	
	#DELETES ALL FILES IN ./tmp that are older than a day
	
	$path = $config['out_path'];
	
	if ($handle = opendir($path)) {
	
	    while (false !== ($file = readdir($handle))) { 
	        $filelastmodified = filemtime($file);
	
	        if(($filelastmodified-time()) > 24*3600)
	        {
	           unlink($file);
	        }
	
	    }
	
	    closedir($handle); 
	}
}


#=================================================================================================================

function process_biogeographic(&$qobject) {
	
	$qobject['s_operator'] = $_SESSION['s_operator'];
	$qobject['q_geometry'] = $_SESSION['q_geometry'];

}


#=================================================================================================================


function process_bionames($db_handle, &$qobject, $sources) {	
	
	# Converts names input to array
	# and validates against DB
	
	if ($qobject['errs']) unset($qobject['errs']);
	
	//echo "allnames = " . $qobject['allnames'] . "<br>";
	
	# NAMES IN QUERY
	add_taxa_to_query($qobject);
	if ($term == 'bionames') {
		if ($_SESSION['allnames'] == 'on') {
			$qobject['allnames'] = 'true';
		} else {
			$qobject['allnames'] = 'false';
		}
	    //unset($_SESSION['allnames']);
	} 

	switch (true) {
		case ($qobject['allnames'] == 'false' && empty($qobject['taxa'])):
			//$errs = array();
			//$errs = array_merge($errs, array('taxa' => "one or more taxa must be input"));
			//$qobject = add_key_val($qobject, 'errs', $errs);
			//return $qobject;
			break;
		case ($qobject['allnames'] == 'false'):
			validate_names($db_handle, $qobject, $sources);
			break;
	}
	
}
	
#=================================================================================================================
	
function process_biotable($db_handle, &$qobject, $sources, $names)  {

	// ADD QUERY INPUT FROM html_table_query TO QOBJECT
	
	//if ($qobject['errs']) unset ($qobject['errs']);
	if ($qobject['queries']) unset ($qobject['queries']);
	
	//echo "begin validate table<br>";
	$source = get_obj($sources, $qobject['sources'][0]);
	$fields = $source['fields'];
	$queries = array();
	$qfields = array();            //fields in query
	$fnames = array();

	$qobject['querynull'] = $_SESSION['querynull'];
	
	# GPDD NSERIES
	if ($source['term'] == 'biorelational' && $_SESSION['nseries'] == 'on') {
		echo "adding nseries to query<br>";
		if ($_SESSION['nseries']) $qobject['nseries'] = $_SESSION['nseries'];
		if ($_SESSION['nseries_operation']) $qobject['nseries_operation'] = $_SESSION['nseries_operation'];
	}
	
	# FIELDS IN SOURCE
	foreach($fields as $field) array_push($fnames, $field['name']);
	
	# GET CHECKED QUERIES 
	# add to qfields array.
	foreach($_SESSION as $key=>$value) {
		$keyfield = substr($key, 0, strrpos($key, "_"));
		$keysuffix = substr($key, strrpos($key, "_") + 1);
		$val = 0;
		$val = in_array($keyfield, $fnames);
		if ($keysuffix == 'query' && $value == 'on' && $val == 1) array_push($qfields, $keyfield);
	}
	
	
	# PROCESS QUERY FIELDS
	//echo "qfields: ";
	//print_r($qfields);
	//echo "<br>";
	
	foreach ($qfields as $qfield) {
			
	//$i = array_search($qfield, $fields);
	$field = get_field($qfield, $fields);
	//print_r($field);
	//echo "<br>";
	$dtype = $field['ebtype'];
	$lookup = $field['lookup'];
	
		///echo "field: $qfield, $dtype<br>";
		switch ($dtype) {
			case 'rangefield':
				$op = $qfield . '_operator';
				$val = $qfield . '_value';
				$query = array('field'=>$qfield, 'operator'=>$_SESSION[$op], 'value'=>$_SESSION[$val]);
				unset($_SESSION[$op]);
				unset($_SESSION[$val]);
				array_push($queries, $query);
				break;
			case 'lookupfield':
			case 'namefield':
			case 'catagoryfield':
				$field = $qfield . "_add";
				$values = $_SESSION[$field];
				//echo "field: $field, values: $values<br>";
				$ops = array_fill(0, count($values), '=');
				$query = array('field'=>$qfield, 'operator'=>$ops, 'value'=>$values);
				array_push($queries, $query);
				unset($_SESSION[$field]);
				break;
			case 'lookuptable':
				$field = $qfield . "_add";
				$values = $_SESSION[$field];
				echo "field: $field, values: $values<br>";
				$ops = array_fill(0, count($values), '=');
				$query = array('field'=>$qfield, 'operator'=>$ops, 'value'=>$values, 'lookup'=>$lookup);
				array_push($queries, $query);
				unset($_SESSION[$field]);
				break;
			case 'groupfield':
				# GPDD hardcode
				$op = $_SESSION['NSeries_operation'];
				$value = $_SESSION['NSeries_count'];
				$query = array('field'=>$qfield, 'operator'=>$op, 'value'=>$value);
				array_push($queries, $query);
				unset($_SESSION['NSeries_operation']);
				unset($_SESSION['NSeries_count']);		
				break;
		}
		
		$q = $qfield . '_query';
		unset($_SESSION[$q]);
		unset($_SESSION[$qfield]);
	}
	//print_r($queries);
	//echo "<br>";
	$qobject['queries'] = $queries;	
	
}
	
# ===================================================================================================================
	
	function process_biotemporal(&$qobject, $sources) {
		
		// GPDD HARDCODE
		$day = $_SESSION['day'];
		$month = $_SESSION['month'];
		$qobject['year'] = $_SESSION['year'];
		$qobject['toperator'] = $_SESSION['toperator'];
		
		$months_w30days = array(4,6,9,11);
		$days = array(31,28,31,30,31,30,31,31,30,31,30,31);
		
		// DAYS IN MONTH CORRECTION - should be done via js
		if ($month == 2 && $day > 28) $day = 28;
		if (in_array($month,$months_w30days) && $day = 31) $day = 30;
		$qobject['day'] = $day;
		
		$nday = 0;
		for ($i = 0; $i <= $month - 1; $i++) $nday = $nday + $days[$i];
		$nday = $nday + $day;
		$qobject['dtime'] = $qobject['year'] + ($nday/365);
		$qobject['day'] = $day;
		$qobject['month'] = $month;
	}

# ===================================================================================================================

function process_biotree ($db_handle, &$qobject, $sources) {
			
	$qobject['subtree'] = $_SESSION['subtree'];
	//$qobject['treenodes'] = $_SESSION['treenodes'];
	$qobject['nodefilter'] = $_SESSION['nodefilter'];
	$qobject['filterscope'] = $_SESSION['filterscope'];
	add_taxa_to_query($qobject);
	
	# NO NAMES, NOT ALL & NO NAMES SO SET NAMES TO EMPTY QUERY
	if (empty($qobject['taxa']) and $qobject['subtree'] != 'all' and !$_SESSION['names']) {
		$_SESSION['names'] = array();
	}

}
	
	
# ===================================================================================================================

function validate_name($db_handle, $name, $qobject, $sources) {
	
	#Returns number of sources name is in
	#echo "validate_name: $name<br>";
	//print_r($qobject['sources']);
	if (strlen($name) > 0) {
		$n = 0;
		$qsources = $qobject['sources'];
		foreach ($sources as $source) {	
			//echo "source id: " . $source['id'];
			//print_r($qsources);
			if (in_array($source['id'], $qsources)) {
				//echo $source['term'] . "<br>";
				//print_r($source);
				switch ($source['term']) {
					case "biotable" :
					case "biogeographic" :
						$str = "SELECT " . $source['namefield'] . 
							" FROM " . $source['dbloc'] .
							" WHERE " . $source['namefield'] . " = '$name';";
						break;	
					case "biotree":
						$str = "SELECT * FROM biosql.node WHERE label = '$name' AND tree_id = " . $source['tree_id'] .";";
						break;
					case 'biorelational':
						# GPDD HARDCODE
						$str = "SELECT binomial FROM gpdd.taxon WHERE binomial='$name'";
						break;
					default :
						echo "$source is not a source.<br>";
						return;
					}
				$result = pg_query($db_handle, $str);
				if (!$result) {
					echo "validate name: No result retured.";
					exit;
					}
				$rows = pg_num_rows($result);
				if ($rows > 0) $n++;
				}
			}
		}
	return $n;
	}

	
#=================================================================================================================
		
function validate_names($db_handle, &$qobject, $sources) {
	
	# taxa are names to test which are added to names
	//echo "begin validate names<br>";
/*	print_r($qobject['taxa']);
	echo "<br>";*/
	$taxa = $qobject['taxa'];
	
	if (isset($qobject['invalid_taxa'])) unset ($qobject['invalid_taxa']);

	$valid_taxa = array();
	$invalid_taxa = array();
	foreach ($taxa as $name) {
		$n = validate_name($db_handle, $name, $qobject, $sources);
		#echo "$name is in $n sources<br>";
		if ($n > 0) {
			array_push($valid_taxa, $name);
		} else {
			array_push($invalid_taxa, $name);
		}
	}

	$qobject['taxa'] = $valid_taxa;
	if (!empty($invalid_taxa)) {
		$qobject['invalid_taxa'] = $invalid_taxa;
		$errs = array();
		$errs = array_merge($errs, array('invalid_taxa' => "unrecognised taxa"));
		$qobject = add_key_val($qobject, 'errs', $errs);
		$qobject['status'] = 'invalid';
		}
	}
	
	#=================================================================================================================

	function process_output($db_handle, $output_id) {
		
		$sources = $_SESSION['sources'];
		$outputs = $_SESSION['outputs'];
		$output = get_obj($outputs, $output_id);
		$source = get_obj($sources, $output['sourceid']);
		$term = $source['term'];
		//echo "$output_id<br>";
		//print_r($outputs);
		
		$objname = $_SESSION['objname'];
		if (!$objname) {
			$objname = get_next_name($outputs, $term);
		}
		
		$output['name'] = $objname;
		$output['term'] = $term;
	
		switch ($term) {
			case 'biotable':
				# ADD KEYS
				$output['fields'] = $_SESSION['fields_add'];
				$output['db_format'] = $_SESSION['db_format'];
				// ADD STRING
				//$as_string = "RETURN " . count($output['fields']) . " fields FROM " . $source['name'] . " AS " . $output['db_format'];
				//$output['as_string'] = $as_string;
				break;
			case 'biogeographic':
				# ADD KEYS
				$output['sp_format'] = $_SESSION['sp_format'];
				// ADD STRING
				//$as_string = "RETURN "  . $source['name'] . " AS " . $output['sp_format'];
				//$output['as_string'] = $as_string;
				break;
				
			case 'biorelational':
				$output['db_format'] = 'csv';
				$output['sp_format'] = $_SESSION['sp_format'];
				//$as_string = "RETURN gpdd.tables FROM " . $source['name'] . " AS " . $output['db_format'];
				//$as_string = $as_string . " AND gpdd.geography FROM " . $source['name'] . " AS " . $output['sp_format'];
				//$output['as_string'] = $as_string;
				break;
				
			case 'biotree':
				# ADD KEYS
				$output['tree_id'] = $source['tree_id'];
				$format = $_SESSION['format'];
				$brqual = $_SESSION['brqual'];
				$outsubtree = $_SESSION['outsubtree'];
		
				if ($format) {
					$output['format'] = $format;
					$output['subtree'] = $outsubtree;
					}
				if ($brqual) {
					$output['brqual'] = $brqual;
					}
					
				break;
			}

		$output['status'] = 'valid';
		$outputs = save_obj($outputs, $output);
		
		$_SESSION['outputs'] = $outputs;
	}
	
# =================================================================================================================

function add_taxa_to_query (&$qobject) {
	
	//echo "SESSION['taxa']" .  $_SESSION['taxa'] . "<br>";
	$taxa = $_SESSION['taxa'];
	//unset($_SESSION['taxa']);
	//print_r($taxa);
	$names = array();
	
	if (!empty($taxa)) {
		if ($qobject['term'] == 'biotree') {
			foreach ($taxa as $name) array_push($names, str_replace('.', "", $name));	
			#Remove empty names
			//$names = remove_array_empty_values($names, true);
		} else {
			$names = explode("\r\n",$taxa);
		}
	}
	
	if ($_SESSION['invalid_taxa']) {
		$invalid_taxa = $_SESSION['invalid_taxa'];
		$invalid_names = explode("\r\n",$invalid_taxa);
		$names = array_merge($names, $invalid_names);
		unset($_SESSION['invalid_taxa']);
	}
	
	$names = remove_array_empty_values($names, true);
	
	# Add to qobject
	//if ($qobject['taxa']) unset($qobject['taxa']);
	$qobject['taxa'] = $names;
}
	



?>