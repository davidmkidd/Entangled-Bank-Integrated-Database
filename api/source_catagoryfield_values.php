<?php

	# RETURNS DISTINCT VALUES OF A TABLE FIELD
	# A QUERY MAY BE APPLIED
	session_start();
	include "../lib/config.php";
	include "../lib/php_utils.php";
	
	$db_handle = eb_connect_pg($config);
	
	$query = $_GET['query'];
	$sid = $_GET['sid'];
	$field = $_GET['field'];
	$null = $_GET['null'];

	if ($null == 'n') {
		$null = false;
	} else {
		$null = true;
	}
	if (!$query) $query = "";
	
	//echo "query: $query<br>";
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
				$str = $str . " SELECT c.item, c.name FROM source.source_fields f, source.source_fieldcodes c";
				$str = $str . " WHERE c.field_id = f.field_id";
				$str = $str . " AND f.source_id = $sid";
				$str = $str . " AND f.field_name = '$field' AND";
				if ($null) $str = $str . "(";
				$str = $str . " c.name LIKE '%$query%'";
				if ($null) $str = $str . " OR c.name IS NULL)";
				$str = $str . " ORDER BY c.item";
				
			} else {
				$str = $str . " SELECT DISTINCT \"" . $field . "\"  FROM " . $source['dbloc'] . 
					" WHERE \"" . $field . "\" LIKE '%$query%'";
				if (!$null) $str = $str . " OR \"$field\" IS NULL";
				$str = $str . " ORDER BY \"$field\"";
			}

			break;
		case 'biorelational':
				switch ($field) {
					# GPDD HARDCODE
					case 'Author':
					case 'Year':
					case 'Title':
					case 'Reference':
					case 'Availability':
					case 'Notes':
						$str = "SELECT DISTINCT ds.\"$field\"
							FROM gpdd.taxon t, gpdd.main m, gpdd.datasource ds
							WHERE t.\"TaxonID\" = m.\"TaxonID\"
							AND m.\"DataSourceID\" = ds.\"DataSourceID\"
							AND ds.\"Availability\" <> 'RESTRICTED'";
						if ($null == true) {
							$str = $str . " AND (";
						} else {
							$str = $str . " AND";
						}
						$str = $str . " ds.\"" . $field . "\" LIKE '%$query%'";
						if ($null == true) $str = $str . " OR ds.\"" . $field . "\" IS NULL)";
                        $str = $str . " ORDER BY ds.\"$field\"";
						break;
					case 'TaxonomicPhylum':
					case 'TaxonomicClass':
					case 'TaxonomicOrder':
					case 'TaxonomicFamily':
					case 'TaxonomicGenus':
					case 'binomial':
					case 'CommonName':
					case 'TaxonName':
						$str = "SELECT DISTINCT t.\"$field\"
							FROM gpdd.taxon t, gpdd.main m, gpdd.datasource ds
							WHERE m.\"TaxonID\" = t.\"TaxonID\"
							AND m.\"DataSourceID\" = ds.\"DataSourceID\"
							AND ds.\"Availability\" <> 'RESTRICTED'";
						if ($null == true) {
							$str = $str . " AND (";
						} else {
							$str = $str . " AND";
						}
						$str = $str . " t.\"" . $field . "\" LIKE '%$query%'";
						if ($null == true) $str = $str . " OR t.\"" . $field . "\" IS NULL)";
                        $str = $str . " ORDER BY t.\"$field\"";
						break;
					case 'HabitatName':
					case 'BiotopeType':
						$str = "SELECT DISTINCT b.\"$field\"
							FROM gpdd.taxon t, gpdd.main m, gpdd.biotope b, gpdd.datasource ds
							WHERE t.\"TaxonID\" = m.\"TaxonID\"
							AND m.\"BiotopeID\" = b.\"BiotopeID\"
							AND m.\"DataSourceID\" = ds.\"DataSourceID\"
							AND ds.\"Availability\" <> 'RESTRICTED'";
						if ($null == true) {
							$str = $str . " AND (";
						} else {
							$str = $str . " AND";
						}
						$str = $str . " b.\"" . $field . "\" LIKE '%$query%'";
						if ($null == true) $str = $str . " OR b.\"" . $field . "\" IS NULL)";
                        $str = $str . " ORDER BY b.\"$field\"";
						break;
					case 'ExactName':
					case 'TownName':
					case 'CountyStateProvince':
					case 'Country':
					case 'Continent':
					case 'Ocean':
					case 'SpatialAccuracy':
					case 'LocationExtent':
						$str = "SELECT DISTINCT l.\"$field\"
							FROM gpdd.taxon t, gpdd.main m, gpdd.location l, gpdd.datasource ds
							WHERE t.\"TaxonID\" = m.\"TaxonID\"
							AND m.\"LocationID\" = l.\"LocationID\"
							AND m.\"DataSourceID\" = ds.\"DataSourceID\"
							AND ds.\"Availability\" <> 'RESTRICTED'";
						if ($null == true) {
							$str = $str . " AND (";
						} else {
							$str = $str . " AND";
						}
						$str = $str . " l.\"" . $field . "\" LIKE '%$query%'";
						if ($null == true) $str = $str . " OR l.\"" . $field . "\" IS NULL)";
                        $str = $str . " ORDER BY l.\"$field\"";
						break;
						
					default:
						$str = "SELECT DISTINCT m.\"$field\"
							FROM gpdd.main m, gpdd.datasource ds
							WHERE t.binomial IS NOT NULL
							AND m.\"DataSourceID\" = ds.\"DataSourceID\"
							AND ds.\"Availability\" <> 'RESTRICTED'";
						if ($null == true) {
							$str = $str . " AND (";
						} else {
							$str = $str . " AND";
						}
						$str = $str . " m.\"" . $field . "\" LIKE '%$query%'";
						if ($null == true) $str = $str . " OR m.\"" . $field . "\" IS NULL)";
                        $str = $str . " ORDER BY m.\"$field\"";
						break;
				}
			break;
	}	
	//echo "$str<br>";
	$res = pg_query($db_handle, $str);
	
	if ($ifield['ebtype'] == 'lookupfield') {
		$vals = array_combine(pg_fetch_all_columns($res, 0), pg_fetch_all_columns($res, 1));
	} else {
		$vals = pg_fetch_all_columns($res);
	}

	echo json_encode($vals);
?>