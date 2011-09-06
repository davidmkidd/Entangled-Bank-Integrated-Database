<?php

	include "config_setup.php";
	include "../php_utils.php";
	#$config = parse_ini_file('../../../passwords/entangled_bank.ini');
	$db_handle = eb_connect_pg($config);
	
	$qstr = $_GET['query'];
	$tree_id = $_GET['tree'];
	$filter = $_GET['filter'];
	
	if (!$filter) {
		$str = "SELECT label 
			FROM biosql.node 
			WHERE tree_id = $tree_id
			AND label LIKE '%$qstr%'";
	} else {	
		
		$filters = explode('+', $filter);
		$arr = array_to_postgresql($filters, 'text');
		$str = "SELECT biosql.pdb_tree_type($tree_id)";
		$res = pg_query($db_handle, $str);
		$row = pg_fetch_row($res);
		//echo "$row[0]<br>";
		switch ($row[0]) {
			case 'phylogeny':
				switch (true) {
					case (in_array('tip', $filters) && in_array('internal', $filters)):
						$str = "SELECT label 
							FROM biosql.node 
							WHERE tree_id = $tree_id
							AND label LIKE '%$qstr%'";
						break;
					case (in_array('tip', $filters)):
						$str = "SELECT label
							FROM biosql.node 
							WHERE tree_id = $tree_id
							AND label LIKE '%$qstr%'
							AND right_idx-left_idx = 1";
						break;
						
					case (in_array('internal', $filters)):
						$str = "SELECT label
							FROM biosql.node 
							WHERE tree_id = $tree_id
							AND label LIKE '%$qstr%'
							AND right_idx-left_idx <> 1";
						break;
				}
				break;
				
			case 'taxonomy':
				$str = "SELECT n.label 
					FROM biosql.node n, biosql.node_qualifier_value nq, biosql.term tm
					WHERE tree_id = $tree_id
					AND n.node_id = nq.node_id
					AND nq.term_id = tm.term_id
					AND label LIKE '%$qstr%'
					AND tm.name = ANY($arr)";
				break;
		}
		
	}

	
	$res = pg_query($db_handle, $str);
	$labels = pg_fetch_all_columns($res);
	$first = true;
	
	echo json_encode($labels);


?>