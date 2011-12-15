<?php

	# RETURNS TRUE IF FIELD HAS NULL VALUES
	# A NAMES QUERY MAY BE APPLIED
	
	session_start();
	include "../lib/config.php";
	include "../lib/php_utils.php";
	
	$db_handle = eb_connect_pg($config);
	
	$sid = $_GET['sid'];
	$field = $_GET['field'];

	
	$qnames = $_GET['names'];       # FILTER NAMES
	
	if (!$qnames || $qnames !== 'yes') $qnames = 'no';
	
	if ($qnames == 'yes') {
		if ($_SESSION['names'])
			$arr = array_to_postgresql($_SESSION['names'],'text');
	}
	
	if (!$sid || !$field) exit("sid=source_id and field=\$field required");

	$sources = $_SESSION['sources'];
	$source = get_obj($sources, $sid);
	$fields = $source['fields'];
	
	$i = 0;
	$ifield = $fields[$i];
	while ($field !== $ifield['name']) {
		$i++;
		if ($i >= count($fields) - 1) exit("$field required sid=source_id ");
		$ifield = $fields[$i];
	}
	
	# RETURN LOOKUP NAME AS WELL AS ID
	
	//print_r($ifield);

	switch ($source['term']) {
		case 'biotable':
		case 'biogeographic':
			if ($ifield['ebtype'] == 'lookupfield') {
				$str = "SELECT CASE (";
				$str = $str . "SELECT COUNT(*) FROM source.source_fields f, source.source_fieldcodes c";
				$str = $str . " WHERE c.field_id = f.field_id";
				$str = $str . " AND f.source_id = $sid";
				$str = $str . " AND f.field_name = '$field'";
				$str = $str . " AND c.name IS NULL";
				$str = $str . ") WHEN 0 THEN FALSE ELSE TRUE END";
			} else {
				$str = "SELECT CASE (SELECT COUNT(*) FROM " . $source['dbloc'] . " WHERE";
				$str = $str . " \"$field\" IS NULL";
				if ($arr)	$str = $str . " AND \"" . $source['namefield'] . "\" LIKE '%$query%'";
				$str = $str . ") WHEN 0 THEN FALSE ELSE TRUE END";
			}

			break;
		case 'biorelational':
				# GPDD HARDCODE
				switch ($field) {
					case 'Author':
					case 'Year':
					case 'Title':
					case 'Reference':
					case 'Availability':
					case 'Notes':
						$str = "SELECT CASE (SELECT COUNT(*)
							FROM gpdd.taxon t, gpdd.main m, gpdd.datasource ds
							WHERE t.\"TaxonID\" = m.\"TaxonID\"
							AND m.\"DataSourceID\" = ds.\"DataSourceID\"
							AND ds.\"Availability\" <> 'RESTRICTED'";
						$str = $str . " AND ds.\"" . $field . "\" IS NULL";
						if ($arr) $str = $str . " AND t.\"" . $source['namefield'] . "\" = ANY($arr)";
						$str = $str . ") WHEN 0 THEN FALSE ELSE TRUE END";
						break;
						
					case 'TaxonomicPhylum':
					case 'TaxonomicClass':
					case 'TaxonomicOrder':
					case 'TaxonomicFamily':
					case 'TaxonomicGenus':
					case 'binomial':
					case 'CommonName':
					case 'TaxonName':
						$str = "SELECT CASE (SELECT COUNT(*)
							FROM gpdd.taxon t, gpdd.main m, gpdd.datasource ds
							WHERE t.binomial IS NOT NULL
							AND m.\"DataSourceID\" = ds.\"DataSourceID\"
							AND ds.\"Availability\" <> 'RESTRICTED'";
						$str = $str . " AND t.\"" . $field . "\" IS NULL";
						if ($arr) $str = $str . " AND t.\"" . $source['namefield'] . "\" = ANY($arr)";
						$str = $str . ") WHEN 0 THEN FALSE ELSE TRUE END";
						break;
						
					case 'HabitatName':
					case 'BiotopeType':
						$str = "SELECT CASE (SELECT COUNT(*)
							FROM gpdd.taxon t, gpdd.main m, gpdd.datasource ds, gpdd.biotope b
							WHERE t.binomial IS NOT NULL
							AND m.\"DataSourceID\" = ds.\"DataSourceID\"
							AND ds.\"Availability\" <> 'RESTRICTED'";
						$str = $str . " AND b.\"" . $field . "\" IS NULL";
						if ($arr) $str = $str . " AND t.\"" . $source['namefield'] . "\" = ANY($arr)";
						$str = $str . ") WHEN 0 THEN FALSE ELSE TRUE END";
						break;
						
					case 'ExactName':
					case 'TownName':
					case 'CountyStateProvince':
					case 'Country':
					case 'Continent':
					case 'Ocean':
					case 'SpatialAccuracy':
					case 'LocationExtent':
						$str = "SELECT CASE (SELECT COUNT(*)
							FROM gpdd.taxon t, gpdd.main m, gpdd.datasource ds, gpdd.location l
							WHERE t.binomial IS NOT NULL
							AND m.\"DataSourceID\" = ds.\"DataSourceID\"
							AND ds.\"Availability\" <> 'RESTRICTED'";
						$str = $str . " AND l.\"" . $field . "\" IS NULL";
						if ($arr) $str = $str . " AND t.\"" . $source['namefield'] . "\" = ANY($arr)";
						$str = $str . ") WHEN 0 THEN FALSE ELSE TRUE END";
						break;
						
					default:
						$str = "SELECT CASE (SELECT COUNT(*)
							FROM gpdd.taxon t, gpdd.main m, gpdd.datasource ds
							WHERE t.binomial IS NOT NULL
							AND m.\"DataSourceID\" = ds.\"DataSourceID\"
							AND ds.\"Availability\" <> 'RESTRICTED'";
						$str = $str . " AND m.\"" . $field . "\" IS NULL";
						if ($arr) $str = $str . " AND t.\"" . $source['namefield'] . "\" = ANY($arr)";
						$str = $str . ") WHEN 0 THEN FALSE ELSE TRUE END";
						break;
				}
			break;
	}	
	//echo "$str<br>";
	$res = pg_query($db_handle, $str);
	$val = pg_fetch_row($res);
	echo json_encode($val[0]);
?>