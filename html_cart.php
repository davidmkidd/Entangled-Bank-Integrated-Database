<?php

# ------------------------------------------------------------------------------------------------------------

function html_cart($db_handle, $qobjid, $qobjects, $sources, $names, $object_id, $outputs, $stage) {
	
	echo '<script src="./scripts/cart_utils.js" type="text/javascript"></script>';
	
	# CART
	echo "<div id='cart'>";
	
	# ICON
	echo "<table border='0' style='display: inline'>";
	echo "<th class='query_title' align='left' height='65px'>";
	$title = "Data Cart";
	echo "<img src='./image/shoppingCartIcon.gif' alt='Cart'/>";
	echo "</th>";
	echo "</table>";
	
	# INFO
	echo "<table style='display: inline' border='0'>";
	echo "<tr height='20px'>";
	echo "<td>";
	# SOURCES
	html_cart_sources($sources);
	# QUERIES
	//html_cart_query($qobjects, $sources);
	# NAMES
	html_cart_names($names);
	# SERIES
	html_cart_series($qobjects);
	echo "</td>";
	echo "</tr>";
	# QUERIES
	html_cart_queries($qobjid, $qobjects);	
	echo "</table>";
	echo "</div>";
}
# ------------------------------------------------------------------------------------------------------------

function html_cart_series($qobjects) {
	
	If (count($qobjects) > 0) {
		$mids = query_get_mids($qobjects);
		if (!$mids) { 
			echo " | 0 series";
		} else {
			//echo "<td class = 'cart_menu'>";
			echo ' | <a href="list_series.php?' . SID . '"  target="_blank"> ' . count($mids) . " series</a>";
			echo '<a href="table_series.php?' . SID . '"  target="_blank"> (table)</a>';
			echo '<a href="table_series_by_names.php?' . SID . '"  target="_blank"> (by name)</a>';
			echo '<a href="sql_series.php?' . SID . '"  target="_blank"> (sql)</a>';
			//echo "</td>";
		}
	}
}

# ------------------------------------------------------------------------------------------------------------

function html_cart_query($qobjects, $sources) {

	# QUERIES
//	echo "qobj: ";
	//print_r($qobjects);
//	echo "<br>";
	
	if ($qobjects) {
		$c = count($qobjects);
		if ($qobjects[$c - 1]['status'] == 'new') $c = $c - 1;
		}
		
	switch ($c) {
		case 0:
			echo " | 0 queries";
			break;
		case 1:
			#echo  " | <a href='query_table.php?" . SID . "' target='_blank'> 1 query</a>";
			echo  " | 1 query";
			break;
		default:
			#echo " | <a href='query_table.php?" . SID . "' target='_blank'>" . $c . " queries</a>";
			echo " | " . $c . " queries";
			break;
		}
	
	}

# ------------------------------------------------------------------------------------------------------------
	
	function html_cart_queries($qobjid, $qobjects) {
		
		echo "<input type='hidden' id='qedit_objid' name='qedit_objid' value=''>";
		
		# QUERY CHAIN
		$title = "Queries";
		
		echo "<tr>";
		echo "<td>";

		$n = count($qobjects);
		
		if ($n == 0) {
			# NO QOBJECTS
			$title = 'No queries';
			echo "<img src='./image/no-query.gif' alt='$title' title='$title' class='query_type_button_non_active'>";
		} else {
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
				echo "</a>";
				$c++;
			}
		}
	echo "</td>";
	echo "</tr>";
	}
	
# ------------------------------------------------------------------------------------------------------------
	
function html_cart_outputs($output_id, $outputs, $qobjects) {
	
	//echo "begin cart output<br>";
	//print_r ($outputs);	
	//echo "<input type='hidden' id='qedit_objid' name='qedit_objid' value=''>";
		
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
			if ($output['status'] !== 'new' && $output['id'] !== $output_id) {
				# NON-ACTIVE QUERY
				$class = 'non-active';
				//echo "<a>";
				echo "<a href='javascript: editOutput(\"$id\")'>";
				html_query_image($output['term'], $class, $name, 'output');
			} else {
				# ACTIVE QUERY
				$class = 'active';
				echo "<a>";
				html_query_image($output['term'], $class , $name, 'output');
			}
			echo "</a>";
		}
		# RETURN DATA
		$title = 'Return Data';
		echo "&nbsp;<a href='javascript: returnOutput($q);'><img src='./image/returndata.gif' alt='return data' title='$title' class='query_type_button_non_active';></img></a>";
	}
	echo "</td>";
	echo "</tr>";
	echo "</table>";
	echo "</div>";
	}
	
# ------------------------------------------------------------------------------------------------------------
	
function html_cart_sources($sources) {
	
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
	}
	
# ------------------------------------------------------------------------------------------------------------

function html_cart_names($names) {


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
	
	}

#=================================================================================================================
	

?>