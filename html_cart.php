<?php

# ------------------------------------------------------------------------------------------------------------

function html_cart($db_handle, $qobjects, $sources, $names, $outputs, $stage) {
	
	# CART
	echo "<div id='cart'>";
	echo "<table>";
	echo "<tr>";
	$title = "Data Cart";
	if ($stage == 'qbegin') {
		$class = 'option_title_plus';
	} else {
		$class = 'query_title';
	}
	echo "<td class='$class' title='$title'>";
	echo "<img src='./image/shoppingCartIcon.gif' alt='Cart' height='50px'/>";
	echo "</td>";
	echo "<td>";
	# SOURCES
	html_cart_sources($sources);
	# QUERIES
	html_cart_query($qobjects, $sources);
	# NAMES
	html_cart_names($names);
	# SERIES
	html_cart_series($db_handle, $qobjects);
	# OUTPUTS
	html_cart_outputs($outputs);	
	echo "</td>";
	echo "</tr>";
	echo "</table>";
	
	if (isset($qobjects) && ! empty($qobjects) && $qobjects[0]['status'] != 'new') {
	# QUERY CHAIN
		$title = "Queries";
		echo "<table>";
		echo "<tr>";
		echo "<td class='$class' title='$title'><img src='./image/queryicon.gif' alt='queryicon.gif'></td>";
		echo "<td class='querycart'>";
		html_cart_queries($qobjects);
		echo "</td>";
		echo "</tr>";
		echo "</table>";
	}
	echo "</div>";
	;
}
# ------------------------------------------------------------------------------------------------------------

function html_cart_series($db_handle, $qobjects) {

	If ($qobjects) {
		$mids = query_get_mids($qobjects);
		if (!$mids) { 
			echo " | 0 series";
		} else {
			echo ' | <a href="list_series.php?' . SID . '"  target="_blank"> ' . count($mids) . " series</a>";
			echo ' <a href="table_series.php?' . SID . '"  target="_blank"> (table)</a>';
			echo ' <a href="table_series_by_names.php?' . SID . '"  target="_blank"> (by name)</a>';
			echo ' <a href="sql_series.php?' . SID . '"  target="_blank"> (sql)</a>';
		}
		//$qobjects['series_sql'] = $total_sql;
		//$qobjects['series'] = $mids;
		//print_r($qobjects);
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
	
	function html_cart_queries($qobjects) {
		
		echo '<script src="./scripts/cart_utils.js" type="text/javascript"></script>';
		
		echo "<input type='hidden' id='qedit_objid' name='qedit_objid' value=''>";
		
		$c = 0;
		//print_r($qobjects);
		if ($qobjects) {
			foreach ($qobjects as $qobject) {
				if ($c == 0) {
					# FIRST QUERY
					if ($qobject['status'] !== 'new') {
						$name = $qobject['name'];
						$id = $qobject['id'];
						echo "<a href='javascript: editQuery(\"$id\")'>";
						html_query_image($qobject, 40 , $name);
						echo "</a>";
					}
				} else {
					# SUBSEQUENT QUERY
					if ($qobject['status'] == 'valid') {
						echo "&nbsp;", $qobject['queryoperator'], "&nbsp;";
						$name = $qobject['name'];
						html_query_image($qobject,40, $name);
					}
				}
			$c++;
			}
		}
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

	if ($c > 0) echo " | <a href='list_output.php?" . SID . "' target='_blank'>";
	
	switch ($c) {
		case 0:
			echo " | 0 outputs";
			break;
		case 1:
			echo "1 output";
			break;
		default:
			echo "$c outputs";
		}
	if ($c > 0) echo "</a>";
	

	}
	
# ------------------------------------------------------------------------------------------------------------
	
function html_cart_sources($sources) {
	
	if ($sources) {
		$c = count($sources);
		} else {
		$c = 0;
		}
	
	if ($c > 0) echo '<a href="list_sources.php?' . SID . '"  target="_blank">';
	
	#echo "<b>";
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
	#echo "</b>";
	if ($c > 0) echo '</a>';
	#echo "<br>";
	}
	
# ------------------------------------------------------------------------------------------------------------

function html_cart_names($names) {

	if (!isset($names)) {
		echo " | 0 names";
		} else {
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
		}
	}

#=================================================================================================================
	

?>