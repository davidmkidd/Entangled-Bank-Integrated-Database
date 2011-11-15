<?php

// Validation

function process_query ($db_handle, $qobjid, $qsources) {
	
	//echo "begin prcess_query<br>";
	
	$qobjects = $_SESSION['qobjects'];
	if ($qobjid) $qobject = get_obj($qobjects, $qobjid);
	$sources = $_SESSION['sources'];
	$names = $_SESSION['names'];
	unset ($qobject['errs']);
	
	$term = $qobject['term'];
	
	echo "Validate, term = $term<br>";
	
	# --------
	# ADD KEYS
	# --------

	# GENERAL
	$qobject['name'] = $_SESSION['objname'];
	$qobject['querynull'] = $_SESSION['querynull'];
	$qobject['queryoperator'] = $_SESSION['queryoperator'];
    
	# NAMES IN QUERY
	if ($term == 'bionames' || $term == 'biotree') {
		$qobject = add_taxa_to_query($qobject);
		if ($_SESSION['allnames']) {
			if ($_SESSION['allnames'] == 'on') {
				$qobject['allnames'] = 'true';
			} else {
				$qobject['allnames'] = 'false';
			}
		    unset($_SESSION['allnames']);
		} else {
		    $qobject['allnames'] = 'false';
	    }
	}
    
    # MULTIPLE SOURCES
    if ($term == 'biogeographic' || $term =='biotemporal' || $term == 'bionames') {
    	$qobject['sources'] = $qsources;
    	$qobject ['nsources'] = $_SESSION['nsources'];
    	$qobject['noperator'] = $_SESSION['noperator'];
    }
    
	# Tree keys
	if ($term == 'biotree') {
		$qobject['subtree'] = $_SESSION['subtree'];
		switch (true) {
			case ($_SESSION['treenodes'][0] == 'tip' && $_SESSION['treenodes'][1] == 'internal'):
				$qobject['treenodes'] = 'all';
				break;
			case ($_SESSION['treenodes'][0] == 'tip'):
				$qobject['treenodes'] = 'tip';
				break;
			case ($_SESSION['treenodes'][0] == 'internal'):
				$qobject['treenodes'] = 'internal';
				break;
		}
	}
    
	# PROCESS QUERY BY TERM
	switch ($term) {
		case 'bionames':
			$qobject = process_bionames($db_handle, $qobject, $sources);
			break;
		case 'biotable':
			process_biotable($db_handle, $qobject, $sources, $names);
			break;
		case 'biotree':
			$qobject = process_biotree($db_handle, $qobject, $sources);
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
	
	if (!$qobject['errs']) {
		$stage = 'query';
		$qobject['status'] = 'valid';
	}  else {
		$qobject['status'] = 'invalid';
	}
	

	if ($qobject['status'] === 'valid') {
		$stage = 'query';
	} else {
		$stage = 'qset';
	}
	
	$qobjects = save_obj($qobjects, $qobject);
	$_SESSION['qobjects'] = $qobjects;
	
	//echo "After process_query<br>";
	//print_r($qobjects);
	//echo "<br>";
	
	return $stage;
	
}

#=================================================================================================================


function process_biogeographic(&$qobject) {
	
	$qobject['s_operator'] = $_SESSION['s_operator'];
	$qobject['q_geometry'] = $_SESSION['q_geometry'];

}


#=================================================================================================================


function process_bionames($db_handle, $qobject, $sources) {	
	
	# Converts names input to array
	# and validates against DB
	
	if ($qobject['errs']) unset($qobject['errs']);
	
	//echo "allnames = " . $qobject['allnames'] . "<br>";
	
	switch (true) {
		case ($qobject['allnames'] == 'false' && empty($qobject['taxa'])):
			$errs = array();
			$errs = array_merge($errs, array('taxa' => "one or more taxa must be input"));
			$qobject = add_key_val($qobject, 'errs', $errs);
			return $qobject;
			break;
		case ($qobject['allnames'] == 'false'):
			$qobject = validate_names($db_handle, $qobject, $sources);
			break;
	}
	
	return $qobject; 
	}
	
#=================================================================================================================
	
function process_biotable($db_handle, &$qobject, $sources, $names)  {
	
	//echo "begin validate table<br>";

	// Generates query from html_table_query entrie
	if ($qobject['errs']) unset ($qobject['errs']);
	if ($qobject['queries']) unset ($qobject['queries']);
	
	$source = get_obj($sources, $qobject['sources'][0]);
	$fields = $source['fields'];
	$queries = array();
	$qfields = array();            //fields in query
	$fnames = array();

	# GPDD keys
	if ($source['term'] == 'biorelational') {
		$qobject['nseries'] = $_SESSION['nseries'];
		$qobject['nseries_operation'] = $_SESSION['nseries_operation'];
	}
	
	foreach($fields as $field) array_push($fnames, $field['name']);
	
	# GET CHECKED QUERIES 
	// add to qfields array.
	foreach($_SESSION as $key=>$value) {
		$keyfield = substr($key, 0, strrpos($key, "_"));
		$keysuffix = substr($key, strrpos($key, "_") + 1);
		$val = 0;
		$val = in_array($keyfield, $fnames);
		if ($keysuffix == 'query' && $value == 'on' && $val == 1) array_push($qfields, $keyfield);
	}
	
	
	// Process qfields
	if (!empty($qfields)) {
		echo "qfields: ";
		print_r($qfields);
		echo "<br>";
		foreach ($qfields as $qfield) {
			
			//$i = array_search($qfield, $fields);
			$field = get_field($qfield, $fields);
			$dtype = $field['ebtype'];
			$lookup = $field['lookup'];
			
			///echo "field: $qfield, $dtype<br>";
			
			switch ($dtype) {
				case 'rangefield':
					$ops = array();
					$values = array();
					$field = $qfield . "_min";
					$value = $_SESSION[$field];
					array_push ($ops, '>=');
					array_push ($values, $value);
					$field = $qfield . "_max";
					$value = $_SESSION[$field];
					array_push ($ops, '<=');
					array_push ($values, $value);						
					$query = array('field'=>$qfield, 'operator'=>$ops, 'value'=>$values);
					array_push($queries, $query);
					break;
				case 'lookupfield':
				case 'namefield':
				case 'catagoryfield':
					$field = $qfield . "_add";
					$values = $_SESSION[$field];
					$ops = array_fill(0, count($values), '=');
					$query = array('field'=>$qfield, 'operator'=>$ops, 'value'=>$values);
					array_push($queries, $query);
					break;
				case 'lookuptable':
					$field = $qfield . "_add";
					$values = $_SESSION[$field];
					$ops = array_fill(0, count($values), '=');
					$query = array('field'=>$qfield, 'operator'=>$ops, 'value'=>$values, 'lookup'=>$lookup);
					array_push($queries, $query);
					break;
				case 'groupfield':
					# GPDD hardcode
					$op = $_SESSION['NSeries_operation'];
					$value = $_SESSION['NSeries_count'];
					$query = array('field'=>$qfield, 'operator'=>$op, 'value'=>$value);
					array_push($queries, $query);				
					break;
			}
		
		}
		print_r($queries);
		echo "<br>";
		$qobject['queries'] = $queries;	
	} else {
		$errs = array();
		$errs = array_merge($errs, array('query' => "one or more fields must be queried"));
		$qobject = add_key_val($qobject, 'errs', $errs);
	}
	
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


	function process_biotree ($db_handle, $qobject, $sources) {
			# NO NAMES
			if ($qobject['errs']) unset($qobject['errs']);
			if (empty($qobject['taxa']) and $qobject['subtree'] != 'all') {
				$errs = array();
				$errs = array_merge($errs, array('taxa' => "one or more taxa must be selected"));
				$qobject = add_key_val($qobject, 'errs', $errs);
				return $qobject;
			}
			$qobject['taxa'] = $qobject['taxa'];
			return $qobject;
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
		
function validate_names($db_handle, $qobject, $sources) {
	
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

//	echo "qobject after validate_names:<br>";
//	print_r($qobject['taxa']);
//	print_r($qobject['invalid_taxa']);
//	echo "<br>";
	
	return $qobject;
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

function add_taxa_to_query ($qobject) {
	
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
	return $qobject;
}
	
?>