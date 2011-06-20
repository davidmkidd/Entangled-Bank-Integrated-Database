<?php

function write_output($db_handle, $config, $qobjects, $names, $output, $sources) {

	# WRITE INDIVIDUAL DATA OUTPUT TO TEMPORARY FILE
	
	#$source = get_obj($sources, $output['sourceid']);
	$term = $output['term'];
	#$dbloc = $source['dbloc'];
	#$namefield = $source['namefield'];
	#$format = $output['format'];
	#$filename = $output['filename'];	
	#$outpath = substr($config['tmp_path'], strpos($config['tmp_path'],'/') + 1) . '/';
	
	if ($names) {
		$names_arr = array_to_postgresql($names,'text');
		}
	
	switch ($term) {
		case 'biotable':
			$outfiles = write_biotable($db_handle, $config, $output, $sources, $names);
			break;
		case 'biogeographic':
			$outfiles = write_biogeographic($db_handle, $config, $qobjects, $output, $sources, $names);
			break;	
		case 'biotree':
			$outfiles = write_biotree($config, $output);
			break;
		case 'biorelational' :
			$outfiles = write_biorelational($db_handle, $config, $qobjects, $output, $sources, $names);
			break;
		}
	#echo "n: $n";
	$output['outfiles'] = $outfiles;
	$output['nout'] = $n;
	#echo "After write<br>";
	return $output;
	}

#=================================================================================================================
	
	function write_biogeographic($db_handle, $config, $qobjects, $output, $sources, $names) {
		
		$source = get_obj($sources, $output['sourceid']);
		$term = $source['term'];
		$dbloc = $source['dbloc'];
		$namefield = $source['namefield'];
	
		//print_r($output);
		
		$format= $output['sp_format'];
		$filename = $output['filename'];
		$outfilename = $filename;
		# echo "format: $format<BR>";
		#$mids = get_mids($qobjects);
		#echo $qobjects[0]['series'];
		$str = "SELECT * FROM $dbloc";
		if ($names) {
			$names_arr = array_to_postgresql($names,'text');
			$str = $str . " WHERE $namefield = ANY($names_arr)";
		}
		
//		if ($mids) {
//			$str = "SELECT * 
//				FROM $dbloc d, gpdd.main m, gpdd.taxon t
//				WHERE m.\"TaxonID\" = t.\"TaxonID\"
//				AND d.$namefield = t.binomial";
//			$arr = array_to_postgresql($mids,'numeric');
//			$str = $str . " WHERE m.\"MainID\" = ANY($arr)";
//		}
		
		//echo "$str<br>";
		//$res = pg_query($db_handle, $str);
		//$n = pg_num_rows($res);
		# HARDCODE
		#$outpath = substr($config['tmp_path'], strpos($config['tmp_path'],'/') + 1) . '/';
		$outpath = "/ms4w/Apache/htdocs/eclipse/entangled_bank_db_dev/tmp/";
		
		switch ($format) {
			case 'shapefile' :
				$outfiles = array(
					$outpath . $filename . '.shp',
					$outpath . $filename . '.shx',
					$outpath . $filename . '.dbf');
				$filename = $filename . '.shp';
				$driver = 'ESRI Shapefile';
				$ext = '.shp';
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
		
		#load php_ogr.so LINUX ONLY
		#dl('php_ogr.so');
		
		# THIS WORKS
//		$cmdstr = '""C:\FWTools2.4.7\bin\ogr2ogr" -f "ESRI Shapefile"';
//		$cmdstr = $cmdstr . ' /ms4w/Apache/htdocs/eclipse/entangled_bank_db_dev/tmp/d0e5_biogeographic_5';
//		$cmdstr = $cmdstr . ' PG:"host=localhost user=entangled_bank_user dbname=entangled_bank password=m0nkeypu22le" -sql ';
//		$cmdstr = $cmdstr . ' "SELECT * FROM msw05.msw05_geographic WHERE msw05_binomial =';
//		$cmdstr = $cmdstr . ' ANY(ARRAY[\'Loxodonta africana\',\'Elephantidae\',\'Loxodonta\',\'Proboscidea\',\'Elephas maximus\',\'Elephas\',\'Loxodonta cyclotis\'])" 2>&1"';
		
		# THIS WORKS
		$cmdstr = '""C:\FWTools2.4.7\bin\ogr2ogr" -f "' . $driver . '" ';
		$cmdstr = $cmdstr . " $write_file ";
		$cmdstr = $cmdstr . $db_connect;
		$cmdstr = $cmdstr . ' -sql "' . $str . '" 2>&1"';

		#echo "<BR>$cmdstr<br>";
		$out = shell_exec($cmdstr);
		#$out = shell_exec($cmdstr . " 2> output");
		#echo $out ? $out : join("", file("output"));
		#echo "out: $out<br>";
		#$outfiles = array('/ms4w/Apache/htdocs/eclipse/entangled_bank_db_dev/tmp/' . $outfilename);
		return $outfiles;
	}
#=================================================================================================================
	
	function write_biorelational($db_handle, $config, $qobjects, $output, $sources, $names) {
		
		$source = get_obj($sources, $output['sourceid']);
		$mids = get_mids($qobjects);
		$midsarr = array_to_postgresql($mids, 'numeric');
		$outpath = $config['outpath'];
		$outfiles = array();
		
		# GPDD tables
		$db_format = $output['db_format'];
		switch ($db_format) {
			case 'csv':
				$db_ext = ".csv";
				break;
			default:
				echo "format not supported<br>";
				break;
		}
		
		# MAIN
		$str = "SELECT * FROM gpdd.main WHERE \"MainID\" = ANY($midsarr)";
		$res = pg_query($db_handle, $str);
		$cols = get_column_names ($db_handle, 'gpdd.main');
		$filename = $config['out_path'] . substr(md5(uniqid()),0,4) . "_" . str_replace(" ","_", $output['name']) . "_gpdd_main" . "$db_ext";
		$c = write_csv($res, $filename, $cols);
		array_push($outfiles, $filename);
		
		# TAXON
		$str = "SELECT t.* FROM gpdd.main m, gpdd.taxon t 
			WHERE m.\"TaxonID\" = t.\"TaxonID\"
			AND m.\"MainID\" = ANY($midsarr)";
		$res = pg_query($db_handle, $str);
		$cols = get_column_names ($db_handle, 'gpdd.taxon');
		$filename = $config['out_path'] . substr(md5(uniqid()),0,4) . "_" . str_replace(" ","_",$output['name']) . "_gpdd_taxon" . "$db_ext";
		$c = write_csv($res, $filename, $cols);
		array_push($outfiles, $filename);
		
		# BIOTOPE
		$str = "SELECT b.* FROM gpdd.main m, gpdd.biotope b
			WHERE m.\"BiotopeID\" = b.\"BiotopeID\"
			AND m.\"MainID\" = ANY($midsarr)";
		$res = pg_query($db_handle, $str);
		$cols = get_column_names ($db_handle, 'gpdd.biotope');
		$filename = $config['out_path'] . substr(md5(uniqid()),0,4) . "_" . str_replace(" ","_",$output['name']) . "_gpdd_biotope" . "$db_ext";
		$c = write_csv($res, $filename, $cols);
		array_push($outfiles, $filename);
		
		# DATASOURCE
		$str = "SELECT d.* FROM gpdd.main m, gpdd.datasource d
			WHERE  m.\"DataSourceID\" = d.\"DataSourceID\"
			AND m.\"MainID\" = ANY($midsarr)";
		$res = pg_query($db_handle, $str);
		$cols = get_column_names ($db_handle, 'gpdd.datasource');
		$filename = $config['out_path'] . substr(md5(uniqid()),0,4) . "_" . str_replace(" ","_",$output['name']) . "_gpdd_datasource" . "$db_ext";
		$c = write_csv($res, $filename, $cols);
		array_push($outfiles, $filename);
		
		# LOCATION
		$str = "SELECT l.* FROM gpdd.main m, gpdd.location l
			WHERE m.\"LocationID\" = l.\"LocationID\"
			AND m.\"MainID\" = ANY($midsarr)";
		$res = pg_query($db_handle, $str);
		$cols = get_column_names ($db_handle, 'gpdd.location');
		$filename = $config['out_path'] . substr(md5(uniqid()),0,4) . "_" . str_replace(" ","_",$output['name']) . "_gpdd_location" . "$db_ext";
		$c = write_csv($res, $filename, $cols);
		array_push($outfiles, $filename);
		
		# DATA
		
		# Temporal limits
		
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
		$res = pg_query($db_handle, $str);
		$cols = array('DataID',"MainID", "Populations","PopulationUntransformed","SampleYear","TimePeriod",
			"Generation","SeriesStep","DecimalYearBegin","DecimalYearEnd");
		$filename = $config['out_path'] . substr(md5(uniqid()),0,4) . "_" . str_replace(" ","_",$output['name']) . "_gpdd_data" . "$db_ext";
		$c = write_csv($res, $filename, $cols);
		array_push($outfiles, $filename);
		
		# LOCATION GEOGRAPHIC
		$filename_pt = substr(md5(uniqid()),0,4) . "_" . str_replace(" ","_",$output['name']) . "_gpdd_location_pt";
		$filename_bbox = substr(md5(uniqid()),0,4) . "_" . str_replace(" ","_",$output['name']). "_gpdd_location_bbox";
		#$outfilename_pt = $filename_pt ;
		#$outfilename_bbox = $filename_bbox ;
		
		$sp_format = $output['sp_format'];
		
		switch ($sp_format) {
			case 'shapefile' :
				$sp_outfiles = array(
					$outpath . $filename_pt . '.shp',
					$outpath . $filename_pt . '.shx',
					$outpath . $filename_pt . '.dbf',
					$outpath . $filename_bbox . '.shp',
					$outpath . $filename_bbox . '.shx',
					$outpath . $filename_bbox . '.dbf');
				$filename_pt = $filename_pt . '.shp';
				$filename_bbox = $filename_bbox . '.shp';
				$driver = 'ESRI Shapefile';
				$ext = '.shp';
				break;
			case 'mapinfo':
				$sp_outfiles = array(
					$outpath . $filename_pt . '.dat',
					$outpath . $filename_pt . '.id',
					$outpath . $filename_pt . '.map',
					$outpath . $filename_pt . '.tab',
					$outpath . $filename_bbox . '.dat',
					$outpath . $filename_bbox . '.id',
					$outpath . $filename_bbox . '.map',
					$outpath . $filename_bbox . '.tab');
				$filename_pt = $filename_pt . '.tab';
				$filename_bbox = $filename_bbox . '.tab';
				$ext = '.tab';
				$driver = 'MapInfo file';
				break;
			case 'dgn':
				$filename_pt = $filename_pt . '.dgn';
				$filename_bbox = $filename_bbox . '.dgn';
				$driver = 'DGN';
				$sp_outfiles = array($outpath . $filename_pt, $outpath . $filename_bbox);
				break;
			case 'dxf':
				$filename_pt = $filename_pt . '.dxf';
				$filename_bbox = $filename_bbox . '.dxf';
				$sp_outfiles = array($outpath . $filename_pt, $outpath . $filename_bbox);
				$driver = 'DXF';
				$ext = '.dxf';
				break;
			case 'kml':
				$filename_pt = $filename_pt . '.kml';
				$filename_bbox = $filename_bbox . '.kml';
				$sp_outfiles = array($outpath . $filename_pt, $outpath . $filename_bbox);
				$driver = 'KML';
				$ext = '.kml';
				break;
			case 'gml':
				$sp_outfiles = array($filename_pt . '.gml', $outpath . $filename_pt . '.xsd');
				$filename_pt = $filename_pt . '.gml';
				$filename_bbox = $filename_bbox . '.gml';
				$driver = 'GML';
				$ext = '.gml';
				break;
			default:
				echo "write: spatial format " . $output['format'] . " not implemented";
				break;
			}
		
		array_merge($outfiles, $sp_outfiles);
			
		
		$db_connect = ' PG:"host=' . $config['host'] . ' user=' . $config['user'] .	' dbname=' . $config['dbname'] . ' password=' . $config['password'] . '" ';
		$write_file = $config['out_path'] . "/$filename_pt";
		if (file_exists($write_file)) unlink($write_file);
		
		# LOCATION TEST WORKS WHEN PASTED INTO CMD!
//		$str =  'SELECT *
//			 FROM gpdd.location_pt
//			 WHERE \"LocationID\" = ANY(Array[1,2,3])';
//		
//		$write_file = $config['out_path'] . "/$filename_pt";
//		if (file_exists($write_file)) unlink($write_file);
//		$cmdstr = '"C:\FWTools2.4.7\bin\ogr2ogr" -f "' . $driver . '"';
//		$cmdstr = $cmdstr . ' /ms4w/Apache/htdocs/eclipse/entangled_bank_db_dev/tmp/test.shp';
//		$cmdstr = $cmdstr . $db_connect;
//		$cmdstr = $cmdstr . ' -sql "' . $str . '"';
//		$cmdstr = $cmdstr . ' 2>&1"';
//		#echo "<BR>pt: " . $cmdstr. "<br>";
//		$out = shell_exec($cmdstr);
		#echo "out: $out<br>";
		
//		$str =  'SELECT *
//			 FROM gpdd.location_pt
//			 WHERE \"LocationID\" = ANY(Array[1,2,3])';
//		
//		$cmdstr = '""C:\FWTools2.4.7\bin\ogr2ogr"';
//		$argstr = ' -f "' . $driver . '"';
//		$argstr = $argstr . ' /ms4w/Apache/htdocs/eclipse/entangled_bank_db_dev/tmp/test.shp';
//		$argstr = $argstr . $db_connect;
//		$argstr = $argstr . ' -sql "' . $str . '"';
//		$cmdstr = $cmdstr . escapeshellarg($argstr). ' 2>&1"';
//		echo "<BR>cmd : " . $cmdstr . "<br>";
//		$out = shell_exec($cmdstr);
//		echo "out: $out<br>";
		
//		# LOCATION PT
//		$str =  'SELECT l.*
//			 FROM gpdd.main m, gpdd.location_pt l
//			 WHERE m.\"LocationID\" = l.\"LocationID\"
//			 AND m.\"MainID\" = ANY($midsarr)';
//		$write_file = $config['out_path'] . "/$filename_pt";
//		if (file_exists($write_file)) unlink($write_file);
//		$cmdstr = '"C:\FWTools2.4.7\bin\ogr2ogr" -f "' . $driver . '"';
//		$cmdstr = $cmdstr . ' /ms4w/Apache/htdocs/eclipse/entangled_bank_db_dev/tmp/' . $filename_pt;
//		$cmdstr = $cmdstr . ' PG:"host=' . $config['host'] . ' user=' . $config['user'];
//		$cmdstr = $cmdstr .	' dbname=' . $config['dbname'] . ' password=' . $config['password'] . '" ';
//		$cmdstr = $cmdstr . " -sql \"" . $str . '"';
//		$cmdstr = $cmdstr . ' 2>&1"';
//		##echo "<BR>pt: " . $cmdstr. "<br>";
//		$out = shell_exec($cmdstr);
//		##echo "out: $out<br>";
//		
//	
//		# LOCATION BBOX
//		$str = "SELECT l.*
//			 FROM gpdd.main m, gpdd.location_bbox l
//			 WHERE m.\"LocationID\" = l.\"LocationID\"
//			 AND m.\"MainID\" = ANY($midsarr)";
//		$write_file = $config['out_path'] . "/$filename_pt";
//		if (file_exists($write_file)) unlink($write_file);
//		$cmdstr = '""C:\FWTools2.4.7\bin\ogr2ogr" -f "' . $driver . '"';
//		$cmdstr = $cmdstr . ' /ms4w/Apache/htdocs/eclipse/entangled_bank_db_dev/tmp/' . $filename_bbox;
//		$cmdstr = $cmdstr . ' PG:"host=' . $config['host'] . ' user=' . $config['user'];
//		$cmdstr = $cmdstr .	' dbname=' . $config['dbname'] . ' password=' . $config['password'] . '" ';
//		$cmdstr = $cmdstr . ' -sql "' . $str . '"';
//		$cmdstr = $cmdstr . ' 2>&1"';
//		#echo "<BR>bbox: $cmdstr<br>";
//		$out = shell_exec($cmdstr);
		#echo "out: $out<br>";
		return $outfiles;
	}
	
#=================================================================================================================
	
function write_biotable ($db_handle, $config, $output, $sources, $names) {
	
	//print_r($output);
	//echo "<BR>";
	
	$source = get_obj($sources, $output['sourceid']);
	$term = $source['term'];
	$dbloc = $source['dbloc'];
	$namefield = $source['namefield'];
	
	$format = $output['db_format'];
	$filename = $output['filename'];
	
	# OS HARDCODE
	#$outpath = substr($config['tmp_path'], strpos($config['tmp_path'],'/') + 1) . '/';
	
	if ($names) {
		$names_arr = array_to_postgresql($names,'text');
		}
		
	$outpath = $config['out_path'];	
	$filename = "$outpath/$filename.csv";
	#echo "write::filename: $filename<br>";
	$columns = $output['fields'];
	array_unshift($columns, $namefield);
	$colstr = array_dbcols($columns, null, true);
	$str = "SELECT $colstr FROM $dbloc";
	if ($names) $str = $str . " WHERE $namefield = ANY($names_arr)";
	#echo "write_biotable ". count($columns) . " to $filename<br>";
	$res = pg_query($str);
	$c = write_csv($res, $filename, $columns);
	$outfiles = array($filename);
	
	return $outfiles;
}

#=================================================================================================================

 function write_biotree($config, $output) {
 	
 	// Get session variables
	$sid = session_id();
	$spath = $config['out_tree_path'];
	$spath = session_save_path();
	#echo "spath $spath<br>";
	
	# LINUX HARDCODE
	//if (strpos ($spath, ";") !== FALSE)
	#$spath = substr ($spath, strpos ($spath, ";")+1);
	#echo "spath $spath<br>";
	
	$filename = $output['filename'];
	switch ($output['format']) {
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
		case 'linree':
			$filename = $outpath . $filename . '.lin';
			$outfiles = array($filename);
			break;
		default;
		}
	# Save output id to session
	$_SESSION['output_id'] = $output['id'];
	session_write_close(); 
	#echo "<br>*** Before PERL ***<br>";
	//$spath = $spath . "/" . $filename;
	$str = $config['perl_path'] . "/perl " . $config['write_tree_path'];
	$str = $str . "write_tree.pl $sid $spath 2>&1";
	#echo "<br>PERL: $str<br>";
	$out = shell_exec($str);
	#echo "$out<br>";
	#echo "<br>*** After PERL ***<br>";
	$outfiles = array($filename);
 	
 	return $outfiles;
 }

#=================================================================================================================

function write_csv($result, $file, $columns) {

	if (!$result) {
		echo "write_result error: result is empty<br>.";
		exit;
		
		} else {

		#WRITES QUERY RESULT TO FILE
		# Open file for writing
		
		#echo "file: $file<br>";
			
		$fh = fopen($file, "w+") or die ("Failed to open $file: $php_errormsg");
		
		#Write column headers
		$first = 1;
		foreach ($columns as $column) {
			if ($first == 1) {
				$mystr = $column;
				$first = 0;
				} else {
				$mystr = $mystr . "," . $column;
				}
			}
		$mystr = $mystr . "\n";
		fwrite($fh, $mystr);
		
		#Write Data
		$c = 0;
		while ($row = pg_fetch_row($result)) {
			$c++;
			for ($i = 0; $i <= count($columns); $i++) {
				if ($i == 0) {
					$mystr = $row[$i];
					} else {
					$mystr = $mystr . ", $row[$i]";
					}
				}
			$mystr = $mystr . "\n";
			fwrite($fh, $mystr);
			}
		# Close file	
		fclose($fh);
		}
	return $c; #n records
	}
	
	
#=================================================================================================================

//function write_spatial($db_handle, $sptable, $spfield, $spoutfile, $names) {
//	
//	# Get tip labels
//	#echo "$tree, $subtree, $names, $nodetype<br>";
//	#$nodes = get_node_ids($db_handle, $tree, $subtree, $names, $nodetype);
//	#$node_array = array_to_postgresql($nodes, 'numeric');
//	$label_array = array_to_postgresql($names, 'text');
//
//	$sql = "SELECT * FROM $sptable WHERE $spfield = ANY($label_array)";
//	#$sql = "SELECT * FROM data.msw05_geographic WHERE msw05_binomial = 'Glis glis'";
//	$cmdstr = "ogr2ogr -overwrite -f \"ESRI Shapefile\" " . $spoutfile;
//	$cmdstr = $cmdstr . " PG:\"host='lb-gissvr1' user='entangled_bank_user' dbname='dk_playground' password='m0nkeypu22le'\" ";
//	$cmdstr = $cmdstr . "-sql \"" . $sql . "\"";
//	#echo "$cmdstr<br>";
//	
//	#$output = shell_exec($cmdstr);
//	#$output = shell_exec('c:/ms4w/apache/htdocs/entangled_bank/ogr2ogrtest.bat');
//	return count($nodes);
//}
#=================================================================================================================
	
	function write_readme($qobjects, $outputs) {
		
		# Writes readme file
		
		#BEGIN README
		$readme = "Entangled Bank Output " . strftime('%c') . "\r\n\r\n";
			
		# ADD QUERIES TO README
		if ($qobjects) {
			$c = count($qobjects);
			} else {
			$c = 0;
			}
		
		switch ($c) {
			case 0 :
				$readme =  "$readme 0 queries, all data returned from sources\r\n";
				break;
			case 1:
				$readme = "$readme 1 query:\r\n";
			default:
				$readme = "$readme $c queries:\r\n";
				break;
			}	
			
		if ($qobjects) {
			foreach ($qobjects as $qobj) {
				$readme = $readme . $qobj['name'] . ": ";
				$readme = $readme . $qobj['sql'] . "\r\n";
			}			
		}
		
		# ADD OUTPUTS TO README AND FILES_TO_ZIP
	$readme = $readme . count($outputs) . " Outputs:\r\n";
	#echo "add outputs to readme and files to zip<br>";
	foreach ($outputs as $output) {
		#print_r($output);
		#echo "<br>";
		$readme = $readme . $output['name'] . ": ";
		$readme = $readme . $output['as_string'] . "\r\n";
		$outfiles = $output['outfiles'];
		//print_r($outfiles);
		//echo count($outfiles) . "<br>";
		foreach ($outfiles as $outfile) {
			//echo "outfile $outfile<br>";
			$readme = $readme . $outfile . "\r\n";
		}
		#echo "outfiles: " . print_r($outfiles) . '<br><br>';
		$readme = $readme . "\r\n";
		#add output files to zip list
		}

	return $readme;
		
	}
	
#=================================================================================================================

function write($db_handle, $config, $qobjects, $names, $outputs, $sources) {

	#Writes all data output 
	#echo "begin write_outputs<br>";
	
	foreach ($outputs as $output) {
		# add output file name to outputs
		$filename = substr(md5(uniqid()),0,4) . "_" . str_replace(" ","_",$output['name']);
		#echo 'write: ' . $output['name']. " to " . $filename;
		$output['filename'] = $filename;
		$outputs = save_obj($outputs, $output);
		$_SESSION['outputs'] = $outputs;
		#echo "writing output " . $output['name'];
		$output = write_output($db_handle, $config, $qobjects, $names, $output, $sources);
		#echo ", " . $output['name'] . " written<br>";
		$outputs = save_obj($outputs, $output);
		#echo ', written ' . $filename . "<br>";
		}
	#echo "finish write_outputs<br>";
	$_SESSION['outputs'] = $outputs;
	return $outputs;
	}
#=================================================================================================================
?>