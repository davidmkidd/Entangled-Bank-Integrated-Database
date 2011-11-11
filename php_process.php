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

function process_get_sources($db_handle, $sourceids, &$qobjects) {
	
	# REFRESH AND BACK
	if (!empty($qobjects)) {
		if ($qobjects[count($qobjects) - 1]['status'] == 'new') unset($qobjects[count($qobjects) - 1]);
	}
	
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


?>