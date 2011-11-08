<?php

	function query($db_handle, $qobject, $qobjects, $names, $sources) {
	
		# RUNS AN ENTANGLED BANK QUERY
		
/*		echo "Begin query<br>";
		print_r($qobject);
		echo "<br>";*/

		
		# QUERY PARAMETERS
		$qterm = $qobject['term'];
		$queryop = $qobject['queryoperator'];
		$qsources = $qobject['sources'];
		$nsources = $qobject['nsources'];
		$nop = $qobject['noperator'];
		$allnames = $qobject['allnames'];
		
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
		if ($names) $names_array = array_to_postgresql($names, 'text');
		
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
					$str = query_biotable(db_handle, $qobject, $source, $str);
				break;
				case ($qterm == 'bionames' && $sterm == 'biotree'):
					$str = query_bionames_tree($qobject, $source, $str);
					break;
				case ($qterm <> 'bionames' && $sterm =='biotree'):
					$str = query_biotree($qobject, $source, $str);
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
						$str = $str . " WHERE binomial = ANY($taxa_array)";
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
							$str = $str . " WHERE t.binomial IS NOT NULL";
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
			# GROUP BY 
			$str = $str . " GROUP BY bioname HAVING COUNT(*) $nop $nsources";
		}
		
		# COPY QUERY FOR SAVING IN QOBJECT
		$qstr = $str;
		
		# ADD INTERQUERY OPERATOR
		//if ($names_array) $str = "$str $queryop SELECT UNNEST($names_array) AS bioname";
		if ($names_array) {
			if ($qterm == 'biotable' && $sterm == 'biorelational') {
				$str = "$str $queryop SELECT UNNEST($names_array) AS bioname, NULL AS n";
			} else {
				$str = "$str $queryop SELECT UNNEST($names_array) AS bioname";
			}
		}
			
		# RUN NAMES QUERY
		//echo "query: $str<br>";
		$res = pg_query($db_handle, $str);
		$outnames = pg_fetch_all_columns($res, 0);
		
		# ADD SQL TO QOBJECT
		//echo "query: $qstr<br>";
		$qobject = query_add_names_sql($qobject, $qobjects, $qstr);
		$qobjects = save_obj($qobjects, $qobject);
		
		# GPDD SERIES QUERY
		# =================
		
		if (!empty($outnames)) {
			# RUN GPDD SERIES QUERY
			$qobject = query_series($db_handle, $qobject, $qobjects, $outnames, $sources);
			$qobjects = save_obj($qobjects, $qobject);
			# RUN NAMES QUERY
			$outnames = query_series_names($db_handle, $qobjects, $outnames, $sources);
		} else {
			# No Names
			$qobject['series'] = null;
		}
		$qobjects = save_obj($qobjects, $qobject);
		# RETURN QOBJECT AND NAMES
		if ($outnames) {
			return array($qobject, array_filter($outnames));
			} else {
			return array($qobject, array());
			}
		return ($out);
	}

# ----------------------------------------------------------------------
	
	function query_bionames_table ($source, $str) {
		$str = $str . "SELECT " . $source['namefield'] . " AS bioname "
				. " FROM " . $source['dbloc'];
		return($str);
	}
	
# ----------------------------------------------------------------------
	
	function query_biotable($db_handle,$qobject, $source, $str) {
		
		$qterm = $qobject['term'];
		$queries = $qobject['queries'];
		$fields = $source['fields'];
		$not = $qobject['querynot'];
		$null = $qobject['querynull'];
		$sterm = $source['term'];
		//$nseries = -1;
		$nseries_op = "";
		
		//echo "Begin biotable query " . $source['id'] . "<br>";
		//print_r($qobject);
		//echo  "<br>";
		
		# SELECT CLAUSE
		if ($source['id'] !== '23') {
			# NOT GPDD
			$str = $str . "SELECT d." . $source['namefield'] . " AS bioname "
				. " FROM " . $source['dbloc']
				. " d WHERE";
			$first = true;
		} else {
			
			# GPDD
			# TABLES
			$tables = array();				
			$str = $str . "SELECT t.binomial AS bioname, COUNT(*) AS n
				 FROM gpdd.main m";
			
			
			//$qtables = array();
			foreach ($queries as $query) {
				switch (true) {
					case ($query['lookup'] == 24 || $query['field'] == 'NSeries'):
						$tables['taxon'] = ", gpdd.taxon t";
						break;
					case ($query['lookup'] == 25):
						$tables['location'] = ", gpdd.location l";
						break;					
					case ($query['lookup'] == 28):
						$tables['biotope'] = ", gpdd.biotope b";
						break;
					case ($query['lookup'] == 31):
						$tables['datasource'] = ", gpdd.datasource d";
						break;		
				}
			}
			
			//print_r($tables);
			$tables_val = array_values($tables);
			foreach ($tables_val as $val) $str = $str . $val;
			
			# WHERE JOINS
			$str = $str . " WHERE ";
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
						$str = $str . " m.\"DataSourceID\" = d.\"DataSourceID\"";
						break;				
				}
			}
		}
		
		# NOT
		if ($not == 'NOT') {
			if ($first == true) {
				$str = $str . " NOT (";
			} else {
				$str = $str . " AND NOT (";
			}
			$first = true;
		}
		
		
		# WHERE CONDTIONS
		# nseries?
		$nseries_type = 'no';
		$i = 0;
		foreach ($queries as $query) {
			$qfname = $query['field'];
			//echo "qfname: $qfname";
			$qfield = get_field($qfname, $fields);
			$dtype = $qfield['ebtype'];
			//echo ", dtype: $dtype<br />";
			
			if ($i > 0) $str = $str . " AND";
			$i++;
			
			# WHERE CLAUSES
			switch ($dtype) {
				case 'rangefield':
					query_biotable_rangefield($query, $str, $source['id'], $null);
					break;
/*				case 'lookup':
					$str = query_biotable_lookup($query, $str, $source['id']);
					break;*/
				case 'groupfield':
					if (count($queries) == 1) {
						$nseries_type = 'only';
					} else {
						$nseries_type = 'yes';
					}
					$nseries = $query['value'];
					$nseries_op = $query['operator'];
					//echo "$nseries, $nseries_op, $nseries_type<br>";
					break;
				case 'lookupfield':
				case 'catagoryfield':
					query_biotable_lookupfield($query, $str, $source['id'], $null);
					break;
				case 'lookuptable':
					# GPDD HARDCODE
					query_biotable_lookuptable($query, $str, $null);
					break;
				default:
					//look up
					//$str = query_biotable_gpdd($query, $str);
					break;
			}
		}

		# ALL NULL
		if ($null && count($queries) > 1) {
			$str = $str . " AND (";
			foreach ($queries as $query) $str = $str . " \"" . $query['field'] . "\" IS NOT NULL AND";
			$str = substr($str, 0, strlen($str) - 4);
			$str = $str . ")";
		}
		
		
		#NOT END
		if ($not == 'NOT' && $nseries_only == 'only') $str = $str . ")";
		
		if ($source['id'] == '23') $str = $str . " AND t.binomial IS NOT NULL";
		
		# GROUP BY CLAUSES
		if ($source['id'] == '23' && $nseries_type) {
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
		if (count($queries) == 1 && $queries[0]['field'] == 'NSeries') return $str;
		
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
						case 'NSeries': 
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
		
		if ($null) $str = $str . "(";
		
		$str = $str . " $letter.\"$field\" = ANY ($arr)";
		if ($null) $str = $str . " OR $letter.\"$field\" IS NULL)";
		
	}

	
	# --------------------------------------------------------------------------------
	
	function query_biotable_lookupfield($query, &$str, $source, $null) {
		
		if ($source['id'] == 23) {
			$s = 'm';
		} else {
			$s = 'd';
		}
		$field = $query['field'];
		$ftype = $query['ftype'];
		$values = $query['value'];
		$arr = array_to_postgresql($values, $ftype);
		
		if ($null) $str = $str . "(";
		
		$str = $str . " $s.\"$field\" = ANY ($arr)";
		
		if ($null) $str = $str . " OR $s.\"$field\" IS NULL)";
		
		//return ($str);
	}
	
	
	# --------------------------------------------------------------------------------
	
	function query_biotable_rangefield ($query, &$str, $source, $null) {
		
		$field = $query['field'];
		$values = $query['value'];
		$ops = $query['operator'];
		$first = true;
		$i = 0;
		
		if ($null) $str = $str . "(";
		$str = $str . " (";
		
		if ($source['id'] == 23) {
			$s = 'm';
		} else {
			$s = 'd';
		}
				
		foreach ($values as $value) {
			if ($first == false) $str = $str . " AND ";
			$str = $str . " $s.\"$field\" $ops[$i] $value";
			$first = false;
			$i++;
		}
		
		$str = $str . ")";
		if ($null) $str = $str . " OR $s.\"$field\" IS NULL)";
		
		//return $str;
	}

	
	# --------------------------------------------------------------------------------
	
	function query_biotree($qobject, $source, $str) {
			
		//echo "Begin biotree query<br>";
					
		$subtree = $qobject['subtree'];
		# There is no subtree in a names query
		If (!$subtree) $subtree = 'all';
		//print_r($qobject['treenodes']);
		$treenodes = $qobject['treenodes'];
		$tree_id = $source['tree_id'];
		
		#echo "tree: $tree_id, $subtree<br>";
		if ($qobject['taxa']) $names_array = array_to_postgresql($qobject['taxa'], 'text');
		
		switch ($subtree) {
			
			case "all":
				if (!$not) {
					$str = $str . " SELECT label AS bioname FROM biosql.node WHERE tree_id = $tree_id";
					if ($treenodes == 'tip') {
						$str = $str . " AND left_idx = right_idx - 1";
						} elseif ($treenodes == 'internal') {
						$str = $str . " AND left_idx <> right_idx - 1";
					}
					} else {
					$str = "SELECT NULL AS bioname";
					}
				break;
				
			case "subtree":	
				if (!$not) {
					switch ($treenodes) {
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
					switch ($treenodes) {
						case 'all':
							$str = $str . " SELECT label AS bioname FROM biosql.node WHERE tree_id = $tree_id";
							$str = $str . " EXCEPT SELECT * FROM";
							$str = $str . " biosql.pdb_lca_subtree_label($tree_id, $names_array) AS bioname";									
							break;
						case 'tip':
							$str = $str . " SELECT label AS bioname FROM biosql.node WHERE tree_id = $tree_id";
							$str = $str . " AND left_idx = right_idx - 1";
							$str = $str . " AND NOT label = ANY ($names_array)";
							break;
						case 'internal':
							$str = $str . " SELECT label AS bioname FROM biosql.node WHERE tree_id = $tree_id";
							$str = $str . " AND left_idx <> right_idx - 1";
							$str = $str . " AND NOT label = ANY ($names_array)";
							break;
						}
					}
				break;
				
			case 'lca':
				$str = $str . " SELECT biosql.pdb_node_id_to_label(biosql.pdb_lca($tree_id, $names_array)) AS bioname";
				break;
				
			case "selected":
				if (!$not) {
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
					switch ($treenodes) {
						case 'all':
							$str = $str . " SELECT label AS bioname FROM biosql.node";
							$str = $str . " WHERE tree_id = $tree_id";
							$str = $str . " EXCEPT SELECT label AS bioname FROM biosql.node";
							$str = $str . " WHERE tree_id = $tree_id AND label = ANY ($names_array)";	
							break;
						case 'tip':
							$str = $str . " SELECT label AS bioname FROM biosql.node";
							$str = $str . " WHERE tree_id = $tree_id";
							$str = $str . " AND left_idx = right_idx - 1";
							$str = $str . " EXCEPT SELECT label AS bioname FROM biosql.node";
							$str = $str . " WHERE tree_id = $tree_id AND label = ANY ($names_array)";
							break;
						case 'internal':
							$str = $str . " SELECT label AS bioname FROM biosql.node";
							$str = $str . " WHERE tree_id = $tree_id";
							$str = $str . " AND left_idx <> right_idx - 1";
							$str = $str . " EXCEPT SELECT label AS bioname FROM biosql.node";
							$str = $str . " WHERE tree_id = $tree_id AND label = ANY ($names_array)";
							break;
						}								
					}
				break;
			}
						
	return ($str);
	}
# ====================================================================================================
	
	function query_add_names_sql($qobject, $qobjects, $qsql){
		
		//ADD SQL TO QUERY
		//echo "$qsql<br>";
		$qobject['sql_names_query'] = $qsql;
		
		//ADD FULL SQL
		if ($qobjects && count($qobjects) > 1) {
			$sql = $qobjects[count($qobjects) - 2]['sql_names'];
			$op = $qobject['queryoperator'];
			$sql = "$sql $op $qsql"; 
			$sql = "SELECT bioname FROM ( \n$sql) AS foo";
			$qobject['sql_names'] = $sql;
			//$qobject = add_key_val($qobject, 'sql_names', $sql);
		} else {
			//$qobject = add_key_val($qobject, 'sql_names', $qsql);
			$qobject['sql_names'] = $qsql;
		}
		//print_r ($qobject);
		return $qobject;
	}
	# ====================================================================================================
	
function query_add_series_sql($qobject, $qobjects, $sources) {
	
		
	if ($qobjects) {
		$qobject = $qobjects[count($qobjects) - 1];
		if ($qobject['status'] == 'new') $qobject = $qobjects[count($qobjects) - 2];
		//NAMES
		##$sql = "SELECT mid FROM (";
		$sql = $sql . "SELECT m.\"MainID\" AS mid \nFROM gpdd.main m, gpdd.taxon t \nWHERE";
		$sql = $sql . " m.\"TaxonID\" = t.\"TaxonID\" \nAND t.binomial IN ( \n";
		$sql = $sql . $qobject['sql_names'] . ")";
		# MAIN IDs
		# Is the GPDD in any queries, if not pass
		$gpdd = false;
		foreach ($qobjects as $q) 
			if (in_array(23, $q['sources']) || in_array(26, $q['sources']) || in_array(27, $q['sources'])) $gpdd = true;

		$first = true;
		if ($gpdd == true) {
			$sql = $sql . " AND m.\"MainID\" IN (";
			foreach ($qobjects as $q) {
				$term = $q['term'];
				//echo "adding " . $q['name'] . ", $term to sql<br>";
				switch ($term) {
					case 'biotable':
						if (in_array(23,$q['sources'])) {
							if ($first == false) {
								$sql = "$sql " . $q['queryoperator'] . " ";
							} else {
								$first = false;
							}
							$sql = query_biotable_series($q, $sources, $sql);
						}

						break;
					case 'biogeographic':
						if (in_array(26,$q['sources']) || in_array(27,$q['sources'])) {
							if ($first == false) {
								$sql = "$sql " . $q['queryoperator'] . " ";
							} else {
								$first = false;
							}
							$sql =  query_biogeographic_series ($q, $sql);
						}

						break;
					case 'biotemporal':
						if ($first == false) {
							$sql = "$sql " . $q['queryoperator'] . " ";
						} else {
							$first = false;
						}
						$sql =  query_biotemporal_series ($q, $sql);
						break;
				}
			}
			$sql = $sql . ")";
		}
		

		$qobject = add_key_val($qobject, 'sql_series', $sql);
	}

return $qobject;
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
					$str = $str . " FROM gpdd.taxon t, gpdd.main m,	$dbloc l,";
					$str = $str . " (SELECT (ST_Dump(ST_GeomFromEWKT('SRID=4326; $q_geometry'))).geom) AS foo";
					$str = $str . " WHERE l.$s_col::geometry $s_op geom::geometry";
					$str = $str . " AND t.\"TaxonID\" = m.\"TaxonID\"";
					$str = $str . " AND m.\"LocationID\" = l.locationid";
					$str = $str . " AND t.binomial IS NOT NULL";					
					break;
					
				case 'overlap':
				case 'within':
					$str = $str . " SELECT DISTINCT t.binomial AS bioname";
					$str = $str . " FROM gpdd.taxon t, gpdd.main m,	$dbloc l ";
					$str = $str . " INNER JOIN (";
					$str = $str . " SELECT (ST_Dump(ST_GeomFromEWKT('SRID=4326; $q_geometry'))).geom v) AS foo";
					$str = $str . " ON $s_op(v::geometry, l.$s_col::geometry)";
					$str = $str . " WHERE t.\"TaxonID\" = m.\"TaxonID\"";
					$str = $str . " AND m.\"LocationID\" = l.locationid";
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
					// !!!!!!!!!!!CHECK RESULTS WITH GEOMETRY COLLECTION!!!!!!!!!!!
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
			$str = $str . "	FROM gpdd.main m, gpdd.location_pt l, gpdd.taxon t";
			$str = $str . " SELECT (ST_Dump(ST_GeomFromEWKT('SRID=4326; $q_geometry'))).geom v) AS foo";
			$str = $str . " ON $s_op(v::geometry, l.$s_col::geometry)";
			$str = $str . "	WHERE m.\"LocationID\" = l.locationid";
			$str = $str . "	AND m.\"TaxonID\" = t.\"TaxonID\"";
			$str = $str . "	AND t.binomial IS NOT NULL";
		}
			
		if ($both == true) $sql = $sql . " UNION ALL";
			
		if (in_array(27, $qsources)) {
			$sql = $sql . " SELECT m.\"MainID\" AS mid";
			$str = $str . "	FROM gpdd.main m, gpdd.location_bbox l, gpdd.taxon t";
			$str = $str . " SELECT (ST_Dump(ST_GeomFromEWKT('SRID=4326; $q_geometry'))).geom v) AS foo";
			$str = $str . " ON $s_op(v::geometry, l.$s_col::geometry)";
			$str = $str . "	WHERE m.\"LocationID\" = l.locationid";
			$str = $str . "	AND m.\"TaxonID\" = t.\"TaxonID\"";
			$str = $str . "	AND t.binomial IS NOT NULL";
		}
		
		if ($both == true) $sql = "$sql GROUP BY mid HAVING COUNT(*) = 2) AS mid ";
		
		return $sql;
		
	}
	
	# ====================================================================================================
	
	function query_biotemporal ($qobject,$qobjects, $str){
		
		#echo "query_biotemporal: $str<br>";
		$t_from_overlay = $qobject['t_from_overlay'];
		$t_to_overlay = $qobject['t_from_overlay'];
		$from_dtime = $qobject['from_dtime'];
		$to_dtime = $qobject['to_dtime'];
		
		$mids = query_get_mids($qobjects);
		if ($mids) $arr = array_to_postgresql($mids, 'numeric');
		
		$str = $str . "SELECT bioname 
			FROM ( 
				SELECT t.binomial AS bioname, 
				MIN(d.\"DecimalYearBegin\") AS dstart, 
				MAX(d.\"DecimalYearEnd\") AS dfinish
				FROM gpdd.taxon t,
				gpdd.main m,
				gpdd.data d
				WHERE m.\"MainID\" = d.\"MainID\"
				AND m.\"TaxonID\" = t.\"TaxonID\"
				AND t.binomial IS NOT NULL";
			if ($arr) $str = $str .  " AND m.\"MainID\" = ANY($arr)";
			$str = $str . " GROUP BY t.binomial";
		
		
		switch ($t_from_overlay) {
			case 'BEFORE':
					$str = $str . " HAVING MAX(d.\"DecimalYearBegin\") >= 1500 AND MIN(d.\"DecimalYearEnd\") <= $from_dtime";
					if ($qobject['t_2'] == 'on') {
						if ($t_to_overlay == 'DURING') {
						 	$str = $str . " AND MIN(d.\"DecimalYearEnd\") <= $to_dtime AND MAX(d.\"DecimalYearEnd\") >= $to_dtime";
						} else {
							$str = $str . " AND MAX(d.\"DecimalYearEnd\") <= $to_dtime";
						}
					}
				break;
			case 'DURING':
					$str = $str . " HAVING MAX(d.\"DecimalYearBegin\") >= 1500
						AND (MIN(d.\"DecimalYearBegin\") <= $from_dtime AND MAX(d.\"DecimalYearEnd\") >= $from_dtime)";
					if ($qobject['t_2'] == 'on') {
						if ($t_to_overlay == 'DURING') {
						 	$str = $str . " AND MIN(d.\"DecimalYearEnd\") <= $to_dtime AND MAX(d.\"DecimalYearEnd\") >= $to_dtime";
						} else {
							$str = $str . " AND MAX(d.\"DecimalYearEnd\") <= $to_dtime";
						}
					}
				break;
			case 'AFTER':		
					$str = $str . " HAVING MAX(d.\"DecimalYearBegin\") >= 1500
						AND MIN(d.\"DecimalYearBegin\") >= $from_dtime";
					if ($qobject['t_2'] == 'on') {
						if ($t_to_overlay == 'DURING') {
						 	$str = $str . " AND MIN(d.\"DecimalYearEnd\") <= $to_dtime AND MAX(d.\"DecimalYearEnd\") >= $to_dtime";
						} else {
							$str = $str . " AND MAX(d.\"DecimalYearEnd\") <= $to_dtime";
						}
					}
				break;
		}
		$str = $str . " ) AS foo";
		#echo "$str<br>";
		return ($str);
	}
	
		# ====================================================================================================
	
	function query_biotemporal_series ($qobject,$str) {
		
		$t_overlay = $qobject['t_overlay'];
		$from_dtime = $qobject['from_dtime'];
		$to_dtime = $qobject['to_dtime'];
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
					gpdd.data d
					WHERE m.\"MainID\" = d.\"MainID\"
					GROUP BY m.\"MainID\"
					HAVING MAX(d.\"DecimalYearBegin\") >= 1500
					AND (MIN(d.\"DecimalYearEnd\") >= $from_dtime AND MAX(d.\"DecimalYearBegin\") <= $to_dtime)
					) AS foo";	
				break;
			case 'WITHIN':
				$str = $str . "SELECT mid 
				FROM ( 
					SELECT m.\"MainID\" AS mid, 
					MIN(d.\"DecimalYearBegin\") AS dstart, 
					MAX(d.\"DecimalYearEnd\") AS dfinish
					FROM gpdd.main m,
					gpdd.data d
					WHERE m.\"MainID\" = d.\"MainID\"
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
		
		$str = $str . "SELECT DISTINCT binomial AS bioname FROM gpdd.taxon t ";
		
		return ($str);
	}
	
	# ====================================================================================================
	
	function query_bionames_tree($qobject, $source, $str) {
		
		$tree_id = $source['tree_id'];
		
		$str = $str . "SELECT label AS bioname 
			  FROM biosql.node WHERE node.tree_id = $tree_id";
		
		return ($str);
	}
	
	# ====================================================================================================
	
	function query_series ($db_handle, $qobject, $qobjects, $names, $sources){
	
		#echo "begin query series<br>";
		
		$run = false;
		$out = array();
		
		if ($sources) {
			foreach ($sources as $source) {
				if ($source['id'] == 23) {
					$run = true;
				}
			}
		}
		if($run == false) return $qobject;
		
		$mids = query_get_mids($qobjects);
		if ($mids && ($_SESSION['token'] == $_POST['token'])) {
			if (count($qobjects) == 1) {
				unset ($mids);
			} else {
				$mids = $qobjects[count($qobjects) - 2]['series'];
			}

		}
		
		if ($mids) $midsarr = array_to_postgresql($mids, 'numeric');
		if ($names) $arr = array_to_postgresql($names, 'text');		
		
		if (!$mids) {
			# SERIES
			$str = "SELECT m.\"MainID\"
				FROM gpdd.main m, gpdd.taxon t
				WHERE m.\"TaxonID\" = t.\"TaxonID\"";
			if ($arr) $str = $str . " AND t.binomial = ANY($arr)";
		} else {
			$term = $qobject['term'];
			#echo $qobject['term'] . "<br>";
			
			switch ($term){
				case 'biotree':
				case 'biotable':
				case 'bionames':
					# SERIES
					$str = "SELECT m.\"MainID\"
					FROM gpdd.main m, gpdd.taxon t
					WHERE m.\"TaxonID\" = t.\"TaxonID\"";
					if ($arr) $str = $str . " AND t.binomial = ANY($arr)";
					# MainIDs
					#if ($midsarr) $str = $str . " AND m.\"MainID\" = ANY ($midsarr)";
					break;
					
				case 'biogeographic':
					$qsources = $qobject['sources'];
					$s_operator = $qobject['s_operator'];
					$s_op = get_s_operator($s_operator);
					$q_geometry = $qobject['q_geometry'];


					# SELECT
					$str = "SELECT m.\"MainID\"
						FROM gpdd.main m,";
					if (in_array(26, $qsources)) $str = $str . " gpdd.location_pt p,";		
					if (in_array(27, $qsources)) $str = $str . " gpdd.location_bbox b,";
					$str = $str . " gpdd.taxon t";
					$str = $str . ", (SELECT (ST_Dump(ST_GeomFromEWKT('SRID=4326; $q_geometry'))).geom) AS foo";
					
					$str = $str . " WHERE m.\"TaxonID\" = t.\"TaxonID\"";
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
					
					//$str = $str . " AND t.\"TaxonID\" = m.\"TaxonID\"";
					$//str = $str . " AND m.\"LocationID\" = l.\"LocationID\"";
					$str = $str . " AND t.binomial IS NOT NULL";	
	
					# MainIDs
					#if ($midsarr) $str = $str . " AND m.\"MainID\" = ANY ($midsarr)";
					if ($arr) $str = $str . " AND t.binomial = ANY($arr)";
					break;
					
				case 'biotemporal':
					$t_overlay = $qobject['t_overlay'];
					$from_dtime = $qobject['from_dtime'];
					$to_dtime = $qobject['to_dtime'];
					# echo "$from_dtime - $to_dtime : $t_overlay<br>";
		
					switch ($t_overlay) {
						case 'OVERLAP':
							$str = $str . "SELECT mid
							FROM ( 
								SELECT m.\"MainID\" AS mid,
								MIN(d.\"DecimalYearBegin\") AS dstart, 
								MAX(d.\"DecimalYearEnd\") AS dfinish
								FROM gpdd.taxon t,
								gpdd.main m,
								gpdd.data d
								WHERE m.\"MainID\" = d.\"MainID\"
								AND m.\"TaxonID\" = t.\"TaxonID\"
								AND t.binomial IS NOT NULL ";
							
							#if ($midsarr) $str = $str . " AND m.\"MainID\" = ANY ($midsarr)";
							if ($arr) $str = $str . " AND t.binomial = ANY($arr)";
							
							$str = $str . " GROUP BY m.\"MainID\"
								HAVING MAX(d.\"DecimalYearBegin\") >= 1500
								AND (MIN(d.\"DecimalYearEnd\") >= $from_dtime AND MAX(d.\"DecimalYearBegin\") <= $to_dtime)
								) AS foo";
							break;
						case 'WITHIN':
							$str = $str . "SELECT mid
								FROM ( 
								SELECT m.\"MainID\" AS mid,
								MIN(d.\"DecimalYearBegin\") AS dstart, 
								MAX(d.\"DecimalYearEnd\") AS dfinish
								FROM gpdd.taxon t,
								gpdd.main m,
								gpdd.data d
								WHERE m.\"MainID\" = d.\"MainID\"
								AND m.\"TaxonID\" = t.\"TaxonID\"";
							
							#if ($midsarr) $str = $str . " AND m.\"MainID\" = ANY ($midsarr)";
							if ($arr) $str = $str . " AND t.binomial = ANY($arr)";
							
							$str = $str . " GROUP m.\"MainID\"
								HAVING MAX(d.\"DecimalYearBegin\") >= 1500
								AND (MIN(d.\"DecimalYearEnd\") <= $to_dtime AND MAX(d.\"DecimalYearBegin\") >= $from_dtime)
								) AS foo";			
							break;
					}
				default:
				break;
			}   #term
		}
		//echo "series query: $str<br>";
		$res = pg_query($str);
		$ids = pg_fetch_all_columns($res, 0);


		# INTERQUERY OPERATOR
		
		if (!$mids) {
			$mids = $ids;                          #first mids query
		} else {
			$op = $qobject['queryoperator'];
			switch ($op) {
				case 'UNION':
					 if ($ids) $mids = array_values(array_unique(array_merge($mids, $ids)));
					break;
				case 'MINUS':
					if ($ids) $mids = array_values(array_diff($mids, $ids));
					break;
				case 'INTERSECT';
					if ($ids) $mids = array_values(array_intersect($mids, $ids));
					break;
			}
		}		
		
	$sql = "$sql $op $str";

	$qobject = query_add_series_sql($qobject,$qobjects, $sources);
	$qobject['series'] = $mids;
	return $qobject;
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

function query_get_mids($qobjects) {
	
	$n = count($qobjects);
	
	switch ($n) {
		case 0:
			return null;
			break;
		case 1:
			if ($qobjects[0]['series']) {
				return $qobjects[0]['series'];
				 null;
			} else {
				return null;
			}
			break;
		default:
			if ($qobjects[$n - 1]['status'] == 'new') {
				return $qobjects[$n - 2]['series'];
			} else {
				return $qobjects[$n - 1]['series'];
			}
			break;
	}
	
}

# ====================================================================================================

function query_name_search($db_handle, $sources) {
	
	# returns information on which sources names are in
	$input = $_SESSION['name_search'];
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
				//$scode = $source['code'];
				
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
			array_push($out, array($taxon, null));	
		} else {
			array_push($out, array($taxon,implode(", ",$sin)));	
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
