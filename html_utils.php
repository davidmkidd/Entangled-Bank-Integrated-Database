<?php

#Filename: entangled_bank_html_utils.php
#
# Contains html programs for the Entangled Bank:
#

	
#=======================================================================================================================

function html_all_tree_names ($form_objname, $form_treenodes, $form_not, $form_qoperator, $form_cancel,
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
	}
	
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

function html_cancel_select() {
	//echo "<input type='button' name=$formname value='yes'> Cancel<br><br>";
	echo "<input type='radio' CHECKED name=cancel value=no> Continue";
	echo "<input type='radio' name=cancel value=yes> Cancel ";
	}
	
#=======================================================================================================================

function html_entangled_bank_header($eb_path, $html_path, $share_path, $restart) {
	#echo "restart $restart<br>";
	if($restart ) $restart = true;
	#if($restart !== false) $restart = true;
	#echo "restart $restart<br>";
	echo '<hr>';
	echo '<img src=' . $share_path . 'Entangled-Bank_small.gif alt="Banner" /><br>';
	echo 'Serving linked phylogenetic, spatial, trait and ecological data since 2010<br>';
	echo "<a href='" . $html_path . "index.php' target='_blank'>Home</a>";
	echo " | ";
	echo "<a href='" . $html_path . "help.php' target='_blank'>Help</a>";
	echo " | ";
	echo "<a href='" . $html_path . "examples.php' target='_blank'>Examples</a>";
	if ($restart == true) { 
		echo " | ";
		echo "<a href='" . $eb_path . "restart.php'> New Session</a>";
	}
	echo ' | v0.4 (23 May 2011)<br>';
	echo '<hr>';
}

#=======================================================================================================================

function html_entangled_bank_footer() {

	echo '<hr />';
	echo '&copy Center for Population Biology, Division of Biology, Imperial College London, 2011.<br>';
	echo '<i>Open source powered using BioPerl, BioSQL, PhyloDB, PostrgreSQL, PostGIS, OGR, PHP and Apache.</a></i>';
	echo '<hr />';
	echo "<i><a href='mailto:d.kidd@imperial.ac.uk'>Email bugs and comments to David Kidd.</a></i><br>";
	echo '<body/>';
	echo '</html>';
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
	# NAME SUGGESTIONS - NOT IMPLEMENTED
	#if ($invalidnames) html_suggest_names($db_handle, $biodb, "tree", $tree,$invalidnames);
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
	
function html_obj_name($formname, $obj) {
	# Set Obj name
	if ($obj['name']) {
		$name = $obj['name'];
	} else {
		$name = "";
	}
	echo "<INPUT type='text' name=$formname value=$name>";
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
	$form_objname = 'objname';
	 	
	//$output = get_obj($outputs, $outputid);
	$source = get_obj($sources, $output['sourceid']);
	# print_r($source);
	 
	$subtree = $output['subtree'];
	$format = $output['format'];
	$brqual = $output['brqual'];
	$outname = $output['name'];
	
	if (!$outname) {
		$outname = get_next_name($outputs, $source['term']);
		$output['name'] = $outname;
	}
	echo "Name ";
	html_obj_name($form_objname, $output);
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
	$term = $qobject['term'];
//	echo "$qobjid<br>";
//	print_r($qobjects);
	//echo "<br>";
    //echo "<br>qid: $qobjid<br>";
   	//echo "html qset: $term<br>";
	
	# Tool
	switch ($term) {
		
		case 'bionames' :
			html_query_bionames($db_handle, $qobject, $qobjects, $sources);
			echo "<input type = 'hidden' name ='stage' value='qverify'>";
			break;
			
		case 'biogeographic':			
			html_query_biogeographic($db_handle, $qobject, $qobjects, $sources);
			echo "<input type='hidden' name='stage' value='qverify'>";
			break;

		case 'biotree':
		case 'biotable':
			if ($term == 'biotree') {
				echo "<h3>Tree query</h3>";
			} else {
				echo "<h3>Attribute query</h3>";
			}
			# Select Source
			html_query_sources($db_handle, $qobject, $sources);
			echo "<hr>";
			html_reset_form();
			echo " | ";
			html_cancel_select('cancel');
			echo "<input type='hidden' name='stage' value='qset2'>";
			break;

		case 'biotemporal':
			html_query_biotemporal($db_handle, $qobject, $qobjects, $sources, $names);
			echo "<input type='hidden' name='stage' value='qverify'>";
			break;
			
		default:
			echo "Invalid selectobj: term.<br>";
			break;
				
		}
	echo "<input type = 'hidden' name ='qobjid' value=$qobjid>";
}


#=======================================================================================================================	

function html_query_set2($db_handle, $qobjid, $qobjects, $sources, $names) {
	
	$qobject = get_obj($qobjects, $qobjid);
	//print_r($qobjects);
	$term = $qobject['term'];
	switch($term) {
		case 'biotable':
			#echo "html_table_query2<br>";
			html_query_biotable($db_handle, $qobject, $qobjects, $sources, $names);
			echo "<input type = 'hidden' name ='stage' value='qverify'>";
			echo "<input type = 'hidden' name ='qobjid' value=$qobjid>";
			break;
		case 'biotree':
			echo "<h3>Tree query</h3>";
			html_query_biotree($db_handle, $qobject, $sources, '.', 1000000);
			html_query_footer($qobject, $qobjects);
			echo "<input type = 'hidden' name ='stage' value='qverify'>";
			echo "<input type = 'hidden' name ='qobjid' value=$qobjid>";
			break;
		default:
			echo "Invalid selectobj: term.<br>";
			break;	
	}
}

#=======================================================================================================================	
	
	function html_query_errs ($qobject) {
		
		if ($qobject['errs']) {
			$errs = $qobject['errs'];
			echo "<FONT COLOR='red'>";
			echo "Error";
			if (count($errs) > 1) echo "s";
			echo ": "; 
			$i = 1;
			foreach ($errs as $key => $value) {
				if ($i > 1) echo ", ";
				echo "($i) $value";
			}
			echo "</FONT><br>";
		}
	}
	
#=======================================================================================================================	
	
	function html_query_footer($qobject, $qobjects) {
		
		//echo count($qobjects) . " qobjects<br>";
		if (count($qobjects) > 1) {
			echo "<hr>";
			html_query_operator($qobject);
		}
		echo "<hr>";
		html_reset_form();
		echo " | ";
		html_cancel_select();
	}
	
#================================================================================================================

function html_query_biogeographic ($db_handle, $qobject, $qobjects, $sources) {
	
	# Bounding box only
	if (!$qobject or !$sources) {
		echo "html_select_spatial: qobject and sources required";
		exit;
		}
	//print_r($sources);
	echo "<h3>Geographic query</h3>";
	
	html_query_errs($qobject);
	html_query_heading($qobject);
	echo '<br>';
	html_query_sources($db_handle, $qobject, $sources);
//	print_r($qobject);
//	echo "<br>";
	
	$qname = $qobject['name'];
	
	# Delete errors from qobj
	//if ($errs) remove_element($qobject, 'errs');
	$bbox = $qobject['bbox'];
	
	if (!$bbox) {
		$bbnorth = +90;
		$bbsouth = -90;
		$bbwest = -180;
		$bbeast = +180;
		$s_overlay = 'overlap';
		} else {
		$bbnorth = $bbox['bbnorth'];
		$bbsouth = $bbox['bbsouth'];
		$bbeast = $bbox['bbeast'];
		$bbwest = $bbox['bbwest'];
		$s_operator = $bbox['s_operator'];
		}
	# div tags for OpenLayers
	
	# Retreiving spatial data from javascript part 1
	#echo '<form name="spatialobj" method="POST" action="dk_inteface.php">';
	#echo '<input type="hidden" name="spatialobj">';
	#echo '</form>';
	
	#echo '<div id="map" align="left"</div><br>';
	#echo '<textarea id="wkt" name="wkt" rows="3" cols="40"></textarea><br>';

		
	#echo 'Use the tools to draw new polygons, lines, and points.
	#		After drawing some new features, hover over a feature to see the
	#		serialized version below.';
			
	# Retreiving spatial data from javascript part 2
	// echo '<form name="spatialobj" method="POST" action="dk_inteface.php">';
	// echo '<input type="hidden" name="spatialobj">';
	// echo '</form>';
	#echo '<a href="javascript:sendData();">Query on Spatial Object</a>';
	
	# BOUNDING BOX
	echo "Decimal degree bounding box ";
	#West
	echo " W ";
	echo "<INPUT TYPE='text' size=8 NAME=bbwest VALUE=$bbwest /> ";
	# North
	echo "  N ";
	echo "<INPUT TYPE='text' size=8 NAME=bbnorth VALUE=$bbnorth /> ";
	#East
	echo " E ";
	echo "<INPUT TYPE='text' size=8 NAME=bbeast VALUE=$bbeast />  ";
	# South
	echo " S ";
	echo "<INPUT TYPE='text' size=8 NAME=bbsouth VALUE=$bbsouth /> ";


	echo "<br>To query across longitude +/-180&deg;  
		enter the larger longitude in W and the smaller in E<br>";

	# echo "<FONT color='Red'> (INSIDE is not supported over -180/+180 longitude)</FONT>.<br><br>";
	
	# Overlay
	echo "Overlay <input type='radio'";
	if ($s_operator == 'within') echo " CHECKED";
	echo " name=s_operator value='within'> WITHIN";
	echo "<input type='radio'";
	if (!$s_operator || $s_operator == 'overlap') echo " CHECKED";
	echo " name=s_operator value='overlap'> OVERLAP<br>";
	//echo "<br>";
	html_query_footer($qobject, $qobjects);
}

	

#=======================================================================================================================	

	function html_query_heading($qobject) {
		
		$status = $qobject['status'];
		$term = $qobject['term'];
		
		switch ($status) {
			case 'new':
				echo "New $term query ";
				break;
			case 'complete':
				echo "Editing $term query ";
				break;
			case 'invalid':
				echo "Invalid $term query ";
				break;
			default:
				echo "qset: unrecognised query status: " . $status;
				return;
				break;
			}
		html_obj_name('objname', $qobject);
		html_query_not('querynot', $qobject);
		#echo "<br>";
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
	
//	echo "<br>qobject:<br>";
//	print_r($qobject);
//	echo "<br>";	

	echo "<h3>Names query</h3>";
	html_query_errs($qobject);
	html_query_heading($qobject);
	echo '<br>';
	html_query_sources($db_handle, $qobject, $sources);
	#echo '<br>';
	
	echo "One name on each line or ";
	
	if ($qobject['allnames'] == 'false') {
		echo "<input type='checkbox' CHECKED name='allnames' value='true'> All names<br>";
		} else {
		echo "<input type='checkbox' name='allnames' value='false'> All names<br>";
		}
		# Get valid names and errors
	if ($qobject['validnames']) $valid = $qobject['validnames'];
	if ($qobject['invalidnames']) $invalid = $qobject['invalidnames'];
	
	//echo("valid: " . empty($valid) . ", " . isset($valid) . ", " .!$valid . "<br>");
		
	# Empty text area
	if (empty($valid) && empty($invalid)) {
		echo "<textarea name='taxa' rows='10' cols='40' wrap='soft'></textarea>";
	} else {
	
	if ($valid) {
		#write list of validnames
		echo "Valid Names<br>";
		$mystr = "";
		foreach ($valid as $name) $mystr = $mystr . "$name\n";
		echo "<textarea name='taxa2' rows='7' cols='40' wrap='soft'>" . chop($mystr, "\n") . "</textarea><br><br>";
		echo "Valid names are checked on resubmittion so can be edited or deleted<br>";
		}

	if ($invalid) {
		#write list of invalidnames
		echo "Invalid Names<br>";
		$mystr = "";
		foreach ($invalid as $name) {
			$mystr = $mystr . "$name\n";
			}
		echo "<FONT color=red><textarea name='taxa' rows='7' cols='40' wrap='soft' style='color:#FF0000'>"
			. chop($mystr, "\n") . "</textarea></FONT><br><br>";
		echo "Edit or delete invalid names and resubmit<br>";
		}
	}
	echo "<br>";
	
	# Nodes in trees
//	html_subtree_select_method('subtree');
//	html_select_tree_nodes($qobject['treenodes']);
//	echo " (no effect if no source trees)<br><br>";

	unset($qobject['validnames']);
	unset($qobject['invalidnames']);
	
	# Footer
	html_query_footer($qobject, $qobjects);
}
	


	#===========================================================================================================
	
function html_query_nsources ($qobject, $sources){

	# How many sources name required to be in required
	//print_r($sources);
	echo "in ";
	
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
	echo "<INPUT type=text name='nsources' $disabled size=3 value=$n>";
	echo " sources";
}

#=======================================================================================================================
	
function html_query_nseries ($db_handle, $qobject, $sources, $names){

	# How many sources name required to be in required
	//print_r($sources)bj;
	# GPDD HARDCODE	
	echo "<INPUT type=checkbox $check id='NSeries_query' name='NSeries_query'
		 onClick='show_nseries(this);'> NSeries ";
	
	echo "<DIV id='nseries_div' style='display: none;'>";
	
	$nop = $qobject['nseries_operation'];
	
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

	if ($qobject['nseries']) {
		$n = $qobject['nseries'];
	} else {
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
		$n = $row[0];
	}
	
	echo "<INPUT type=text id='nseries' name='NSeries_count' size='3' value='$n'>";
	echo "($n) series";
	echo "</DIV>";
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

function html_query_not($formname, $qobject) {
	if ($qobject['querynot']) {
		echo "<input type=checkbox CHECKED name=$formname value='not'> NOT";
		} else {
		echo "<input type=checkbox name=$formname value='not'>NOT";
		}
	}
	
#=======================================================================================================================

function html_query_null($qobj) {
	if ($qobj['querynull'] and $qobj['querynull'] == 1) {
		echo "<input type=checkbox CHECKED name='querynull' value='0'>Include null value rows";
		} else {
		echo "<input type=checkbox name='querynull' value='1'>Include null value rows";
		}
	}


#=======================================================================================================================

function html_query_operator($qobject) {
	
	echo "Between query operator ";
	
	$op = $qobject['queryoperator'];
	
	if (!$op || $op == 'AND') {
		echo "<input type=radio CHECKED name='queryoperator' value=INTERSECT> AND (INTERSECT)";
		} else {
		echo "<input type=radio name='queryoperator' value=INTERSECT> AND (INTERSECT)";
		}
	if ($op == 'OR') {
		echo "<input type=radio CHECKED name='queryoperator' value=UNION> OR (UNION)";
		} else {
		echo "<input type=radio name='queryoperator' value=UNION> OR (UNION)";
		}
	if ($op == 'MINUS') {
		echo "<input type=radio CHECKED name='queryoperator' value=EXCEPT> MINUS (EXCEPT)<br>";
		} else {
		echo "<input type=radio name='queryoperator' value=EXCEPT> MINUS (EXCEPT)<br>";
		}
	}
	
		
#=================================================================================================================
	
	function html_query_select_options($db_handle, $str, $fname, $fields, $n_options, $width) {
		
		//HTML select box set with 'in' and 'out' controls
		// SQL must return two fields the value to pass and the item to display
		if ($fields && in_array($fname, $fields)) {
			$check = ' CHECKED ';
			$disabled = '';
		} else {
			$check = '';
			$disabled = "DISABLED='disabled'";
		}
		
		//echo "$str<br>";
		$res2 = pg_query($db_handle, $str);
		if (pg_num_rows($res2) < $n_options) $n_options = pg_num_rows($res2);
		echo "<SELECT id='$fname' name='$fname' $disabled MULTIPLE size=$n_options style='width:" . $width . "px;'>";
		while ($row2 = pg_fetch_row($res2)) {
			echo "<OPTION value='$row2[0]'>$row2[1]</OPTION>";
		}
		echo "</SELECT>";

		echo "<BUTTON type='button' $disabled id='" . $fname . "__allin' name='$fname' onClick='add_all(this)'>>></BUTTON>";
		echo "<BUTTON type='button' $disabled id='" . $fname . "_____in' name='$fname' onClick='add_sel(this)'>></BUTTON>";
		echo "<BUTTON type='button' $disabled id='" . $fname . "____out' name='$fname' onClick='rem_sel(this)'><</BUTTON>";
		echo "<BUTTON type='button' $disabled id='" . $fname . "_allout' name='$fname' onClick='rem_all(this)'><<</BUTTON>";
		
		echo "<SELECT id='$fname" . "_add' name='$fname" . "_add[]' MULTIPLE size=$n_options style='width:" . $width . "px;'>";
		for ($j = 0; $j < $n_options; $j++) "<OPTION value='$j'>";
		echo "</SELECT>";
	}
	
		
#=======================================================================================================================

function html_query_sources ($db_handle, $qobject, $sources) {
	
	# SOURCES QUERY IS APPLIED TO
	# 1 table or tree, 
	# >= 1 names, spatial or temporal

	$qterm = $qobject['term'];
	$qsources = $qobject['sources'];
	//echo "qsources ";
//	print_r ($qobject);
//	echo "<br>";
//	print_r ($sources);
	//echo "qterm: $qterm<br>";
	//echo "Sources ";
	# Select sources heading
	if ($qterm == 'biogeographic' || $qterm == 'bionames' || $qterm == 'biotemporal') {
		
		echo '<script type ="text/javascript">
			function checkAll(field)
			{
			for (i = 0; i < field.length; i++)
				field[i].checked = true;
			}
			function uncheckAll(field)
			{
			for (i = 0; i < field.length; i++)
				field[i].checked = false;
			}
			</script>';
		
		# 'select all' and 'clear selection' buttons.
		$form_id = 'qsources';
		$formname = "qsources[]";
		echo "<input type=button name='allbtn' value='all' onClick='checkAll(document.ebankform." . $form_id . ")'> ";
		echo "<input type=button name='clearbtn' value='clear' onClick='uncheckAll(document.ebankform." . $form_id . ")'>";
		echo "<br>";
		} else {
			$formname = 'qsources';
		}
	
	# SOURCES LIST
	$first = true;
	$disabled = '';
	if (count($sources) == 1) $disabled = "disabled='disabled'";
	
	foreach ($sources as $source) {
	
		$sterm = $source['term'];

		switch (true) {
		
			# SINGLE SOURCE - RADIO BUTTONS
			case (($qterm == 'biotable' && $sterm == 'biotable')
				or ($qterm == 'biotable' && $sterm == 'biorelational')
				or ($qterm == 'biotree' && $sterm == 'biotree') 
				or ($qterm == 'biotable' && $sterm == 'biogeographic' and ($source['firstfield'] and $source['firstfield'] != -1))
				):
					
					if (!$qsources) {
						if ($first) {
							echo "<input type=radio CHECKED name=$formname value='"
								. $source['id'] . "'> " . $source['name'] . "<br>";
							$first = false;
							} else {
							echo "<input type=radio name=$formname value='" . $source['id'] . "'> " . $source['name'] . "<br>";
							}
						} else {
						#QSOURCES SET
						if (in_array($source['id'], $qsources)) {
							echo "<input type=radio CHECKED name=$formname value='"
								. $source['id'] . "'> " . $source['name'] . "<br>";
							} else {
							echo "<input type=radio name=$formname value='" . $source['id'] . "'> " . $source['name'] . "<br>";
							}
						}
				break;
			
			# MULTIPLE CHECKBOXES
			case ($qterm == 'biogeographic' && $sterm == 'biogeographic'):
				if (!$qsources) {
					if ($first) {
						echo "<input type=checkbox CHECKED name=$formname id=$form_id value='"
							. $source['id'] . "'> " . $source['name'] . "<br>";
							$first = false;
						} else {
						echo "<input type=checkbox CHECKED name=$formname id=$form_id value='"
							. $source['id'] . "'> " . $source['name'] . "<br>";
						}
					} else {
					if (in_array($source['id'], $qsources)) {
						echo "<input type=checkbox CHECKED name=$formname id=$form_id value='"
							. $source['id'] . "'> " . $source['name'] . "<br>";	
						} else {
						echo "<input type=checkbox name=$formname id=$form_id value='"
							. $source['id'] . "'> " . $source['name'] . "<br>";
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
					 value='26'> Global Population Dynamics Database (Point)<br>";
				if (!$qsources || ($source['id'] == 23 && in_array(27, $qsources))) {
					$checked = 'CHECKED';
				} else {
					$checked = "";
				}
				echo "<input type=checkbox $checked name=$formname id=$form_id
					 value='27'> Global Population Dynamics Database (Bounding Box)<br>";				
				break;
			
			# ALL SOURCES CHECKBOX
			case ($qterm == 'bionames'):
				#echo "formname: $formname<br>";
				if (!$qsources) {
					echo "<input type=checkbox CHECKED name=$formname id=$form_id value='"
						. $source['id'] . "'> " . $source['name'] . "<br>";
					} else {
					if (in_array($source['id'], $qsources)) {
						echo "<input type=checkbox CHECKED name=$formname id=$form_id value='"
							. $source['id'] . "'> " . $source['name'] . "<br>";	
						} else {
						echo "<input type=checkbox name=$formname id=$form_id value='"
							. $source['id'] . "'> " . $source['name'] . "<br>";
						}
					}
				break;
				
			case ($qterm == 'biotemporal'):
				// GPDD HARDCODE
				if ($source['name'] == "Global Population Dynamics Database") 
					echo "<input type=checkbox CHECKED $disabled name=$formname id=$form_id value='"
							. $source['id'] . "'> " . $source['name'] . "<br>";
				break;
				
			default:
				// echo "html_query_sources: $qtype on $stype not supported";
				// exit;
				break;
			}
		}
		if ($qterm == 'biogeographic' || $qterm == 'bionames' || $qterm == 'biotemporal') {
			html_query_nsources ($qobject, $sources);
		}
		echo"<br>";
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
	//print_r($qobject);
	# Get source
	$source = get_obj($sources, $qobject['sources'][0]);
	//print_r($source);
	$dbloc = $source['dbloc'];
	echo "<BIG>" . $source['name'] . " </BIG>";;
	html_www($source);
	
	html_query_heading($qobject);
	html_query_null($form_null, $qobject);
	echo "<HR>";
	#echo "<br>";
	if ($qobject['queryoperator']) {
		html_query_operator($qobject);
	}
	
	
	
	# Names passed
	if ($names) $arr = array_to_postgresql($names, 'text');
	
	# Fields in query
	if ($qobject['fields']) {
		$fields = $qobject['fields'];
		$qfieldids = array();
		for ($i = 0; $i < $nf; $i++) {
			$fname = pg_field_name($res, $i);
			if (in_array($fname, $fields) == True) {
				array_push($qfieldids, $i);
			}
		}
	}
	
	//echo "<BUTTON type='button' name='selectall' onClick='selAll()'>*</button><br>";
	
	# FIELD TYPES
	$dtypes = get_source_dtypes($db_handle, $source);
	//print_r ($dtypes);
	// SELECT BOX SIZES
	$n_options = 8;
	$width = 250;
	
	foreach ($dtypes as $dtype) {
		
		$fname = $dtype['fname'];
		$type = $dtype['dtype'];
		
		// FIELD TYPE OVERRIDES
		//if ($dtype['dtype'] == 'namefield' && $dtype['fname'] = 'binomial') $type = 'gpdd';
		//if ($dtype['dtype'] == 'namefield' && $dtype['fname'] = 'msw05_binomial') $type = 'lookup';
		//echo "fname $fname, dtype $type :";
		
		// Existing query
		if ($fields && in_array($fname, $fields)) {
			$check = ' CHECKED ';
		} else {
			$check = '';
		}
		
		if ($type !== 'gpdd') {
			//echo "fname: $fname, ftype: $dtype, dfname: $dfname<br>";
			echo "<INPUT type=checkbox $check id='$fname" . "_query' name='$fname" .
			 	"_query' onClick='showfield(this)';'>$fname ";
			echo "<DIV id='$fname" . "_div' style='display: none;'>";
		} 
		
		
		switch ($type) {
			
			case "rangefield":
				
				//GPDDHARDCODE
				if ($source['id'] <> 23) {
					# Get min and max of all names
					$str = 'SELECT MIN("' . $fname . '"), MAX("' . $fname . '")
						FROM ' . $dbloc;
					#$res_all = pg_query($db_handle, $str);
					#$row_all = pg_fetch_row($res_all);
					#Get min and max of given names
					if ($names) $str = $str . " WHERE " . $source['namefield'] . " = ANY($arr)";
				} else {
					$str = "SELECT MIN(m.\"$fname\"), MAX(m.\"$fname\")
						FROM gpdd.main m, gpdd.taxon t
						WHERE m.\"TaxonID\" = t.\"TaxonID\"";
					if ($names) $str = $str . " AND t.binomial = ANY($arr)";
					//echo "$str<br>";
					#$res_all = pg_query($db_handle, $str);
					#$row_all = pg_fetch_row($res_all);
				}
				$res_names = pg_query($db_handle, $str);
				$row_names = pg_fetch_row($res_names);			
				# Get user set min and max
				#$vals = query_vals($qobject, $fname);
				
				if (!$vals) {
					if (!$names) {
						echo " <INPUT type='text' name='$fname" . "_min'" .
							" id='" . $fname . "_min' disabled=true size=8 value=$row_names[0]>";
						echo " &ndash <INPUT type='text' name='$fname" . "_max'" .
							" id='" . $fname . "_max' disabled=true align='right' size=8" . 
							" value='$row_names[1]'>";
						} else {
						echo " <INPUT name='$fname" . "_min'" .
							" id='" . $fname . "_min' disabled=true size=8 value=$row_names[0]>";
						echo " &ndash <INPUT type='text' name='$fname" . "_max'" .
							" id='" . $fname . "_max' disabled=true size=8" . 
							" value='$row_names[1]'>";
						}
					} else {
					# vals
					if (!$names) {
						echo " (min $row_names[0]) <INPUT type='text' name='$fname" . "_min'" .
						 	" id='" . $fname . "_min' size=8 value=$vals[0]>";
						echo " &ndash <INPUT type='text' name='$fname" . "_max'" .
							" id='" . $fname . "_max' size=8 value='$vals[1]'> (max $row_all[1])";
						} else {
						echo " (min $row_all[0]/$row_names[0]) <INPUT type='text' name='$fname" . "_min'" .
							" id='" . $fname . "_min' size=8 value=$vals[0]>";
						echo " &ndash <INPUT type='text' name='$fname" . "_max'" .
							" id='" .$fname . "_max' size=8 value='$vals[1]'> (max $row_all[1]/$row_names[0])";
						}
					}
				break;
			
			case "classfield":

				$str = 'SELECT DISTINCT "' . $fname . '"
					FROM ' . $dbloc . ' ORDER BY "' . $fname . '"';
				//echo "str: $str<br>";
				$res_all =  pg_query($db_handle, $str);
				$vals = query_uvals($qobject, $fname);
				
				// Toggle box
				if ($fields && in_array($fname, $fields)) {
					$check = ' CHECKED ';
				} else {
					$check = '';
				}
				// Toggle box
				echo "<INPUT type=checkbox $check name='$fname" . "_query' onClick='checkboxes(this)';'>$fname: ";
				
				// Class boxes
				while ($row3 = pg_fetch_row($res_all)) {
					if ($row3[0] != '') {
						//echo "row3: $row3[0]<br>";
						if (!$vals) {
							echo "<INPUT type=checkbox name=$fname" . 
								"_$row3[0] class=$fname id='$fname" . "_$row3[0]' disabled=true>$row3[0]" . " ";
						} else {
							if (in_array($row3[0], $vals)) {
								echo "<INPUT type=checkbox CHECKED name=$fname" . 
								"_$row3[0] class=$fname id='$fname" . "_$row3[0]'>$row3[0]" . " ";
							} else {
								echo "<INPUT type=checkbox name=$fname" . 
								"_$row3[0] class=$fname id='$fname" . "_$row3[0]'>$row3[0]" . " ";
							}
						}
					}
				}
				//echo "<br>";
				break;
				
			case 'gpdd':
				switch ($fname) {
					// GPDD HARDCODE
					case 'NSeries':
						html_query_nseries($db_handle, $qobject, $sources, $names);
						break;
					case 'Author':
					case 'Year':
					case 'Title':
					case 'Reference':
					case 'Availability':
					case 'Notes':
							echo "<INPUT type=checkbox $check id='$fname" . "_query' name='$fname" .
			 					"_query' onClick='showfield(this)';'>$fname (ref)";
							echo "<DIV id='$fname" . "_div' style='display: none;'>";
							$str = "SELECT DISTINCT s.\"$fname\", s.\"$fname\"
									FROM gpdd.taxon t, gpdd.main m, gpdd.datasource s
								 	WHERE t.\"TaxonID\" = m.\"TaxonID\"
								 	AND m.\"DataSourceID\" = s.\"DataSourceID\"
								 	AND t.binomial IS NOT NULL
								 	ORDER BY s.\"$fname\"";
							//echo "$str<br>";
							if ($arr) $str = $str . " WHERE t.binomial = ANY($arr)";
							html_query_select_options($db_handle, $str, $fname, $fields, $n_options, $width);
							echo "<br></DIV>";
						break;
					case 'TaxonomicPhylum':
					case 'TaxonomicClass':
					case 'TaxonomicOrder':
					case 'TaxonomicFamily':
					case 'TaxonomicGenus':
					case 'binomial':
					case 'CommonName':
							echo "<INPUT type=checkbox $check id='$fname" . "_query' name='$fname" .
			 					"_query' onClick='showfield(this)';'>$fname (taxon)";
							echo "<DIV id='$fname" . "_div' style='display: none;'>";
							$str = "SELECT DISTINCT t.\"$fname\", t.\"$fname\"
									FROM gpdd.taxon t
								 	WHERE t.binomial IS NOT NULL
								 	ORDER BY t.\"$fname\"";
							if ($arr) $str = $str . " WHERE t.binomial = ANY($arr)";
							html_query_select_options($db_handle, $str, $fname, $fields, $n_options, $width);
							echo "<br></DIV>";
						break;
					case 'HabitatName':
					case 'BiotopeType':
							echo "<INPUT type=checkbox $check id='$fname" . "_query' name='$fname" .
			 					"_query' onClick='showfield(this)';'>$fname (biotope)";
							echo "<DIV id='$fname" . "_div' style='display: none;'>";
							$str = "SELECT DISTINCT b.\"$fname\", b.\"$fname\"
									FROM gpdd.taxon t, gpdd.main m, gpdd.biotope b
								 	WHERE t.\"TaxonID\" = m.\"TaxonID\"
								 	AND m.\"BiotopeID\" = b.\"BiotopeID\"
								 	AND t.binomial IS NOT NULL
								 	ORDER BY b.\"$fname\"";
							//echo "$str<br>";
							if ($arr) $str = $str . " WHERE t.binomial = ANY($arr)";
							html_query_select_options($db_handle, $str, $fname, $fields, $n_options, $width);
							echo "<br></DIV>";
						break;
					case 'ExactName':
					case 'TownName':
					case 'CountyStateProvince':
					case 'Country':
					case 'Continent':
					case 'Ocean':
					case 'SpatialAccuracy':
					case 'LocationExtent':
							echo "<INPUT type=checkbox $check id='$fname" . "_query' name='$fname" .
			 					"_query' onClick='showfield(this)';'>$fname (loc)";
							echo "<DIV id='$fname" . "_div' style='display: none;'>";
							$str = "SELECT DISTINCT l.\"$fname\", l.\"$fname\"
									FROM gpdd.taxon t, gpdd.main m, gpdd.location l
								 	WHERE t.\"TaxonID\" = m.\"TaxonID\"
								 	AND m.\"LocationID\" = l.\"LocationID\"
								 	AND t.binomial IS NOT NULL
								 	ORDER BY l.\"$fname\"";
							//echo "$str<br>";
							if ($arr) $str = $str . " WHERE t.binomial = ANY($arr)";
							html_query_select_options($db_handle, $str, $fname, $fields, $n_options, $width);
							echo "<br></DIV>";
						break;
						
					default:
						break;
				}
				break;
				
			case 'lookup':
				$str = "SELECT DISTINCT \"$fname\", \"$fname\" FROM $dbloc ORDER BY \"$fname\"";
				//echo "$str<br>";
				html_query_select_options($db_handle, $str, $fname, $fields, $n_options, $width);
				break;
			}
		
		# End DIV
		if ($type !== 'gpdd') echo "<br></DIV>";

	}
	
	html_query_footer($object,$qobjects);
	# Delete queries
//	unset($qobject['queries']);
//	$qobjects = save_obj($qobjects, $qobject);
//	return ($qobjects);
	}
	
	
#=================================================================================================================
	
	function html_query_biotemporal($db_handle, $qobject, $qobjects, $sources, $names) {
		
		// Temporal Query

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
	    
	    echo "<h3>Temporal query</h3>";
	    html_query_errs ($qobject);
	    html_query_heading($qobject);
	    echo "<BR>";
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
		
		echo "From ";
		
		// From Day
		echo "<SELECT NAME='from_day' id='from_day'>";
		for ($i = 1; $i <= 31; $i++) {
			if ($i != $from_day) {
				echo "<OPTION VALUE='$i'>$i";
			} else {
				echo "<OPTION VALUE='$i' SELECTED>$i";
			}
		}
		echo "</SELECT> ";
		
		// From Month
		echo "<SELECT NAME='from_month' id='from_month'>";
		for ($i = 1; $i <= 12; $i++) {
			if ($i != $from_month) {
				echo "<OPTION VALUE='$i'>$month[$i]";
			} else {
				echo "<OPTION VALUE='$i' SELECTED>$month[$i]";
			}
		}
		echo "</SELECT> ";
		
		// From Year
		echo "<SELECT NAME='from_year' id='from_year'>";
		for ($i = $minyear; $i <= $maxyear; $i++) {
			if ($i != $from_year ) {
				echo "<OPTION VALUE='$i'>$i";
			} else {
				echo "<OPTION VALUE='$i' SELECTED>$i";
			}
		}
		echo "</SELECT> ";
		echo " to ";
		
		// To Day
		echo "<SELECT NAME='to_day' id='to_day'>";
		for ($i = 1; $i <= 31; $i++) {
			if ($i != $to_day) {
				echo "<OPTION VALUE='$i'>$i";
			} else {
				echo "<OPTION VALUE='$i' SELECTED>$i";
			}
		}
		echo "</SELECT> ";
		// To Month
		echo "<SELECT NAME='to_month' id='to_month'>";
		for ($i = 1; $i <= 12; $i++) {
			if ($i != $to_month) {
				echo "<OPTION VALUE='$i'>$month[$i]";
			} else {
				echo "<OPTION VALUE='$i' SELECTED>$month[$i]";
			}
			
		}
		echo "</SELECT> ";
		
		// To Year
		echo "<SELECT NAME='to_year' id='to_year'>";
		for ($i = $minyear; $i <= $maxyear; $i++) {
			if ($i != $to_year ) {
				echo "<OPTION VALUE='$i'>$i";
			} else {
				echo "<OPTION VALUE='$i' SELECTED>$i";
			}
		}
		echo "</SELECT> ";
		echo "<br>";
		
		echo $msg;
		
		// Overlay
		echo "Temporal intersection";
		if (!$t_overlay || ($t_overlay && $t_overlay == 'OVERLAP')) {
			echo " <input type='radio' name='t_overlay' CHECKED value='OVERLAP'> OVERLAP";
			echo " <input type='radio' name='t_overlay' value='WITHIN'> WITHIN";
		} else {
			echo " <input type='radio' name='t_overlay'  value='OVERLAP'> OVERLAP";
			echo " <input type='radio' name='t_overlay' CHECKED value='WITHIN'> WITHIN";
		}
		echo "<br>";
		
		html_query_footer($qobject, $qobjects);
	}

	
	
#=================================================================================================================

function html_query_biotree($db_handle, $qobject, $sources, $indentchar, $indentlimit) {
	
	echo '<script src="./scripts/tree_utils.js" type="text/javascript"></script>';

//	
	html_query_errs($qobject);
//	echo "qobject: <br>";
//	print_r($qobject);
//	echo "<br>";
	
	html_query_heading($qobject);
	echo '<br>';

	$qnames = $qobject['validnames'];
	if (!$qnames) $qnames = array();

	$source = get_obj($sources, $qobject['sources'][0]);
	//print_r($source);
	$tree_id = $source['tree_id'];
	echo "Method ";
	html_select_subtree_method();
	# Internal/tip nodes
	html_select_tree_nodes($qobject['treenodes']);
	echo "<br>";
	
	# Find Box
	echo "<INPUT type='text' id = 'findval' name='findval' value='' style='width:400px'>";
	echo "<BUTTON type='button' id='findbtn' name='findbtn' onClick='findNode()' onChange='clear()'>Find Next</BUTTON>";
	echo "<INPUT type='text' id ='treeval' name='treeval' value='' style='width:350px' DISABLED>";
	echo "<BUTTON type='button' id='addbtn' name='addbtn' onClick='add()'>Add</BUTTON><br>";
	
	#Add root node to text SELECT box
	$str = "SELECT *
		FROM biosql.node
		WHERE node.left_idx = 1
		AND node.tree_id = $tree_id;";
	//echo "$str<br>";
	$res = pg_query($db_handle,$str);
	$row = pg_fetch_row($res);
	$name = $row[1];
	echo "<SELECT name='tree' id='tree_items' MULTIPLE SIZE=15 style='width:400px'>";
	if (in_array($row[1], $qnames)) {
		echo "<OPTION SELECTED>$name</OPTION>";
		} else {
		echo "<OPTION>$name</OPTION>";
		}
	# Add other values
	html_tree_level_options($db_handle, $tree_id, $row[0], $qnames, $indentchar, 1, $indentlimit);
	echo "</SELECT>";
	
	# Add Buttons
	echo "<BUTTON type='button' id='tree_add' name='tree_add' onClick='treeAdd()'>></BUTTON>";
	echo "<BUTTON type='button' id='tree_all' name='tree_all' onClick='treeAll()'>>></BUTTON>";
	
	# Taxa area
	echo "<SELECT name='taxa[]' id='taxa_items' MULTIPLE SIZE=15 style='width:400px'>";
	if (!empty($qnames)) {
		foreach ($qnames as $qname) echo "<OPTION>$qname</OPTION>";
	}

	echo "</SELECT>";
	
	# Delete Buttons
	echo "<BUTTON type='button' id='tree_del' name='tree_del' onClick='treeDel()'>Delete</BUTTON>";
	echo "<BUTTON type='button' id='tree_delall' name='tree_delall' onClick='treeDelall()'>Delete All</BUTTON>";
	
	echo "<BR>... hierarchical depth";
	
	if ($qobject['errs']) {
		$errs = $qobject['errs'];
		unset($qobject['errs']);
		}
	echo "<br>";
}
	

#=======================================================================================================================
	function html_query_type ($qobjects, $sources, $names) {
	
	// Array of sources valid for each query type
	
//	echo "begin html_query_type";
//	print_r($sources);
//	echo "<br>";
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
	
	echo "<h3>Query</h3>";
	
	echo "<input type=radio CHECKED name='qterm' value='bionames'> Names in sources<br>";
	//html_qsources_print($bioname);
	if (!empty($biotree))
		echo "<input type=radio name='qterm' value='biotree'> Tree<br>";
	if (!empty($biotable)) {
		echo "<input type=radio name='qterm' value='biotable'> Attributes<br>";
		//html_qsources_print($biotable);
	}
	if (!empty($biogeographic))
		echo "<input type=radio name='qterm' value='biogeographic'> Geography<br>";
		//html_qsources_print($biogeographic);
	if (!empty($biotemporal))
		echo "<input type=radio name='qterm' value='biotemporal'> Time<br>";
		//html_qsources_print($biotemporal);

		//html_qsources_print($biotree);
	echo "<hr>";
	#echo "count: " . count($names) . "<br>";
	if ($qobjects) echo "<input type=radio name='qterm' value='manage'> Manage queries<br>";
	if (!$names) echo "<input type=radio name='qterm' value='qend'> Output all data<br>";
	if ($names and count($names) != 0) echo "<input type=radio name='qterm' value='qend'> Output data<br>";
	echo "<input type=radio name='qterm' value='finish'> Exit<br>";
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
	echo "<br>outpit_id: $output_id<br>";
	//$output = get_obj($outputs, $outputid);
	//print_r($output);
	$source = get_obj($sources, $output['sourceid']);
	//print_r($source);
	
	# Header
	echo "<h3>Output " . $source['name'] . "</h3>";
	
	#echo $str; 
	
	# WWW link
//	if (array_key_exists('www', $source)) {
//		echo "<a href='" . trim($source['www']) . "' target='_blank'>";
//		echo "Click for information on " . $source['name'] . "</a><br><br>";
//		}
		
	$sterm = $source['term'];
		
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

#================================================================================================================

//function html_select_query_source($db_handle, $formname, $sources) {
//
//	#Checkboxes forwhich subset modes to use		
//	foreach ($sources as $source) {
//		
//		switch ($source['term']) {
//		
//			case 'biotree':
//				echo "<input type='radio' name=$formname value="
//					. $source['id'] . "> Names in the " . $source['name'] . "<br>";
//				break;
//				
//			case 'biogeographic':
//				echo "<input type='radio' name=$formname value="
//					. $source['id'] . "> Geography of " . $source['name'] . "<br>";	
//				break;
//			
//			case 'biotable':
//				echo "<input type='radio' name=$formname value="
//					. $source['id'] . "> Fields in " . $source['name'] . "<br>";
//				break;
//				
//			case 'biolink':
//				echo "<input type='radio' name=$formname value="
//					. $source['id'] . "> Fields in " . $source['name']. "<br>";
//				break;
//				
//			case 'biogpdd':
//				echo "<input type='radio' name=$formname value="
//					. $source['id'] . "> Time series in " . $source['name']. "<br>";
//				break;				
//			
//			default:
//				break;
//			}
//			
//		}
//		echo "<br><hr>";
//	echo "<input type='radio' name=$formname value='delete'> Delete query<br>";
//	echo "<input type='radio' CHECKED name=$formname value='none'> No thanks, I'm done querying<br>";
//	}
	
#=======================================================================================================================

function html_select_sources($db_handle) {

	echo '<h3>Select sources</h3>';
	
	#Select one or more data sources 
	$str = "SELECT obj.source_id, obj.name
		FROM source.source obj, biosql.term t
		WHERE obj.term_id = t.term_id
		AND t.name like 'bio%'
		AND obj.active = TRUE";
	
	$result = pg_query($db_handle,$str);

	
	echo "<SELECT name='qsources[]' MULTIPLE SIZE=7>";
	if(!$result) {
		echo "<OPTION>No Data Sets Available</OPTION>";
		} else {
		while ($row = pg_fetch_row($result)) echo "<OPTION value=$row[0]> $row[1] </OPTION>";
		}
	echo "</SELECT><br>";
	echo " 'Next >' to select all";
	echo "<hr>";
	
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

function html_select_tree_nodes($val) {
	
	echo "Tree node names ";
	if (!$val or $val == 'all') {
		echo "<input type='radio' CHECKED name='treenodes' value=all> All nodes";
		} else {
		echo "<input type='radio' name='treenodes' value=all> All nodes";
		}
	if ($val == 'tip') {
		echo "<input type='radio' CHECKED name='treenodes' value=tip> Tip nodes";
		} else {
		echo "<input type='radio' name='treenodes' value=tip> Tip nodes";
		}
	if ($val == 'internal') {
		echo "<input type='radio' CHECKED name='treenodes' value=internal> Internal nodes";
		} else {
		echo "<input type='radio' name='treenodes' value=internal> Internal nodes";
		}
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

function html_select_subtree_method($mode = 'subtree') {
	
	if(!$mode) $mode = 'all';
	
	$vals = array('all','subtree','selected');
	foreach ($vals as $val) {
			echo "<INPUT type='radio' ";
			if ($val == $mode) echo " CHECKED ";
			echo "name='subtree' value='$val'>";
			switch ($val){
				case 'all': 
					echo" All";
					break;
				case 'subtree': 
					echo" LCA subtree";
					break;
				case 'selected': 
					echo" Selected";
					break;					
			}
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
	
	# ZIP, WRITE README THEN DELETE
	$files_to_zip = array();
		
	# WRITE OUTPUT
	$outputs = write($db_handle, $config, $qobjects, $names, $outputs, $sources);
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
	$fn = $write_path . '/' . substr(md5(uniqid()),0,4) . '_readme.txt';
	$fh = fopen($fn, 'w') or die("can't open file $fn: $php_errormsg");
	fputs($fh, $readme);
	fclose($fh) or die ($php_errormsg);
	
	#echo "readme $fn written<br>";
	# add readme to zip list
	array_push($files_to_zip, $fn);
	$zn = substr(md5(uniqid()),0,4) . '_ebdata.zip';
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
?>