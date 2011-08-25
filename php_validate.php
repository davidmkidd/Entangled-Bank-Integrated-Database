<?php

// Validation

function validate_query ($db_handle, $qobject, $sources, $qsources, $names) {
	
	unset ($qobject['errs']);
	$term = $qobject['term'];
	#echo "Validate, term = $term<br>";
//	echo print_r($qobject) . "<br>";
	# NUMBER OF SOURCES
	//print_r($qsources);
	
	switch ($term){
		case 'biogeographic':
		case 'bionames':
		case 'biotemporal':
			if (count($qsources) == 0) {
				$qobject['errs'] = array_merge($qobject['errs'], array('sources' => "One or more sources must be selected"));
			} else {
				$qobject = add_key_val($qobject,'sources', $qsources);
			}
			break;
		default:
			break;
	}
	
	# --------
	# ADD KEYS
	# --------
	#echo "add keys";
	# GENERAL
	$qobject = add_key_val($qobject, 'name', $_SESSION['objname']);
	if ($_SESSION['querynot']) {
		$qobject = add_key_val($qobject, 'querynot', 'NOT');
	} else {
		$qobject = add_key_val($qobject, 'querynot', '');
	}
	
	$qobject = add_key_val($qobject, 'querynull', $_SESSION['querynull']);

	# INTERQUERY OPERATOR 
	//echo $_SESSION['queryoperator'] . "<br>";
	$qobject = add_key_val($qobject, 'queryoperator', $_SESSION['queryoperator']);
    
	# NAMES QUERY
	if ($term == 'bionames' || $term == 'biotree') {
//		echo "taxa:<br>";
//		print_r($_SESSION['taxa']);
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
    	$qobject = add_key_val($qobject, 'nsources', $_SESSION['nsources']);
    	$qobject = add_key_val($qobject, 'noperator', $_SESSION['noperator']);
    }
    
	# Tree keys
	if ($term == 'biotree') {
		$qobject = add_key_val($qobject, 'subtree', $_SESSION['subtree']);
		$qobject = add_key_val($qobject, 'treenodes', $_SESSION['treenodes']);
	}

	
	# Geographic keys
	if ($term == 'biogeographic') {
		$qobject['s_operator'] = $_SESSION['s_operator'];
		$qobject['q_geometry'] = $_SESSION['q_geometry'];
		}
	#Temporal keys
	if ($term == 'biotemporal') {
		$qobject = add_key_val($qobject, 't_overlay', $_SESSION['t_overlay']);
		$qobject = add_key_val($qobject, 'from_day', $_SESSION['from_day']);
		$qobject = add_key_val($qobject, 'from_month', $_SESSION['from_month']);
		$qobject = add_key_val($qobject, 'from_year', $_SESSION['from_year']);
		$qobject = add_key_val($qobject, 'to_day', $_SESSION['to_day']);
		$qobject = add_key_val($qobject, 'to_month', $_SESSION['to_month']);
		$qobject = add_key_val($qobject, 'to_year', $_SESSION['to_year']);		
	}
	
	# GPDD keys
	if ($term == 'biorelational') {
		$qobject = add_key_val($qobject, 'nseries', $_SESSION['nseries']);
		$qobject = add_key_val($qobject, 'nseries_operation', $_SESSION['nseries_operation']);
	}
    
	#echo " - keys added<br>";
//	print_r ($qobject);
//	echo "<br>";
//	
	# validate query
	switch ($term) {
		case 'bionames':
			$qobject = validate_bionames($db_handle, $qobject, $sources);
			break;
		case 'biotable':
			$qobject = validate_biotable($db_handle, $qobject, $sources, $names);
			break;
		case 'biotree':
			$qobject = validate_biotree($db_handle, $qobject, $sources);
			break;
		case 'biotemporal':
			$qobject = validate_biotemporal($qobject, $sources);
			break;
		// Biogeographic validated with Javascript
		case 'biogeographic':
			// Validated by js on input
			//$qobject = validate_biogeographic($qobject, $sources);
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
	
/*	echo " - validation finished<br>";;
	print_r($qobject);
	echo "<br>";*/
	
	return $qobject;
	
}


# =============================================================================================================================

/*function validate_biogeographic($qobject, $sources) {

	# Validates spatial query returning an updated select object then subsets names by bounding box or returns an array of errors
	
	# Returns an array, [0]  names within spatial query, [1] names outside of spatial query, [2] error messages

	# Delete existing errors - Fix for resubmit
	if (array_key_exists('errs', $qobject)) {
		remove_element($qobject, 'errs');
		}
//	echo "begin validate_biogeographic<br>";
//	print_r($qobject);
//	echo "<br>";
	$bbox = $qobject['bbox'];
	$nsources = $qobject['nsources'];
	$nsources_operator = $qobject['noperator'];
	$nqsources = count($qobject['sources']);
	$s_overlay = $bbox['s_overlay'];
	$bbnorth = $bbox['bbnorth'];
	$bbsouth = $bbox['bbsouth'];
	$bbeast = $bbox['bbeast'];
	$bbwest = $bbox['bbwest'];
	
	#check all boxes have valid entries
	$errs = array();
	//echo "nsources = $nsources, nqsources = $nqsources, nsources_operator = $nsources_operator<br>";
	#nsources
	if ($nsources > $nqsources && ($nsources_operator == '=' || $nsources_operator == '>=')) {
		$errs = add_key_val($errs, "nsources", "$nqsources in query, but $nsources_operator $nsources requested");
	}
	
	
	# VALUES IN ALL BOXES
	if (!is_numeric($bbnorth)) {
		$errs = add_key_val($errs, "north", "All bounding box fields must have numeric values");
		}
	if (!is_numeric($bbsouth)) {
		$errs = add_key_val($errs, "south", "All bounding box fields must have numeric values");
		}
	if (!is_numeric($bbeast)) {
		$errs = add_key_val($errs, "east", "All bounding box fields must have numeric values");
		}
	if (!is_numeric($bbwest)) {
		$errs = add_key_val($errs, "west", "All bounding box fields must have numeric values");
		}
	
	# NORTH AND SOUTH
	if ($bbnorth and $bbsouth and $bbeast and $bbwest) {
	
		if ($bbnorth > 90 || $bbnorth < -90) $errs = add_key_val($errs, "north", "North must be between -90 and +90");
		if ($bbsouth > 90 || $bbsouth < -90) $errs = add_key_val($errs, "south", "South must be between -90 and +90");

		if ($bbnorth <= 90 and $bbsouth < 90 and $bbnorth > -9 and $bbsouth >= -90) {
			if ($bbnorth <= $bbsouth) {
				$errs = add_key_val($errs, "north", "North must be greater than South");
				$errs = add_key_val($errs, "south", "South must be less than Nouth");
				}
			}
		}
	
	# EAST AND WEST
	if ($bbwest > 180 || $bbwest < -180) $errs = add_key_val($errs, "west", "West must be between -180 and +180");
	if ($bbwest > 180 || $bbeast < -180) $errs = add_key_val($errs, "east", "East must be between -180 and +180");

	if (!empty($errs)) $qobject = add_key_val($qobject, "errs", $errs);
;	
	return $qobject;
	}*/

#=================================================================================================================


function validate_bionames($db_handle, $qobject, $sources) {	
	
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
	
function validate_biotable($db_handle, $qobject, $sources, $names)  {
	
	echo "begin validate table<br>";

	// Generates query from html_table_query entrie
	if ($qobject['errs']) unset ($qobject['errs']);
	if ($qobject['queries']) unset ($qobject['queries']);
	
	$source = get_obj($sources, $qobject['sources'][0]);
	$fields = $source['fields'];
	$queries = array();
	$qfields = array();            //fields in query
	$fnames = array();
	
	foreach($fields as $field) array_push($fnames, $field['fname']);
	
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
		foreach ($qfields as $qfield) {
			//echo "field $qfield<br>";
			//$i = array_search($qfield, $fields);
			$field = get_field($qfield,$fields);
			$dtype = $field['dtype'];
			
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
					$field = $qfield . "_add";
					$values = $_SESSION[$field];
					$ops = array_fill(0, count($values), '=');
					$query = array('field'=>$qfield, 'operator'=>$ops, 'value'=>$values);
					array_push($queries, $query);
					break;
				case 'lookuptable':
					$field = $qfield . "_add";
					$values = $_SESSION[$field];
					$ops = array_fill(0, count($values) - 1, '=');
					$query = array('field'=>$qfield, 'operator'=>$ops, 'value'=>$values);
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
		$qobject['queries'] = $queries;	
	} else {
		$errs = array();
		$errs = array_merge($errs, array('query' => "one or more fields must be queried"));
		$qobject = add_key_val($qobject, 'errs', $errs);
		return $qobject;
	}
	echo "End table validate<br>";
//	print_r($qobject);
//	echo "<br>";
	return $qobject;
	
}
	
# ===================================================================================================================
	
	function validate_biotemporal($qobject, $sources) {
		
		// GPDD HARDCODE
		// Validates:
		// days in month
		// before < to
		
		$from_year = $qobject['from_year'];
		$to_year = $qobject['to_year'];	
		$from_month = $qobject['from_month'];
		$to_month = $qobject['to_month'];
		$from_day = $qobject['from_day'];
		$to_day = $qobject['to_day'];
//		echo "from $from_day $from_month $from_year ";
//		echo " to $to_day $to_month $to_year<br>";
		
		$months_w30days = array(4,6,9,11);
		$days = array(31,28,31,30,31,30,31,31,30,31,30,31);
		//print_r($days);
		//echo "<br>";
		
		// DAYS IN MONTH CORRECTION - should be done via js
		if ($from_month == 2 && $from_day > 28) $from_day = 28;
		if (in_array($from_month,$months_w30days) && $from_day = 31) $from_day = 30;
		if ($to_month == 2 && $to_day > 28) $to_day = 28;
		if (in_array($to_month,$months_w30days) && $to_day = 31) $to_day = 30;
		$qobject['from_day'] = $from_day;
		$qobject['to_day']= $to_day;
		
		$nday = 0;
		for ($i = 0; $i <= $from_month - 1; $i++) $nday = $nday + $days[$i];
		//echo "$nday<br>";
		$nday = $nday + $from_day;
		$from_digital_time = $qobject['from_year'] + ($nday/365);
		$qobject['from_dtime'] = $from_digital_time;

		
		$nday = 0;
		for ($i = 0; $i <= $to_month - 1; $i++) $nday = $nday + $days[$i];
		$nday = $nday + $to_day;
		$to_digital_time =$qobject['to_year'] + ($nday/365);
		$qobject['to_dtime'] = $to_digital_time;

		//echo "$from_digital_time - $to_digital_time<br>";
		
		if ($from_digital_time >= $to_digital_time) {
			$errs = array();
			$errs = add_key_val($errs, "temporal", "'From' time must be before 'To' time");
			$qobject = add_key_val($qobject, 'errs', $errs);
		}
		
		return $qobject;
	}

# ===================================================================================================================


	function validate_biotree ($db_handle, $qobject, $sources) {
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

	function validate_output ($db_handle, $output, $outputs, $sources) {
		
		$source = get_obj($sources, $output['sourceid']);
		$term = $source['term'];
	
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
				# FORMAT OVERRIDE
				$output['db_format'] = 'csv';
				// ADD STRING
				$as_string = "RETURN " . count($output['fields']) . " fields FROM " . $source['name'] . " AS " . $output['db_format'];
				$output['as_string'] = $as_string;
				break;
			case 'biogeographic':
				# ADD KEYS
				$output['sp_format'] = $_SESSION['sp_format'];
				// ADD STRING
				$as_string = "RETURN "  . $source['name'] . " AS " . $output['sp_format'];
				$output['as_string'] = $as_string;
				break;
				
			case 'biorelational':
				$output['db_format'] = 'csv';
				$output['sp_format'] = $_SESSION['sp_format'];
				$as_string = "RETURN gpdd.tables FROM " . $source['name'] . " AS " . $output['db_format'];
				$as_string = $as_string . " AND gpdd.geography FROM " . $source['name'] . " AS " . $output['sp_format'];
				$output['as_string'] = $as_string;
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
					
				// ADD STRING
				if (array_key_exists('format', $output)) {
					if (array_key_exists('brqual', $output)) {
						$str = "SELECT name FROM biosql.term WHERE term_id = " . $output['brqual'];
						$res = pg_query($db_handle, $str);
						$row = pg_fetch_row($res);
						$as_string = "RETURN " . $output['subtree'] . "(bioname) FROM "
							. $source['name'] . " WITH '$row[0]' AS " . $output['format'];
					} else {
						$as_string = "RETURN " . $output['subtree'] . "(bioname) FROM "
							. $source['name'] . " AS " . $output['format'];
					}
				} else {
					$as_string = "RETURN ? FROM " . $source['name'];
				}
				$output['as_string'] = $as_string;
				break;
			}
		//print_r($output);
		//echo "<BR>";
		$output['status'] = 'valid';
	
		return $output;
	}
	
# =================================================================================================================

function add_taxa_to_query ($qobject) {
	
	//echo "SESSION['taxa']" .  $_SESSION['taxa'] . "<br>";
	$taxa = $_SESSION['taxa'];
	unset($_SESSION['taxa']);
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
	if ($qobject['taxa']) unset($qobject['taxa']);
	$qobject['taxa'] = $names;
	return $qobject;
}
	
?>