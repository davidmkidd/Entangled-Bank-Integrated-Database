<?php

	function query($db_handle, $qobjid) {
	
		# RUNS AN ENTANGLED BANK QUERY

		# QUERY PARAMETERS
		$qobjects = $_SESSION['qobjects'];
		$sources = $_SESSION['sources'];
		# IF RESUMBISSION OF ONLY QUERY SO DELETE NAMES
		if (count($qobjects) == 1 && $_SESSION['names']) unset($_SESSION['names']);
		if ($_SESSION['names']) $names = $_SESSION['names'];
		
		
		$qobject = get_obj($qobjects, $qobjid);
		$qterm = $qobject['term'];
		$queryop = $qobject['queryoperator'];
		$qsources = $qobject['sources'];
		$nsources = $qobject['nsources'];
		$nop = $qobject['noperator'];
		$allnames = $qobject['allnames'];
		
		//print_r($qobject);
		
		if ($names && !$queryop) {
			echo "query: if names passed queryoperators must be set";
			exit;
			}
			
		# SINGLE OR MULTISOURCE?
		if (count($qsources) == 1) {
			$single_source = true;
		} else {
			$single_source = false;
		}
	
		# TAXA IN QUERY
		if ($qobject['taxa']) $taxa_array = array_to_postgresql($qobject['taxa'], 'text');
		# TAXA FROM PREVIOUS QUERY IN STACK
		if (!empty($names)) $names_array = array_to_postgresql($names, 'text');
		
		$n = 1;
		$str = '';
		# OPEN MULTISOURCE WRAPPER
		if ($single_source == false) $str = "SELECT DISTINCT bioname FROM (";
		
		
		# NAMES QUERY
		# ===========
			
		foreach ($qsources as $sid) {
			
			#  GET SOURCE FOR SID (GPDD HARDCODE)
			if($sid == 26 || $sid == 27) {
				$source = get_source($db_handle, $sid, null);
			} else {
				$source = get_obj($sources, $sid);
			}
		
			$sterm = $source['term'];
			#echo "Building query on $sterm " . $source['name'] . " (" . $source['id'] . ") with $qterm<br>";
			
			# ADD NAMES QUERY BY TYPE
			Switch (true) {	
				case (($qterm == 'bionames' && $sterm == 'biotable')
					|| ($qterm == 'bionames' && $sterm == 'biogeographic')):
					$str = query_bionames_table($source, $str);
					break;
				case ($qterm == 'biotable'):
					$str = query_biotable($db_handle, $qobject, $source);
				break;
				case ($qterm == 'bionames' && $sterm == 'biotree'):
					$str = query_bionames_tree($qobject, $source, $str);
					break;
				case ($qterm <> 'bionames' && $sterm =='biotree'):
					$str = query_biotree($db_handle, $qobject, $source, $str);
					break;		
				case ($qterm == 'biogeographic' || $qterm == 'geographic' 
					|| ($qterm == 'biogeographic' && $sterm == 'biogeographic')):
					$str = query_biogeographic($qobject, $source, $str);
					break;
				case ($qterm == 'bionames' && $sterm == 'biorelational'):
					//GPDD HARDCODE
					$str = query_bionames_relational($str);
					break;	
				case ($qterm == 'biotemporal' && $sterm == 'biorelational'):
					//GPDD HARDCODE
					$str = query_biotemporal($qobject, $qobjects, $str);
					break;
				default:
					break;
				} # switch
				
			# ADD CONDITIONAL QUERY TAXA CLAUSE
			if ($taxa_array) {
				switch (true) {
					case ($qterm == 'bionames' && $sterm == 'biotree'):
						$str = $str . " AND label = ANY($taxa_array)";
						break;
					case ($qterm == 'bionames' && $sterm == 'biorelational'):
						$str = $str . " AND t.binomial = ANY($taxa_array)";
						break;
					case $qterm == 'biotree':
						break;
					case ($qterm == 'biotable' && $sterm == 'biorelational'):
						$str = $str . " AND t.binomial = ANY($taxa_array)";
						break;
					default:
						$str = $str . " WHERE ". $source['namefield'] . " = ANY($taxa_array)";
						break;
					}
				} else {
					switch (true) {
						case ($qterm == 'bionames' && $sterm == 'biorelational'):
							$str = $str . " AND t.binomial IS NOT NULL";
							break;
					}
				}
			
			# ADD INTERSOURCE SET OPERATOR
			if ($n != count($qsources)) {
				if ($nsources) {
					$str = $str . " UNION ALL ";
					} else {
					$str = $str . " UNION ";
					}
				}
			$n++;	
			#echo "str: $str<br><br>";
		} # qsources
		
		# CLOSE MULTISOURCE WRAPPER
		if ($single_source == false) {
			$str = $str . ") AS bioname";
			$str = $str . " GROUP BY bioname HAVING COUNT(*) $nop $nsources";
		}
		
		# COPY QUERY FOR SAVING IN QOBJECT
		$qstr = $str;
		
		# ADD INTERQUERY OPERATOR
		if ($names_array) {
			if ($qterm == 'biotable' && $sterm == 'biorelational') {
				$str = "$str $queryop SELECT UNNEST($names_array) AS bioname";
			} else {
				$str = "$str $queryop SELECT UNNEST($names_array) AS bioname";
			}
		}
			
		# RUN NAMES QUERY
		$res = pg_query($db_handle, $str);
		$names = pg_fetch_all_columns($res, 0);
		
		# ADD SQL TO QOBJECT
		query_add_names_sql($qobject, $qobjects, $qstr);
		$qobjects = save_obj($qobjects, $qobject);
		
		# GPDD SERIES QUERY
		if (!empty($names)) {
			# RUN GPDD SERIES QUERY
			query_series($db_handle, $qobject, $qobjects, $names, $sources);
			$qobjects = save_obj($qobjects, $qobject);
			$names = query_series_names($db_handle, $qobjects, $names, $sources);
		} else {
			# No Names
			$qobject['series'] = null;
			$qobjects = save_obj($qobjects, $qobject);
		}
		
		$_SESSION['names'] = $names;
		$_SESSION['qobjects'] = $qobjects;
		
		unset($_SESSION['info']);
	}

# ----------------------------------------------------------------------
	
	function query_bionames_table ($source, $str) {
		$str = $str . "SELECT " . $source['namefield'] . " AS bioname";
		$str = $str	. " FROM " . $source['dbloc'];
		return($str);
	}
	
# ----------------------------------------------------------------------
	
	function query_biotable($db_handle, $qobject, $source) {
		
		$qterm = $qobject['term'];
		$queries = $qobject['queries'];
		$fields = $source['fields'];
		//$null = $qobject['querynull'];
		$sterm = $source['term'];
		$nseries_op = "";
		//print_r($source);
		
		# SELECT CLAUSE
		if ($source['id'] !== '23') {
			# NOT GPDD
			$str = "SELECT d." . $source['namefield'] . " AS bioname "
				. " FROM " . $source['dbloc']
				. " d WHERE";
			$first = true;
		} else {
			
			# GPDD
			$str = "SELECT t.binomial AS bioname FROM gpdd.main m";
			# TABLES
			$tables = array();				
			$tables['taxon'] = ", gpdd.taxon t";
			$tables['datasource'] = ", gpdd.datasource ds";
			foreach ($queries as $query) {
				switch (true) {
					case ($query['lookup'] == 25):
						$tables['location'] = ", gpdd.location l";
						break;					
					case ($query['lookup'] == 28):
						$tables['biotope'] = ", gpdd.biotope b";	
				}
			}
			
			$tables_val = array_values($tables);
			foreach ($tables_val as $val) $str = $str . $val;
			
			# WHERE JOINS
			$str = $str . " WHERE";
			$first = true;
			
			$table_keys = array_keys($tables);
			
			foreach ($table_keys as $key) {
				if ($first == false) $str = $str . " AND";
				switch ($key) {
					case 'taxon' :
						$str = $str . " m.\"TaxonID\" = t.\"TaxonID\"";
						break;
					case 'location' :
						$str = $str . " m.\"LocationID\" = l.\"LocationID\"";
						break;
					case 'biotope' :
						$str = $str . " m.\"BiotopeID\" =  b.\"BiotopeID\"";
						break;						
					case 'datasource' :
						$str = $str . " m.\"DataSourceID\" = ds.\"DataSourceID\"";
						$str = $str . " AND ds.\"Availability\" <> 'Restricted'";
						break;				
				}
				$first = false;
			}
			//$str = chop($str, 'AND');
		}
		
		//echo "WHERE query: $str<br>";
		
		# WHERE CONDTIONS
		$nseries_type = 'no';
		
		$i = 0;
		foreach ($queries as $query) {
			
			$qfname = $query['field'];
			$qfield = get_field($qfname, $fields);
			$dtype = $qfield['ebtype'];
			$ftype = $qfield['ftype'];
			
			if ($i > 0 || $source['id'] == '23') $str = $str . " AND";
			$i++;
			
			# WHERE CLAUSES
			switch ($dtype) {
				case 'rangefield':
					query_biotable_rangefield($query, $str, $source['id']);
					break;
				case 'groupfield':
					if (count($queries) == 1) {
						$nseries_type = 'only';
					} else {
						$nseries_type = 'yes';
					}
					$nseries = $query['value'];
					$nseries_op = $query['operator'];
					$str = $str . " t.\"binomial\" IN (SELECT t.binomial  AS bioname";
					$str = $str . " FROM gpdd.main m, gpdd.taxon t";
					$str = $str . " WHERE m.\"TaxonID\" = t.\"TaxonID\"";
					$str = $str . " GROUP BY t.binomial";
					$str = $str . " HAVING COUNT(*) $nseries_op $nseries)";
					break;
				case 'lookupfield':
				case 'catagoryfield':
					query_biotable_lookupfield($db_handle, $query, $str, $source['id'],$ftype, $dtype);
					break;
				case 'lookuptable':
					# GPDD HARDCODE
					query_biotable_lookuptable($query, $str, $null);
					break;
				default:
					break;
			}
		}
		
		#NOT END
		//if ($not == 'NOT' && $nseries_only == 'only') $str = $str . ")";
		
		//if ($source['id'] == '23') $str = $str . " AND t.binomial IS NOT NULL";
		
		# GROUP BY CLAUSES
		if ($source['id'] == '23' && $nseries_type == 'yes') {
			$str = $str . " GROUP BY t.binomial";
			if ($nseries !== -1) {
				if($not == 'NOT') {
					switch ($nseries_op) {
						case '=':
							$nseries_op = '<>';
							break;
						case '>=':
							$nseries_op = '<';
							break;
						case '<=':
							$nseries_op = '>';
							break;						
					}
				}
			$str = $str . " HAVING COUNT(*) $nseries_op $nseries";
			}
		}
		
		return ($str);
	}
	
	# ----------------------------------------------------------------------
	
	function query_biotable_series($qobject, $sources, $str) {
		
		//print_r($qobject);
		$qterm = $qobject['term'];
		$queries = $qobject['queries'];
		$not = $qobject['querynot'];
		$null = $qobject['querynull'];
		$sid = $qobject['sources'][0];
		$source = get_obj($sources, $sid);
		$dbloc = $source['dbloc'];
		$schema = $source['schema'];
		#$sterm = $source['term'];
		//$nseries = -1;
		//$nseries_op = "";
		
		//echo "Begin biotable query " . $source['id'] . "<br>";
		//print_r($qobject) . "<br>";
		
		// NSERIES ONLY
		if (count($queries) == 1 && $queries[0]['field'] == 'nseries') return $str;
		
		$first = true;
		$str = $str . "SELECT m.\"MainID\" AS mid
			 FROM gpdd.main m, gpdd.taxon t, gpdd.location l, gpdd.biotope b, gpdd.datasource s";
		
		if ($source['id'] <> 23) $str = $str . ", $dbloc d" ;
		
		$str = $str . " WHERE m.\"TaxonID\" = t.\"TaxonID\"
			 AND m.\"LocationID\" = l.\"LocationID\"
			 AND m.\"DataSourceID\" = s.\"DataSourceID\"
			 AND m.\"BiotopeID\" = b.\"BiotopeID\"";
		
		if ($source['id'] <> 23) $str = $str . " AND t.binomial = d." . $source['namefield'];
		
		if ($not == 'NOT') {
			$str = $str . " AND NOT (";
			$first = false;
		}
		# QUERIES 
		$nf = 0;
		//print_r($queries);
		
		foreach ($queries as $query) {
			$field = $query['field'];
			$dtype = $query['ebtype'];
			if ($first == true) $str = $str . " AND";
		
			# WHERE CLAUSES
			switch ($dtype) {
				case 'rangefield':
					$str = query_biotable_rangefield ($query, $str, $source);
					$first = false;
					break;
				case 'lookup':
					$str = query_biotable_lookup($query, $str, $source);
					break;
				case 'gpdd':
					switch ($field) {
						case 'nseries': 
							$nseries = $query['value'];
							$nseries_op = $query['operator'];
							break;
						case 'MainID':
							$str = query_biotable_lookup($query, $str, $source);
							$first = false;
							break;
						default:
							//look up
							$str = query_biotable_gpdd($query, $str);
							$first = false;
							break;
					}
					break;
			}
			//echo "$str<br>";
			$nf++;
		}

		#NOT END
		if ($not == 'NOT' ) $str = $str . ")";
		
		$str = $str . ")";
		
		//return ($str);
	}
	
	# --------------------------------------------------------------------------------
	function query_biotable_lookuptable($query, &$str, $null) {
		
		$field = $query['field'];
		$ftype = $query['ftype'];
		$values = $query['value'];
		
		switch ($field) {
			case 'BiotopeName':
			case 'BiotopeType':
				$letter = 'b';
				break;
			case 'ExactName':
			case 'TownName':
			case 'CountyStateProvince':
			case 'Country':
			case 'Continent':
			case 'Ocean':
			case 'SpatialAccuracy':
			case 'LocationExtent':
				$letter = 'l';
				break;				
			case 'Author':
			case 'Year':
			case 'Title':
			case 'Reference':
			case 'Availability':
			case 'Notes':
				$letter = 's';
				break;	
			case 'TaxonomicPhylum':
			case 'TaxonomicOrder':	
			case 'TaxonomicClass':
			case 'TaxonomicFamily':
			case 'TaxonomicGenus':
			case 'binomial':
			case 'CommonName':
				$letter = 't';
				break;
		}
		$arr = array_to_postgresql($values, $ftype);
		
		//$str = $str . " AND";
		if ($null) $str = $str . "(";
		
		$str = $str . " $letter.\"$field\" = ANY ($arr)";
		if ($null) $str = $str . " OR $letter.\"$field\" IS NULL)";
		
	}

	
	# --------------------------------------------------------------------------------
	
	function query_biotable_lookupfield($db_handle, $query, &$str, $sid, $ftype, $dtype) {
		
		if ($sid == 23) {
			$s = 'm';
		} else {
			$s = 'd';
		}
		
		$field = $query['field'];

		$values = $query['value'];
		$null = $query['null'];
		
		if (!empty($values)) $arr = array_to_postgresql($values, $ftype);
		//print_r($values);
		//echo empty($values), ", ", $ftype, "<br>";
		
		if ($dtype == lookupfield) {
			//echo "$arr<br>";
			$str2 = " SELECT c.item FROM source.source_fields f, source.source_fieldcodes c";
			$str2 = $str2 . " WHERE c.field_id = f.field_id";
			$str2 = $str2 . " AND f.source_id = $sid";
			$str2 = $str2 . " AND f.field_name = '$field'";
			$str2 = $str2 . " AND c.name = ANY($arr)";
			$str2 = $str2 . " ORDER BY c.item";
			//echo "$str2<br>";
			$res = pg_query($db_handle, $str2);
			$ids = pg_fetch_all_columns($res);
			$arr = array_to_postgresql($ids, 'numeric');
		}
		
		if (!empty($values) && $null) $str = $str . " (";
		if (!empty($values)) $str = $str . " $s.\"$field\" = ANY($arr)";
		if (!empty($values) && $null) $str = $str . " OR";
		if ($null) $str = $str . " $s.\"$field\" IS NULL";
		if (!empty($values) && $null) $str = $str . ")";
	}
	
	
	# --------------------------------------------------------------------------------
	
	function query_biotable_rangefield ($query, &$str, $sid) {
		
		//print_r($query);
		//echo "<br>";
		$field = $query['field'];
		$value = $query['value'];
		$op = $query['operator'];
		$null = $query['null'];
		
		if ($null) $str = $str . "(";
		if ($sid == 23) {
			$s = 'm';
		} else {
			$s = 'd';
		}
		$str = $str . " $s.\"$field\" $op $value";
		if ($null == 'on') $str = $str . " OR $s.\"$field\" IS NULL)";

	}

	
	# --------------------------------------------------------------------------------
	
	function query_biotree($db_handle, $qobject, $source, $str) {
			
		//echo "Begin biotree query<br>";
		//print_r($qobject);
		
		$subtree = $qobject['subtree'];
		if (!$subtree) $subtree = 'all';
		$tree_id = $source['tree_id'];
		$nodefilter = $qobject['nodefilter'];
		$filterscope = $qobject['filterscope'];
		//$treenodes = $qobject['treenodes'];
		if ($qobject['taxa']) $names_array = array_to_postgresql($qobject['taxa'], 'text');
				
		# GET TREE TYPE
		$str2 = "SELECT biosql.pdb_tree_type($tree_id)";
		$res = pg_query($db_handle, $str2);
		$row = pg_fetch_row($res);
		$type = $row[0];
		
		
		#TREENODES
		# If phylogeny then tip, internal and all
		//print_r($nodefilter);
		//echo "<br>filter: $filterscope, n_nodefilter: " . count($nodefilter) . ", nodefilter: $nodefilter<br>";
		
		if ($type == 'phylogeny') {
			if (in_array('tip', $nodefilter) && in_array('internal', $nodefilter)) {
				$nodefilter = 'all';
			} else {
				$nodefilter = $nodefilter[0];
			}
		} else {
			if ($filterscope == 'query') {
				# ARE THERE AS MANY LEVELS IN THE QUERY AS IN THE TREE
				$str2 = "SELECT biosql.pdb_taxonomy_levels($tree_id)";
				$res = pg_query($db_handle, $str2);
				$n = pg_num_rows($res);
				if (count($nodefilter) !== $n) $levels = array_to_postgresql($nodefilter, 'text'); 
			}
		}

		//echo "subtree: $subtree, type: $type, levels: $levels<br>";
		
		switch ($subtree) {
			
			case "all":
				$str = $str . " SELECT label AS bioname FROM biosql.node WHERE tree_id = $tree_id";
				if ($type == phylogeny) {
					if ($nodefilter == 'tip') {
						$str = $str . " AND left_idx = right_idx - 1";
					} elseif ($nodefilter == 'internal') {
						$str = $str . " AND left_idx <> right_idx - 1";
					}
				} else {
					if ($levels) $str = $str . " AND label IN (SELECT biosql.pdb_taxonomy_has_level($tree_id, $levels))";
				}
				break;
				
			case "subtree":
				if ($type == 'phylogeny') {
					switch ($nodefilter) {
						case 'all':
							$str = $str . " SELECT * FROM biosql.pdb_lca_subtree_label($tree_id, $names_array) AS bioname";									
							break;
						case 'tip':
							$str = $str . " SELECT * FROM biosql.pdb_lca_subtree_tip_label($tree_id, $names_array) AS bioname";
							break;
						case 'internal':
							$str = $str . " SELECT * FROM biosql.pdb_lca_subtree_internal_label($tree_id, $names_array) AS bioname";
							break;
					}
				} else {
					$str = $str . " SELECT * FROM biosql.pdb_lca_subtree_label($tree_id, $names_array) AS bioname";									
					if ($levels) $str = $str . " WHERE bioname IN (SELECT biosql.pdb_taxonomy_has_level($tree_id, $levels))";
				}
				break;
				
			case 'lca':
				$str = $str . " SELECT biosql.pdb_node_id_to_label(biosql.pdb_lca($tree_id, $names_array)) AS bioname";
				if ($levels) $str = $str . " AND label IN (SELECT biosql.pdb_taxonomy_has_level($tree_id, $levels))";
				break;
				
			case "selected":
				if ($type == 'phylogeny') {
					switch ($treenodes) {
						case 'all':
							$str = $str . " SELECT label AS bioname FROM biosql.node";
							$str = $str . " WHERE tree_id = $tree_id AND label = ANY ($names_array)";	
							break;
						case 'tip':
							$str = $str . " SELECT label AS bioname FROM biosql.node";
							$str = $str . " WHERE tree_id = $tree_id";
							$str = $str . " AND left_idx = right_idx - 1";
							$str = $str . " AND label = ANY ($names_array)";
							break;
						case 'internal':
							$str = $str . " SELECT label AS bioname FROM biosql.node";
							$str = $str . " WHERE tree_id = $tree_id";
							$str = $str . " AND left_idx <> right_idx - 1";
							$str = $str . " AND label = ANY ($names_array)";
							break;
					}					
				} else {
					$str = $str . " SELECT label AS bioname FROM biosql.node";
					$str = $str . " WHERE tree_id = $tree_id AND label = ANY ($names_array)";
					if ($levels) $str = $str . " AND label IN (SELECT biosql.pdb_taxonomy_has_level($tree_id, $levels))";
				}
		
				break;
			}
						
	return ($str);
	}
# ====================================================================================================
	
function query_add_names_sql(&$qobject, $qobjects, $qstr) {
	
	$qobject['sql_names_query'] = htmlspecialchars(trim($qstr));
	$str_names = '';
	$i = 0;
	$end = false;
	foreach ($qobjects as $qobj) {
		if ($qobj['id'] == $qobject['id']) $end = true;
		if ($end == false) {
			if ($i > 0) {
				$str_names = $str_names . $qobj['queryoperator'];
			}
			$str_names = $str_names . $qobj['sql_names_query'];		
		}
	}
	$qobject['sql_names_queries'] = $str_names;
}
# ====================================================================================================
	
function query_add_series_sql(&$qobject, $qobjects, $qstr) {
	
	$qobject['sql_series_query'] = htmlspecialchars(trim($qstr));
	$str_series = '';
	$i = 0;
	$end = false;
	foreach ($qobjects as $qobj) {
		if ($qobj['id'] == $qobject['id']) $end = true;
		if ($end == false) {
			if ($i > 0) {
				$str_series = $str_series . " " . $qobj['queryoperator'];
			}
			$str_series = $str_series . $qobj['sql_series_query'];			
		}
	}
	$qobject['sql_series_queries'] = $str_series;
}
	
	
	
	# ====================================================================================================
	
	function query_biogeographic($qobject, $source, $str){
		
		//echo "Begin biogeographic query<br>";
		//print_r($qobject);
		//echo $qobject['q_geometry'], "<br>";

		// SRID HARDCODED TO GPS84

		$s_operator = $qobject['s_operator'];
		$s_col = $source['spatial_column'];
		$q_geometry = $qobject['q_geometry'];
		$dbloc = $source['dbloc'];
		# POSTGIS FUNCTION
		$s_op = get_s_operator($s_operator);

		# QUERY
		if ($source['id'] == 26 || $source['id'] == 27) {
			# GPDD
			switch ($s_operator) {
				case 'quickoverlap':
				case 'quickwithin':
					$str = $str . " SELECT DISTINCT t.binomial AS bioname ";
					$str = $str . " FROM gpdd.taxon t, gpdd.main m,	$dbloc l, gpdd.datasource ds,";
					$str = $str . " (SELECT (ST_Dump(ST_GeomFromEWKT('SRID=4326; $q_geometry'))).geom) AS foo";
					$str = $str . " WHERE l.$s_col::geometry $s_op geom::geometry";
					$str = $str . " AND t.\"TaxonID\" = m.\"TaxonID\"";
					$str = $str . " AND m.\"LocationID\" = l.locationid";
					$str = $str . " AND m.\"DataSourceID\" = ds.\"DataSourceID\"";
					$str = $str . " AND ds.\"Availability\" <> 'Restricted'";
					$str = $str . " AND t.binomial IS NOT NULL";					
					break;
					
				case 'overlap':
				case 'within':
					$str = $str . " SELECT DISTINCT t.binomial AS bioname";
					$str = $str . " FROM gpdd.taxon t, gpdd.main m,	$dbloc l, gpdd.datasource ds,";
					$str = $str . " INNER JOIN (";
					$str = $str . " SELECT (ST_Dump(ST_GeomFromEWKT('SRID=4326; $q_geometry'))).geom v) AS foo";
					$str = $str . " ON $s_op(v::geometry, l.$s_col::geometry)";
					$str = $str . " WHERE t.\"TaxonID\" = m.\"TaxonID\"";
					$str = $str . " AND m.\"LocationID\" = l.locationid";
					$str = $str . " AND m.\"DataSourceID\" = ds.\"DataSourceID\"";
					$str = $str . " AND ds.\"Availability\" <> 'Restricted'";
					$str = $str . " AND t.binomial IS NOT NULL";
					break;				
			}
		} else {
			# Not GPDD
			switch ($s_operator) {
				case 'quickoverlap':
				case 'quickwithin':	
					$str = $str . " SELECT DISTINCT " . $source['namefield'] . " AS bioname";
					$str = $str . " FROM " . $source['dbloc'] . " s, ";
					$str = $str . " (SELECT (ST_Dump(ST_GeomFromEWKT('SRID=4326; $q_geometry'))).geom) AS foo";
					$str = $str . " WHERE s.$s_col::geometry $s_op geom::geometry = 't'";					
					break;
					
				case 'overlap':
				case 'within':
					$str = $str . " SELECT " . $source['namefield'] . " AS bioname";
					$str = $str . " FROM " . $source['dbloc'] . " s INNER JOIN (";
					$str = $str . " SELECT (ST_Dump(ST_GeomFromEWKT('SRID=4326; $q_geometry'))).geom v) AS foo";
					$str = $str . " ON $s_op(v::geometry, s.$s_col::geometry)";
					$str = $str . " WHERE s." . $source['namefield'] . " IS NOT NULL";
					break;
			}
		}
		
		#if ($not) $str = $str . ")";

		#echo "End biogeographic query: $str<br>";
	return ($str);
	}
	

	# ====================================================================================================
	
	function query_biogeographic_series($qobject, $sql) {
		
		//echo "Begin biogeographic_series query<br>";

		//print_r($qobject);
		
		$qsources = $qobject['sources'];
		$s_operator = $qobject['s_operator'];
		$s_op =get_s_operator ($s_operator); 
		$s_col = $source['spatial_column'];
		$q_geometry = $qobject['q_geometry'];
		$dbloc = $source['dbloc'];
		
		if (in_array(26, $qsources) && in_array(27, $qsources)) {
			$both = true;
		} else {
			$false = true;
		}
		
		if ($both == true) $str = $str . " SELECT DISTINCT mid FROM (";
			
		if (in_array(26, $qsources)) {
			$sql = $sql . " SELECT m.\"MainID\" AS mid";
			$str = $str . "	FROM gpdd.main m, gpdd.location_pt l, gpdd.taxon t, gpdd.datasource ds,";
			$str = $str . " SELECT (ST_Dump(ST_GeomFromEWKT('SRID=4326; $q_geometry'))).geom v) AS foo";
			$str = $str . " ON $s_op(v::geometry, l.$s_col::geometry)";
			$str = $str . "	WHERE m.\"LocationID\" = l.locationid";
			$str = $str . "	AND m.\"TaxonID\" = t.\"TaxonID\"";
			$str = $str . " AND m.\"DataSourceID\" = ds.\"DataSourceID\"";
			$str = $str . " AND ds.\"DataSourceID\" <> 'Availability'";
			$str = $str . "	AND t.binomial IS NOT NULL";
		}
			
		if ($both == true) $sql = $sql . " UNION ALL";
			
		if (in_array(27, $qsources)) {
			$sql = $sql . " SELECT m.\"MainID\" AS mid";
			$str = $str . "	FROM gpdd.main m, gpdd.location_bbox l, gpdd.taxon t, gpdd.datasource ds,";
			$str = $str . " SELECT (ST_Dump(ST_GeomFromEWKT('SRID=4326; $q_geometry'))).geom v) AS foo";
			$str = $str . " ON $s_op(v::geometry, l.$s_col::geometry)";
			$str = $str . "	WHERE m.\"LocationID\" = l.locationid";
			$str = $str . "	AND m.\"TaxonID\" = t.\"TaxonID\"";
			$str = $str . " AND m.\"DataSourceID\" = ds.\"DataSourceID\"";
			$str = $str . " AND ds.\"DataSourceID\" <> 'Availability'";
			$str = $str . "	AND t.binomial IS NOT NULL";
		}
		
		if ($both == true) $sql = "$sql GROUP BY mid HAVING COUNT(*) = 2) AS mid ";
		
		return $sql;
		
	}
	
	# ====================================================================================================
	
	function query_biotemporal ($qobject, $qobjects, $str){
		
		//print_r($qobject);
		//echo "<br>";
		
		$operator = $qobject['toperator'];
		$dtime = $qobject['dtime'];
		if ($qobject['status'] == 'new') {
			$mids = query_get_mids($qobjects, 'this');
		} else {
			$mids = query_get_mids($qobjects, 'last');
		}
		
		if ($mids) $arr = array_to_postgresql($mids, 'numeric');
		
		# HERE
		$str = $str . "SELECT bioname FROM (";
		$str = $str . " SELECT t.binomial AS bioname,";
		$str = $str . " MIN(d.\"DecimalYearBegin\") AS dstart,";
		$str = $str . " MAX(d.\"DecimalYearEnd\") AS dfinish";
		$str = $str . " FROM gpdd.taxon t,";
		$str = $str . " gpdd.main m,";
		$str = $str . " gpdd.data d,";
		$str = $str . " gpdd.datasource ds";
		$str = $str . " WHERE m.\"MainID\" = d.\"MainID\"";
		$str = $str . " AND m.\"TaxonID\" = t.\"TaxonID\"";
		$str = $str . " AND m.\"DataSourceID\" = ds.\"DataSourceID\"";
		$str = $str . " AND ds.\"Availability\" <> 'Restricted'";		
		$str = $str . " AND t.binomial IS NOT NULL";
		if ($arr) $str = $str .  " AND m.\"MainID\" = ANY($arr)";
		$str = $str . " GROUP BY t.binomial";
		
		
		switch ($operator) {
			case 'BEFORE':
				$str = $str . " HAVING MAX(d.\"DecimalYearBegin\") >= 1500 AND MIN(d.\"DecimalYearEnd\") <= $dtime";
				break;
			case 'DURING':
				//$str = $str . " HAVING MAX(d.\"DecimalYearBegin\") >= 1500";
				//$str = $str . " AND (MIN(d.\"DecimalYearBegin\") <= $dtime AND MAX(d.\"DecimalYearEnd\") >= $dtime)";
				$str = $str . " HAVING (MIN(d.\"DecimalYearBegin\") <= $dtime AND MAX(d.\"DecimalYearEnd\") >= $dtime)";
				break;
			case 'AFTER':		
				//$str = $str . " HAVING MAX(d.\"DecimalYearBegin\") >= 1500";
				//$str = $str . " AND MIN(d.\"DecimalYearBegin\") >= $dtime";
				$str = $str . " HAVING MIN(d.\"DecimalYearBegin\") >= $dtime";
				break;
		}
		$str = $str . ") AS foo";
		#echo "$str<br>";
		return ($str);
	}
	
		# ====================================================================================================
	
	function query_biotemporal_series ($qobject,$str) {
		
		$t_overlay = $qobject['queryoperator'];
		$dtime = $qobject['dtime'];

		//print_r($mids);
		#if ($mids) $arr = array_to_postgresql($mids, 'numeric');
		
		//$str = "$str AND m.\"MainID\" IN (";
		
		switch ($t_overlay) {
			case 'OVERLAP':
				$str = $str . "SELECT mid 
				FROM ( 
					SELECT m.\"MainID\" AS mid, 
					MIN(d.\"DecimalYearBegin\") AS dstart, 
					MAX(d.\"DecimalYearEnd\") AS dfinish
					FROM gpdd.main m,
					gpdd.data d,
					gpdd.datasource ds
					WHERE m.\"MainID\" = d.\"MainID\"
					AND m.\"DataSourceID\" = ds.\"DataSourceID\"
					AND ds.\"DataSourceID\" <> 'Availability'
					GROUP BY m.\"MainID\"
					HAVING MAX(d.\"DecimalYearBegin\") >= 1500
					AND (MIN(d.\"DecimalYearEnd\") >= $dtime AND MAX(d.\"DecimalYearBegin\") <= $dtime)
					) AS foo";	
				break;
			case 'WITHIN':
				$str = $str . "SELECT mid 
				FROM ( 
					SELECT m.\"MainID\" AS mid, 
					MIN(d.\"DecimalYearBegin\") AS dstart, 
					MAX(d.\"DecimalYearEnd\") AS dfinish
					FROM gpdd.main m,
					gpdd.data d,
					gpdd.datasource ds
					WHERE m.\"MainID\" = d.\"MainID\"
					AND m.\"DataSourceID\" = ds.\"DataSourceID\"
					AND ds.\"Availability\" <> 'Restricted'					
					GROUP BY m.\"MainID\"
					HAVING MAX(d.\"DecimalYearBegin\") >= 1500
					AND (MIN(d.\"DecimalYearEnd\") <= $to_dtime AND MAX(d.\"DecimalYearBegin\") >= $from_dtime)
					) AS foo";							
				break;
		}
		
		//$str = "$str)";
		return ($str);
	}
	
	
	# ====================================================================================================
	
	function query_bionames_relational($str) {
		
		$str = $str . "SELECT DISTINCT binomial AS bioname";
		$str = $str . " FROM gpdd.taxon t, gpdd.main m, gpdd.datasource ds";
		$str = $str . " WHERE m.\"DataSourceID\" = ds.\"DataSourceID\"";
		$str = $str . " AND ds.\"Availability\" <> 'Restricted'";
		return ($str);
	}
	
	# ====================================================================================================
	
	function query_bionames_tree($qobject, $source, $str) {
		
		$tree_id = $source['tree_id'];
		
		$str = $str . "SELECT label AS bioname";
		$str = $str . " FROM biosql.node WHERE node.tree_id = $tree_id";
		
		return ($str);
	}
	
# ====================================================================================================
	
	function query_series ($db_handle, &$qobject, $qobjects, $names, $sources){
	
		# QUERY GPDD SERIES
		//echo "begin query series<br>";
		//$out = array();
		
		#ONLY RUN IF GPDD A SOURCE
		$run = false;
		if ($sources) {
			foreach ($sources as $source) {
				if ($source['id'] == 23) {
					$run = true;
				}
			}
		}
		//echo "run $run<br>";
		if($run == false) return;
	
		# GET MIDS
		$mids = query_get_mids($qobjects, 'last');
		if ($mids && ($_SESSION['token'] == $_POST['token'])) {
			if (count($qobjects) == 1) {
				unset ($mids);
			} else {
				$mids = $qobjects[count($qobjects) - 2]['series'];
			}
		}
		
		if ($mids) $midsarr = array_to_postgresql($mids, 'numeric');
		if ($names) $arr = array_to_postgresql($names, 'text');		
		
		switch ($qobject['term']){
			case 'biotree':
			case 'biotable':
			case 'bionames':
				# SERIES
				$str = "SELECT m.\"MainID\"";
				$str = $str . " FROM gpdd.main m, gpdd.taxon t";
				$str = $str . " WHERE m.\"TaxonID\" = t.\"TaxonID\"";
				if ($arr) $str = $str . " AND t.binomial = ANY($arr)";
				//if ($midsarr) $str = $str . " AND m.\"MainID\" = ANY($midsarr)";
				break;
				
			case 'biogeographic':
				$qsources = $qobject['sources'];
				$s_operator = $qobject['s_operator'];
				$s_op = get_s_operator($s_operator);
				$q_geometry = $qobject['q_geometry'];

				# SELECT
				$str = "SELECT m.\"MainID\"";
				$str = $str . " FROM gpdd.main m,";
				if (in_array(26, $qsources)) $str = $str . " gpdd.location_pt p,";		
				if (in_array(27, $qsources)) $str = $str . " gpdd.location_bbox b,";
				$str = $str . " gpdd.taxon t,";
				$str = $str . " gpdd.datasource ds";
				$str = $str . ", (SELECT (ST_Dump(ST_GeomFromEWKT('SRID=4326; $q_geometry'))).geom) AS foo";
				
				$str = $str . " WHERE m.\"TaxonID\" = t.\"TaxonID\"";
				$str = $str . " AND m.\"DataSourceID\" = ds.\"DataSourceID\"";
				$str = $str . " AND ds.\"Availability\" <> 'Restricted'";		
				if (in_array(26, $qsources)) $str = $str . " AND m.\"LocationID\" = p.locationid";
				if (in_array(27, $qsources)) $str = $str . " AND m.\"LocationID\" = b.locationid";
				
				
				switch ($s_operator) {
					case 'quickoverlap':
					case 'quickwithin':
						if (in_array(26, $qsources)) {
							$source = get_source($db_handle, 26, null);
							$str = $str . " AND p." . $source['spatial_column'] . "::geometry $s_op geom::geometry";
						}
						if (in_array(27, $qsources)) {
							$source = get_source($db_handle, 27, null);
							$str = $str . " AND b." . $source['spatial_column'] . "::geometry $s_op geom::geometry";
						}
						break;
						
					case 'overlap':
					case 'within':
						if (in_array(26, $qsources)) {
							$source = get_source($db_handle, 26, null);
							$str = $str . " AND $s_op(p." . $source['spatial_column'] . "::geometry, geom::geometry)";
						}
						if (in_array(27, $qsources)) {
							$source = get_source($db_handle, 27, null);
							$str = $str . " AND $s_op(b." . $source['spatial_column'] . "::geometry, geom::geometry)";
						}
						break;				
				}
				
				$str = $str . " AND t.binomial IS NOT NULL";
				if ($arr) $str = $str . " AND t.binomial = ANY($arr)";
				//if ($midsarr) $str = $str . " AND m.\"MainID\" = ANY ($midsarr)";
				break;
				
			case 'biotemporal':
				$operator = $qobject['toperator'];
				$dtime = $qobject['dtime'];
				$str = $str . "SELECT mid FROM (";
				$str = $str . " SELECT m.\"MainID\" AS mid,";
				$str = $str . " MIN(d.\"DecimalYearBegin\") AS dstart,";
				$str = $str . " MAX(d.\"DecimalYearEnd\") AS dfinish";
				$str = $str . " FROM gpdd.taxon t,";
				$str = $str . " gpdd.main m,";
				$str = $str . " gpdd.data d,";
				$str = $str . " gpdd.datasource ds";
				$str = $str . " WHERE m.\"MainID\" = d.\"MainID\"";
				$str = $str . " AND m.\"TaxonID\" = t.\"TaxonID\"";
				$str = $str . " AND m.\"DataSourceID\" = ds.\"DataSourceID\"";
				$str = $str . " AND ds.\"Availability\" <> 'Restricted'";
				$str = $str . " AND t.binomial IS NOT NULL";
				if ($arr) $str = $str . " AND t.binomial = ANY($arr)";
				//if ($midsarr) $str = $str . " AND m.\"MainID\" = ANY ($midsarr)";
					
				switch ($operator) {
					case 'BEFORE':
						$str2 = " GROUP BY m.\"MainID\" HAVING (MAX(d.\"DecimalYearBegin\") >= 1500";
						$str2 = $str2 . " AND MAX(d.\"DecimalYearEnd\") <= $dtime)) AS foo";
					break;
					case 'AFTER':
						$str2 = " GROUP BY m.\"MainID\" HAVING (MAX(d.\"DecimalYearBegin\") >= 1500";
						$str2 = $str2 . " AND MAX(d.\"DecimalYearBegin\") >= $dtime)) AS foo";
					break;
					case 'DURING':
						$str2 = " GROUP BY m.\"MainID\" HAVING (MAX(d.\"DecimalYearBegin\") >= $dtime";
						$str2 = $str2 . " AND MIN(d.\"DecimalYearEnd\") <= $dtime)) AS foo";
					break;
				}
				$str = $str . $str2;
				break;
			default:
			break;
		}   #term
		
		//echo "qstr: $qstr<br>";
		query_add_series_sql($qobject, $qobjects, $str);
		
		$op = $qobject['queryoperator'];
		if ($midsarr) $str = "$str $op SELECT UNNEST($midsarr) as mid";	
		
		//echo "series query: $str<br>";
		$res = pg_query($str);
		$mids = pg_fetch_all_columns($res, 0);
		$qobject['series'] = $mids;
		//query_add_sql($qobject, $qobjects, $sources);
	
	}
	
# ====================================================================================================
	
	function query_null ($db_handle, $sid, $field) {

		# RETURNS TRUE IF NULLS IN FIELD, OTHERWISE FALSE
		$sources = $_SESSION['sources'];
		$source = get_obj($sources, $sid);
		
		switch ($source['term']) {
			case 'biotable':
			case 'biogeographic':
				if ($ifield['ebtype'] == 'lookupfield') {
					$str = "SELECT CASE (";
					$str = $str . "SELECT COUNT(*) FROM source.source_fields f, source.source_fieldcodes c";
					$str = $str . " WHERE c.field_id = f.field_id";
					$str = $str . " AND f.source_id = $sid";
					$str = $str . " AND f.field_name = '$field'";
					$str = $str . " AND c.name IS NULL";
					$str = $str . ") WHEN 0 THEN FALSE ELSE TRUE END";
				} else {
					$str = "SELECT CASE (SELECT COUNT(*) FROM " . $source['dbloc'] . " WHERE";
					$str = $str . " \"$field\" IS NULL";
					if ($arr)	$str = $str . " AND \"" . $source['namefield'] . "\" LIKE '%$query%'";
					$str = $str . ") WHEN 0 THEN FALSE ELSE TRUE END";
				}
	
				break;
			case 'biorelational':
					# GPDD HARDCODE
					switch ($field) {
						case 'Author':
						case 'Year':
						case 'Title':
						case 'Reference':
						case 'Availability':
						case 'Notes':
							$str = "SELECT CASE (SELECT COUNT(*)
								FROM gpdd.taxon t, gpdd.main m, gpdd.datasource ds
								WHERE t.\"TaxonID\" = m.\"TaxonID\"
								AND m.\"DataSourceID\" = ds.\"DataSourceID\"
								AND ds.\"Availability\" <> 'RESTRICTED'";
							$str = $str . " AND ds.\"" . $field . "\" IS NULL";
							if ($arr) $str = $str . " AND t.\"" . $source['namefield'] . "\" = ANY($arr)";
							$str = $str . ") WHEN 0 THEN FALSE ELSE TRUE END";
							break;
							
						case 'TaxonomicPhylum':
						case 'TaxonomicClass':
						case 'TaxonomicOrder':
						case 'TaxonomicFamily':
						case 'TaxonomicGenus':
						case 'binomial':
						case 'CommonName':
						case 'TaxonName':
							$str = "SELECT CASE (SELECT COUNT(*)
								FROM gpdd.taxon t, gpdd.main m, gpdd.datasource ds
								WHERE t.binomial IS NOT NULL
								AND m.\"DataSourceID\" = ds.\"DataSourceID\"
								AND ds.\"Availability\" <> 'RESTRICTED'";
							$str = $str . " AND t.\"" . $field . "\" IS NULL";
							if ($arr) $str = $str . " AND t.\"" . $source['namefield'] . "\" = ANY($arr)";
							$str = $str . ") WHEN 0 THEN FALSE ELSE TRUE END";
							break;
							
						case 'HabitatName':
						case 'BiotopeType':
							$str = "SELECT CASE (SELECT COUNT(*)
								FROM gpdd.taxon t, gpdd.main m, gpdd.datasource ds, gpdd.biotope b
								WHERE t.binomial IS NOT NULL
								AND m.\"DataSourceID\" = ds.\"DataSourceID\"
								AND ds.\"Availability\" <> 'RESTRICTED'";
							$str = $str . " AND b.\"" . $field . "\" IS NULL";
							if ($arr) $str = $str . " AND t.\"" . $source['namefield'] . "\" = ANY($arr)";
							$str = $str . ") WHEN 0 THEN FALSE ELSE TRUE END";
							break;
							
						case 'ExactName':
						case 'TownName':
						case 'CountyStateProvince':
						case 'Country':
						case 'Continent':
						case 'Ocean':
						case 'SpatialAccuracy':
						case 'LocationExtent':
							$str = "SELECT CASE (SELECT COUNT(*)
								FROM gpdd.taxon t, gpdd.main m, gpdd.datasource ds, gpdd.location l
								WHERE t.binomial IS NOT NULL
								AND m.\"DataSourceID\" = ds.\"DataSourceID\"
								AND ds.\"Availability\" <> 'RESTRICTED'";
							$str = $str . " AND l.\"" . $field . "\" IS NULL";
							if ($arr) $str = $str . " AND t.\"" . $source['namefield'] . "\" = ANY($arr)";
							$str = $str . ") WHEN 0 THEN FALSE ELSE TRUE END";
							break;
							
						default:
							$str = "SELECT CASE (SELECT COUNT(*)
								FROM gpdd.taxon t, gpdd.main m, gpdd.datasource ds
								WHERE t.binomial IS NOT NULL
								AND m.\"DataSourceID\" = ds.\"DataSourceID\"
								AND ds.\"Availability\" <> 'RESTRICTED'";
							$str = $str . " AND m.\"" . $field . "\" IS NULL";
							if ($arr) $str = $str . " AND t.\"" . $source['namefield'] . "\" = ANY($arr)";
							$str = $str . ") WHEN 0 THEN FALSE ELSE TRUE END";
							break;
					}
				break;
		}	
		//echo "$str<br>";
		$res = pg_query($db_handle, $str);
		return pg_fetch_row($res);
	
	}
	# ====================================================================================================
	
	function query_series_names($db_handle, $qobjects, $names, $sources) {
		
		# STRIPS $names without mids

		$mids = query_get_mids($qobjects);
		# REPOST FIX
		if ($mids && ($_SESSION['token'] == $_POST['token'])) unset ($mids);
		//print_r($mids);
		if ($mids && !empty($mids)) {
			$mids_arr = array_to_postgresql($mids, 'numeric');
			if ($names) $names_arr = array_to_postgresql($names, 'text');
			if ($mids_arr) {
				$str = "SELECT DISTINCT binomial AS bioname
					FROM gpdd.main m,
					gpdd.taxon t
					WHERE m.\"TaxonID\" = t.\"TaxonID\"
					AND m.\"MainID\" = ANY($mids_arr)
					";
				if ($names_arr) $str = $str . " AND t.binomial = ANY($names_arr )";
			}
			$res = pg_query($db_handle, $str);
			$outnames = pg_fetch_all_columns($res, 0);
		} else {
			$outnames = $names;
		}
		return ($outnames);
		
	}
	
	#=================================================================================================================

function query_get_mids($qobjects, $query = 'this') {
	
	# RETURNS GPDD MAINIDs FROM A QUERY STACK
	# $query	'this' returns mids for the last valid query
	#           'last' returns mids for the penultimate query
	# Returns Null if no mids
	
	$n = count($qobjects);
	
	switch ($n) {
		case 0:
			return null;
			break;
		case 1:
			if ($qobjects[0]['series'] && $query == 'this') {
				return $qobjects[0]['series'];
				 null;
			} else {
				return null;
			}
			break;
		default:
			if ($qobjects[$n - 1]['status'] == 'new') {
				if ($query == 'this') {
					return $qobjects[$n - 2]['series'];
				} else {
					return $qobjects[$n - 3]['series'];
				}
			} else {
				if ($query == 'this') {
					return $qobjects[$n - 1]['series'];
				} else {
					return $qobjects[$n - 2]['series'];
				}
			}
			break;
	}
	
}

# ====================================================================================================

function query_name_search($db_handle) {
	
	# RETURNS SOURCES NAMES ARE IN
	$input = $_SESSION['name_search'];
	$sources = $_SESSION['sources'];
	#echo "$input<br>";
	$out = array();
	$taxa = explode(",",$input);
	
	# trim whitespace
	$taxa = array_map('trim', $taxa);
	
	foreach ($taxa as $taxon) {
		if (strlen($taxon) > 0) {
			$sin = array(); 	//sources name is in
			foreach ($sources as $source) {
				$sid = $source['id'];
				switch ($source['term']) {
					case "biotable" :
					case "biogeographic" :
						$str = "SELECT " . $source['namefield'] . 
							" FROM " . $source['dbloc'] .
							" WHERE " . $source['namefield'] . " = '$taxon';";
						break;	
					case "biotree":
						$str = "SELECT * FROM biosql.node WHERE label = '$taxon' AND tree_id = " . $source['tree_id'] .";";
						break;
					case 'biorelational':
						# GPDD HARDCODE
						$str = "SELECT binomial FROM gpdd.taxon WHERE binomial='$taxon'";
						break;
					default :
						echo "$source is not a source.<br>";
						return;
				}
				#echo "$scode: $str<br>";
				$res = pg_query($db_handle, $str);
				$row = pg_fetch_row($res);
				if ($row) array_push($sin, $sid);
			}
			if (empty($sin)) {
				$out[$taxon] = null;	
			} else {
				$out[$taxon] = $sin;	
			}
		}	
	}
	#print_r($out);
	#echo "<br>";
	return $out;
}

# ====================================================================================================

function get_s_operator($s_operator) {
		
	# Returns POSTGIS FUNCTION
		switch ($s_operator) {
			case 'quickoverlap':
				$s_op = "&&";
				break;
			case 'quickwithin':
				$s_op = "~-";
				break;
			case 'overlap':
				$s_op = "ST_Intersects";
				break;
			case 'within':
				$s_op = "ST_Contains";
				break;
			default:
				echo "php_query: spatial operator $s_operator not supported";
				$s_op = null;
				break;
		}
	return $s_op;
}
					
# ====================================================================================================
	
?>
