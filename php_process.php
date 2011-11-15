<?php

function process_qset($oldtoken, $newtoken, $lastaction, $lastid, $qterm, $qobjects) {
	
	# BACK BUTTON
	if ($lastaction == 'run') {
		$qobjid = $lastid;
		return $qobjid;
	}
	
	if ($oldtoken == $newtoken || $qobjects[count($qobjects) - 1]['status'] == 'new') {
		# REFRESH
		$qobject = $qobjects[count($qobjects) - 1];
		$qobjid = $qobject['id'];
	} else {
		if (!$qobjects) $qobjects = array();
		
		# CREATE NEW QOBJECT
		$qname = get_next_name($qobjects, $qterm);
		$qobjid = md5(uniqid());
		echo "Creating new $qterm qobject, id $qobjid<br>";
		$qobject = array(
			'id' => $qobjid,
			'term' => $qterm,
			'name' => $qname,
			'status' => 'new'
			);
		
		# ADD SOURCE TO BIOTREE/BIOTABLE QUERY
		if ($qterm == 'biotree') $qobject['sources'] = array($_SESSION['biotree_sid']);
		if ($qterm == 'biotable') $qobject['sources'] = array($_SESSION['attribute_sid']);

		array_push($qobjects, $qobject);
		$_SESSION['qobjects'] = $qobjects;
	}
	return $qobjid;
}


#=====================================================================================================

function process_get_sources($db_handle, $sourceids) {
	
	
	$sources = get_sources($db_handle, $sourceids, 'bio');
	
	# WHICH TYPES OF QUERY ARE AVAILABLE?
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
	$_SESSION['sources'] = $sources;
	$_SESSION['bioname'] = $bioname;
	$_SESSION['biotable'] = $biotable;
	$_SESSION['biotree'] = $biotree;
	$_SESSION['biogeographic'] = $biogeographic;
	$_SESSION['biotemporal'] = $biotemporal;
	return 'main';
}

#=====================================================================================================

function process_delete_query($db_handle, $qobjid) {
	
	$qobjects = $_SESSION['qobjects'];
	
	
	$_SESSION['names'] = $names;
	$idx = obj_idx($qobjects,$qobjid);
	unset ($qobjects[$idx]);
	//echo "query $qobjid deleted<br>";
	array_values($qobjects);
	$names = null;
	# RUN QUERIES
	if (!empty($qobjects)) {
		$sources = $_SESSION['sources'];
		foreach ($qobjects as $qobject) {
			$out = query($db_handle, $qobject, $qobjects, $names, $sources);
			$qobjects = save_obj($qobjects,$out[0]);
			$names = $out[1];
		}	
		$_SESSION['names'] = $names;	
	} else {
		unset($_SESSION['names']);
		unset($_SESSION['qobjects']);
	}
	$_SESSION['qobjects'] = $qobjects;	
}

#=====================================================================================================

function process_new_output ($newtoken, $newtoken, $output_sid) {
	
	$outputs = $_SESSION['outputs'];
	$sources = $_SESSION['sources'];
	
	switch (true) {
		case ($outputs && $outputs[count($outputs) - 1]['status'] == 'new'):
		case ($outputs && $newtoken == $oldtoken):
			$output = $outputs[count($outputs) - 1];
			$output_id = $output['id'];
			break;
		default;
			if (!$outputs) $outputs = array();
			$output = array();
			$output['sourceid'] = $output_sid;
			$output['id'] =  md5(uniqid());
			$output['status'] = 'new';
			$source = get_obj($sources, $output_sid);
			$output['term'] = $source['term'];
			array_push($outputs, $output);
			break;
	}
	
	$_SESSION['outputs'] = $outputs;
	return($output['id']);
	
}

#=====================================================================================================

function process_delete_output ($oid) {
	
	$outputs = $_SESSION['outputs'];
	
	$idx = obj_idx($outputs, $oid);
	unset ($outputs[$idx]);
	array_values($outputs);
	
	$_SESSION['outputs'] = $outputs;
	
}

#=====================================================================================================



?>