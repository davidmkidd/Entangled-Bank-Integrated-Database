<?php

#=================================================================================================================
	
function write_outputs($db_handle, $config) {

	# WRITES ALL OUTPUTS TO COMPRESSED ARCHIVE
	
	if ($_SESSION['names']) $names = $_SESSION['names'];
	if ($_SESSION['qobjects']) $qobjects = $_SESSION['qobjects'];
	if ($_SESSION['outputs']) $outputs = $_SESSION['outputs'];
	if ($_SESSION['sources']) $sources = $_SESSION['sources'];
	$zip = $config['out_path'] . "/" . $_SESSION['zip'];
	if ($_SESSION['zip'] && file_exists($zip)) {
		//echo "Deleting zip<br>";
		unlink($zip);
	}
	
	#UNIQE ID FOR OUTPUT TO PREVENT FILE NAME CONFLICTS
	$oid = substr(md5(uniqid()),0,4);
	$_SESSION['oid'] = $oid;
	
		
	# WRITE OUTPUTS
	foreach ($outputs as $output) {
		$filename = str_replace(" ","_",$output['name']) . "_$oid";
		$output['filename'] = $filename;
		unset ($output['outfiles']);
		write_output($db_handle, $config, $qobjects, $names, $output, $sources);
		$outputs = save_obj($outputs, $output);
		$_SESSION['outputs'] = $outputs;
	}

	# ADD OUTPUTS TO README AND FILES_TO_ZIP
	$files_to_zip = array();
	foreach ($outputs as $output) {
		$outfiles = $output['outfiles'];
		$files_to_zip = array_merge($files_to_zip, $outfiles);
	}
	
	# WRITE README
	$readme = write_readme($db_handle, $sources, $qobjects, $outputs);
	$out_path = $config['out_path'];
	$fn = $out_path . "/readme_$oid.txt";
	$fh = fopen($fn, 'w') or die("can't open file $fn: $php_errormsg");
	fputs($fh, $readme);
	fclose($fh) or die ($php_errormsg);
	# add readme to zip list
	array_push($files_to_zip, $fn);
	$zn = "ebdata_$oid.zip";
	
	//echo "zipping files ", implode(", ", $files_to_zip), " to $zn<br>";
	
	$res = create_zip($files_to_zip, $out_path . '/' . $zn, true);
	
	if ($res === false) {
		echo "php_interface_subs::html_write: zip file creation failed";
		return null;
	} else {
		# Delete files_to_zip
		foreach ($files_to_zip as $file) {
			if (file_exists($file)) unlink($file);
		}
		$_SESSION['zip'] = $zn;
	}
}

#=================================================================================================================


function write_output($db_handle, $config, $qobjects, $names, &$output, $sources) {

	# WRITE INDIVIDUAL DATA OUTPUT TO TEMPORARY FILE
	
	$term = $output['term'];
	
	switch ($term) {
		case 'biotable':
			write_biotable($db_handle, $config, $output, $sources, $names);
			break;
		case 'biogeographic':
			write_biogeographic($db_handle, $config, $qobjects, $output, $sources, $names);
			break;	
		case 'biotree':
			write_biotree($db_handle, $config, $output, $sources, $names);
			break;
		case 'biorelational' :
			write_biorelational($db_handle, $config, $qobjects, $output, $sources, $names);
			break;
		}
	}

#=================================================================================================================
	
	function write_biogeographic($db_handle, $config, $qobjects, &$output, $sources, $names) {
		
		$source = get_obj($sources, $output['sourceid']);
		$term = $source['term'];
		$dbloc = $source['dbloc'];
		$namefield = $source['namefield'];
		$format= $output['sp_format'];
		$filename = $output['filename'];
		//$outfilename = $filename;
		$outpath = $config['out_path']. "/";;

		$str = "SELECT * FROM $dbloc";
		if ($names) {
			$names_arr = array_to_postgresql($names,'text');
			$str = $str . " WHERE $namefield = ANY($names_arr)";
		}
		
		switch ($format) {
			case 'shapefile' :
				$pfile = $outpath . $filename. '.prj';
				$outfiles = array(
					$outpath . $filename . '.shp',
					$outpath . $filename . '.shx',
					$outpath . $filename . '.dbf',
					$pfile
					);
				
				$filename = $filename . '.shp';
				$driver = 'ESRI Shapefile';
				$ext = '.shp';
				# PROJECTION FILE
				//echo "$pfile<br>";
				$fh = fopen($pfile, "w+") or die ("write_geographic projection: failed to open $pfile: $php_errormsg");
				$pstr = 'GEOGCS["GCS_WGS_1984",DATUM["D_WGS_1984",SPHEROID["WGS_1984",6378137.0,298.257223563]],PRIMEM["Greenwich",0.0],UNIT["Degree",0.0174532925199433]]';
				fwrite($fh, $pstr);
				fclose($fh);
				break;
			case 'mapinfo':
				$outfiles = array(
					$outpath . $filename . '.dat',
					$outpath . $filename . '.id',
					$outpath . $filename . '.map',
					$outpath . $filename . '.tab');
				$filename = $filename . '.tab';
				$ext = '.tab';
				$driver = 'MapInfo file';
				break;
			case 'dgn':
				$filename = $filename . '.dgn';
				$driver = 'DGN';
				$outfiles = array($outpath . $filename);
				break;
			case 'dxf':
				$filename = $filename . '.dxf';
				$outfiles = array($outpath . $filename);
				$driver = 'DXF';
				$ext = '.dxf';
				break;
			case 'kml':
				$filename = $filename . '.kml';
				$outfiles = array($outpath . $filename);
				$driver = 'KML';
				$ext = '.kml';
				break;
			case 'gml':
				$outfiles = array($filename . '.gml',
					$outpath . $filename . '.xsd');
				$filename = $filename . '.gml';
				$driver = 'GML';
				$ext = '.gml';
				break;
			default:
				echo "write: spatial format " . $output['format'] . " not implemented";
				break;
			}
		
		# OS HARDCODE
		#$write_file = getcwd() . '/' . $outpath . $filename;
		$write_file = $outpath . $filename;
		if (file_exists($write_file)) unlink($write_file);
		$db_connect = ' PG:"host=' . $config['host'] . ' user=' . $config['user'] .	' dbname=' . $config['dbname'] . ' password=' . $config['password'] . '" ';
		
		$ogr = $config['ogr2ogr_path'];
		$os = php_uname('s');
		if ($os == 'Linux') {
			$cmdstr = $ogr . 'ogr2ogr" -f "' . $driver . '" ';
			$cmdstr = $cmdstr . " $write_file ";
			$cmdstr = $cmdstr . $db_connect;
			$cmdstr = $cmdstr . ' -sql "' . $str . '"';
		} else {
		# WORKS IN WIN
		$cmdstr = '""' . $ogr . '\ogr2ogr" -f "' . $driver . '" ';
		$cmdstr = $cmdstr . " $write_file ";
		$cmdstr = $cmdstr . $db_connect;
		$cmdstr = $cmdstr . ' -sql "' . $str . '" 2>&1"';
		}
		//echo "<BR>$cmdstr<br>";
		$out = shell_exec($cmdstr);

		if (!$output['outfiles']) {
			$output['outfiles'] = $outfiles;
		} else {
			array_push($output['outfiles'], $outfiles);
		}
	}
#=================================================================================================================
	
	function write_biorelational($db_handle, $config, $qobjects, &$output, $sources, $names) {
		
		//echo "write_biorelational: begin ";
		
		$oid = $_SESSION['oid'];
		$source = get_obj($sources, $output['sourceid']);
		$mids = query_get_mids($qobjects);
		if ($mids) {
			if (!empty($mids)) {
				$midsarr = array_to_postgresql($mids, 'numeric');
			} else {
				$midsarr = null;
			}
		}
		
		if ($midsarr) {
		
			$outfiles = array();
		
			# 1 MAIN
			$str = "SELECT * FROM gpdd.main";
			if ($midsarr) $str = $str . " WHERE \"MainID\" = ANY($midsarr)";
			//echo "$str<br>";
			$res = pg_query($db_handle, $str);
			$cols = get_column_names ($db_handle, 'gpdd.main');
			$output['filename'] = str_replace(" ","_", $output['name']) . "_gpdd_main_$oid";
			write_delineated_gpdd($config, $cols, $res, $output);
			
			# 2 TAXON
			if ($midsarr) {
				$str = "SELECT t.* FROM gpdd.main m, gpdd.taxon t 
				WHERE m.\"TaxonID\" = t.\"TaxonID\"
				AND m.\"MainID\" = ANY($midsarr)";
			} else {
				$str = "SELECT t.* FROM gpdd.main m, gpdd.taxon t 
				WHERE m.\"TaxonID\" = t.\"TaxonID\"
				AND t.\"TaxonID\" IS NOT NULL";
			}
			
			$res = pg_query($db_handle, $str);
			$cols = get_column_names ($db_handle, 'gpdd.taxon');
			$output['filename'] = str_replace(" ","_",$output['name']) . "_gpdd_taxon_$oid";
			write_delineated_gpdd($config, $cols, $res, $output);
			
			# 3 DATASOURCE
			if ($midsarr) {
				$str = "SELECT d.* FROM gpdd.main m, gpdd.datasource d
					WHERE  m.\"DataSourceID\" = d.\"DataSourceID\"
					AND m.\"MainID\" = ANY($midsarr)";
			} else {
				$str = "SELECT d.* FROM gpdd.main m, gpdd.datasource d, gpdd.taxon t
					WHERE  m.\"DataSourceID\" = d.\"DataSourceID\"
					AND m.\"TaxonID\" = t.\"TaxonID\"
					AND t.binomial IS NOT NULL";
			}
			$res = pg_query($db_handle, $str);
			$cols = get_column_names ($db_handle, 'gpdd.datasource');
			$output['filename'] = str_replace(" ","_",$output['name']) . "_gpdd_datasource_$oid";
			write_delineated_gpdd($config, $cols, $res, $output);
			
			# 4 LOCATION
			if ($midsarr) {
				$str = "SELECT l.* FROM gpdd.main m, gpdd.location l
				WHERE m.\"LocationID\" = l.\"LocationID\"
				AND m.\"MainID\" = ANY($midsarr)";
			} else {
				$str = "SELECT l.* FROM gpdd.main m, gpdd.location l, gpdd.taxon t
				WHERE m.\"LocationID\" = l.\"LocationID\"
				AND m.\"TaxonID\" = t.\"TaxonID\"
				AND t.binomial IS NOT NULL";
			}
	
			$res = pg_query($db_handle, $str);
			$cols = get_column_names ($db_handle, 'gpdd.location');
			$output['filename'] = str_replace(" ","_",$output['name']) . "_gpdd_location_$oid";
			write_delineated_gpdd($config, $cols, $res, $output);
			
			# 5 DATA
			
			# Temporal limits
			if ($midsarr) {
				$str = "SELECT d.\"DataID\",
					d.\"MainID\",
					d.\"Population\",
					d.\"PopulationUntransformed\",
					d.\"SampleYear\",
					t.\"TimePeriod\",
					d.\"Generation\",
					d.\"SeriesStep\",
					d.\"DecimalYearBegin\",
					d.\"DecimalYearEnd\"
					FROM gpdd.data d, gpdd.timeperiod t
					WHERE d.\"TimePeriodID\" = t.\"TimePeriodID\"
					AND d.\"MainID\" = ANY($midsarr)";
			} else {
				$str = "SELECT d.\"DataID\",
					d.\"MainID\",
					d.\"Population\",
					d.\"PopulationUntransformed\",
					d.\"SampleYear\",
					tp.\"TimePeriod\",
					d.\"Generation\",
					d.\"SeriesStep\",
					d.\"DecimalYearBegin\",
					d.\"DecimalYearEnd\"
					FROM gpdd.data d, gpdd.timeperiod tp, gpdd.main m, gpdd.taxon t
					WHERE d.\"TimePeriodID\" = tp.\"TimePeriodID\"
					AND d.\"MainID\" = m.\"MainID\"
					AND m.\"TaxonID\" = t.\"TaxonID\"
					AND t.binomial IS NOT NULL";
			}
			//echo "$str<br>";
			$res = pg_query($db_handle, $str);
			$cols = array('DataID',"MainID", "Population","PopulationUntransformed","SampleYear","TimePeriod",
				"Generation","SeriesStep","DecimalYearBegin","DecimalYearEnd");
			$output['filename'] =  str_replace(" ","_",$output['name']) . "_gpdd_data_$oid";
			write_delineated_gpdd($config, $cols, $res, $output);
			
			# LOCATION GEOGRAPHIC
			$filename_pt = str_replace(" ","_",$output['name']) . "_gpdd_location_pt$oid";
			$filename_bbox = str_replace(" ","_",$output['name']). "_gpdd_location_bbox$oid";
			#$outfilename_pt = $filename_pt ;
			#$outfilename_bbox = $filename_bbox ;
			
			$sp_format = $output['sp_format'];
			//print_r($output);
			//echo "<br>spformat: $sp_format<br>";
			
			switch ($sp_format) {
				case 'shapefile' :
					
					$sp_outfiles = array(
						$config['out_path'] . "/" . $filename_pt . '.shp',
						$config['out_path'] . "/" . $filename_pt . '.shx',
						$config['out_path'] . "/" . $filename_pt . '.dbf',
						$config['out_path'] . "/" . $filename_bbox . '.shp',
						$config['out_path'] . "/" . $filename_bbox . '.shx',
						$config['out_path'] . "/" . $filename_bbox . '.dbf'
						);
					$filename_pt = $filename_pt . '.shp';
					$filename_bbox = $filename_bbox . '.shp';
					$driver = 'ESRI Shapefile';
					$ext = '.shp';
					break;
				case 'mapinfo':
					$sp_outfiles = array(
						$config['out_path'] . "/" . $filename_pt . '.dat',
						$config['out_path'] . "/" . $filename_pt . '.id',
						$config['out_path'] . "/" . $filename_pt . '.map',
						$config['out_path'] . "/" . $filename_pt . '.tab',
						$config['out_path'] . "/" . $filename_bbox . '.dat',
						$config['out_path'] . "/" . $filename_bbox . '.id',
						$config['out_path'] . "/" . $filename_bbox . '.map',
						$config['out_path'] . "/" . $filename_bbox . '.tab');
					$filename_pt = $filename_pt . '.tab';
					$filename_bbox = $filename_bbox . '.tab';
					$ext = '.tab';
					$driver = 'MapInfo file';
					break;
				case 'dgn':
					$filename_pt = $filename_pt . '.dgn';
					$filename_bbox = $filename_bbox . '.dgn';
					$driver = 'DGN';
					$sp_outfiles = array(
						$config['out_path'] . "/" . $filename_pt,
						$config['out_path'] . "/" .  $filename_bbox
						);
					break;
				case 'dxf':
					$filename_pt = $filename_pt . '.dxf';
					$filename_bbox = $filename_bbox . '.dxf';
					$sp_outfiles = array(
						$config['out_path'] . "/" .  $filename_pt,
						$config['out_path'] . "/" .  $filename_bbox
						);
					$driver = 'DXF';
					$ext = '.dxf';
					break;
				case 'kml':
					$filename_pt = $filename_pt . '.kml';
					$filename_bbox = $filename_bbox . '.kml';
					$sp_outfiles = array(
						$config['out_path'] . "/" .  $filename_pt,
						$config['out_path'] . "/" .  $filename_bbox);
					$driver = 'KML';
					$ext = '.kml';
					break;
				case 'gml':
					$sp_outfiles = array(
						$config['out_path'] .  "/" . $filename_pt . '.gml',
						$config['out_path'] . "/" .  $filename_pt . '.xsd'
						);
					$filename_pt = $filename_pt . '.gml';
					$filename_bbox = $filename_bbox . '.gml';
					$driver = 'GML';
					$ext = '.gml';
					break;
				default:
					echo "write: spatial format " . $output['format'] . " not implemented";
					break;
				}
			
			$db_connect = ' PG:"host=' . $config['host'] . ' user=' . $config['user'] .	' dbname=' . $config['dbname'] . ' password=' . $config['password'] . '" ';
			
			# LOCATION POINTS
			# Fix for fieldname captialisation problem with ogr2ogr - sql statement
			$str = "SELECT l.locationid
				 FROM gpdd.location_pt l, gpdd.main m
				 WHERE m.\"LocationID\" = l.locationid
				 AND m.\"MainID\" = ANY($midsarr)";
			$res = pg_query($db_handle, $str);
			$arr = array_to_postgresql(pg_fetch_all_columns($res),'numeric');
			$str = "SELECT * FROM gpdd.location_pt WHERE locationid = ANY($arr)";		
			
			$write_file = $config['out_path'] . "/$filename_pt";
			if (file_exists($write_file)) unlink($write_file);
			//array_push($output['outfiles'],$write_file);
			$cmdstr = "\"\"C:\FWTools2.4.7\bin\ogr2ogr\" -f \"$driver\"";
			$cmdstr = $cmdstr . " $write_file";
			$cmdstr = $cmdstr . $db_connect;
			$cmdstr = $cmdstr . ' -sql "' . $str . '"';
			$cmdstr = $cmdstr . ' 2>&1"';
			//echo "<BR>$cmdstr<br>";
			$out = shell_exec($cmdstr);
			//echo "out: $out<br>";
			
			# LOCATION BBOX
			# Fix for fieldname captialisation problem with ogr2ogr - sql statement
			$str = "SELECT l.locationid
				 FROM gpdd.location_bbox l, gpdd.main m
				 WHERE m.\"LocationID\" = l.locationid
				 AND m.\"MainID\" = ANY($midsarr)";
			$res = pg_query($db_handle, $str);
			$arr = array_to_postgresql(pg_fetch_all_columns($res),'numeric');
			$str = "SELECT * FROM gpdd.location_bbox WHERE locationid = ANY($arr)";		
			
			$write_file = $config['out_path'] . "/$filename_bbox";
			if (file_exists($write_file)) unlink($write_file);
	
			$cmdstr = "\"\"C:\FWTools2.4.7\bin\ogr2ogr\" -f \"$driver\"";
			$cmdstr = $cmdstr . " $write_file";
			$cmdstr = $cmdstr . $db_connect;
			$cmdstr = $cmdstr . ' -sql "' . $str . '"';
			$cmdstr = $cmdstr . ' 2>&1"';
			$out = shell_exec($cmdstr);
			foreach ($sp_outfiles as $file) array_push($output['outfiles'], $file);
		}
	}
	
#=================================================================================================================
	
function write_biotable ($db_handle, $config, &$output, $sources, $names) {
	
	//print_r($output);
	//echo "<BR>";
	
	$source = get_obj($sources, $output['sourceid']);
	//$term = $source['term'];
	$dbloc = $source['dbloc'];
	$namefield = $source['namefield'];
	$db_format = $output['db_format'];
	
	if ($names) {
		$names_arr = array_to_postgresql($names,'text');
		}
	
	
	$columns = $output['fields'];

	$colstr = array_dbcols($columns, null, true);
	$str = "SELECT $colstr FROM $dbloc";
	if ($names) $str = $str . " WHERE $namefield = ANY($names_arr)";
	$res = pg_query($str);
	
	switch ($db_format) {
		case 'comma-delineated (*.csv)':
		case 'tab-delineated (*.txt)':
			write_delineated($config, $res, $output);
			break;			
		case 'dBase (*.dbf)':
			$write_dbase($config, $res, $output, $source);
			break;
		default:
			echo "write_biotable: database format not recognised";
			break;
	}

}
 
 #=================================================================================================================

 function write_biotree($db_handle, $config, &$output, $sources, $names) {
 	
 	# Get session variables
	$sid = session_id();
	$spath = session_save_path();
	$outpath = $config['out_path'] . "/";
	$perl_script_path = $config['perl_script_path'];
	
	# LINUX HARDCODE
	//if (strpos ($spath, ";") !== FALSE)
	#$spath = substr ($spath, strpos ($spath, ";")+1);
	#echo "spath $spath<br>";
	
	$tree_id = $output['tree_id'];	
	$filename = $output['filename'];
	$output_sid = $output['sourceid']; 
	$brqual = $output['brqual'];
	$format = $output['format'];

	//print_r($output);
	//echo "<br>";
	
	switch ($format) {
		case 'newick':
			$filename = $outpath . $filename . '.tre';
			$outfiles = array($filename);
			break;
		case 'nhx':
			$filename = $outpath . $filename . '.nhx';
			$outfiles = array($filename);
			break;
		case 'tabtree':
			$filename = $outpath . $filename . '.tab';
			$outfiles = array($filename);
			break;
		case 'lintree':
			$filename = $outpath . $filename . '.lin';
			$outfiles = array($filename);
			break;
		case 'nexus':
			$filename = $outpath . $filename . '.nex';
			$outfiles = array($filename);
			break;
		case 'xml':
			$filename = $outpath . $filename . '.xml';
			$outfiles = array($filename);
			break;
		case 'svg':
			$filename = $outpath . $filename . '.svg';
			$outfiles = array($filename);
			break;
		default;
			break;
		}
	

	# Get NEWICK string
	
	if ($output['subtree'] == 'subtree') {
		# LCA Subtree array
		if ($names) {
			$arr = array_to_postgresql($names,'text');
			$str = "SELECT biosql.pdb_lca_subtree_label($tree_id, $arr)";
		} else {
			$str = "SELECT label FROM biosql.node WHERE tree_id = $tree_id)";
		}
		//echo "str: $str<br>";
		$res = pg_query($str);
		$lcanames = pg_fetch_all_columns($res);
		$arr = array_to_postgresql($lcanames, 'text');
	} else {
		$arr = array_to_postgresql($names, 'text');
	}
	//echo $output['brqual'] . "<br>";
	# PRUNED
	if (!$output['brqual'] || $output['brqual'] == 'none') {
		$str = "SELECT biosql.pdb_as_newick_label($tree_id, $arr)";
	} else {
		$str = "SELECT biosql.pdb_as_newick_label($tree_id, $arr, $brqual, FALSE)";
	}

	//echo "str: $str<br>";
	$res = pg_query($str);
	$row = pg_fetch_row($res);
	$tree = $row[0];

	
	//echo "format: $format<br>";
	if ($format !== 'newick') {
		$_SESSION['newick'] = $tree;
		session_write_close(); 
		$str = "$perl_script_path\convert_tree.pl $sid $spath $format 2>&1";
		$tree = shell_exec($str);
		//echo "$tree<br>";
	} 

	# WRITE TREE FILE
	$fh = fopen($filename, 'w') or die ("failed to open tree file fo writing");
	fwrite($fh, $tree);
	fclose($fh);
	
 	$output['outfiles'] = $outfiles;

 }
 

#=================================================================================================================

function write_delineated($config, $res, &$output) {

	if (!$res) {
		echo "write_delineated error: result is empty<br>.";
		exit;
	} else {

	$file = $output['filename'];
	$db_format = $output['db_format'];
	$fields = $output['fields'];
	$outpath = $config['out_path'];
	
	if ($db_format == 'comma-delineated (*.csv)') {
		$file = "$outpath/$file.csv";
		$del = ",";
	} else {
		$file = "$outpath/$file.txt";
		$del = "\t";
	}
	
	#WRITE TO FILE	
	$fh = fopen($file, "w+") or die ("write_delineated: failed to open $file: $php_errormsg");

	#Write column headers
	$first = 1;
	foreach ($fields as $field) {
		if ($first == 1) {
			$mystr = $field;
			$first = 0;
		} else {
			$mystr = $mystr . $del . $field;
		}
	}
	$mystr = $mystr . "\n";
	fwrite($fh, $mystr);
	
	#Write Data
	$c = 0;
	while ($row = pg_fetch_row($res)) {
		$c++;
		for ($i = 0; $i <= count($fields); $i++) {
			if ($i == 0) {
				$mystr = $row[$i];
			} else {
				$mystr = $mystr . $del . $row[$i];
			}
		}
		$mystr = $mystr . "\n";
		fwrite($fh, $mystr);
	}
	# Close file	
	fclose($fh);
	}
	$output['n'] = $c;
	if (!$output['outfiles']) {
		$output['outfiles'] = array($file);
	} else {
		array_push($output['outfiles'],$file);
	}
}


#=================================================================================================================

function write_delineated_gpdd($config, $fields, $res, &$output) {

	if (!$res) {
		echo "write_delineated error: result is empty<br>.";
		exit;
	} else {

	$file = $output['filename'];
	//$db_format = $output['db_format'];
	//$fields = $output['fields'];
	$outpath = $config['out_path'];
	
	if ($db_format == 'comma-delineated (*.csv)') {
		$file = "$outpath/$file.csv";
		$del = ",";
	} else {
		$file = "$outpath/$file.txt";
		$del = "\t";
	}
	
	
	#WRITE TO FILE	
	$fh = fopen($file, "w+") or die ("write_delineated: failed to open $file: $php_errormsg");
	//echo "writing $file<br>";
	$first = 1;
	foreach ($fields as $field) {
		if ($first == 1) {
			$mystr = $field;
			$first = 0;
			} else {
			$mystr = $mystr . $del . $field;
			}
		}
	$mystr = $mystr . "\n";
	fwrite($fh, $mystr);
	
	#Write Data
	$c = 0;
	while ($row = pg_fetch_row($res)) {
		$c++;
		for ($i = 0; $i <= count($fields); $i++) {
			if ($i == 0) {
				$mystr = $row[$i];
				} else {
				$mystr = $mystr . $del . $row[$i];
				}
			}
		$mystr = $mystr . "\n";
		fwrite($fh, $mystr);
	}
	# Close file	
	fclose($fh);
	}
	$output['n'] = $c;
	if (!$output['outfiles']) {
		$output['outfiles'] = array($file);
	} else {
		array_push($output['outfiles'],$file);
	}
}

#=================================================================================================================

function write_dbase($config, $res, &$output, $source) {
	
	# Writes table to dbf
	# UNFINISHED
	if (!$res) {
		echo "write_dbase error: result is empty<br>.";
		exit;
	} else {

	$file = $output['filename'];
	$fields = $output['fields'];
	$outpath = $config['out_path'];
	$file = "$outpath/$file.dbf";
	$sfields = $source['fields'];
	$def = array();
	
	# FIELD DEFINTION ARRAY
	foreach ($fields as $field) {
		$myfield = get_field($field, $sfields);
		
		switch ($myfield['dbtype']) {
			case 'numeric':
			case 'float':
			case 'float8':
			case (substr($ftype, 0, 3) == 'int'):
				$fdef = array();
				break;
			case (substr($ftype,-4) == 'char'):
			case 'text':
			case 'varchar':
				$ftype = 'text';
				break;
			default:
				//echo "html_table_query: unrecognised DB field type - $ftype<br>";
				break;
		}
	}

// creation
if (!dbase_create($file, $def)) {
  echo "Error, can't create the database\n";
}
	
	}
}

#=================================================================================================================
	
function write_readme($db_handle, $sources, $qobjects, $outputs) {
		
	# WRITE README
	
	$dul = "================================================================\r\n";
	$sul = "----------------------------------------------------------------\r\n";
	
	# HEADER
	$readme = $readme . $dul . "\r\n";
	$readme = $readme . "Entangled Bank Download (accessed " . strftime('%c') . ")\r\n\r\n$dul";
	
	$str = 'www.entangled-bank.org\r\n';
	
	#DATA SOURCES
	$readme = $readme . "\r\n";
	$srm = '';
	$readme = $readme  . count($sources) . " data sets\r\n\r\n" . $sul . "\r\n";
	foreach ($sources as $source) {
		$srm = $srm . $source['id'] . "\r\n" . $source['name'] . "\r\n";
		$str = "SELECT ref FROM source.source WHERE source_id =" . $source['id'];
		$res = pg_query($db_handle, $str);
		$row = pg_fetch_row($res);
		$srm = $srm . $row[0] . "\r\n";
		if ($source['www']) $srm = $srm . $source['www'] . "\r\n";
	}
	
	$readme = $readme . $srm;
	$readme = $readme . $sul;
	
	# QUERIES
	$readme = $readme . "\r\n";
	
	if ($qobjects) {
		$c = count($qobjects);
	} else {
		$c = 0;
	}
	
	switch ($c) {
		case 0 :
			$readme = $readme . "0 queries, all data in outputs returned";
			break;
		case 1:
			$readme = $readme . "1 query";
		default:
			$readme = $readme . "$c queries";
			break;
	}
		
	$readme = "$readme\r\n\r\n$sul\r\n";

	$i = 0;
	$str = 'Query Chain:\r\n';
	if ($qobjects) {
		foreach ($qobjects as $qobj) {
			if ($i > 0) $str = "$str " . $qobj['queryoperator'] . " ";
			$str = $str . $qobj['name'];
			$i++;
		}
	}
	$readme = $readme . $str;
	
	# SQL
	$str = "\r\n\r\nNames SQL:";
	if ($qobjects) {
		$i = 0;
		foreach ($qobjects as $qobj) {
			if ($i > 0) $str = $str. "\r\n" . $qobj['queryoperator'];
			$str = $str . "\r\n" . $qobj['sql_names_query'];
			$i++;
		}
		$readme = $readme . htmlspecialchars_decode($str);
		
		$str = "\r\n\r\nSeries SQL: ";
		foreach ($qobjects as $qobj) {
			if ($qobj['sql_series_query']) {
				$str = $str . $qobj['name'] . "\r\n";
				$str = $str . $qobj['sql_series_query'];
			}
			$i++;
			$str = $str . "\r\n\r\n";
		}
		$readme = $readme . htmlspecialchars_decode($str) . "\r\n";
	}
	
	# OUTPUTS
	$str = "$sul\r\n" . count($outputs) . " outputs\r\n\r\n$sul";
	foreach ($outputs as $output) {
		$str = $str . "\r\n" . $output['name'];
		$outfiles = $output['outfiles'];
		foreach ($outfiles as $outfile) {
			$str2 = substr($outfile, strrpos($outfile,"/") + 1);
			$str = $str. "\r\n" . $str2;
		}
		$str = $str. "\r\n";
	}
	$readme = $readme . "\r\n" . $str . "\r\n\r\n$dul";	

	return $readme;
		
}

#=================================================================================================================
?>