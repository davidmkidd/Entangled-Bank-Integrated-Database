<?php

function html_info($db_handle, $qobjects, $sources, $names) {
	
	# INFORMATION ON SOURCES, NAMES AND QUERIES
	//echo "names: " . count($names) . "<br>";
	
	# DIV
	echo "<div id='info_div'>";
	
	# OUTER TABLE
	echo "<table border='0'>";
	
	# HEADERS;
	echo "<tr>";
	echo "<td class='query_title'>Selected</td>";
	echo "<td>";
	
	# INNER TABLE
	echo "<div id='inner_table_div'>";
	echo "<table border='0'  class='info'>";
	echo "<tr>";
	echo "<th title='Sources queried' class='info'>Sources</th>";
	echo "<th title='Names returned' class='info'>Names</th>";

	foreach ($sources as $source) {
		$t = $source['name'];
		$c = $source['code'];
		//$class = 'info_' . $source['term'];
		echo "<th class='info' title='$t'>$c</th>";
	}
	echo "</tr>";

	
	# INFO FOR SOURCES
	echo "<tr>";
	
	# N SOURCES
	$i = count($sources);
	$t = "Sources";
	echo "<td class='info_basic'>";
	echo "<a href='list_sources.php?" . SID . "' title='$t' target='_blank'>$i</a>";
	echo "</td>";
	
	# NAMES
	$snames = array();
	$allnames = array();
	if ($names) $arr = array_to_postgresql($names,'text');
	
	
	foreach ($sources as $source) {
		switch ($source['term']) {
			case 'biotable':
			case 'biogeographic':
				$str = "SELECT DISTINCT " . $source['namefield'] . " AS name FROM " . $source['dbloc'];
				if ($names) $str = $str . " WHERE " . $source['namefield'] . " = ANY($arr)";
				break;
			case 'biotree':
				$str = "SELECT DISTINCT label AS name FROM biosql.node WHERE tree_id=" . $source['tree_id'];
				if ($names) $str = $str . " AND label = ANY($arr)";
				break;
			case 'biorelational':
				$str = "SELECT DISTINCT t.binomial AS name FROM gpdd.taxon t, gpdd.main m WHERE m.\"TaxonID\"=t.\"TaxonID\"";
				if ($names) $str = $str . " AND t.binomial IS NOT NULL AND t.binomial = ANY($arr)";
				
				break;
		}
		
		$res = pg_query($db_handle, $str);
		array_push($snames, pg_fetch_all_columns($res)) ;
		$allnames = array_merge($allnames, pg_fetch_all_columns($res));
		//echo $source['name'], ": ", count(pg_fetch_all_columns($res)) , ", all: ", count($allnames), "<br>";
	}
	
	
	# UNIQUE NAMES
	$allnames = array_unique($allnames);
	$n = count($allnames);

	$t = "Names";
	echo "<td class='info_basic'>";
	echo "<a href='list_names.php?" . SID . "' title='$t' target='_blank' >$n</a>";
	echo "</td>";
		
	#SOURCES
		//if ($names) $arr = array_to_postgresql($names, 'text');
	$i = 0;
	foreach ($sources as $source) {
		switch ($source['term']) {
			case 'biotable':
			case 'biogeographic':
				html_info_biotable($source, $snames[$i]);
				break;
			case 'biorelational':		
				html_info_gpdd($db_handle, $source, $snames[$i], $qobjects);
				break;
			case 'biotree':
				html_info_biotree($source, $snames[$i]);
				break;
		}
		$i++;
	}		
	

	echo "</tr>";
	# QUERIES
	//html_cart_queries($qobjid, $qobjects);
	echo "</table>";
	echo "</div>";
	
	# OUTER TABLE
	echo "</td>";
	echo "</tr>";	
	echo "</table>";
	echo "</div>";
	
}

# ------------------------------------------------------------------------------------------------------------

function html_info_biotree($source, $snames) {
	
	$t = 'Names';
	$tree = $source['tree_id'];
	$sid = $source['id'];
	$n = count($snames);
	echo "<td class='info_biotree'><a href='entangled_bank_source_info.php?id=$sid' title='$t' target='_blank'>$n</a></td>";
	
}

# ------------------------------------------------------------------------------------------------------------

function html_info_biotable($source, $snames) {
	
	$sid = $source['id'];
	$t = 'Names';
	if ($source['term'] == 'biotable') {
		$class = 'info_biotable';
	} else {
		$class = 'info_biogeographic';
	}
	$n = count($snames);
	echo "<td class='$class'><a href='entangled_bank_source_info.php?id=$sid' title='$t' target='_blank'>$n</td>";
	
}

# ------------------------------------------------------------------------------------------------------------

function html_info_gpdd($db_handle, $source, $snames, $qobjects) {
	
	$sid = $source['id'];
	$n = count($snames);
	if ($qobjects) {
		$mids = query_get_mids($qobjects);
		$s = count($mids);
	} else {
		$str = "SELECT COUNT(*) FROM gpdd.main m, gpdd.taxon t WHERE m.\"TaxonID\"=t.\"TaxonID\" AND t.binomial IS NOT NULL";
		$res = pg_query($db_handle, $str);
		$row = pg_fetch_row($res);
		$s = $row[0];
	}

	$t = 'Names';
	echo "<td class='info_biorelational'><a href='entangled_bank_source_info.php?id=$sid' title='$t' target='_blank'>$n</a>/";
	$t = 'Series';	
	echo "<a href='entangled_bank_source_info.php?id=$sid' title='$t' target='_blank'>", $s, '</a></td>';
}

# ------------------------------------------------------------------------------------------------------------
	
	function html_info_queries($qobjid, $qobjects, $sources) {
		
		# QUERY CHAIN
		
		if ($qobjects && !empty($qobjects)) {
			echo "<div id='cart_queries'>";
			
			echo "<input type='hidden' id='qedit_objid' name='qedit_objid' value=''>";
			echo "<table>";
			
			echo "<tr>";
			$title = "Your queries - click to edit or delete";
			echo "<td class='query_title' title='$title'>Queries</td>";
			echo "<td id='info_queries'>";
				# QOBJECTS	
			$c = 0;
			foreach ($qobjects as $qobject) {
				# IF EQ QOBJID OR NEW THEN LARGE
				$name = $qobject['name'];
				$id = $qobject['id'];
				if ($qobject['status'] !== 'new' && $qobject['id'] !== $qobjid) {
					# NON-ACTIVE QUERY
					$class = 'non-active';
					if ($c > 0) echo html_query_operator_image($qobject['queryoperator'], $class);
					echo "<a>";
					echo "<a href='javascript: editQuery(\"$id\")'>";
					html_query_image($qobject['term'], $class, $name);
				} else {
					# ACTIVE QUERY
					$class = 'active';
					if ($c > 0) echo html_query_operator_image($qobject['queryoperator'], $class);
					echo "<a>";
					html_query_image($qobject['term'], $class , $name);
				}
				echo "</a>&nbsp;";
				$c++;
			}
			$t = "Delete all queries";
			echo "&nbsp;<a href='javascript: deleteAllQueries()' >";
			echo "<img src='./image/red-cross.gif' class='query_type_button_non_active' title='$t'/></a>";
			
		//	}
		echo "</td>";
		echo "</tr>";	
		echo "</table>";
		echo "</div>";
		}
	}
	
# ------------------------------------------------------------------------------------------------------------
	
function html_info_outputs($output_id, $outputs, $qobjects) {
	
	//echo "begin cart output<br>";
	//print_r ($outputs);	
	//echo "<input type='hidden' id='qedit_objid' name='qedit_objid' value=''>";
	if ($outputs) {
		
		echo "<input type='hidden' id='output_id' name='output_id' value=''>";
		
		# OUTPUTS
		$n = count($outputs);
		$q = count($qobjects);
		echo "<div id='output_cart'>";
		echo "<table border='0'>";
		echo "<tr>";
		echo "<td class='query_title'>";
		echo "Outputs";
		echo "</td>";
		echo "<td>";
		$first = true;
		if ($n == 0) {
			# NO OUTPUTS
			$title = 'No Outputs';
			echo "<img src='./image/no-output.gif' alt='$title' title='$title' class='query_type_button_non_active'>";
		} else {
			$title = "Outputs";
			foreach ($outputs as $output) {
				# IF EQ QOBJID OR NEW THEN LARGE
				$name = $output['name'];
				$id = $output['id'];
				if ($first == false) echo "&nbsp;";
				if ($output['status'] !== 'new' && $output['id'] !== $output_id) {
					# NON-ACTIVE QUERY
					$class = 'non-active';
					//echo "<a>";
					echo "<a href='javascript: editOutput(\"$id\");'>";
					html_query_image($output['term'], $class, $name, 'output');
				} else {
					# ACTIVE QUERY
					$class = 'active';
					echo "<a>";
					html_query_image($output['term'], $class , $name, 'output');
				}
				echo "</a>";
				$first = false;
			}
			
			# DELETE ALL
			$t = "Delete all outputs";
			echo "&nbsp;<a href='javascript: deleteAllOutputs()' >";
			echo "<img src='./image/red-cross.gif' class='query_type_button_non_active' title='$t'/></a>";
			
			# RETURN DATA
			$title = 'Return Data';
			echo "&nbsp;<a href='javascript: returnOutput($q);'><img src='./image/returndata.gif' width='45px' alt='return data' title='$title';></img></a>";
		}
		echo "</td>";
		echo "</tr>";
		echo "</table>";
		echo "</div>";
		}

	}
	
# ------------------------------------------------------------------------------------------------------------
	
/*function html_cart_sources($sources) {
	
	//echo "<td class='cart_menu'>";
	if ($sources) {
		$c = count($sources);
		} else {
		$c = 0;
		}
	
	if ($c > 0) echo '<a href="list_sources.php?' . SID . '"  target="_blank">';
	
	switch ($c) {
		case 0:
			echo "0 sources";
			break;
		case 1:
			echo "1 source";
			break;
		default:
			echo $c . " sources";
		}
	if ($c > 0) echo '</a>';
	//echo "</td>";
	}*/
		

# ------------------------------------------------------------------------------------------------------------

/*function html_cart_names($names) {


	if (!isset($names)) {
		//echo " | 0 names";
	} else {
		//echo "<td class='cart_menu'>";
		# NAMES
		$c = count($names);
		switch ($c) {
			case 0:
				echo " | 0 names";
				break;
			case 1:
				echo ' | <a href="list_names.php?' . SID . '"  target="_blank"> 1 name</a>';
				break;
			default:
				echo ' | <a href="list_names.php?' . SID . '"  target="_blank"> ' . $c . " names</a>";
			}
		# INFO
		if ($names) {
			echo ' <a href="table_names.php?' . SID . '"  target="_blank"> (table)</a>';
			echo ' <a href="sql_names.php?' . SID . '"  target="_blank"> (sql)</a> ';
			//echo '<a href="namestable.php?' . SID . '"  target="_blank"> (sources)</a>';
		}
		//echo "</td>";
	}
	
	}*/

#=================================================================================================================
	

?>