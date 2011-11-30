<?php

	# RETURNS DISTINCT VALUES OF A TABLE FIELD
	# A QUERY MAY BE APPLIED
	session_start();
	include "config_setup.php";
	include "../lib/php_utils.php";
	
	$db_handle = eb_connect_pg($config);
	
	$query = $_GET['query'];
	$sid = $_GET['sid'];
	$field = $_GET['field'];
	
	if (!$sid || !$field) exit("sid=source_id and filed=\$field required");

	$sources = $_SESSION['sources'];
	$source = get_obj($sources, $sid);
	
	switch ($source['term']) {
		case 'biotable':
		case 'biogeographic':
			$str = $str . " SELECT DISTINCT \"" . $field . "\" FROM " . $source['dbloc'];
			if ($query)	$str = $str . " WHERE \"" . $field . "\" LIKE '%$query%'";
			$str = $str . " ORDER BY \"$field\"";
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
							AND ds.\"Availability\" <> 'RESTRICTED'
							AND t.binomial IS NOT NULL";
						if ($query)	$str = $str . " AND ds.\"" . $field . "\" LIKE '%$query%'";
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
								WHERE t.binomial IS NOT NULL
								AND m.\"DataSourceID\" = ds.\"DataSourceID\"
								AND ds.\"Availability\" <> 'RESTRICTED'";
						if ($query)	$str = $str . " AND t.\"" . $field . "\" LIKE '%$query%'";
                        $str = $str . " ORDER BY t.\"$field\"";
						break;
					case 'HabitatName':
					case 'BiotopeType':
						$str = "SELECT DISTINCT b.\"$field\"
								FROM gpdd.taxon t, gpdd.main m, gpdd.biotope b, gpdd.datasource ds
							 	WHERE t.\"TaxonID\" = m.\"TaxonID\"
							 	AND m.\"BiotopeID\" = b.\"BiotopeID\"
							 	AND t.binomial IS NOT NULL
							 	AND m.\"DataSourceID\" = ds.\"DataSourceID\"
								AND ds.\"Availability\" <> 'RESTRICTED'";
						if ($query)	$str = $str . " AND b.\"" . $field . "\" LIKE '%$query%'";
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
								 AND t.binomial IS NOT NULL
								AND m.\"DataSourceID\" = ds.\"DataSourceID\"
								AND ds.\"Availability\" <> 'RESTRICTED'";
						if ($query)	$str = $str . " AND l.\"" . $field . "\" LIKE '%$query%'";
                        $str = $str . " ORDER BY l.\"$field\"";
						break;
						
					default:
						break;
				}
			break;
	}	
	//echo "$str<br>";
	$res = pg_query($db_handle, $str);
	$vals = pg_fetch_all_columns($res);

	echo json_encode($vals);
?>