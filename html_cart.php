<?php

# ------------------------------------------------------------------------------------------------------------

function html_cart($db_handle, $qobjid, $qobjects, $sources, $names, $outputs, $stage) {
	
	//echo "$qobjid<br>";
	
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
	html_cart_series($db_handle, $qobjects);
	# OUTPUTS
	html_cart_outputs($outputs);
	echo "</td>";
	echo "</tr>";
	html_cart_queries($qobjid, $qobjects);
	echo "</table>";
	echo "</div>";
}
# ------------------------------------------------------------------------------------------------------------

function html_cart_series($db_handle, $qobjects) {
	
	If (count($qobjects) > 0) {
		$mids = query_get_mids($qobjects);
		
		if (!$mids) { 
			//echo "0 series";
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
		
		//if (isset($qobjects) && ! empty($qobjects)) {
		
			echo '<script src="./scripts/cart_utils.js" type="text/javascript"></script>';
		
			echo "<input type='hidden' id='qedit_objid' name='qedit_objid' value=''>";
			
			# QUERY CHAIN
			$title = "Queries";
			//echo "<table>";
			echo "<tr>";
			//echo "<td class=''>";
			echo "<td>";
			//echo "<td class='$class' title='$title'><img src='./image/queryicon.gif' alt='queryicon.gif'></td>";
			//echo "<td class='query_title' title='$title'>Queries</td>";
			$n = count($qobjects);
			
			if ($n == 0) {
				# NO QOBJECTS
				//echo "<td class='cart_query'>";
				echo "<img src='./image/no-query.gif' alt='0 queries' class='query_type_button_non_active'>";
				//echo "</td>";
			} else {
				# QOBJECTS	
				$c = 0;

				foreach ($qobjects as $qobject) {
					# IF EQ QOBJID OR NEW THEN LARGE
					$name = $qobject['name'];
					//echo $qobject['id'] . "<br>";
					if ($qobject['status'] !== 'new' && $qobject['id'] !== $qobjid) {
						# NON-ACTIVE QUERY
						$class = 'non-active';
						if ($c > 0) echo html_query_operator_image($qobject['queryoperator'], $class);
						echo "<a>";
						echo "<a href='javascript: editQuery(\"$qobjid\")'>";
						html_query_image($qobject, $class, $name);
					} else {
						# ACTIVE QUERY
						$class = 'active';
						$id = $qobject['id'];
						if ($c > 0) echo html_query_operator_image($qobject['queryoperator'], $class);
						echo "<a>";
						html_query_image($qobject, $class , $name);
					}
					echo "</a>";
					$c++;
				}
			}
		echo "</td>";
		echo "</tr>";
	}
	
# ------------------------------------------------------------------------------------------------------------
	
function html_cart_outputs($outputs) {
	
	//echo "begin cart output<br>";
	//print_r ($outputs);
	
	# OUTPUTS
	if ($outputs) {
		$c = count($outputs);
		if ($outputs[$c - 1]['status'] == 'new') $c = $c - 1;
	} else {
		$c = 0;
	}

	if ($c > 0)  {
		echo "<td class='cart_menu'>";
		echo "<a href='list_output.php?" . SID . "' target='_blank'>";
		switch ($c) {
			case 0:
				//echo " | 0 outputs";
				break;
			case 1:
				echo "1 output";
				break;
			default:
				echo "$c outputs";
		}
	echo "</a>";
	echo "</td>";
	}
	
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