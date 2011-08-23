<?php

#Filename: php_utils.php
#
#

#=================================================================================================================

function add_key_val($arr, $key, $val) {
	$arr2 = array($key => $val);
	$arr3 = array_merge($arr, $arr2);
	return $arr3;
	}

#=================================================================================================================

function array_to_postgresql($myarray, $arrtype) {
	
	#print_r ($myarray);
	
	if (is_array($myarray)) {
	
		#Check if all items numeric
		if (!$arrtype) {
			$type = is_numeric_array($myarray, $check_all=true);
			if ($type == true) {
				$arrtype = 'numeric';
			} else {
				$arrtype = 'text';
			}
		} else {
			if ($arrtype != 'numeric' && $arrtype != 'text') {
			echo "array_to_postgresql error: arrtype must be undef, 'text' or 'numeric'";
			}
		}
		#echo " " . is_array($myarray) . "<br>";
		#echo "arraytype is numeric : $arraytype<br>";
		#foreach ($myarray as $item) echo "$item<br>";
		$retval = "ARRAY[";
		$first = true;
		
		if ($arrtype == 'text') {
			#echo "array is text<br>";
			foreach ($myarray as $myitem) {
				If ($first == TRUE) {
					$retval = $retval . "'" . $myitem . "'" ;
					$first = FALSE;
				} else {
					$retval = $retval . ",'" . $myitem . "'" ;
				}
			}
			
		} else {
			#echo "array is numeric<br>";
			foreach ($myarray as $myitem) {
				If ($first == TRUE) {
					$retval = $retval . $myitem ;
					$first = FALSE ;
				} else {
					$retval = $retval . "," . $myitem ;
				}
			}
		
		}
		
		$retval = $retval . "]";
		return $retval;
	} else {
		echo "array_to_postgresql error: the variable passed is not an array.<br>";
		exit;
	}
}

#=================================================================================================================

function array_sort($array, $on, $order=SORT_ASC)
{
    $new_array = array();
    $sortable_array = array();

    if (count($array) > 0) {
        foreach ($array as $k => $v) {
            if (is_array($v)) {
                foreach ($v as $k2 => $v2) {
                    if ($k2 == $on) {
                        $sortable_array[$k] = $v2;
                    }
                }
            } else {
                $sortable_array[$k] = $v;
            }
        }

        switch ($order) {
            case SORT_ASC:
                asort($sortable_array);
            break;
            case SORT_DESC:
                arsort($sortable_array);
            break;
        }

        foreach ($sortable_array as $k => $v) {
            $new_array[$k] = $array[$k];
        }
    }

    return $new_array;
}

#=================================================================================================================

function array_dbcols($arr, $pre, $q) {

	#echo "$q<br>";
	if (!$q) $q = false;
	
	if ($q != 1 && $q != 0) {
		echo "q must be true or false<br>";
		exit;
	}

	#returns a  comma seperated string of the items in an array. Optionally prefixed and quoted
	$first = 1;
	if (!$pre) {
		foreach ($arr as $col) {
			if ($first == 1) {
				if ($q == true) {
					$str = '"' . $col . '"';
					} else {
					$str = $col;
					}
				$first = 0;
			} else {
				if ($q == true) {
					$str = $str . ', "'. $col . '"';
				} else {
					$str = $str . ', '. $col;
				}				
			}
		}
	} else {
		foreach ($arr as $col) {
			if ($first == 1) {
				if ($q == true) {
					$str = '"'. $pre . '.' . $col . '"';
					} else {
					$str = $pre . '.' . $col;
					}
				$first = 0;
			} else {
				if ($q == true) {
					$str = $str . ', "' . $pre . '.' . $col . '"';
					} else {
					$str = $str . ', ' . $pre . '.' . $col;
					}
			}
		 }
	}
	return $str;
}


#=================================================================================================================

function bbox_select($name, $coords, $bbnorth, $bbsouth, $bbeast, $bbwest, $spatialtype) {
	
	#Returns within and overlapping names within the coords 
	#If W > E box is accross -180/+180
	if ($bbeast > $bbwest) {
		#Nornmal box
		switch ($spatialtype) {
			case "within":
				if ($coord[0] >= $bbsouth && $coord[1] >= $bbwest && $coord[2] <= $bbnorth && $coord[3] <= $bbeast) {
					return True;
					} else {
					return False;
					}
				break;
					
			case 'overlap':
				if ($coord[0] >= $bbsouth || $coord[1] >= $bbwest || $coord[2] <= $bbnorth || $coord[3] <= $bbeast) {
					return True;
					} else {
					return False;
					}
				break;
				
			default:
				return;
			}
			
		} else {
		# Back world box
		switch ($spatialtype) {
			case 'within':
				if ($coord[0] >= $bbsouth && $coord[2] <= $bbnorth && $coord[1] <= $bbeast && $coord[3] >= $bbewest) {
					return True;
					} else {
					return False;
					}
				break;
					
			case 'overlap':
				if (($coord[0] >= $bbsouth && $coord[2] <= $bbnorth) && ($coord[1] <= $bbeast || $coord[3] >= $bbewest)) {
					return True;
					} else {
					return False;
					}
				break;
				
			default:
				return;
			}
		}
	}

	
# ============================================================================

/* creates a compressed zip file */
# Source: http://davidwalsh.name/create-zip-php

function create_zip($files = array(),$destination = '',$overwrite = false) {
	//if the zip file already exists and overwrite is false, return false
	if(file_exists($destination) && !$overwrite) { return false; }
	//vars
	$valid_files = array();
	//if files were passed in...
	if(is_array($files)) {
		//cycle through each file
		foreach($files as $file) {
			//make sure the file exists
			if(file_exists($file)) {
				$valid_files[] = $file;
			}
		}
	}
	
//	echo "validfiles: ";
//	print_r($valid_files);
//	echo "<br>";
	
	//if we have good files...
	if(count($valid_files)) {
		//create the archive
		$zip = new ZipArchive();
		if($zip->open($destination,$overwrite ? ZIPARCHIVE::OVERWRITE : ZIPARCHIVE::CREATE) !== true) {
			return false;
		}
		//add the files
		foreach($valid_files as $file) {
			$zipname = explode("/", $file);
			#$zipname[count($zipname)] - 1
			$zip->addFile($file,$zipname[count($zipname)- 1] );
		}
		//debug
		//echo 'The zip archive contains ',$zip->numFiles,' files with a status of ',$zip->status;
		
		//close the zip -- done!
		$zip->close();
		
		//check to make sure the file exists
		return file_exists($destination);
	}
	else
	{
		return false;
	}
}

#=================================================================================================================

function debug_print_array ($arr, $name) {
	
	if ($arr) {
		echo "$name ";
		$fst = 1;
		foreach ($arr as $item) {
			if ($fst == 1) {  
				echo "<i>$item</i>";
				$fst = 0;
				} else {
				echo ", " . "<i>$item</i>";
				}
		}
		echo "<br>";
	}
}

#=================================================================================================================

function eb_connect($config) {
	$str = "host=" . $config['host'] . " port=" . $config['port'] . " user=" . $config['user'];
	$str = $str . " password=" . $config['password'] . " dbname=" . $config['dbname'];
	$db_handle = pg_connect ($str);
	return $db_handle;
}


#=================================================================================================================

function get_source_field_types($db_handle, $source) {
	
	# Returns array of field types from source.source_fields
	if ($source['term'] == 'biotree') return false;
	$sid = $source['id'];
	# Fields in table
	$str = "SELECT f.field_name, f.field_description, t.name AS ftype 
		FROM source.source_fields f, biosql.term t
		WHERE f.source_id = $sid
		AND f.term_id = t.term_id
		ORDER by f.rank;";
	//echo "$str<br>";
	$res = pg_query($db_handle, $str);
	$rows = pg_fetch_all($res);
	return $rows;
}

#=================================================================================================================

function add_source_fields($db_handle, &$source) {
	
	# Adds namesfield and fields array to source
	
	$dtypes = array();         //display type from source.source_fields (rangefield,catagoryfield,lookupfield, lookuptable)
	$ftypes = array();		   //field type from db (will be converted to text or numeric)
	$fnames = array();         //field names
	//$fids = array();           //field id
	$franks = array();         //field rank
	$fdescs = array();         //field description
	$flookups = array();         //field description
	$faliases = array();         //field description
		
	if ($source['term'] == 'biotree') return false;

	# GET FIELD INFO
	$str = "SELECT s.field_name,t.name,s.rank,s.field_description, s.field_alias FROM source.source_fields s, biosql.term t 
		WHERE s.source_id=". $source['id'] .
		"AND t.term_id=s.term_id ORDER by s.rank;";
	$res = pg_query($db_handle, $str);
	while ($row = pg_fetch_row($res)) {
		array_push($fnames,$row[0]);
		array_push($dtypes,$row[1]);
		array_push($franks,$row[2]);
		array_push($fdescs,$row[3]);
		array_push($faliases,$row[4]);
	}
	
	# FTYPE
	$i = 0;
	foreach($fnames as $fname) {
		$dtype = $dtypes[$i];
		switch ($dtype) {
			case 'rangefield':
			case 'catagoryfield':
				# FIELD IN TABLE
				//$str = "SELECT \"$fname\" FROM " . $source['dbloc'] . " LIMIT 1;";
				//echo "$str<br/>";
				$res = pg_query($db_handle, $str);
				$dbtype = pg_field_type($res, 0);
				$ftype = get_ftype_from_dbtype($dbtype);
				$flookup = null;
				break;
			case 'lookupfield':
				$ftype = 'numeric';
				$flookup = null;
				break;
			case 'lookuptable':
				$str = "SELECT lookup_id FROM source.source_fields WHERE source_id=" . $source['id'] . " AND field_name='$fname'";
				//echo "$str<br/>";
				$res = pg_query($db_handle, $str);
				if ($res) {
					$row = pg_fetch_row($res);
					$lookup_id = $row[0];
					$lookup_source = get_source($db_handle, $lookup_id);
					$str = "SELECT \"$fname\" FROM " . $lookup_source['dbloc'] . " LIMIT 1;";
					$res = pg_query($db_handle, $str);
					$dbtype = pg_field_type($res, 0);
					$ftype = get_ftype_from_dbtype($dbtype);
					$flookup = $lookup_id;
				} else {
					$ftype = 'not set';
					$flookup = null;
				}

				break;
			default:
				$ftype = null;
				$flookup = null;
				break;
		}
		array_push($ftypes,$ftype);
		array_push($flookups,$flookup);
		$i++;
	}

	
	
	$fields = array();
	for ($i = 0; $i <= count($fnames) -1; $i++) {
		//echo "fname: $fnames[$i], dtype: $dtypes[$i] ftype: $ftypes[$i], ftitle: $fdescs[$i]<br/><br/>";
		$field = array('fname' => $fnames[$i], 'ftype'=>$ftypes[$i], 
			'dtype'=>$dtypes[$i], 'frank'=>$franks[$i], 'fdesc'=>$fdescs[$i], 'flookup'=>$flookups[$i], 'falias'=>$faliases[$i]);
		array_push($fields, $field);
		//echo "<br />";
		//print_r ($field);
		//echo "<br />";
	}
	$fields = array_sort($fields,'frank') ;
	$source['fields'] = $fields;
	
}

#=================================================================================================================

function get_ftype_from_dbtype($dbtype) {
	
	//echo "$dbtype<br />";
	switch ($dbtype) {
		case 'numeric':
		case 'float':
		case 'float8':
		case (substr($ftype, 0, 3) == 'int'):
			$ftype = 'numeric';
			break;
		case (substr($ftype,-4) == 'char'):
		case 'text':
		case 'varchar':
			$ftype = 'text';
			break;
		default:
			//echo "html_table_query: unrecognised DB field type - $ftype<br>";
			break;
	}
	return $ftype;
}

#=================================================================================================================

function get_column_names ($db_handle, $table) {
	
	$colnames = array();
	$str = "SELECT * FROM $table WHERE 0=1";
	$res = pg_query($db_handle, $str);
	$i = pg_num_fields($res);
	#echo "i = $i<br>";
	for ($j = 0; $j < $i; $j++) array_push($colnames, pg_fieldname($res, $j));
	
	return $colnames;
	
}


#=================================================================================================================


function get_next_name($objs, $type) {
	# NEEDS AMENDING TO CHECK IF NAME IS type + numeral, if so get next highest integer
	//echo "$type<br>";
	$i = 1;
	foreach ($objs as $obj) if ($obj['term'] == $type && $obj['name']) $i++;
	//echo "$type $i<br>";
	return $type . "_" . $i;
	}

	
#=================================================================================================================

function get_obj($objs, $id) {
	foreach ($objs as $obj) {
		if ($obj['id'] == $id) return $obj;
		}
	}

#=================================================================================================================
	
function get_sources($db_handle, $ids, $type) {
	
//	echo "ids: " . empty($ids);
//	echo print_r($ids);
	$sources = array();
	
	if (!$ids || empty($ids)) {	
		// Get all bio sources
		# Returns an array containing details of sources
		# $ids 			a list of source ids to limit the query to
		# $type			types of dataset to return. 
		#				Valid options:
		#				'all'   		all sources
		#				'bio'			all bio sources
		#				'biotree'   	only biotrees 
		#				'biotable'  	only biotables 
		#				'biogeographic' only biogeographic
		#				'biorelational' only biorelational
		
		if (!$type) $type = "all";	
		# All sources that are selectable are prefixed with 'bio'
		# Type specific data are stored as source_qualifier_values 
		
		$ids = array();
		
		$str = "SELECT obj.*, t.name
				FROM source.source obj, biosql.term t
				WHERE obj.term_id = t.term_id";
		switch ($type) {
			case 'bio':
				$str = $str . " AND t.name like 'bio%'";
				break;
			case 'biotree': 
				$str = $str . " AND t.name = 'biotree'";
				break;
			case 'biotable': 
				$str = $str . " AND t.name = 'biotable'";
				break;
			case 'biogeographic':
				$str = $str . " AND t.name = 'biogeographic'";
				break;
			case 'biorelational': 
				$str = $str . " AND t.name = 'biorelational'";
				break;
		}
		$str = $str . " AND obj.active = true";
		# echo "$str<br>";
		$res = pg_query($db_handle, $str);
		$ids = pg_fetch_all_columns($res, 0);
	}
	
	foreach($ids as $id) {
		$source = get_source($db_handle, $id);
		$sources = add_key_val($sources, $id, $source);
	}
	
//	echo "sources: ";
//	print_r($sources);
//	echo "<br>";
	
	if (empty($sources)) {
		return(false);	
	} else {
		return $sources;
	}
	
}

#=================================================================================================================
	
	function get_source($db_handle, $id) {
		
		# RETURNS A SOURCE OBJECT GIVEN AN ID
		
		$str = "SELECT s.*, t.name
			FROM source.source s, biosql.term t
			WHERE s.source_id = $id
			AND s.term_id = t.term_id";
		//echo "$str<br>";
		$res = pg_query($db_handle, $str);
		$row = pg_fetch_row($res);
		
		if (!$row) return(false);
	
		$dbloc = $row[3] . "." . $row[4];
		$source = array(
			'id'=>$row[0],
			'name'=>$row[1],
			'schema'=>$row[3],
			'tablename'=>$row[4],
			'dbloc'=>$dbloc,
			'n'=>$row[5],
			'code'=>$row[8],
			'term'=>$row[9],
			);
		
		if (!empty($row[6])==1) $source = add_key_val($source, 'www', $row[6]);
		
		
		# GET SOURCE QUALIFIER VALUES
		# only trees at the moment
		$str = "SELECT sqv.value, t.name
			 FROM source.source_qualifier_value sqv, biosql.term t, biosql.ontology ont
			 WHERE sqv.source_id = $row[0]
			 AND sqv.term_id = t.term_id
			 AND t.ontology_id = ont.ontology_id
			 AND ont.name = 'source_qualifier_value'";
		$res = pg_query($db_handle, $str);
		
		while ($row =  pg_fetch_row($res)) {
			$source = add_key_val($source, $row[1], $row[0]);
			}
		
		# GET GEOMETRY COLUMN (Non-Geographic)
//		$str = "SELECT f_geometry_column 
//			FROM public.geometry_columns 
//			WHERE f_table_name = '" . $source['tablename'] . "'";
//		$res = pg_query($db_handle, $str);
//		$row = pg_fetch_row($res);
//		if ($row) $source['spatial_column'] = $row[0];
			
		# GET GEOGRAPHY COLUMNS (Geographic)
		$str = "SELECT f_geography_column 
			FROM public.geography_columns 
			WHERE f_table_name = '" . $source['tablename'] . "'";
		$res = pg_query($db_handle, $str);
		$row = pg_fetch_row($res);
		if ($row) $source['spatial_column'] = $row[0];
		
		# GET FIELDS
		add_source_fields($db_handle,$source);
	//echo "<br/>";
	//print_r($source);
	//echo "<br/>";
	return($source);
	
	}
	
#=================================================================================================================
	
	function get_source_relations($db_handle, $source) {

	# HARDCODED FOR GPDD
	$str = "SELECT s.*, t.name
		FROM source.source s,
		biosql.term t
		WHERE 
		s.term_id = t.term_id
		 AND s.schema = 'gpdd'
		 AND s.tablename NOT IN ('main','location_pt','location_bbox','timeperiod')";
	$res = pg_query($db_handle, $str);
	
	$relations= array();
	
	while ($row = pg_fetch_row($res)) {	
	
		# SOURCES
		$relation = array(
			'id'=>$row[0],
			'name'=>$row[1],
			'schema'=>$row[3],
			'tablename'=>$row[4],
			'dbloc'=>"$row[3].$row[4]",
			'n'=>$row[5],
			'www'=>$row[6],
			'term'=>$row[8],
			);
			
		# SOURCE SPECIFIC
		
		switch ($row[4]) {
			
			case 'main':
				break;
			
			case 'taxon':
				$relation = add_key_val($relation, 'name','taxon');
				$relation = add_key_val($relation, 'relation','biolookup');
				$relation = add_key_val($relation, 'joinfield','TaxonID');
				$relation = add_key_val($relation, 'namefield','binomial');
				break;
				
			case 'datasource':
				$relation = add_key_val($relation, 'name','datasource');
				$relation = add_key_val($relation, 'relation','lookup');
				$relation = add_key_val($relation, 'joinfield','DatasourceID');
				break;
								
			case 'biotope':
				$relation = add_key_val($relation, 'name','biotope');
				$relation = add_key_val($relation, 'relation','lookup');
				$relation = add_key_val($relation, 'joinfield','BiotopeID');
				break;
							
			case 'location':
				$relation = add_key_val($relation, 'name','location');
				$relation = add_key_val($relation, 'relation','geolookup');
				$relation = add_key_val($relation, 'joinfield','location_id');
				$geomap1 = Array('id'=>26,
					'tablename'=>'location_pt',
					'dbloc'=>'gpdd.location_pt',
					'geomfield'=>'the_geom');
				$geomap2 = Array('id'=>27,
					'tablename'=>'location_bbox',
					'dbloc'=>'gpdd.location_bbox',
					'geomfield'=>'the_geom');
				$geomaps = Array($geomap1,$geomap2);
				$relation = add_key_val($relation, 'geomaps',$geomaps);
				break;
			
			case 'data':
				$relation = add_key_val($relation, 'name','data');
				$relation = add_key_val($relation, 'relation','timedata');
				$relation = add_key_val($relation, 'joinfield','main_id');
				//$relation = add_key_val($relation, 'timefield','time_id');
				$timemap = Array('id'=>30,
					'tablename'=>'timeperiod',
					'dbloc'=>'gpdd.timeperiod',
					'joinfield'=>'timeperiod_id');
				$relation = add_key_val($relation, 'timemap',$timemap);
				break;
				
			default:
				echo "get_source_relations: $row[3] is unrecognised source";
				break;
		}
	array_push($relations, $relation);
	}

	$source = add_key_val($source, 'relations',$relations);
	return $source;

	}
	
	
#=================================================================================================================
	
function get_tree_name($tree) {
	$str = "SELECT name from biosql.tree WHERE tree_id = $tree;";
	$result = pg_query($str);
	if (!$result) {
		"Error get_tree_name : no name for tree_id $tree";
		return;
		} else {
		$row = pg_fetch_row($result);
		return $row[0];
		}
	}
	
#=================================================================================================================
//
//function get_taxa ($qobject, $namesmethod)	{
//
//	# Converts taxa and taxa2 from input_names to array.
//	# taxa and taxa2 are the two names inputs
//	# Remove empty values
//	# Intersect two taxa arrays
//	
//	$taxa = $qobject['taxa'];
//	$taxa2 = $qobject['taxa2'];
//	
//	if (empty($taxa)) {
//		} else {
//		$mynames = taxa_to_names($taxa, $namesmethod, ".");
//		$mynames = remove_array_empty_values($mynames, true);
//		}
//		
//	if ($taxa2) {
//		$mynames2 = taxa_to_names($taxa2, $namesmethod, ".");
//		$mynames2 = remove_array_empty_values($mynames2, true);
//	}
//	
//	// echo "mynames: ";
//	// print_r($mynames);
//	// echo "<br>";
//	// echo "mynames2: ";
//	// print_r($mynames2);
//	// echo "<br>";
//	
//	if ($mynames and $mynames2) {
//		$innames = array_unique(array_merge($mynames, $mynames2));
//		} else {
//		if ($mynames) {
//			$innames = $mynames;
//			} else {
//			$innames = $mynames2;
//			}
//		}
//	return $innames;
//	}

#=================================================================================================================

/**
* Test if the supplied argument is a numeric array (list).
#  Amended from http://anewt.uwstopia.nl/doc/doxygen/html/array_8lib_8php_source.html
*
* For performance reasons, this function only checks the first element of the
 * array by default.
 *
  * \param $arr
  *   The array to test
  * \param $check_all
  *   Whether to check all elements instead of just the first (optional, defaults
  *   to false)
  *
  * \return
  *   Returns true if $arr is a numeric array, false otherwise.
  */
 function is_numeric_array($arr, $check_all=false) {
	 
	 if (!is_array($arr))
			 return false;

	 if (count($arr) == 0)
			 return true;

	 if ($check_all)
	 {
			 foreach ($arr as $key)
					 if (!is_numeric($key))
							 return false;
	 } else
	 {
			 reset($arr);
			 #echo "Arr[0] = " . $arr[0]. "<br>";
			 if (!is_numeric($arr[0])) 
				return false;
	 }

	 return true;
	 
}
	



#=================================================================================================================

function get_tips($id, $nodes) {

	$bin = array();
	#returns binomials fro a set of tip nodes
	if ($nodes) {
		$nodearr = array_to_postgresql($nodes,'numeric');
		$statement = "SELECT label 
			FROM biosql.node
			WHERE tree_id = $id
			AND (node.right_idx - node.left_idx) = 1
			AND node_id = ANY($nodearr);";
		} else{
		$statement = "SELECT label FROM biosql.node n
			WHERE tree_id = $id 
			AND (n.right_idx - n.left_idx) = 1;";	
		}
	#echo "statement = $statement<br>";
	$result = pg_query($statement);
	
	while ($row = pg_fetch_row($result)) {
		array_push($bin, $row[0]);
		}
		
	return $bin;
	}
	
#=================================================================================================================

function get_rowcol($table, $col, $names) {

	#returns an array of row column values matching $names
	$bin = array();
	if ($names) {
		$arr = array_to_postgresql($names,'text');
		$str = "SELECT t.$col FROM $table t WHERE t.$col = ANY($arr);";
		} else {
		$str = "SELECT t.$col FROM $table t;";
		}
	
	$result = pg_query($str);
	
	while ($row = pg_fetch_row($result)) {
		array_push($bin, $row[0]);
		}
		
	return $bin;
}



#=================================================================================================================
	
function n_sources_type($sources, $type) {
	# Returns number of sources of type x
	$c = 0;
	foreach($sources as $source) {
		if($source['term'] == $type) $c = $c + 1;
	}
	return $c;
}

#=================================================================================================================

function names_check($table, $column, $names) {
	
	#Checks a table column against a list of names   and returns matches [0] and failures [1]
	$match = array();
	$fail = array();
	$names_array = array_to_postgresql($names,'text');
	$statement = "SELECT $column FROM $table WHERE $column = ANY($names_array);";
	#echo "statement = $statement<br>";
	$result = pg_query($statement);
	
	while ($row = pg_fetch_row($result)) {
		if (in_array($row[0], $names) == true) {
			array_push($match, $row[0]);
			} else {
			array_push($fail, $row[0]);
			}
		}
		
	return array($match, $fail);
	
	}
	
#=================================================================================================================

function nodes_array_to_labels_array($node_array) {


	$statement = "SELECT biosql.pdb_node_id_to_label($node_array);";
	$result = pg_query($statement);
	
	if (!$result) {
		echo "An error occured.\n";
		exit;
		} else {
		$labels = array();
		while ($row = pg_fetch_row($result))  {
			array_push($labels, $row[0]);
			}
			$label_array = array_to_postgresql($labels, 'text');
			#echo "label array = $label_array<br>";
			}
	return $label_array;
	}
	

	
#=================================================================================================================

function obj_idx($objs, $id) {
	$i = 0;
	foreach ($objs as $obj) {
		if ($obj['id'] == $id) return $i;
		$i++;
		}
	}	
	

#=================================================================================================================

function qobjs_to_sql($qobjs, $mode = 'html') {

	switch ($mode) {
		case 'html':
			$cr = "<br>";
			break;
		case 'txt':
			$cr = "\n\r";
			break;
		default:
			echo "qobjs_to_sql: $mode is not a mode<br>";
			exit;
			break;
		}
	
	$fst = true;
	$str = "";
	
	foreach ($qobjs as $qobj) {
		if ($fst) {
			$str = $qobj['sql'] . $cr;
			$fst = false;
			} else {
			$str = $str . $qobj['queryoperator'] . $cr . $qobj['sql'] . $cr;
			}
		}

	return $str;
	}

#=================================================================================================================

function qobj_to_sql($qobj, $mode = 'html') {

	switch ($mode) {
		case 'html':
			$cr = "<br>";
			break;
		case 'txt':
			$cr = "\n\r";
			break;
		default:
			echo "qobjs_to_sql: $mode is not a mode<br>";
			exit;
			break;
		}
	
	$str = "";
	
	$str = $qobj['sql'] . $cr;

	return $str;
	}
	
	
#=================================================================================================================

function print_arr($array) {
	
	$first = 1;
	$lasttime = 0;
	
	foreach ($array as $key=>$val) {
		if ($first == 1) {
			echo $key . " : 0<br>";
			$first = 0;
			$starttime = $val;
			} else {
			$timetaken = $val - $starttime;
			echo $key . " : " . $timetaken . "<br>";
			}
		}
	
	}

	
#=================================================================================================================
function query_vals($qobj, $fname) {

	# Returns min and max for field
	$qs = $qobj['queries'];
	$out = array(null,null);
	
	if (!$qs) {
		return null;
		} else {
		foreach ($qs as $q) {
			if ($q['field'] == $fname) {
				if ($q['operator'] == ">=") {
					$out[0] = $q['value'];
					} elseif ($q['operator'] == "<=") {
					$out[1] = $q['value'];
					}
				}
			}
		if (empty($out[0]) and empty($out[1])) {
			return null;
			} else {
			return $out;
			}
		}
	}

#=================================================================================================================

function query_uvals($qobj, $fname) {

	# Returns unique values for query field
	$qs = $qobj['queries'];
	$out = array();
	
	if (!$qs) {
		return null;
		} else {
		foreach ($qs as $q) {
			if ($q['field'] == $fname) {
				if ($q['operator'] == "=") array_push($out, $q['value']);
				}
			}
		return $out;
		}
	}
	
#=================================================================================================================

function remove_element($arr, $val){
	foreach ($arr as $key => $value){
		if ($arr[$key] == $val){
		unset($arr[$key]);
		}
	}
	return $arr = array_values($arr);
}

	
#=================================================================================================================

function save_obj($objs, $newobj) {
	#Saves object
	$i = 0;
	foreach ($objs as $obj) {
		if ($obj['id'] == $newobj['id']) {
			$objs[$i] = $newobj;
			return $objs;
			}
		$i++;
		}
	}

#=================================================================================================================

	function sql_mids_open ($str, $mids){
		if($mids) {
			return $str . " SELECT bioname FROM gpdd.taxon t,(";
		} else {
				return $str;
		}
	}
	
#=================================================================================================================

	function sql_mids_close ($str,$mids){
		if($mids) {
			return $str . ") AS bioname";
		} else {
				return $str;
		}
	}

#=================================================================================================================
	

function subtract_elements($arr, $vals){
	foreach ($arr as $key => $value){
		if (in_array($arr[$key], $vals)){
		unset($arr[$key]);
		}
	}
	return $arr = array_values($arr);
}



# ==========================================================================================
/*
Credits: Bit Repository
URL: http://www.bitrepository.com/web-programming/php/remove-empty-values-from-an-array.html
*/
function remove_array_empty_values($array, $remove_null_number = true)
{
	$new_array = array();

	$null_exceptions = array();

	foreach ($array as $key => $value)
	{
		$value = trim($value);

        if($remove_null_number)
		{
	        $null_exceptions[] = '0';
		}

        if(!in_array($value, $null_exceptions) && $value != "")
		{
            $new_array[] = $value;
        }
    }
    return $new_array;
}


#=================================================================================================================
	
	function table_names_check($table, $column, $names) {
	
	#Checks a list of names  against  a table column and returns matches [0] and failures [1]
	$match = array();
	$fail = array();
	#debug_print_array($names, "Names");
	foreach ($names as $name) {
		$statement = "SELECT $column FROM $table WHERE $column = '$name';";
		#print $statement."<br>";
		$result = pg_query($statement);	
		$row = pg_fetch_row($result);
		#echo "$row[0]<br>";
		if ($row[0]) {
			array_push($match, $row[0]);
			} else {
			array_push($fail, $row[0]);
			}
		}
	
	print count($match) . " binomials matched in $table.$column<br>";
	print count($fail) . " binomials not in $table.$column<br>";
	debug_print_array($fail, "Failed");
	#debug_print_array($match, "Matched");
	return array($match, $fail);
	
	}
	

#=================================================================================================================

function taxa_to_names($taxa, $namesmethod, $char) {
	
	# selectnames returns an array with indents using a char 
	# inputnames returns a text list that must be exploded into an array
	if ($namesmethod == 'selectnames') {
		$names = array();
		foreach ($taxa as $name) array_push($names, str_replace($char, "", $name));
	} else {
		$names = explode("\r\n",$taxa);
	}

	#Remove empty names
	$arr = remove_array_empty_values($names, true);
	return $arr;
}


#=================================================================================================================

function tip_names($tree, $names) {

	#returns array of tip names
	$tips = array();
	$names_array = array_to_postgresql($names,'text');

	$str = "SELECT * FROM biosql.pdb_lca_subtree_tip_label($tree, $names_array);";
	$res = pg_query($str);
	while ($row = pg_fetch_row($res)) {
		array_push($tips, $row[0]);
	}
	return tips;
}

#=================================================================================================================


function get_field($fname, $fields) {
	foreach ($fields as $field) {
		if ($field['fname'] == $fname) return $field;
	}
	return false;
}


#=================================================================================================================

function get_field_title($db_handle, $source, $fname) {
	
	# Function returns the title of a field from source.source_fields
	$source_id = $source['id'];
	$str = "SELECT field_description FROM source.source_fields WHERE source_id=$source_id AND field_name=\"$fname\"";
	echo "$str<br>";
	$res = pg_query($str);
	$row = pg_fetch_row($res);
	if (!$row) {
		return false;
	} else {
		return $row[0];
	}
}

#=================================================================================================================

?>