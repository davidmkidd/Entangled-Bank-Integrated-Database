<?php

function html_info($db_handle, $oldtoken, $newtoken) {
	
	$sources = $_SESSION['sources'];
	if ($_SESSION['qobjects']) $qobjects = $_SESSION['qobjects'];
	if ($_SESSION['names']) $names = $_SESSION['names'];
	
	# INFORMATION ON SOURCES, NAMES AND QUERIES
	# SAVE TO USE AGAIN IF NEEDED: FIND
	if (!$_SESSION['info']) {
		$info = info($db_handle, $sources, $qobjects, $names);
		//echo "Generating Info ...<BR>";
		$_SESSION['info'] = $info;
	} else {
		$info = $_SESSION['info'];
		//echo "Info from session ...<BR>";
	}
	
	# DIV
	echo "<div id='info_div'>";
	
	# OUTER TABLE
	echo "<table border='0'>";
	
	# HEADERS;
	echo "<tr>";
	echo "<td class='query_title'>Selection</td>";
	echo "<td>";
	
	# INNER TABLE
	echo "<div id='inner_table_div'>";
	echo "<table border='0'  class='info'>";
	echo "<tr>";
	echo "<th title='Sources queried' class='info'>Sources</th>";
	echo "<th title='Names returned' class='info'>Names</th>";

	# TITLES
	foreach ($sources as $source) {
		$t = $source['name'];
		$c = $source['code'];
		echo "<th class='info' title='$t'>$c</th>";
	}
	echo "</tr>";

	
	# INFO
	echo "<tr>";
	# N SOURCES
	$n = $info['sources'];
	$t = "Sources";
	echo "<td class='info_basic'>";
	echo "<a href='./list_sources.php?" . SID . "' title='$t' target='_blank'>$n</a>";
	echo "</td>";

	# NAMES
	$n = $info['names'];
	$t = "Names";
	echo "<td class='info_basic'>";
	echo "<a href='list_names.php?" . SID . "' title='$t' target='_blank'>$n</a>";
	echo "</td>";
		
	# SOURCES
	$i = 0;
	foreach ($sources as $source) {
		switch ($source['term']) {
			case 'biotable':
			case 'biogeographic':
				html_info_biotable($source, $info);
				break;
			case 'biorelational':		
				html_info_gpdd($source, $info);
				break;
			case 'biotree':
				html_info_biotree($source, $info);
				break;
		}
		$i++;
	}		
	
	echo "</tr>";
	
	# INNER TABLE
	echo "</table>";
	echo "</div>";
	
	# OUTER TABLE
	echo "</td>";
	echo "</tr>";	
	echo "</table>";
	echo "</div>";
	
}

# ------------------------------------------------------------------------------------------------------------

function html_info_biotree($source, $info) {
	
	$t = 'Names';
	$sid = $source['id'];
	$n = $info[$sid];
	echo "<td class='info_biotree'><a href='source_info.php?id=$sid' title='$t' target='_blank'>$n</a></td>";
	
}
# ------------------------------------------------------------------------------------------------------------

function info($db_handle, $sources, $qobjects, $names) {
	
	# GENERATE INFO
	//echo "Generating info ...<BR>";
	$info = array();
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
				$str = "SELECT DISTINCT t.binomial AS name 
					FROM gpdd.taxon t, gpdd.main m, gpdd.datasource ds
					WHERE m.\"TaxonID\"=t.\"TaxonID\"
					AND m.\"DataSourceID\" = ds.\"DataSourceID\"
					AND ds.\"Availability\" <> 'Restricted'";
				if ($names) $str = $str . " AND t.binomial IS NOT NULL AND t.binomial = ANY($arr)";
				
				break;
		}
		$res = pg_query($db_handle, $str);
		$info[$source['id']] = count(pg_fetch_all_columns($res));
		$allnames = array_merge($allnames, pg_fetch_all_columns($res));
	}
	
	# UNIQUE NAMES
	$allnames = array_unique($allnames);
	$info['names'] = count($allnames);
	$info['sources'] = count($sources);

	foreach ($sources as $source) {
		switch ($source['term']) {
			case 'biotable':
			case 'biogeographic':
			case 'biotree':
				break;
			case 'biorelational':		
				info_gpdd($db_handle, $source, $qobjects, &$info);
				break;
		}
	}
	
	return $info;
	
}


# ------------------------------------------------------------------------------------------------------------

function html_info_biotable($source, $info) {
	
	if ($source['term'] == 'biotable') {
		$class = 'info_biotable';
	} else {
		$class = 'info_biogeographic';
	}
	$sid = $source['id'];
	$t = 'names';
	$n = $info[$sid];
	echo "<td class='$class'><a href='source_info.php?id=$sid' title='$t' target='_blank'>$n</td>";
	
}

# ------------------------------------------------------------------------------------------------------------

function html_info_gpdd($source, $info) {
	$sid = $source['id'];
	$vals = $info[$sid];
	$n = $vals[0];
	$s = $vals[1];
	$t = 'Names';
	echo "<td class='info_biorelational'><a href='source_info.php?id=$sid' title='$t' target='_blank'>$n</a>/";
	$t = 'Series';	
	echo "<a href='source_info.php?id=$sid' title='$t' target='_blank'>", $s, '</a></td>';
}

# ------------------------------------------------------------------------------------------------------------

function info_gpdd($db_handle, $source, $qobjects, &$info) {
	
	$sid = $source['id'];
	$n = $info[$sid];
	//$n = count($snames);
	if ($qobjects) {
		$mids = query_get_mids($qobjects);
		$s = count($mids);
	} else {
		$str = "SELECT COUNT(*) 
			FROM gpdd.main m, gpdd.taxon t, gpdd.datasource ds
			WHERE m.\"TaxonID\" = t.\"TaxonID\"
			AND m.\"DataSourceID\" = ds.\"DataSourceID\"
			AND ds.\"Availability\" <> 'Restricted'
			AND t.binomial IS NOT NULL";
		//echo "$str";
		$res = pg_query($db_handle, $str);
		$row = pg_fetch_row($res);
		$s = $row[0];
	}

	$info[$sid] = array($n,$s);
}

# ------------------------------------------------------------------------------------------------------------
	
	function html_info_queries() {
		
		# QUERY CHAIN
		$qobjects = $_SESSION['qobjects'];
		$sources = $_SESSION['sources'];
		
		if ($qobjects && !empty($qobjects)) {
			echo "<div id='cart_queries'>";
			
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
	
function html_info_outputs($output_id) {
	
	$outputs = $_SESSION['outputs'];
	$qobjects = $_SESSION['$qobjects'];
	
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


?>