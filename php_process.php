<?php

function qset($oldtoken, $newtoken, $lastaction, $lastid, $qterm, $qobjects) {
	
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
		//echo "Creating new qobject<br>";
		# CREATE NEW QOBJECT
		$qname = get_next_name($qobjects, $qterm);
		$qobjid = md5(uniqid());
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

?>