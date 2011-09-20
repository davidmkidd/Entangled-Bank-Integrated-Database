<?php

#Filename: entangled_bank_html_utils.php
#
# Contains html programs for the Entangled Bank:
#

	
#=======================================================================================================================

/*function html_all_tree_names ($form_objname, $form_treenodes, $form_not, $form_qoperator, $form_cancel,
	$qobjects, $qobjid) {
	
	$qobj = get_obj($qobjects, $qobjid);
	$qname = $qobj['name'];
	
	if ($qname) {
		echo "<h3>Query: $qname</h3>";
		} else {
		echo "<h3>New tree query</h3>";
		}	
	if (!$qname) $qname = get_next_name($qobjects, 'biotree');	
	
	html_select_tree_nodes($qobj['treenodes']);

	#html_query_not($form_not, $qobj);
	#echo "<br>";
	
	if (obj_idx($qobjects, $qobjid) != 0 or $qobj['queryoperator']) {
		html_query_operator($qobj);
		echo "<br>";
		// html_query_join($form_qjoin, $qobj);
		// echo "<br>";
		}
	html_obj_name($form_objname, $qname);
	echo "<hr>";
	html_cancel_select();
	}*/
	
#=================================================================================================================	

function html_arr_to_table($arr) {
	# Prints array of arrays with equal number of keys to html table
	
	$keys = array_keys($arr);

	# Check same number of keys in each subarray
	$first = true;
	foreach ($keys as $key) {
		if ($first) {
			$c = count($arr["$key"]);
			$first = false;
			} else {
			if (count($arr["$key"]) != $c) {
				echo "html_arr_to_table: different sized subarray $key";
				}
			}
		}
		
	#write table
	echo '<TABLE CELLPADDING="2" CELLSPACING="0" BORDER =1>';
	echo "\n";
	echo "<tr>";
	echo "<th>#</th>";
	foreach ($keys as $key) echo "<th>$key</th>";
	echo "</tr>";
	for ($i = 1; $i <= $c; $i++) {
		echo "<tr>";
		echo "<td ALIGN = 'center'>" . $i . "</td>";
		$first = true;
		foreach ($keys as $key) {
			if ($first) {
				echo "<td>" . $arr[$key][$i - 1] . "</td>";
				$first = false;
				} else {
				echo "<td ALIGN = 'center'>" . $arr[$key][$i - 1] . "</td>";
				}
			}
			
		echo "</tr>";
		}
	echo "</TABLE>";
	}
	
#=================================================================================================================

/*function html_cancel_select() {
	echo "<input type='button' name='cancel' value='Cancel'></input>";
	//echo "<input type='radio' CHECKED id='cancel_no' name='cancel' value='no'> Continue";
	//echo "<input type='radio' id='cancel_yes' name='cancel' value='yes'> Cancel ";
	}*/
	
#=======================================================================================================================

function html_entangled_bank_header($eb_path, $html_path, $share_path, $restart) {

	if($restart) $restart = true;

	echo "<div id='ebheader'>";
	echo "<img id='ebimage' src='" , $share_path , "Entangled-Bank_small.gif' alt='Banner'>";

	echo "<a href='" , $html_path , "index.php' target='_blank'>Home</a>";
	echo " | ";
	echo "<a href='" , $html_path , "help.php' target='_blank'>Help</a>";
	echo " | ";
	echo "<a href='" , $html_path , "examples.php' target='_blank'>Examples</a>";
	if ($restart == true) { 
		echo " | ";
		echo "<a href='" , $eb_path , "restart.php'> New Session</a>";
	}
	echo ' | v0.5 (Sept 2011)';

	echo "</div>";
	//echo '<hr>';
}

#=======================================================================================================================

function html_entangled_bank_footer() {

	echo "<div id='ebfooter'>";
	echo '<i>Open source powered: PostrgreSQL, PostGIS, BioSQL/PhyloDB, PHP/Javascript, BioPerl/Bio::Phylo, GDAL/OGR2 and Apache.</a></i><br>';
	echo '&copy NERC Center for Population Biology & Division of Biology, Imperial College London, 2011.';
	echo " <i><a href='mailto:d.kidd@imperial.ac.uk'>Contact: David Kidd</a></i>";
	echo "</div>";
	
}
	
#=================================================================================================================

function html_input_tree_names ($db_handle, $form_subtree, $form_inames_taxa, $form_inames_valid,
	$form_nsources, $form_noperator, $form_nnmaes, $form_objname, $form_not, $form_qoperator, $form_qjoin, $form_cancel, 
	$qobjects, $qobjid, $sources) {

	$qobj = get_obj($qobjects, $qobjid);
	$qname = $qobj['name'];
	
	if (!$qname) {
		echo "<h3>New tree query</h3>";
		} else {
		echo "<h3>$qname tree query</h3>";
		}
		
	echo "<b>Subtree:</b><br>";
	html_subtree_select_method($form_subtree, 'subtree');
	html_input_names($db_handle, $form_inames_taxa, $form_inames_valid, 
		$form_nsources, $form_noperator, $form_nnames, $form_objname, $form_not, $form_qoperator, $form_qjoin, $form_cancel,
		$qobjects, $qobjid, $sources, 'none');
	echo "<br>";
	
	}

	
//#=======================================================================================================================

function html_manage($qobjects, $manage_err) {
	
	#Radio buttons to select which query to manage
	$f = 'CHECKED';
	foreach ($qobjects as $qobject) {
		$id = $qobject['id'];
		$str = $qobject['name'];
		echo "<input type='radio' name='qobjid' $f value=$id> $str<br>";
		if ($f == 'CHECKED') $f = "";
		}
		
	if ($qmange_err == true) echo "<FONT color=red>Select query to edit</FONT><br>";
	echo "<hr>";
	echo "<input type='radio' name='maction' value='delete'> delete<br>";
	echo "<input type='radio' name='maction' value='edit'> edit<br>";
	echo "<input type='radio' CHECKED name='maction' value='return'> return<br>";
	}
	
#=======================================================================================================================
	
function html_obj_name($obj) {
	# Set Obj name
	if ($obj['name']) {
		$name = $obj['name'];
	} else {
		$name = "";
	}
	echo "<INPUT type='text' id='objname' name='objname' class='namewidth' value=$name onChange='checkObjName()'>";
	}
	
#=================================================================================================================
	
	function html_output_biorelational($db_handle, $output, $outputs, $sources) {
		
		# GPDD HARD CODE
		
		# OUTPUT NAME
		$outname = $output['name'];
		//echo $output['term'] . "<br>";
		if (!$outname) {
			$outname = get_next_name($outputs, $output['term']);
			//echo "$outname<BR>";
			$output['name'] = $outname;
		}
		
		echo "Name ";
		html_obj_name('objname', $output);
		echo "<BR>";
		
		# OUTPUT TABLES
		html_output_dbformat($output);
		echo "<BR>";
		
		# OUTPUT GEOGRAPHY
		echo "Spatial format ";
		echo "<SELECT name='sp_format'>";
		echo "<OPTION SELECTED value='shapefile'> ESRI Shapefile</OPTION>";
		echo "<OPTION value='mapinfo'> MapInfo</OPTION>";
		echo "<OPTION value='dgn'> DGN</OPTION>";
		echo "<OPTION value='dxf'> DXF</OPTION>";
		echo "<OPTION value='gml'> Geographic Markup Language (GML)</OPTION>";
		echo "<OPTION value='kml'> Keyhole Markup Language (KML)</OPTION>";
		echo "</SELECT><br>";		
		
		
	}
	
#=================================================================================================================

function html_output_biogeographic($output, $outputs, $sources) {

	//$output = get_obj($outputs, $outputid);
	//$source = get_obj($sources, $output['sourceid']);
	//print_r($output);
	$outname = $output['name'];
	//echo $output['term'] . "<br>";
	if (!$outname) {
		$outname = get_next_name($outputs, $output['term']);
		//echo "$outname<BR>";
		$output['name'] = $outname;
	}
	
	echo "Name ";
	html_obj_name('objname', $output);
	echo "<BR>";

	echo "Spatial format ";
	echo "<SELECT name='sp_format'>";
	echo "<OPTION SELECTED value='shapefile'> ESRI Shapefile</OPTION>";
	echo "<OPTION value='mapinfo'> MapInfo</OPTION>";
	echo "<OPTION value='dgn'> DGN</OPTION>";
	echo "<OPTION value='dxf'> DXF</OPTION>";
	echo "<OPTION value='gml'> Geographic Markup Language (GML)</OPTION>";
	echo "<OPTION value='kml'> Keyhole Markup Language (KML)</OPTION>";
	echo "</SELECT><br>";
	
	
	}
	
	
#=================================================================================================================

function html_output_biotree($db_handle, $output, $outputs, $sources) {

	$subtree_formname = 'outsubtree';
	$format_formname = 'format';
	$branch_formname = 'brqual';
	 	
	//$output = get_obj($outputs, $outputid);
	$source = get_obj($sources, $output['sourceid']);
	# print_r($source);
	 
	$subtree = $output['subtree'];
	$format = $output['format'];
	$brqual = $output['brqual'];
	$outname = $output['name'];
	
	if (!$outname) {
		$outname = get_next_name($outputs, $source['term']);
		//echo "outname: $outname";
		$output['name'] = $outname;
	}
	echo "Name ";
	html_obj_name($output);
	echo "<BR>";
	
	#Select subtree type
	echo "Tree type ";
	if (!$subtree or $subtree == 'subtree') {
		echo "<INPUT type='radio' CHECKED name=$subtree_formname value='subtree'> LCA subtree";
		echo "<INPUT type='radio' name=$subtree_formname value='pruned'> Pruned LCA subtree";
		} else {
		echo "<INPUT type='radio' name=$subtree_formname value='subtree'> LCA subtree";
		echo "<INPUT type='radio' CHECKED name=$subtree_formname value='pruned'> Pruned LCA subtree";
		}

	echo "<br>";
	#Select tree format to output
	echo "Tree file format ";
	echo "<SELECT name=$format_formname>";
	if (!$format || $format == 'newick') {
		echo "<OPTION SELECTED value='newick'> NEWICK</OPTION>";
		} else {
		echo "<OPTION value='newick'> NEWICK</OPTION>";
		}
	if ($format == 'nhx') {
		echo "<OPTION SELECTED value='nhx'> NHX</OPTION>";
		} else {
		echo "<OPTION value='nhx'> NHX</OPTION>";
		}
	if ($format == 'tabtree') {
		echo "<OPTION SELECTED value='tabtree'> ASCII (tab indented)</OPTION>";
		} else {
		echo "<OPTION value='tabtree'> ASCII (tab indented)</OPTION>";
		}
	if ($format == 'lintree') {
		echo "<OPTION SELECTED value='lintree'> LINTREE</OPTION>";
		} else {
		echo "<OPTION value='lintree'> LINTREE</OPTION>";
		}
	echo "</SELECT><br>";
	
	#  If new query then is it a phylogeny with distances? If so, then select edge qualifiers
	$brlen = false;
	if (!$brqual) {
		$str = "SELECT tm.name
			FROM biosql.term tm, biosql.tree tr, biosql.ontology ont, biosql.tree_qualifier_value tqv
			WHERE tm.term_id = tqv.term_id
			AND tm.ontology_id = ont.ontology_id
			AND tr.tree_id = tqv.tree_id
			AND tr.tree_id = " . $source['tree_id'] .
			 " AND ont.name = 'tree type'";
		
		#echo "$str ";
		$res = pg_query($db_handle, $str);
		$row = pg_fetch_row($res);
		if ($row[0] == "phylogeny") $brlen = true;
		} else {
		$brlen = false;
		}
	
		if ($brlen) {
			
			# Get Edge Qualifiers
			$str = "SELECT DISTINCT t.term_id, t.name
			FROM biosql.term t, biosql.node n, biosql.edge e, biosql.edge_qualifier_value eq
			WHERE eq.term_id = t.term_id
			AND e.edge_id = eq.edge_id
			AND (e.parent_node_id = n.node_id
			OR e.child_node_id = n.node_id)
			AND n.tree_id = " . $source['tree_id'];
			$res = pg_query($db_handle, $str);

			echo "Tree length ";
			echo "<SELECT name=$branch_formname>";
			# Reload of exiting query
			if (!$brqual) {
				# New output
				$first = true;
				while ($row = pg_fetch_row($res)) {
					if ($first) {
						echo "<OPTION SELECTED value=$row[0]> $row[1]</OPTION>";
						$first = false;
						} else {
						echo "<OPTION value=$row[0]> $row[1]</OPTION>";
						}
					}
				echo "<OPTION value='none'> None</OPTION>";	
				} else {
				# Reload of exiting output
				while ($row = pg_fetch_row($res)) {
					if ($row[0] == $brqual) {
						echo "<OPTION SELECTED value=$row[0]> $row[1]</OPTION>";
						$first = false;
						} else {
						echo "<OPTION value=$row[0]> $row[1]</OPTION>";
						}
					}
				if ($brqual == 'none') {
					echo "<OPTION SELECTED value='none'> None</OPTION>";
					} else {
					echo "<OPTION value='none'> None</OPTION>";
					}
				}
			echo "</SELECT>";
			}
	
	//$outputs = save_obj($outputs,$output);
	//$_SESSION['outputs'] = $outputs;
	#echo "<br>";
	//html_obj_name($form_objname, $outname);
	}
	
	#=======================================================================================================================	
	
	function html_output_dbformat($output) {
	
		if ($output['format']) {
			$f = $output['format'];
		} else {
			$f = 'csv';
		}
		echo "Tabular format ";
		$formats = array('csv','tab-delineated','dbf');
		#print_r($formats);
		echo "<SELECT id='format' name='db_format'>";
			foreach ($formats as $format) {
				if ($format == $f) {
					$selected = 'SELECTED';
				} else {
					$selected = '';
				}
			echo "<OPTION $selected value='$format'>$format</OPTION>";
			}
		echo "</SELECT>";
	
	}
	
#=======================================================================================================================	
	
	function html_qsources_print($arr) {
		// echos array as text list
		if (!empty($arr)) {
			$n = count($arr);
			$i = 0;
			echo "[";
			foreach($arr as $val) {
				$i++;
				echo $val;
				if ($i != $n) {
					echo ", ";
				} else {
					echo "]<br><br>";
				}
			}
		}
	}

#=======================================================================================================================	

function html_query_set($db_handle, $qobjid, $qobjects, $sources, $names){
	
	if ($qobjid) {
		$qobject = get_obj($qobjects, $qobjid);
	} else {
		echo "No qobjid!!";
	}
	//echo "html_query_set: ";
	//print_r($qobjects);
	//echo "<br/>";
	
	$term = $qobject['term'];

	echo '<script src="./scripts/query_utils.js" type="text/javascript"></script>';

	html_query_header($qobject, $qobjects, $sources);
	
	# Tool
	switch ($term) {
		case 'bionames' :
			html_query_bionames($db_handle, $qobject, $qobjects, $sources);
			break;			
		case 'biogeographic':			
			html_query_biogeographic($db_handle, $qobject, $qobjects, $sources);
			break;
		case 'biotree':
			html_query_biotree($db_handle, $qobject, $qobjects, $sources);
			break;
		case 'biotable':
			html_query_biotable($db_handle, $qobject, $qobjects, $sources, $names);
			break;	
		case 'biotemporal':
			html_query_biotemporal($db_handle, $qobject, $qobjects, $sources, $names);
			break;
		default:
			echo "Invalid selectobj: term.<br>";
			break;
	}
		
	echo "<input type='hidden' id='stage' name='stage' value='qverify'>";
	echo "<input type='hidden' id='qobjid' name ='qobjid' value=$qobjid>";
}
	
#================================================================================================================

	
	function html_query_buttons($qobject) {
		
/*		echo "<td class='query_title'>";
		if (count($qobjects) > 1) echo "Interquery";
		echo "</td>";*/
		
		//$op = $qobject['queryoperator'];
		$term = $qobject['term'];
		$id = $qobject['id'];
		
//		echo "<td class='qop' title='$title'>";
//		echo "</td>";
		
		echo "<td id='query_buttons' class='query_buttons' align='right'>";
		echo "<input type='button' name='cancel' class='cancel' value='Cancel' onClick='cancelQuery(\"$id\")'/>";
		if ($qobject['status'] != 'new') 
			echo "<input type='button' name='delete' class='delete' value='Delete' onClick='deleteQuery(\"$id\")'/>";
			
		switch ($term) {
			case 'biotree':
				echo "<input id='submit-button' type='submit' class='button-standard' onClick='selAll(); return false;' value='Run >' />";
				break;
			case 'biotable':
				echo "<input id='submit-button' type='submit' class='button-standard' onClick='validateBiotable(); return false;' value='Run >' />";
				break;
			case 'biogeographic':
				echo "<input id='submit-button' type='submit' class='button-standard' onClick='serializeLayer();' value='Run >' />";
				break;
			default:
				echo "<input id='submit-button' type='submit' class='button-standard' value='Run > ' />";
				break;
		}
		echo "</td>";
		
	}
	
#================================================================================================================
	
	
function html_query_biogeographic ($db_handle, $qobject, $qobjects, $sources) {
	
	//echo '<script src="http://openlayers.org/api/OpenLayers.js" type="text/javascript"></script>';
	echo '<script src="./OpenLayers-2.11/OpenLayers.js" type="text/javascript"></script>';
	echo '<script src="http://maps.google.com/maps/api/js?v=3.2&sensor=false"></script>';
	echo '<script src="./scripts/geographic_utils.js" type="text/javascript"></script>';
	
	if (!$qobject or !$sources) {
		echo "html_select_spatial: qobject and sources required";
		exit;
		}

	//html_query_header($qobject, $sources);
	//echo "<br>";

	$qname = $qobject['name'];
		
	$s_operator = $qobject['s_operator'];	
	
	# MAP
	$q_geometry = '';
	if ($qobject['q_geometry']) $q_geometry = $qobject['q_geometry'];
	//echo "q_geom: $q_geometry<br>";
	echo "<INPUT type='hidden' name='q_geometry' id='q_geometry' value='$q_geometry' />";
	
	html_query_spatial_operator ($s_operator);
	
	echo "<p align='right'><FONT color='red'>Bug: if map is not visible change layer with 
		<img src='./image/openlayers_layerswitcher.gif'> button.</FONT></p>";
	
	# div tags for OpenLayers
    echo "<div id='map' name='map' class='smallmap'></div>";
    echo '<script type="text/javascript" defer="true">
     	mapinit();
     	</script>';
	echo "<p>Google Map content &copy; Google, TeleAtlas and their suppliers<p>";
	
    # BOUNDING BOX
	 echo "<table border='0'>";
	 $title='Bounding box in decimal degrees';
	echo "<tr>";
	echo "<td class='query_title' title='title'>Bounding Box</td>";
	echo "<td class='query_spatial_c2'>";	
	echo "N&deg; <INPUT TYPE='text'id='bbnorth' NAME='bbnorth' VALUE='90.000000'  class='left_input' />&nbsp;";
	echo "E&deg; <INPUT TYPE='text'id='bbeast' NAME='bbeast' VALUE='180.000000' class='left_input'  /><br>";
	echo "S&deg; <INPUT TYPE='text' id='bbsouth' NAME='bbsouth' VALUE='-90.000000' class='left_input' />&nbsp;";
	echo "W&deg;<INPUT TYPE='text' id='bbwest' NAME='bbwest' VALUE='-180.000000' class='left_input' />";
	echo "</td>";
	echo "<td style='valign: middle;'>";
	echo "<BUTTON type='button' class='button-standard' onclick='addBoundingBox()'>Add</BUTTON>&nbsp;";
	echo "<BUTTON type='button' id='delete_features' class='button-standard' onClick='clearMap()'>Clear</BUTTON>";
	echo "</td>";
	echo "</tr>";
	

	echo "</table>";

}

#=======================================================================================================================	

function html_query_spatial_operator ($s_operator) {
		
	# SPATIAL OPERATOR
	echo "<table>";
	echo "<tr>";
	$title='Point and line queries are ignored by \'Within\'';
	echo "<td class='query_title' title='$title'>Spatial operator</td>";
	
	echo "<td>";
	echo "<select name='s_operator' class='eb'>";
	if (!$s_operator || $s_operator == 'quickoverlap') {
		echo "<option value='quickoverlap' SELECTED>Quick Overlap (by bounding box)</option>";
	} else {
		echo "<option value='quickoverlap'>Quick Overlap (by bounding box)</option>";
	}
	if ($s_operator == 'quickwithin') {
		echo "<option value='quickoverlap'>Quick Within (by bounding box)</option>";
	} else {
		echo "<option value='quickoverlap'>Quick Within (by bounding box)</option>";
	}
	if ($s_operator == 'overlap') {
		echo "<option value='overlap' SELECTED>Accurate Overlap (of query features)</option>";
	} else {
		echo "<option value='overlap'>Accurate Overlap (of query features)</option>";
	}
	if ($s_operator == 'within') {
		echo "<option value='within' SELECTED>Accurate Within (of query polygons)</option>";
	} else {
		echo "<option value='within'>Accurate Within (of query polygons)</option>";
	}
	echo "</select>";
	echo "</td>";
	echo "</tr>";
	echo "</table>";
}

	

#=======================================================================================================================	

	function html_query_image($object, $class, $title = null, $type = 'query', $ret = false) {
		
		//$size = $size . 'px';
		if ($class == 'non-active') {
			$class = 'query_type_button_non_active';
		} else {
			$class = 'query_type_button_active';
		}
		
		switch ($object['term']) {
			case 'bionames' : 
				if (!$title) $title = "Names $type";
				$img = 'systema.gif';
				break;
			case 'biotree' : 
				if (!$title) $title = "Tree $type";
				$img = 'tree.gif';
				break;
			case 'biogeographic' : 
				if (!$title) $title = "Geographic $type";
				$img = 'blue-planet.gif';
				break;
			case 'biotable' : 
				if (!$title) $title = "Attributes $type";
				$img = 'haekel_bug.gif';
				break;
			case 'biotemporal' : 
				if (!$title) $title = "Temporal $type";
				$img = 'clock.gif';
				break;
			case 'biorelational':
				if (!$title) $title = "Time series $type";
				$img = 'ts.gif';
				break;
				
		}
		if ($ret == false) {
			echo "<img src='./image/$img' alt='queryimg' title='$title' class='$class'></img>";
		} else {
			return "<img src='./image/$img' alt='queryimg' title='$title' class='$class'></img>";	
		}

	}


#=======================================================================================================================	

	function html_query_name($qobject, $not = true) {
		
		$objname = $qobject['name'];
		$title = "Query name";
		//html_obj_name($qobject);
		echo "<table>";
		echo "<tr>";
		echo "<td class='query_title' title='$title' >Query Name</td>";
		echo "<td>";
		echo "<INPUT type='text' id='objname' name='objname' class='eb' value=$objname onChange='checkObjName()'>";
		if ($not !== false) {
			echo " ";
			html_query_not('querynot', $qobject);
		}
		echo "</td>";
		echo "</tr>";
		echo "</table>";
		
	}
	
	
#=======================================================================================================================

function html_query_join($formname, $qobj) {
	echo "<b>Between Query Join</b><br>";
	
	$val = $qobj['qjoin'];
	if (!$val or $val == 'INNER') {
		echo "<input type=radio CHECKED name=$formname value=INNER>
			INNER JOIN - Discard names not in both this and the previous query<br>";
		} else {
		echo "<input type=radio name=$formname value=INNER> 
			INNER JOIN - Discard names not in both this and the previous query<br>";
		}
	if ($val == 'LEFTOUTER') {
		echo "<input type=radio CHECKED name=$formname value=LEFTOUTER>
			LEFT OUTER JOIN - Keep names in the previous query that not in this source<br>";
		} else {
		echo "<input type=radio name=$formname value=LEFTOUTER> LEFT OUTER JOIN - Keep names in the previous query that not in this source<br>";
		}
	if ($val == 'RIGHTOUTER') {
		echo "<input type=radio CHECKED name=$formname value=RIGHTOUTER> RIGHT OUTER JOIN - Add names in this query that in the previous source<br>";
		} else {
		echo "<input type=radio name=$formname value=RIGHTOUTER> RIGHT OUTER JOIN - Add names in this query that in the previous source<br>";
		}
	if ($val == 'FULLOUTER') {
		echo "<input type=radio CHECKED name=$formname value=FULLOUTER> FULL OUTER JOIN - Keep names in the previous query that not in this source AND
			names in the previous query that not in this source<br>";
		} else {
		echo "<input type=radio name=$formname value=FULLOUTER> FULL OUTER JOIN - Keep names in the previous query that not in this source AND
			names in the previous query that not in this source<br>";
		}
	}

#=================================================================================================================

function html_query_bionames($db_handle, $qobject, $qobjects, $sources) {

	//print_r($qobjects[1]);
	
	echo '<script src="./scripts/names_utils.js" type="text/javascript"></script>';
	
	//html_query_header($qobject, $sources);
	//html_query_name($qobject);
	
	echo "<table border = '0'>";
	
	echo "<tr>";
	echo "<td class='query_title' title=>All Names</td>";
	echo "<td>";
	if ($qobject['allnames'] == 'on') {
		echo "<input type='checkbox' CHECKED id='allnames' name='allnames' onClick='checkAllNames()'>";
	} else {
		echo "<input type='checkbox' id='allnames' name='allnames' onClick='checkAllNames()'>";
	}
	echo "</td>";
	echo "</tr>";
	
	echo "<tr>";
	$title = "One name on each line or select all names.";
	echo "<td class='query_title' title='$title'>Names</td>";
	
	# Get valid names and errors
	if ($qobject['taxa']) $taxa = $qobject['taxa'];
	if ($qobject['invalid_taxa']) $invalid = $qobject['invalid_taxa'];
	
	# Empty text area
	
	if (empty($taxa) && empty($invalid)) {
		echo "<td>";
		echo "<textarea id='taxa' name='taxa' class='eb' rows='10' wrap='soft'></textarea>";
		echo "</td>";
	} else {
		echo "<td>";
/*		if ($taxa) echo "<label for='taxa'>valid taxa<label>";
		if ($invalid) echo "<label id='invalid_taxa_label' for='invalid_taxa'>unrecognised taxa<label>";
		if ($taxa || $invalid) echo "<br>";*/
		//echo "</td>";
		
		if (taxa) {
			$mystr = "";
			foreach ($taxa as $name) $mystr = $mystr . "$name\n";
			//echo "<td>";
			echo "<textarea id='taxa' name='taxa' class='taxa' rows='7' cols='35' wrap='soft'>" . chop($mystr, "\n") . "</textarea>";
		}
		
		if ($invalid) {
			#write list of invalidnames
			//echo "Invalid Names<br>";
			$mystr = "";
			foreach ($invalid as $name) {
				$mystr = $mystr . "$name\n";
				}
			echo "<textarea id='invalid_taxa' name='invalid_taxa' class='taxa' rows='7' cols='35' wrap='soft' style='color:#FF0000'>"
				. chop($mystr, "\n") . "</textarea>";
			}
		echo "</td>";

	}
	
	echo "</tr>";
	echo "<tr>";
	echo "<td class='query_title'></td>";
	echo "<td><p style='font-size: smaller;'>One name on each line. Case-sensitive.<br>Names in <font color='red'>red</font> are not recognised</p></td>";
	echo "</tr>";

	echo "<tr>";
	echo "<td class='query_title'></td>";
	echo "<td>";
	echo "</td>";
	echo "</tr>";
	echo "</table>";	
	
	//html_query_footer($qobject, $qobjects);
	
	unset($qobject['taxa']);
	unset($qobject['invalid_taxa']);
}
	


	#===========================================================================================================
	
function html_query_nsources ($qobject, $sources){

	# How many sources name required to be in required
	//print_r($sources);
	#echo "in ";
	
	$nop = $qobject['noperator'];
	if ($qobject['term'] == 'biotemporal') $disabled = "disabled='disabled'";
	
	echo "<SELECT name='noperator' $disabled>";
	if (!$nop || $nop == '>=') {
		echo "<option value='<='> <= </option>";
		echo "<option value='='> = </option>";
		echo "<option value='>=' SELECTED> >= </option>";
		}
	if ($nop && $nop == '=' || $disabled) {
		echo "<option value='<='> <= </option>";
		echo "<option value='=' SELECTED> = </option>";
		echo "<option value='>='> >= </option>";
		}
		
	if ($nop && $nop == '<') {
		echo "<option value='<=' SELECTED> <= </option>";
		echo "<option value='='> = </option>";
		echo "<option value='>='> >= </option>";
		}
	
	echo "</SELECT>";

	if ($qobject['nsources']) {
		$n = $qobject['nsources'];
	} else {
		if ($qobject['sources']) {
			$n = count($qobject['sources']);
		} else {
			switch ($qobject['term']) {
				case 'bionames':
					$n = count($sources);
					break;
				default:
					$n = 0;
					foreach ($sources as $s) {
						if ($s['term'] == 'biogeographic') ++$n;
						// GPDD HARD CODE
						if ($s['term'] == 'biorelational') $n = $n + 2;
					}
					break;
			}
		}
	}
	//GPDD HARDCODE
	if ($qobject['term'] == 'biotemporal') $n = 1;
	
	
	echo "<SELECT id='nsources' name='nsources' $disabled>";
	for ($i = 1; $i <= $n; $i++) {
		if ($i == $n) {
			$selected = 'selected';
		} else {
			$selected = '';
		}
		echo "<OPTION value='$i' $selected>$i</OPTION>";
	}
	echo "</SELECT>";
	
	//echo "<INPUT type=text id='nsources' name='nsources' $disabled size=3 value=$n onChange='changeNSources()'>";
	//echo "<input type=button name='allbtn' value='all' onClick='checkAll(document.ebankform." . $form_id . ")'> ";
	//echo "<input type=button name='clearbtn' value='clear' onClick='uncheckAll(document.ebankform." . $form_id . ")'>";
	#echo " sources";
}

#=======================================================================================================================
	
function html_query_nseries ($db_handle, $qobject, $names){

	# How many sources name required to be in required
	# GPDD HARDCODE
	
	$queries = $qobject['queries'];
	
	if ($queries) {
		foreach ($queries as $q) {
			if ($q[field] == 'NSeries') $query = $q;
		}
	}
	
	$nop = $query['op'];
	$n = $query['value'];
	
	
	echo "<select name='NSeries_operation' id='nseries_operation'>";
	if (!$nop | $nop == '>=') {
		echo "<option value='<='><=</option>";
		echo "<option value='='>=</option>";
		echo "<option value='>=' SELECTED>>=</option>";
		}
	if ($nop and $nop == '=') {
		echo "<option value='<='><=</option>";
		echo "<option value='=' SELECTED>=</option>";
		echo "<option value='>='>>=</option>";
		}
		
	if ($nop and $nop == '=<') {
		echo "<option value='<=' SELECTED><=/option>";
		echo "<option value='='>=</option>";
		echo "<option value='>='>>=</option>";
		}
	
	echo "</select>";

	# N SERIES IN SELECT SET
	$str = "SELECT MAX(n) FROM (
		 SELECT t.binomial, COUNT(*) AS n
		 FROM gpdd.main m,
		 gpdd.taxon t
		 WHERE m.\"TaxonID\" = t.\"TaxonID\"
		 AND t.binomial IS NOT NULL";
	if($names) {
		$taxa_array = array_to_postgresql($names, 'text');
		$str = $str . " AND t.binomial = ANY($taxa_array)";
	}
	$str = $str . " GROUP BY t.binomial) AS myquery";
	##echo $str;
	$result = pg_query($db_handle,$str);
	$row = pg_fetch_row($result);
	$ns = $row[0];
	If (!$n) $n = $ns;

	
	# N SERIES
	echo "<SELECT id='nseries' name='NSeries_count'>";
	for ($i = 1; $i <= $ns; $i++) {
		if ($i == $n) {
			$selected = ' SELECTED';
		} else {
			$selected = '';
		}
		echo "<OPTION value=$i $selected>$i</OPTION>";
	}
	echo "</SELECT>";
	
	//echo "<INPUT type=text id='nseries' name='NSeries_count' size='3' value='$n'>";
	//echo "($n) series";
}

#=======================================================================================================================

function html_query_nnames ($formname, $qobject){
	# How many names required in each source
	echo "<b>Number of names in each source: </b>";
	if ($qobject['nnames']) {
		$val = $qobject['nnames'];
		echo "<INPUT type=text name=$formname size=3 value=$val><br>";
		} else {
		echo "<INPUT type=text name=$formname size=3 value='1'><br>";
		}
	}

#=======================================================================================================================

function html_query_not($qobject) {
	
/*	if ($qobject['term'] !== 'bionames') {
		if ($qobject['querynot']) {
			echo "<input type=checkbox CHECKED name='querynot' value='not'>NOT";
		} else {
			echo "<input type=checkbox name='querynot' value='not'>NOT";
		}
	}*/
	
	}
	
#=======================================================================================================================

function html_query_null($qobj) {
	
	echo "<table border='0'>";
	
	$title = "Include names where some, but not all, fields have null values.";
	echo "<tr>";
	echo "<td class='query_title' title='$title'>Include Nulls</td>";
	echo "<td class='query_field'>";
	if ($qobj['querynull'] and $qobj['querynull'] == 1) {
		echo "<input type=checkbox CHECKED name='querynull' value='0'>";
		} else {
		echo "<input type=checkbox name='querynull' value='1'>";
		}
	echo "</td>";
	echo "</tr>";
	echo "</table>";
	}


#=======================================================================================================================

function html_query_operator($qobject) {
	
	
	echo "<table>";
	echo "<tr>";
	echo "<td class='option_title'>";
	echo "Interquery";
	echo "</td>";
	
	$op = $qobject['queryoperator'];
	
	echo "<td>";
	if (!$op || $op == 'AND') {
		echo "<input type=radio CHECKED name='queryoperator' value=INTERSECT> And (Intersect)";
		} else {
		echo "<input type=radio name='queryoperator' value=INTERSECT> And (Intersect)";
		}
	if ($op == 'OR') {
		echo "<input type=radio CHECKED name='queryoperator' value=UNION> Or (Union)";
		} else {
		echo "<input type=radio name='queryoperator' value=UNION> Or (Union)";
		}
	if ($op == 'MINUS') {
		echo "<input type=radio CHECKED name='queryoperator' value=EXCEPT> Minus (Except)<br>";
		} else {
		echo "<input type=radio name='queryoperator' value=EXCEPT> Minus (Except)<br>";
		}
	echo "</td>";
	echo "</tr>";
	echo "</table>";
	}
	
		
#=================================================================================================================
	
	function html_query_select_options($db_handle, $str, $fname, $qobject) {
		
	//HTML select box set with 'in' and 'out' controls
	// SQL must return two fields the value to pass and the item to display
	
	$queries = $qobject['queries'];
	
	if (!$queries) $queries = array();
	foreach ($queries as $query) {
		if ($query['field'] == $fname) $vals = $query['value'];
	}
	
/*	echo "fname: $fname, str: $str<br>";
	print_r($queries);
	echo "<br>";*/
	
	$res = pg_query($db_handle, $str);
	
	echo "<table>";
	echo "<tr>";
	echo "<td>";
	echo "<SELECT id='$fname' name='$fname' class='query_options' $disabled MULTIPLE size='8'>";
	while ($row = pg_fetch_row($res)) {
		echo "<OPTION value='$row[0]'>$row[1]</OPTION>";
	}
	echo "</SELECT>";
	echo "</td>";
	echo "<td>";
	echo "<BUTTON type='button' class='button-standard' $disabled id='" . $fname . "_____in' name='$fname' onClick='add_sel(this)'>></BUTTON><br>";
	echo "<BUTTON type='button' class='button-standard' $disabled id='" . $fname . "__allin' name='$fname' onClick='add_all(this)'>>></BUTTON><br>";
	echo "<BUTTON type='button' class='button-standard' $disabled id='" . $fname . "_allout' name='$fname' onClick='rem_all(this)'><<</BUTTON><br>";
	echo "<BUTTON type='button' class='button-standard' $disabled id='" . $fname . "____out' name='$fname' onClick='rem_sel(this)'><</BUTTON>";
	echo "</td>";
	echo "<td>";
	
	echo "<SELECT id='$fname" . "_add' name='$fname" . "_add[]' class='query_options' MULTIPLE size='8'>";
	if ($vals) {
		$res = pg_query($db_handle, $str);
		while ($row = pg_fetch_row($res)) {
			if (in_array($row[0], $vals)) echo "<OPTION value='$row[0]'>$row[1]</option>";
		}
	}

	echo "</SELECT>";
	echo "</td>";
	echo "</tr>";
	echo "</table>";
	}
	
		
#=======================================================================================================================

function html_query_sources ($qobject, $sources) {
	
	# SOURCES QUERY IS APPLIED TO
	# 1 table or tree, 
	# >= 1 names, spatial or temporal
	echo '<script src="./scripts/sources_utils.js" type="text/javascript"></script>';
	
	$qterm = $qobject['term'];
	$qsources = $qobject['sources'];
	$form_id = 'qsources';
	$formname = "qsources[]";
	
	# SOURCES LIST
	$first = true;
	$disabled = '';
	if (count($sources) == 1) $disabled = "disabled='disabled'";
	
	foreach ($sources as $source) {
	
		$sterm = $source['term'];

		switch (true) {
		
			# MULTIPLE CHECKBOXES
			case ($qterm == 'biogeographic' && $sterm == 'biogeographic'):
				if (!$qsources) {
					if ($first) {
						echo "<input type=checkbox CHECKED name=$formname id=$form_id value='"
							. $source['id'] . "' onClick='checkCount()'> " . $source['name'] . "<br>";
							$first = false;
						} else {
						echo "<input type=checkbox CHECKED name=$formname id=$form_id value='"
							. $source['id'] . "' onClick='checkCount()'> " . $source['name'] . "<br>";
						}
					} else {
					if (in_array($source['id'], $qsources)) {
						echo "<input type=checkbox CHECKED name=$formname id=$form_id value='"
							. $source['id'] . "' onClick='checkCount()'> " . $source['name'] . "<br>";	
						} else {
						echo "<input type=checkbox name=$formname id=$form_id value='"
							. $source['id'] . "' onClick='checkCount()'> " . $source['name'] . "<br>";
						}
					}
				break;
				
			case ($qterm == 'biogeographic' && $sterm == 'biorelational'):
				// GPDD HARDCODE
				if (!$qsources || ($source['id'] == 23 &&  in_array(26, $qsources))) {
					$checked = 'CHECKED';
				} else {
					$checked = "";
				}
				//echo ($source['id'] == 26 && in_array(26, $qsources));
				echo "<input type=checkbox $checked name=$formname id=$form_id
					 value='26' onClick='checkCount()'> Global Population Dynamics Database (Point)<br>";
				if (!$qsources || ($source['id'] == 23 && in_array(27, $qsources))) {
					$checked = 'CHECKED';
				} else {
					$checked = "";
				}
				echo "<input type=checkbox $checked name=$formname id=$form_id
					 value='27' onClick='checkCount()'> Global Population Dynamics Database (Bounding Box)<br>";				
				break;
			
			# ALL SOURCES CHECKBOX
			case ($qterm == 'bionames'):
				#echo "formname: $formname<br>";
				#echo "Sources ";
				if (!$qsources) {
					echo "<input type=checkbox CHECKED name=$formname id=$form_id value='"
						. $source['id'] . "' onClick='checkCount()'> " . $source['name'] . "<br>";
					} else {
					if (in_array($source['id'], $qsources)) {
						echo "<input type=checkbox CHECKED name=$formname id=$form_id value='"
							. $source['id'] . "' onClick='checkCount()'> " . $source['name'] . "<br>";	
						} else {
						echo "<input type=checkbox name=$formname id=$form_id value='"
							. $source['id'] . "' onClick='checkCount()'> " . $source['name'] . "<br>";
						}
					}
				break;
				
			case ($qterm == 'biotemporal'):
				// GPDD HARDCODE
				if ($source['name'] == "Global Population Dynamics Database") 
					echo "<input type=checkbox CHECKED $disabled name=$formname id=$form_id value='"
							. $source['id'] . "'  onClick='checkCount()'> " . $source['name'] . "<br>";
				break;
				
			default:
				// echo "html_query_sources: $qtype on $stype not supported";
				// exit;
				break;
			}
		}

	}

	
#=======================================================================================================================

	function html_www($source) {
		# Web link
	if (array_key_exists('www', $source)) {
		echo " <a href='" . trim($source['www']) . "' target='_blank'>";
		echo  "(info)</a>";
		}
		
	}
	
#=======================================================================================================================
	
	
function html_query_biotable($db_handle, $qobject, $qobjects, $sources, $names) {

	echo '<script src="./scripts/table_utils.js" type="text/javascript"></script>';

	//print_r($qobject['queries']);
	//echo "<br>";
	
	# Get source
	$source = get_obj($sources, $qobject['sources'][0]);
	$sid = $source['id'];

	$dbloc = $source['dbloc'];
	$queries = $qobject['queries'];
	$qfields = array();
	if ($queries) foreach ($queries as $query) array_push($qfields, $query['field']);
	
	//html_query_header($qobject, $sources);
	html_query_null($qobject);

	# Names passed
	if ($names) $arr = array_to_postgresql($names, 'text');
	
	# FIELD TYPES
	$fields = $source['fields'];

	$fieldtitle = count($fields) . ' Fields';
	
	echo "<table border='0'>";
	
	foreach ($fields as $field) {

		echo "<tr>";
		echo "<td class='query_title'>$fieldtitle</td>";
		if ($fieldtitle == (count($fields) . ' Fields')) $fieldtitle = '';
		echo "<td class = 'query_field'>";

		$fname = $field['fname'];
		$fdesc = $field['fdesc'];
		$ftype = $field['ftype'];
		$dtype = $field['dtype'];
		$falias = $field['falias'];
		
		#FIELD RETURN
		$i = $field['frank'];
		// Is field in an existing query?
		if ($qfields && in_array($fname, $qfields)) {
			$check = ' CHECKED ';
			foreach ($queries as $query) if ($query['field'] == $fname) $vals = $query['value'];
		} else {
			$check = '';
			$vals = null;
		}
		
		# DIV
		echo "<INPUT type='checkbox' $check id='$fname" . "_query' name='$fname" .
		 	"_query' onClick='showfield(this);'>";
		echo "<LABEL for='$fname" . "_query' title='$fdesc'>$falias&nbsp;</LABEL>";
		echo "<DIV id='$fname" . "_div' style='display: none;'>";
		
		switch ($dtype) {
			
			case 'catagoryfield':
				$str = "SELECT DISTINCT \"$fname\", \"$fname\" FROM $dbloc ORDER BY \"$fname\"";
				//echo "$str<br>";
				html_query_select_options($db_handle, $str, $fname, $qobject);
				break;
			
			case 'lookupfield':
				$str = "SELECT c.item, c.name
					FROM source.source_fields f,
					source.source_fieldcodes c
					WHERE f.field_id = c.field_id
					AND f.source_id = $sid
					AND f.field_name = '$fname'";
				html_query_select_options($db_handle, $str, $fname, $qobject);
				break;
				
			case "rangefield":
				
				//GPDDHARDCODE
				if ($source['id'] <> 23) {
					# Get min and max of all names
					$str = 'SELECT MIN("' . $fname . '"), MAX("' . $fname . '")
						FROM ' . $dbloc;
					#Get min and max of given names
					if ($names) $str = $str . " WHERE " . $source['namefield'] . " = ANY($arr)";
				} else {
					$str = "SELECT MIN(m.\"$fname\"), MAX(m.\"$fname\")
						FROM gpdd.main m, gpdd.taxon t
						WHERE m.\"TaxonID\" = t.\"TaxonID\"";
					if ($names) $str = $str . " AND t.binomial = ANY($arr)";
				}
				$res_names = pg_query($db_handle, $str);
				$row_names = pg_fetch_row($res_names);			
				# Get user set min and max
				#$vals = query_vals($qobject, $fname);
				
				$fmin = $fname . '_min';
				$fmax = $fname . '_max';
				
				if (!$vals) {
					if (!$names) {
						echo "[$row_names[0]] <INPUT type='text' name='$fmin'" ,
							" id='$fmin' disabled='true' size=8 value='$row_names[0]' onchange='validateRangeField(\"$fmin\")'>";
						echo " &ndash <INPUT type='text' name='$fmax'" .
							" id='$fmax' disabled='true' align='right' size=8" . 
							" value='$row_names[1]' onchange='validateRangeField(\"$fmax\")'>[$row_names[1]]";
						} else {
						echo "[$row_names[0]] <INPUT name='$fmin'id='$fmin' disabled='true' size=8 value='$row_names[0]'",
							" onchange='validateRangeField(\"$fmin\")'>";
						echo " &ndash <INPUT type='text' name='$fmax'" ,
							" id='$fmax' disabled=true size=8" ,
							" value='$row_names[1]' onchange='validateRangeField(\"$fmax\")'>[$row_names[1]]";
						}
					} else {
					# vals
					if (!$names) {
						echo "[$row_names[0]] <INPUT type='text' name='$fmin'" ,
						 	" id='$fmin' size=8 value='$vals[0]' onchange='validateRangeField(\"$fmin\")'>";
						echo " &ndash <INPUT type='text' name='$fname" . "_max'" ,
							" id='$fmax' size=8 value='$vals[1]' onchange='validateRangeField(\"$fmax\")'>[$row_names[1]]";
						} else {
						echo "[$row_names[0]] <INPUT type='text' name='$fmin'" ,
							" id='$fmin' size=8 value='$vals[0]' onchange='validateRangeField(\"$fmin\")'>";
						echo " &ndash <INPUT type='text' name='$fmax'" ,
							" id='$fmax' size=8 value='$vals[1]' onchange='validateRangeField(\"$fmax\")'> [$row_names[1]]";
						}
					}
				break;
				
			case 'lookuptable':
				// Get field name from
				switch ($fname) {
					// GPDD HARDCODE
					case 'Author':
					case 'Year':
					case 'Title':
					case 'Reference':
					case 'Availability':
					case 'Notes':
							$str = "SELECT DISTINCT s.\"$fname\", s.\"$fname\"
									FROM gpdd.taxon t, gpdd.main m, gpdd.datasource s
								 	WHERE t.\"TaxonID\" = m.\"TaxonID\"
								 	AND m.\"DataSourceID\" = s.\"DataSourceID\"
								 	AND t.binomial IS NOT NULL";
							if ($arr) $str = $str . " AND t.binomial = ANY($arr)";
							$str = $str . " ORDER BY s.\"$fname\"";
							html_query_select_options($db_handle, $str, $fname, $qobject);
						break;
					case 'TaxonomicPhylum':
					case 'TaxonomicClass':
					case 'TaxonomicOrder':
					case 'TaxonomicFamily':
					case 'TaxonomicGenus':
					case 'binomial':
					case 'CommonName':
						$str = "SELECT DISTINCT t.\"$fname\", t.\"$fname\"
									FROM gpdd.taxon t
								 	WHERE t.binomial IS NOT NULL";
								 	
						if ($arr) $str = $str . " AND t.binomial = ANY($arr)";
						$str = $str . " ORDER BY t.\"$fname\"";
						html_query_select_options($db_handle, $str, $fname, $qobject);
						//echo "</DIV>";
						break;
					case 'HabitatName':
					case 'BiotopeType':
						$str = "SELECT DISTINCT b.\"$fname\", b.\"$fname\"
								FROM gpdd.taxon t, gpdd.main m, gpdd.biotope b
							 	WHERE t.\"TaxonID\" = m.\"TaxonID\"
							 	AND m.\"BiotopeID\" = b.\"BiotopeID\"
							 	AND t.binomial IS NOT NULL";
							 	
						if ($arr) $str = $str . " AND t.binomial = ANY($arr)";
						$str = $str . "ORDER BY b.\"$fname\"";
						html_query_select_options($db_handle, $str, $fname, $qobject);
						break;
					case 'ExactName':
					case 'TownName':
					case 'CountyStateProvince':
					case 'Country':
					case 'Continent':
					case 'Ocean':
					case 'SpatialAccuracy':
					case 'LocationExtent':
							$str = "SELECT DISTINCT l.\"$fname\", l.\"$fname\"
									FROM gpdd.taxon t, gpdd.main m, gpdd.location l
								 	WHERE t.\"TaxonID\" = m.\"TaxonID\"
								 	AND m.\"LocationID\" = l.\"LocationID\"
								 	AND t.binomial IS NOT NULL";
							if ($arr) $str = $str . " AND t.binomial = ANY($arr)";
							$str = $str . " ORDER BY l.\"$fname\"";
							html_query_select_options($db_handle, $str, $fname, $qobject);
						break;
						
					default:
						break;
				}
				
				break;
				
			case 'groupfield':
				html_query_nseries($db_handle, $qobject, $names);
				break;
				

				break;

			}
		
		# End DIV
		echo "</DIV>";
		echo "</td>";
		echo "</tr>";
	}
	echo "</table>";
	//html_query_footer($object,$qobjects);
	
	

	}
	
	
#=================================================================================================================
	
	function html_query_biotemporal($db_handle, $qobject, $qobjects, $sources, $names) {
		
		
		# TEMPORAL QUERY

		echo '<script src="./scripts/temporal_utils.js" type="text/javascript"></script>';
		
		$month = array (
	        1 => 'January',
	        2 => 'February',
	        3 => 'March',
	        4 => 'April',
	        5 => 'May',
	        6 => 'June',
	        7 => 'July',
	        8 => 'August',
	        9 => 'September',
	        10 => 'October',
	        11 => 'November',
	        12 => 'December'
	    );
	    
	   // html_query_header($qobject, $sources);
	   // echo "<BR>";
		html_query_sources($db_handle, $qobject, $sources);
		
		// Get range of dates
		$str = "SELECT MIN(d.\"SampleYear\"), MAX(d.\"SampleYear\")
			 FROM gpdd.data d
			 WHERE d.\"SampleYear\" <> -9999";

		//echo "$str<br>";
		$res = pg_query($db_handle,$str);
		$row = pg_fetch_row($res);
		$minyear = $row[0];
		$maxyear = $row[1];
		$msg = "Temporal data available from $minyear to $maxyear<br>";
		if ($names) {
			$arr = array_to_postgresql($names, 'text');
			$str = "SELECT MIN(d.\"SampleYear\"), MAX(d.\"SampleYear\")
			 FROM gpdd.data d,
			 gpdd.main m,
			 gpdd.taxon t
			 WHERE d.\"MainID\" = m.\"MainID\"
			 AND m.\"TaxonID\" = t.\"TaxonID\"
			 AND d.\"SampleYear\" <> -9999
			 AND t.binomial = ANY ($arr)";
			//echo "$str<br>";
			$res = pg_query($db_handle,$str);
			$row = pg_fetch_row($res);
			$nminyear = $row[0];
			$nmaxyear = $row[1];
			$msg = "Temporal data in selection from $nminyear to $nmaxyear<br>";
		}
		//echo "<br>";
		
		// Selections
		$from_day = 1;
		$from_month = 1;
		$from_year = $maxyear;
		$to_day = 31;
		$to_month = 12;
		$to_year = $maxyear;
		
		echo "<table border='0'>";
		
		# FROM
		$title='';
		echo "<tr>";
		echo "<td class='query_title' title='$title'>Time</td>";
		
		echo "<td>";
		
		# FROM OPERATOR
		echo "<SELECT NAME='t_from_overlay' id='t_from_overlay'>";
		if (!$t_from_overlay) $t_from_overlay = 'DURING';
		switch ($t_from_overlay) {
			case 'BEFORE':
				echo "<OPTION VALUE='BEFORE' SELECTED>Before";
				echo "<OPTION VALUE='DURING'>During";
				echo "<OPTION VALUE='AFTER'>After";
				break;
			case 'DURING':
				echo "<OPTION VALUE='BEFORE'>Before";
				echo "<OPTION VALUE='DURING' SELECTED>During";
				echo "<OPTION VALUE='AFTER'>After";
				break;				
			case 'AFTER':
				echo "<OPTION VALUE='BEFORE'>Before";
				echo "<OPTION VALUE='DURING'>During";
				echo "<OPTION VALUE='AFTER' SELECTED>After";
				break;
		}
		echo "</SELECT>";
		
		# FROM DAY
		echo "<SELECT NAME='from_day' id='from_day'>";
		for ($i = 1; $i <= 31; $i++) {
			if ($i != $from_day) {
				echo "<OPTION VALUE='$i'>$i";
			} else {
				echo "<OPTION VALUE='$i' SELECTED>$i";
			}
		}
		echo "</SELECT> ";
		
		# FROM MONTH
		echo "<SELECT NAME='from_month' id='from_month'>";
		for ($i = 1; $i <= 12; $i++) {
			if ($i != $from_month) {
				echo "<OPTION VALUE='$i'>$month[$i]";
			} else {
				echo "<OPTION VALUE='$i' SELECTED>$month[$i]";
			}
		}
		echo "</SELECT> ";
		
		# FROM YEAR
		echo "<SELECT NAME='from_year' id='from_year'>";
		for ($i = $minyear; $i <= $maxyear; $i++) {
			if ($i != $from_year ) {
				echo "<OPTION VALUE='$i'>$i";
			} else {
				echo "<OPTION VALUE='$i' SELECTED>$i";
			}
		}
		echo "</SELECT>";
		
		echo "</td>";
		echo "</tr>";
		
/*		# TO
		echo "<tr>";
		echo "<td class='query_title'>Time 2";
		# TO DISABLE
		if ($qobject['no_finish' == 'on']) {
			$checked = 'CHECKED';
			$disabled = '';
		} else {
			$checked = '';
			$disabled = "disabled='disabled'";
		}
		echo "&nbsp;<input type='checkbox' id='t_2' name='t_2' $checked onClick='noFinish()'/>";
		echo "</td>";
		
		echo "<td>";
		# TO OPERATOR
		if (!$t_to_overlay) $t_to_overlay = 'DURING';
		echo "<SELECT NAME='t_to_overlay' id='t_to_overlay' $disabled>";
		switch ($t_to_overlay) {
			case 'BEFORE':
				echo "<OPTION VALUE='BEFORE' SELECTED>Before";
				echo "<OPTION VALUE='DURING'>During";
				//echo "<OPTION VALUE='AFTER'>After";
				break;
			case 'DURING':
				echo "<OPTION VALUE='BEFORE'>Before";
				echo "<OPTION VALUE='DURING' SELECTED>During";
				//echo "<OPTION VALUE='AFTER'>After";
				break;				
		}
		echo "</select>";
		
		# TO DAY
		echo "<SELECT NAME='to_day' id='to_day' $disabled>";
		for ($i = 1; $i <= 31; $i++) {
			if ($i != $to_day) {
				echo "<OPTION VALUE='$i'>$i";
			} else {
				echo "<OPTION VALUE='$i' SELECTED>$i";
			}
		}
		echo "</SELECT> ";
		
		# TO MONTH
		echo "<SELECT NAME='to_month' id='to_month' $disabled>";
		for ($i = 1; $i <= 12; $i++) {
			if ($i != $to_month) {
				echo "<OPTION VALUE='$i'>$month[$i]";
			} else {
				echo "<OPTION VALUE='$i' SELECTED>$month[$i]";
			}
			
		}
		echo "</SELECT> ";
		
		# TO YEAR
		echo "<SELECT NAME='to_year' id='to_year' $disabled>";
		for ($i = $minyear; $i <= $maxyear; $i++) {
			if ($i != $to_year ) {
				echo "<OPTION VALUE='$i'>$i";
			} else {
				echo "<OPTION VALUE='$i' SELECTED>$i";
			}
		}
		echo "</SELECT> ";
		
		echo "</td>";
		echo "</tr>";*/
		
		echo "</table>";
	
	}
	
#=================================================================================================================
	
	function html_query_header ($qobject, $qobjects, $sources) {
		
		// Name and action buttons
		html_query_header1 ($qobject, $qobjects);
		// Sources
		html_query_header2($qobject, $qobjects, $sources);

	}
	
#=================================================================================================================
	
	function html_query_header1 ($qobject, $qobjects) {
		
		//print_r($qobject);
		//echo "<br>";
		
		echo "<table border='0'>";
		echo "<tr>";
		$objname = $qobject['name'];
		if (empty($objname)) $objname = get_next_name($qobjects, $qobject['term']);
		$title = "Query name";

		# QUERY NAME
		echo "<td class='query_title' title='$title'>Name</td>";
		echo "<td>";
		echo "<INPUT type='text' id='objname' name='objname' class='eb' value='$objname' onChange='checkObjName()'>";
		echo "</td>";
		
		# NOT
		echo "<td class='query_not'>";
		if ($not !== false) {
			html_query_not($qobject);
		}
		echo "</td>";
		html_query_interoperator ($qobject, $qobjects);
		echo "</tr>";
		echo "</table>";
	}
	

#=================================================================================================================

	function html_query_header2 ($qobject, $qobjects, $sources) {
		
		$qterm = $qobject['term'];
		
		echo "<table border='0'>";
		echo "<tr>";
		
		
		# ALL/CLEAR
		if ($qterm == 'biogeographic' || $qterm == 'bionames' || $qterm == 'biotemporal') {
			echo "<td class='query_title'>";
			echo "Sources<br>";
			echo "<input type='button' class='button-standard' name='allbtn' value='all' onClick='checkAll(document.ebankform.qsources)'></br>";
			echo "<input type='button' class='button-standard' name='clearbtn' value='clear' onClick='uncheckAll(document.ebankform.qsources)'>";
		} else {
			echo "<td class='query_title'>";
			echo "Source";
		}
		echo "</td>";
		
		echo "<td class='eb_plus'>";
		if ($qobject['term'] == 'biotree' || $qobject['term'] == 'biotable') {
			$source = get_obj($sources, $qobject['sources'][0]);
			echo "<input type='text' id='queryheader' class='eb' disabled='disabled' value='", $source['name'], "'></input><br>";
		} else {
			html_query_sources($qobject, $sources);
		}
		
		echo "</td>";
		html_query_buttons($qobject);
		echo "</tr>";
		
		# N SOURCES
		echo "<tr>";
		if ($qterm == 'biogeographic' || $qterm == 'bionames' || $qterm == 'biotemporal') {	
			$title='Names must be in x datasets.';
			echo "<td class='query_title' title='$title'>N Sources</td>";
			echo "<td>";
			html_query_nsources ($qobject, $sources);
			echo "</td>";
		} 
		echo "</tr>";
		echo "</table>";
		
	}
	
#=================================================================================================================
	
	function html_query_interoperator ($qobject, $qobjects) {
		
		# INTERQUERY OPERATOR
		$op = $qobject['queryoperator'];
		$title = 'Interquery operator';
		
		echo "<td class='query_buttons' title='$title' align='right'>";
		
		//echo "n qobjects:" . count($qobjects);
		if (count($qobjects) > 1) {
			echo "Interquery ";
			echo "<SELECT id='queryoperator' name='queryoperator' class='qop' onChange='updateCART()'>";
			if (!$op || $op == 'INTERSECT') {
				$selected = 'SELECTED';
			} else {
				$selected = '';
			}
			echo "<OPTION value='INTERSECT' $selected >And (Intersect)</OPTION>";
			if ($op == 'UNION') {
				$selected = 'SELECTED';
			} else {
				$selected = '';
			}
			echo "<OPTION value='UNION' $selected>Or (Union)</OPTION>";
			if ($op == 'EXCEPT') {
				$selected = 'SELECTED';
			} else {
				$selected = '';
			}
			echo "<OPTION value='EXCEPT' $selected>Minus (Except)</OPTION>";
			echo "</SELECT >";
		}
		echo "</td>";
	}
	
	
#=================================================================================================================

function html_query_biotree($db_handle, $qobject, $qobjects, $sources) {
	
	echo '<script src="./scripts/tree_utils.js" type="text/javascript"></script>';
	
	$source = get_obj($sources, $qobject['sources'][0]);
	$tree_id = $source['tree_id'];
	$qnames = $qobject['taxa'];
	if (!$qnames) $qnames = array();

	# Find Box
	echo "<table border='0'>";
	echo "<tr>";
	$title = "Case sensitive search for names containing text.";
	echo "<td class='query_title' title='$title'>Find</td>";
	echo "<td>";
	echo "<INPUT type='text' class='eb' id = 'findval' name='findval' value=''>";
	echo "&nbsp;<BUTTON type='button' id='findbtn' class='button-standard' name='findbtn' onClick='findNodes()' onChange='clear()'>Find</BUTTON><br>";
	echo "</td>";
	echo "</tr>";
	echo "</table>";
	echo "<INPUT type='hidden' id='tree_id' value='$tree_id' />";
	# Get filter options for tree
	
	echo "<table border='0'>";
	echo "<tr>";
	$title='Filter find to include names for only nodes of the selected type';
	echo "<td class='query_title' title='$title'>";
	echo "Find Filter";
	echo "</td>";
	echo "<td>";
	$str = "SELECT tm.name 
		FROM biosql.tree_qualifier_value tr,
		biosql.term tm
		WHERE tr.tree_id = $tree_id
		AND tm.term_id = tr.term_id";
	//echo "$str<br>";
	$res = pg_query($db_handle, $str);
	$row = pg_fetch_row($res);
	$treetype = $row[0];
	
	Switch ($treetype) {
		case 'phylogeny':
			//echo "<input type='radio' CHECKED name='nodefilter' value='all'> None";
			echo "<input type='checkbox' name='nodefilter' CHECKED value='tip'> Tips";
			echo "<input type='checkbox' name='nodefilter' CHECKED value='internal'> Internal <BR>";
			break;
		case 'taxonomy':
			# Get levels in tree
			$str = "Select DISTINCT tm.name,tm.identifier
				FROM biosql.node n,
				biosql.node_qualifier_value nq,
				biosql.term tm
				WHERE n.tree_id = $tree_id
				AND n.node_id = nq.node_id
				AND nq.term_id = tm.term_id
				ORDER BY tm.identifier";
			$res = pg_query($db_handle, $str);
			$arr = pg_fetch_all_columns($res, 0);
			//echo "<input type='radio' CHECKED name='nodefilter' value='all'> None ";
			foreach ($arr as $val) echo "<input type='checkbox' CHECKED name='nodefilter' value='$val'>" , ucwords($val);
			echo '<BR>';
			break;
		default:
			echo "html_query_biotree: Unrecognised tree type";
			break;
	}
	echo "</td>";
	echo "</table>";

	# SELECT BOXES
	echo "<table>";
	echo "<tr>";
	echo "<td class='query_title'>Names</td>";
	echo "<td>";
	$title ='Names found';
	echo "<SELECT name='tree' id='tree_items' MULTIPLE SIZE=8 class='eb' title='$title'>";
	echo "</SELECT>";
	echo "</td>";
	
	# Add Buttons
	echo "<td>";
	echo "<BUTTON type='button' class='button-standard' id='tree_add' name='tree_add' onClick='treeAdd()'>></BUTTON><br>";
	echo "<BUTTON type='button' class='button-standard'  id='tree_all' name='tree_all' onClick='treeAll()'>>></BUTTON><br>";
	# Remove Buttons
	echo "<BUTTON type='button' class='button-standard'  id='tree_del' name='tree_del' onClick='treeDel()'><</BUTTON><br>";
	echo "<BUTTON type='button' class='button-standard'  id='tree_delall' name='tree_delall' onClick='treeDelall()'><<</BUTTON><br>";
	echo "</td>";
	
	# Taxa area
	echo "<td>";
	$title ='Names in query';
	echo "<SELECT name=\"taxa[]\" id='taxa_items' MULTIPLE SIZE=8 class='eb' title='$title'>";
	if (!empty($qnames)) {
		foreach ($qnames as $qname) echo "<OPTION>$qname</OPTION>";
	}
	echo "</SELECT>";
	echo "</td>";
	echo "</tr>";
	echo "</table>";


	echo "<table border='0'>";
	echo "<tr>";
	$title = "Names";
	echo "<td class='query_title'>";
	echo "Tree operator";
	echo "</td>";
	echo "<td class='query_c2_footer'>";
	html_query_subtree_method();
	echo "</td>";
	echo "</tr>";
	# Internal/tip nodes
	echo "<tr>";
	echo "<td class='query_title'>";
	echo "Node operator" ;
	echo "</td>";
	echo "<td class='query_c2_footer'>";
	html_query_treenodes($qobject['treenodes']);
	echo "</td>";
	echo "</tr>";
	echo "</table>";	

	//html_query_footer($qobject, $qobjects);

}
	

#=======================================================================================================================

function html_find($db_handle, $name_search, $sources) {
	
	//print_r($name_search);
	
	# OUTER FROM TABLE
	echo "<table border='0'>";
	echo "<tr>";
	echo "<td class='option_title_plus'>Found</td>";
	
	echo "<td class='find_c2'>";
	
	# RESULTS TABLE
	echo "<p id='find_msg'> Hidden...</p>";
	echo "<DIV id='find_div'>";
	echo "<TABLE border='0'>";

	$sn = 1;
	$sid_arr = array();
	$sid_title = array();
	foreach ($sources as $source) {
		array_push($sid_arr, $source['id']);
		array_push($sid_title, $source['name']);
		$sn++;
	}
	
	echo "<tbody>";
	
	foreach ($name_search as $res) {
		$sin = explode(",",$res[1]);
		//print_r ($sin);
		if (empty($sin[0])) {
			$n = 0;
		} else {
			$n = count($sin);
		}
		echo "<TR>";
		echo "<TD class='find_name'>$res[0]</TD>";
		echo "<TD class='find_n'>$n</TD>";
		$i = 0;
		foreach ($sid_arr as $sid) {
			$title = $sid_title[$i];
			if (in_array($sid, $sin)) {
				echo "<TD class='find_source' title='$title'><img src='./image/green-dot.gif' /></TD>";
			} else {
				echo "<TD class='find_source' title='$title'><img src='./image/red-dot.gif' /></TD>";
			}
			$i++;
		}
		echo "</TR>";
	}
	
	echo "</tbody>";
	
	# CLOSE RESULTS
	echo "</TABLE>";
	echo "</DIV>";
	echo "<td><input type='button' class='button-standard' id='find_hide' value='Hide' onClick='showFind()'/></td>";
	//echo "<td><LABEL><INPUT type='checkbox' id='find_hide' onClick='showFind()'/>Hide</LABEL></td>";
	echo "</tr>";
	echo "</table>";
	
	
	return null;

}

#=======================================================================================================================
	
function html_query_type ($db_handle, $qobjects, $sources, $names, $name_search) {
	
		# name_search is an array of name and sources returned by an names search
		
		echo '<script src="./scripts/query_type_utils.js" type="text/javascript"></script>';
		
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
		
		# PROCESS FIND
		if ($name_search) {
			$arr = array();
			foreach ($name_search as $res) array_push($arr,$res[0]);
			$val = implode(", ",$arr);
			//html_name_search($db_handle, $name_search, $sources);
		}
		
		echo "<div class='margin5px'>";

		# FIND
		$title = "Quick find for which sources names are in. Comma seperate names.";
		echo "<table border='0'>";
		echo "<tr>";
		echo "<td class='query_title' title='$title'>Find</td>";
		echo "<td class='find_c2'><INPUT type='text' id='name_search' name='name_search' value='$val' /></td>";
		echo "<td><input type='button' class='button-standard' value='Go' onClick='submitform(\"find\")'></td>";
		echo "</tr>";
		echo "</table>";

		# DISPLAY FIND
		if ($name_search) html_find($db_handle, $name_search, $sources);
		
		# QUERY

		echo "<table border='0'>";
		echo "<tr>";
		$title = "Build query to subset data";
		echo "<td  class='query_title_minus' title='$title'>New Query</td>";
		$title = "Which names are in what sources?";
		echo "<td class='qtype' title='$title' align='center'><a href='javascript: submitform(\"bionames\")'><img src='./image/systema.gif' class='query_type_button'/></a></td>";
	
		if (!empty($biotree)) {
			$title = "Are these names in this tree? What is the least common ancestor? What names descend from the least common ancestor?";
			echo "<td class='qtype' title='$title' align='center'><a href='javascript: openSelect(\"biotree\")'><img src='./image/tree.gif' class='query_type_button' /> </a></td>" ;
		}
		if (!empty($biotable)) {
			$title = "Query the attributes of a source";
			echo "<td class='qtype' title='$title' align='center'><a href='javascript: openSelect(\"attribute\")'><img src='./image/haekel_bug.gif' class='query_type_button' /> </a></td>" ;
		}
		if (!empty($biogeographic)) {
			$title = "For which names is there data here?";
			//http://www.google.co.uk/imgres?q=map+blue+marble+clear+background&hl=en&biw=1440&bih=785&tbs=isz:m&tbm=isch&tbnid=gbVFJa91hd_vOM:&imgrefurl=http://oceanmotion.org/html/background/climate.htm&docid=ruZBy3lxCY6e0M&w=350&h=350&ei=D8RcTsOIMdC58gPn9Y3UAw&zoom=1&iact=rc&dur=307&page=2&tbnh=132&tbnw=133&start=28&ndsp=29&ved=1t:429,r:11,s:28&tx=75&ty=81
			echo "<td class='qtype' title='$title' align='center'><a href='javascript: submitform(\"biogeographic\")'><img src='./image/blue-planet.gif' class='query_type_button'/> </a></td>" ;
		}

		if (!empty($biotemporal)) {
			//http://farm4.static.flickr.com/3605/3639291429_f19524c475.jpg
			$title = "For which names is there data for the input period?";
			echo "<td class='qtype' title='$title' align='center'><a href='javascript: submitform(\"biotemporal\")'><img src='./image/clock.gif' class='query_type_button'/> </a></td>" ;
		}
		
		echo "</tr>";
		echo "<tr>";
		echo "<td></td>
			<td class='qtype_text'>Names</td>
			<td class='qtype_text'>A Tree</td>
			<td class='qtype_text'>Attributes</td>
			<td class='qtype_text'>Geography</td>
			<td class='qtype_text'>Time</td>";
		echo "</tr>";
		echo "</table>";

		# QTYPE HIDDEN INPUT
		echo "<INPUT type='hidden' name='qterm' id = 'qterm' value='none' />";
		
		# SOURCE SELECTOR
		html_select_source_table ($sources,'biotree');
		html_select_source_table ($sources,'attribute');
		
		# OTHER ACTIONS
		echo "<table border='0'>";
		echo "<tr>";
		echo "<td class='query_title_minus' title='$title'>Action</td>";
		$n = 0;
		if ($qobjects) {
			$title = "Edit and delete queries";
			echo "<td class='qtype' title='$title' align='center'><a href='javascript: submitform(\"manage\")'><img src='./image/managequeries.gif' class='query_type_button'/> </a></td>" ;
		} else {
			$n++;
		}
		if (!$names) {
			$title = "Return entire datasets";
			echo "<td class='qtype' title='$title' align='center'><a href='javascript: submitform(\"qend\")'><img src='./image/returnalldata.gif' class='query_type_button'/> </a></td>" ;
		}  else {
			$n++;
		}
		if ($names and count($names) != 0) {
			$title = "Return subsetted data";
			echo "<td class='qtype' title='$title' align='center'><a href='javascript: submitform(\"qend\")'><img src='./image/returndata.gif' class='query_type_button'/> </a></td>" ;
		}	
			
		$title = "I\'m done";
		echo "<td class='qtype' title='$title' align='center'><a href='javascript: submitform(\"finish\")'><img src='./image/exit.gif' class='query_type_button'/> </a></td>" ;
		echo "</tr>";
		echo "</table>";
		echo "</div>";
	}

#=======================================================================================================================
	
	function html_select_source_table ($sources, $term) {
		echo "<div id='$term" , "_select_div' style='display: none;'>";
		echo "<table border='0'>";
		echo "<tr>";
		if ($term == 'biotree') {
			$width = 190;
		} else {
			$width = 310;
		}
		echo "<td style='width: $width px'></td>";
		echo "<td>";
		html_select_source($sources, $term);
		echo "</td>";
		echo "<td>";
		if ($term == 'attribute') $term = 'biotable';
		echo "<input type='button' class='button-standard' value='Go' id='$term", "_submit' onClick='submitform(\"$term\")' />";
		echo "</td>";
		echo "</tr>";
		echo "</table>";
		echo "</div>";
	}
	
#=======================================================================================================================
	
function html_reset_form(){
	echo "<input type='Reset' style='color: red' value='Reset'>";
}


#=======================================================================================================================

	
function html_select_eqval($db_handle, $formname, $tree, $edgequal) {

	if ($tree) {
		
		if (!$edgequal) {
			echo "<select name=$formname>";
			} else {
			echo "<select READONLY name=$formname>";
			}
			
		$result = pg_query($db_handle,"SELECT DISTINCT t.term_id, t.name
			FROM biosql.term t, biosql.node n, biosql.edge e, biosql.edge_qualifier_value eq
			WHERE eq.term_id = t.term_id
			AND e.edge_id = eq.edge_id
			AND (e.parent_node_id = n.node_id
			OR e.child_node_id = n.node_id)
			AND n.tree_id = $tree;");

		if (!$result) {
			#If no edge_qualifiers then select none option
			echo "<option name='edgequal' SELECTED value='none'> None</option>";
			
			} else {
			
			#Edge qualifier selected. 
			if (!$edgequal) {
				#If not set
				echo "<option name='edgequal' SELECTED value='none'> None</option>";
				} else {
				# Edge qualifier set
				echo "<option name='edgequal' value='none'> None</option>";
			}
			
			while ($row = pg_fetch_row($result)) {
				if ($row[0] == $edgequal) {
					echo "<option name='edgequal' SELECTED value=$row[0]> $row[1]</option>";
					} else {
					echo "<option name='edgequal' value=$row[0]> $row[1]</option>";
				}
			}
		}
		echo '</select>';
	}
}

#=================================================================================================================

function html_select_subtree_internal($formname, $subtree) {
	
	if (!$subtree) {
		
		#radio buttons for 'entire tree', 'subtree' and 'pruned subtree'
		echo "<INPUT type='radio' CHECKED name=$formname value='tips'> I want information about the tips.<br>";
		echo "<INPUT type='radio' name=$formname value='both'> I want information about both internal nodes and the tips.<br>";
		echo "<INPUT type='radio' name=$formname value='internal'> I want information about the internal nodes only.<br>";
		
		} else {
		
		#Subtree
		switch ($subtree) {
			case "tips" :
				echo "<INPUT type='radio' CHECKED name=$formname value='tips'> I only want information about the tips.<br>";
				echo "<INPUT type='radio' name=$formname value='both'> I want information about both internal nodes and the tips.<br>";
				echo "<INPUT type='radio' name=$formname value='internal'> I only want information about the internal nodes only.<br>";
				break;
			case "both" :
				echo "<INPUT type='radio' name=$formname value='tips'> I only want information about the tips.<br>";
				echo "<INPUT type='radio' CHECKED name=$formname value='both'> I want information about both internal nodes and the tips.<br>";
				echo "<INPUT type='radio' name=$formname value='internal'> I only want information about the internal nodes only.<br>";			break;
			case "internal" :
				echo "<INPUT type='radio' name=$formname value='tips'> I only want information about the tips.<br>";
				echo "<INPUT type='radio' name=$formname value='both'> I want information about both internal nodes and the tips.<br>";
				echo "<INPUT type='radio' CHECKED name=$formname value='internal'> I only want information about the internal nodes only.<br>";
				break;
			default:
				echo "$subtree passed to html_select_subtree: 'all', 'subtree' and 'pruned' are only valid values";
				return;
		}
	}
}

#=================================================================================================================

function html_select_table_fields($db_handle, $formname, $form_all, $form_cancel,
	$qobjects, $qobjid, $sources, $ncheck) {
	
	# $ncheck check the first x  elements, If 0 then all unchecked, if undef then check all. Useful for development.
	
	if (!$db_handle || !$formname || !$sources || !$qobjects) {
		echo "html_select_table_fields: db_handle, formname, qobject and sources are required.";
		exit;	
		}

	if ($qobjid) {
		$qobj = get_obj($qobjects, $qobjid);
		} else {
		$qobj = $qobjects[count($qobjects) - 1];
		}
		
	# Existing queries
	$queries = $qobj['queries'];
	#$qsources = $qobj['sources'];
	#echo "qobjid: $qobjid<br>";
	
	# GET SOURCE
	$source = get_obj($sources, $qobj['sources'][0]);
	$dbloc = $source['dbloc'];
	$firstfield = $source['firstfield'];
	if (!$firstfield) $firstfield = 0;
	$i = $firstfield;
	
	// echo "source: <br>";
	// print_r($source);
	// echo "<br>";
	
	echo "<h3> Select " . $source['name'] . " fields to query by</h3>";
	
		# Web link
	if (array_key_exists('www', $source)) {
		echo "<a href='" . trim($source['www']) . "' target='_blank'>";
		echo "Click for information on " . $source['name'] . "</a><br><br>";
		}
	
	# ALL/SELECT RADIOS
	echo "<input type='radio' name=$form_all value=all> All fields<br>";
	echo "<input type='radio' CHECKED name=$form_all value=select> Select fields<br><br>";
	
	#PROBLEM WITH UPPER CASE FIELDNAMES
	# SEE http://php.net/manual/en/function.pg-fetch-result.php
	$str = "SELECT * FROM $dbloc LIMIT 1";
	#echo "$str<br>";
	$result = pg_query($db_handle, $str);
	$nf = pg_num_fields($result);
	
	$formname = $formname . "[]";
	
	while ($i < $nf) {
		#echo "i = $i<br>";
		$fname = pg_field_name($result, $i);
		if (!$queries) {
			if ($i - $firstfield <= $ncheck) {
				echo "<input type='checkbox' CHECKED name=$formname value=$fname> $fname<br>";
				} else {
				echo "<input type='checkbox' name=$formname value=$fname> $fname<br>";
				}
			} else {
			if (in_array($fname, $qobj['fields'])) {
				echo "<input type='checkbox' CHECKED name=$formname value=$fname> $fname<br>";
				} else {
				echo "<input type='checkbox' name=$formname value=$fname> $fname<br>";
				}
			}
			$i++;
		}
		
	echo "<br><hr>";
	html_cancel_select();
}

#=================================================================================================================

function html_output_biotable($db_handle, $output, $outputs, $sources) {
	
	echo '<script src="./scripts/table_utils.js" type="text/javascript"></script>';
	
	#echo "begin html_output_biotable<br>";
	
	$form_name = 'fields';
	#$form_all = 'allfields';
	$form_cancel = 'cancel';
	$form_objname = 'objname';
	$width = 250; 
	$n_options = 8;
		
	# $ncheck check the first x  elements, If 0 then all unchecked, if undef then check all. Useful for development.
	
	if (!$db_handle || !$form_name || !$form_cancel || !$form_objname || !$sources || !$outputs || !$output) {
		echo "html_output_biotable: missing arguments.";
		exit;	
		}

	$source = get_obj($sources, $output['sourceid']);
	#print_r($output);
	#echo "<BR>";
	$dtypes = get_source_dtypes($db_handle, $source);
	
	$outname = $output['name'];
	//echo $source['term'] . "<BR>";
	if (!$outname) $outname = get_next_name($outputs, $source['term']);
	//echo "$outname<BR>";
	$output['name'] = $outname;
	echo "Output name ";
	html_obj_name($form_objname, $output);
	echo "<BR>";
	html_output_dbformat($output);
	echo "<BR>";
	echo "<SELECT id='$form_name' name='$form_name' $disabled MULTIPLE size=8 style='width:" . $width . "px;'>";
	foreach ($dtypes as $dtype) {
		$fname = $dtype['fname'];
		echo "<OPTION value='$fname'>$fname</OPTION>";
	}
	echo "</SELECT>";

	echo "<BUTTON type='button' $disabled id='" . $form_name . "__allin' name='$form_name' onClick='add_all(this)'>>></BUTTON>";
	echo "<BUTTON type='button' $disabled id='" . $form_name . "_____in' name='$form_name' onClick='add_sel(this)'>></BUTTON>";
	echo "<BUTTON type='button' $disabled id='" . $form_name . "____out' name='$form_name' onClick='rem_sel(this)'><</BUTTON>";
	echo "<BUTTON type='button' $disabled id='" . $form_name . "_allout' name='$form_name' onClick='rem_all(this)'><<</BUTTON>";
	
	//fields in output
	$fields = $output['fields'];
	
	echo "<SELECT id='$form_name" . "_add' name='$form_name" . "_add[]' MULTIPLE size=$n_options style='width:" . $width . "px;'>";
			foreach (fields as $field) {
				$checked = "";
				"<OPTION value='$field'>";
			}
	echo "</SELECT>";
	
	echo "<BR>";

	echo "<hr>";
	html_cancel_select();
}

#================================================================================================================

	function html_select_source($sources, $term) {
		
		echo "<select name='$term", "_sid' class='sourceselect'>";
		foreach ($sources as $source) {
			if ($term == 'attribute') {
				if ($source['term'] == 'biotable' || $source['term'] == 'biogeographic' || $source['term'] == 'biorelational') 
					echo "<option value='", $source['id'] ,"'>", $source['name'], "</option>";
			} else {
				if ($source['term'] == $term) echo "<option value='", $source['id'] ,"'>", $source['name'], "</option>";
			}
			
		}
		echo "</select>";
		
	}
	
#================================================================================================================

function html_output_source($sources, $outputs) {

	echo "<h3>Select data to output</h3>";
	$fst = true;
	#Radio buttons for outputting different combinations of data
	
	foreach ($sources as $source) {
		if ($fst) {
			echo "<input type='radio' CHECKED name='output_sid' value='" . $source['id'] . "'> " . $source['name'] . "<br>";
			$fst = false;
			} else {
			echo "<input type='radio' name='output_sid' value='" . $source['id'] . "'> " . $source['name'] . "<br>";
			}
		}
	echo "<hr>";
	
	if ($outputs) {
		echo "<input type='radio' name='output_sid' value='manage'> Manage outputs<br>";
		echo "<input type='radio' name='output_sid' value='end'> Return data<br>";
		}
	echo "<input type = 'hidden' name ='stage' value='outputset'>";
	echo "<br>";
}

#================================================================================================================

function html_output_set($db_handle, $output, $outputs, $qobjects, $sources) {
	
	
	$output_id = $output['id'];
	//print_r($outputs);
	#echo "<br>outpit_id: $output_id<br>";
	//$output = get_obj($outputs, $outputid);
	//print_r($output);
	$source = get_obj($sources, $output['sourceid']);
	//print_r($source);
	
	$sterm = $source['term'];
	# Header
	echo "<h3>Output $sterm - " . $source['name'] . "</h3>";
	
	#echo $str; 
	
	# WWW link
//	if (array_key_exists('www', $source)) {
//		echo "<a href='" . trim($source['www']) . "' target='_blank'>";
//		echo "Click for information on " . $source['name'] . "</a><br><br>";
//		}
		
	switch ($sterm) {
		case "biotable" :
			# select traits to output
			html_output_biotable($db_handle, $output, $outputs, $sources);
			break;	
		case "biogeographic" :
			html_output_biogeographic($output, $outputs, $sources);
			break;	
		case "biotree" :
			html_output_biotree($db_handle, $output, $outputs, $sources);
			break;
		case 'biorelational' :
			html_output_biorelational($db_handle, $output, $outputs, $sources);
			break;
		}
	echo "<input type = 'hidden' name='stage' value='verify_output'>";
	echo "<input type = 'hidden' name='output_id' value='$output_id'>";
	echo "<br>";
	echo "<hr>";
	
}

	
#=======================================================================================================================

function html_select_sources($db_handle) {

	echo "<div class='margin5px'>";
	
	#ADD DESCRIPTION TO SOURCES, THEN EDIT get_sources
	
	#Select one or more data sources 
	$str = "SELECT obj.source_id, obj.name, t.name
		FROM source.source obj, biosql.term t
		WHERE obj.term_id = t.term_id
		AND t.name like 'bio%'
		AND obj.active = TRUE
		ORDER BY t.name";
	$result = pg_query($db_handle,$str);
	
	$title = 'Select one or more sources to work with. Hover over names to see data type.';
	
	echo "<table>";
	echo "<tr>";
	echo "<td class='query_title' title='$title'>Sources</td>";
	echo "<td class='query_form'>";
	echo "<SELECT id='select_sources' class='eb' name='qsources' SIZE=7  MULTIPLE='multiple'>";
	if(!$result) {
		echo "<OPTION>No Data Sets Available</OPTION>";
	} else {
		while ($row = pg_fetch_row($result)) {
			switch ($row[2]) {
				case 'biotable':
					$title = 'Tablular';
					break;
				case 'biotree':
					$title = 'Tree';
					break;
				case 'biogeographic':
					$title = 'Geographic';
					break;
				case 'biorelational':
					$title = 'Relational';
					break;
			}
			$img = 'tree.gif';
			echo "<OPTION value=$row[0] title='$title'>$row[1]</OPTION>";
		}
	}
	echo "</SELECT>";
	echo "</td>";
	echo "</tr>";
	echo "</table>";
	
	echo "<table>";
	echo "<tr>";
	echo "<td style='width: 420px'>";
	echo "Just press 'Next >' to select all";
	echo "</td>";
	echo "<td>";
	echo '<input id="submit-button" type="submit" value="Next >">';
	echo "</td>";
	echo "</tr>";
	echo "</table>";
	echo "</div>";
	
	}
	
#================================================================================================================

function html_select_source_network ($db_handle, $formname,$selobj) {

	if (!$selobj) {
	echo "html_select_source_network: selectobjects required";
	exit;
	}
	
	# GPDD can be queried by taxa, geography, and tabularly by biotope and source.
	echo "<input type='radio' name=$formname value='series'> Series Attributes<br>";
	echo "<input type='radio' name=$formname value='location_pt'> Series Location (Point)<br>";
	echo "<input type='radio' name=$formname value='location_bbox'> Series Location (Bounding Box<br>)";
	}


	
#=================================================================================================================

function html_query_treenodes ($nodefilter) {

	$checked = 'CHECKED';
	if ($nodefilter && $nodefilter[0] == false) {
		$checked = '';
	}
	echo "<input type='checkbox' name='treenodes[]' $checked value='tip'>Tip";
	$checked = 'CHECKED';
	if ($nodefilter && $nodefilter[1] == false) {
		$checked = '';
	}
	echo "&nbsp;<input type='checkbox' name='treenodes[]' $checked value='internal'>Internal<BR>";
	
}
	
#================================================================================================================

function html_select_names($formname, $qobj) {

	$nm = $qobj['namesmethod'];
	
	echo "<h3>How do you want to specify names</h3>";
	
	if (!$nm) $nm = 'all';
	
	switch ($nm) {
		case 'selectnames':
			echo "<INPUT type='radio' name=$formname value='all'> All names<br>";
			echo "<INPUT type='radio' CHECKED name=$formname value='selectnames'> Select names<br>";
			echo "<INPUT type='radio' name=$formname value='inputnames'> Input names<br>";
			break;
		case 'inputnames':
			echo "<INPUT type='radio' name=$formname value='all'> All names<br>";
			echo "<INPUT type='radio' name=$formname value='selectnames'> Select names<br>";
			echo "<INPUT type='radio' CHECKED name=$formname value='inputnames'> Input names<br>";
			break;
		case 'all':
			echo "<INPUT type='radio' CHECKED name=$formname value='all'> All names<br>";
			echo "<INPUT type='radio' name=$formname value='selectnames'> Select names<br>";
			echo "<INPUT type='radio' name=$formname value='inputnames'> Input names<br>";
			break;
		}
	echo "<hr>";
}



#================================================================================================================

function html_query_subtree_method($mode = 'subtree') {
	
	$vals = array('subtree','lca','all','selected');			
		
	foreach ($vals as $val) {
		switch ($val){
				case 'all': 
					$label = "All";
					$title = "Return all names in tree that match filters";
					break;
				case 'lca': 
					$label = "LCA";
					$title = "Return the least common ancestor of input names that match filters";
					break;
				case 'subtree': 
					$label = "LCA subtree";
					$title = "Return names within the tree defined by the least common ancestor of input names that match filters";
					break;
				case 'selected':
					$label = "Selected";
					$title = "Return input names only";
					break;					
			}
			echo "<SPAN title='$title'><INPUT type='radio' ";
			if ($val == $mode) echo " CHECKED ";
			echo "name='subtree' value='$val' > $label</SPAN>";
		}
	echo "<br>";
	}

#=================================================================================================================	
	
function html_table_names_check($table, $column, $names) {
	
	$check = table_names_check($table, $column, $names);
	
	$notgood = $check[1];
	
	debug_print_array($notgood,"Not Good");
	
	if (count($check[1]) > 0) {
	
		$str = "No data was returned for taxa : ";
		$f = 1;
		
		foreach ($check[1] as $fail) {
			if ($f == 1) {
				$str = $str . $fail;
				$f = 0;
				} else {
				$str = $str . ", " . $fail; 
				}
			}
		echo "$str.<br>";
		} else {
		echo "All binomials matched<br>";
		}
	}



#=================================================================================================================

function html_tree_level_options($db_handle, $tree, $parent_id, $qnames, $indentchar, $indentlevel, $indentlimit) {

	# Get labels for next level down
	$statement = "SELECT c.node_id, c.label
		FROM biosql.node n,
		biosql.node_path np,
		biosql.node c
		WHERE n.node_id = $parent_id
		AND np.distance = 1
		AND np.parent_node_id = n.node_id
		AND np.child_node_id = c.node_id;";

	$result = pg_query($db_handle,$statement);
	
	# WAS ''
	$indent = '';
	
	if ($indentlevel <= $indentlimit) {
		for ($i = 1; $i <= $indentlevel; $i++) {
			$indent = $indent . $indentchar;
		} 
	} else {
		$indent = $indentlevel;
		$n = $indentlimit - strlen($indentlevel);
		for ($i = 1; $i <= $n; $i++) {
			$indent = $indent . $indentchar;
		}
	}

	while ($row = pg_fetch_row($result)) {
		
		$child_id = $row[0];
		$name = $row[1];
		$name = $indent . $name;
		if (in_array($row[1], $qnames)) {
			echo "<OPTION SELECTED>$name</OPTION>";
			} else {
			echo "<OPTION>$name</OPTION>";
			}
		$indentlevel++;
		html_tree_level_options($db_handle, $tree, $row[0], $qnames, $indentchar, $indentlevel, $indentlimit);
		$indentlevel--;
	}
	
}

#=================================================================================================================
	
function html_write($db_handle, $config, $names, $qobjects, $outputs, $sources) {

	echo "<h3>Entangled Bank Download</h3>";
	
	#UNIQE ID FOR OUTPUT TO PREVENT FILE NAME CONFLICTS
	$oid = substr(md5(uniqid()),0,4);
	$_SESSION['oid'] = $oid;
	
	# ZIP, WRITE README THEN DELETE
	$files_to_zip = array();
		
	# WRITE OUTPUT
	$outputs = write($db_handle, $config, $qobjects, $names, $outputs, $sources, $oid);
	#print_r($outputs);
	
	# ADD OUTPUTS TO README AND FILES_TO_ZIP
	#echo "add outputs to readme and files to zip<br>";
	foreach ($outputs as $output) {
		$outfiles = $output['outfiles'];
		if ($output['term'] == 'biotree') $outfiles[0] = $config['out_path'] . "/" . $outfiles[0];
		$files_to_zip = array_merge($files_to_zip, $outfiles);
	}
	//print_r($files_to_zip);
	#echo "<br>outputs added readme and files to zip<br>";
	
	# WRITE README
	$readme = write_readme($qobjects, $outputs);
	#$write_path = substr($config['tmp_path'], strpos($config['tmp_path'],'/') + 1);
	$write_path = $config['out_path'];
	#echo "write path $write_path<br>";
	$fn = $write_path . "/readme_$oid.txt";
	$fh = fopen($fn, 'w') or die("can't open file $fn: $php_errormsg");
	fputs($fh, $readme);
	fclose($fh) or die ($php_errormsg);
	
	#echo "readme $fn written<br>";
	# add readme to zip list
	array_push($files_to_zip, $fn);
	$zn = "ebdata_$oid.zip";
	#echo "Zipping files to $zn<br>";
	#print_r($files_to_zip);
	#echo "<br>";
	
	$res = create_zip($files_to_zip, $write_path . '/' . $zn, true);
	
	#echo "res: $res";
	
	If ($res === false) {
		echo "php_interface_subs::html_write: zip file creation failed";
		return 0;
		} else {
		echo "Right-click and 'Save as' to download Entangled Bank data zip file ";
		echo "<a href='http://" . $config['host'] . '/' . $config['tmp_path'] . '/' . $zn;
		echo "'> $zn</a><br><br>";
		$_SESSION['zip_to_delete'] = $zn;
		echo "<hr>";
			
		# Delete files_to_zip
		foreach ($files_to_zip as $file) {
			#echo "unlinking $file<br>";
			unlink($file);
		}
		return $zn;
		}
	}

#=================================================================================================================	

	function html_query_operator_image($op, $class) {
		
		if ($class == 'non-active') {
			$class = 'query_type_button_non_active_interquery';
		} else {
			$class = 'query_type_button_active_interquery';
		}
		//echo "$op";
		
		switch ($op) {
			case 'UNION': 
				$img = "union.gif";
				break;
			case 'INTERSECT': 
				$img = "intersect.gif";
				break;
			case 'EXCEPT': 
				$img = "except.gif";
				break;
			default:
				$img = "unset-interquery.gif";
				$op = 'Unset Interquery Operator';
				break;
		}
		
		echo "<img src='./image/$img' alt='$op' title='$op' class='$class'/>";
		
	}
	
#=================================================================================================================	
	
	
	
?>