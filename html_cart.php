<?php

# ------------------------------------------------------------------------------------------------------------

function html_cart($db_handle, $qobjects, $sources, $names, $outputs, $cancel) {
	
	echo "<img src='shoppingCartIcon.gif' alt='Shopping Cart' />";
	echo '<big>Shopping Cart</big><br>';
	##print_r($names);
	
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
	echo "<br>";	
	# MESSAGES
	if ($cancel == 'yes') echo "<FONT color=red>Query Cancelled</FONT> :";
	# QUERY CHAIN
	html_cart_queries($qobjects);

	echo "<hr>";
}
# ------------------------------------------------------------------------------------------------------------

function html_cart_series($db_handle, $qobjects) {

	If ($qobjects) {
		$mids = get_mids($qobjects);
		if (!$mids) { 
			echo " | 0 series";
		} else {
			echo ' | <a href="list_series.php?' . SID . '"  target="_blank"> ' . count($mids) . " series</a>";
			echo ' <a href="table_series.php?' . SID . '"  target="_blank"> (table)</a>';
			echo ' <a href="table_series_by_names.php?' . SID . '"  target="_blank"> (by name)</a>';
			echo ' <a href="series_sql.php?' . SID . '"  target="_blank"> (sql)</a>';
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
			echo  " | <a href='query_table.php?" . SID . "' target='_blank'> 1 query</a>";
			break;
		default:
			echo " | <a href='query_table.php?" . SID . "' target='_blank'>" . $c . " queries</a>";
			break;
		}
	
	}

# ------------------------------------------------------------------------------------------------------------
	
	function html_cart_queries($qobjects) {
		
		$f = true;
		$c = 0;
		//print_r($qobjects);
		if ($qobjects) {
			foreach ($qobjects as $qobject) {
				if ($qobject['status'] !== 'new') {
					if ($f == true) {
						echo "Queries: ";
						$f = false;
					}
					echo " " . $qobject['queryoperator'];
					echo " <i>" . $qobject['name'] . "</i>";
				}
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
			echo ' <a href="names_table.php?' . SID . '"  target="_blank"> (table)</a>';
			echo ' <a href="names_sql.php?' . SID . '"  target="_blank"> (sql)</a> ';
			//echo '<a href="namestable.php?' . SID . '"  target="_blank"> (sources)</a>';
			}
		}
	}

#=================================================================================================================
	

?>