<?php

#=================================================================================================================
	
function write_outputs($db_handle, $config, $names, $qobjects, $outputs, $sources) {

	# WRITES ALL OUTPUTS TO COMPRESSED ARCHIVE
	
	//echo "Begin write outputs<br>";
	
	#UNIQE ID FOR OUTPUT TO PREVENT FILE NAME CONFLICTS
	$oid = substr(md5(uniqid()),0,4);
	$_SESSION['oid'] = $oid;
	
		
	# WRITE OUTPUTS
	foreach ($outputs as $output) {
		$filename = str_replace(" ","_",$output['name']) . "_$oid";
		$output['filename'] = $filename;
		unset ($output['outfiles']);
		//$outputs = save_obj($outputs, $output);
		//$_SESSION['outputs'] = $outputs;
		write_output($db_handle, $config, $qobjects, $names, &$output, $sources);
		$outputs = save_obj($outputs, $output);
		$_SESSION['outputs'] = $outputs;
	}
	
	//print_r($outputs[0]['outfiles']);
	//echo "<br>";
	
	# ADD OUTPUTS TO README AND FILES_TO_ZIP
	$files_to_zip = array();
	foreach ($outputs as $output) {
		$outfiles = $output['outfiles'];
		//if ($output['term'] == 'biotree') $outfiles[0] = $config['out_path'] . "/" . $outfiles[0];
		$files_to_zip = array_merge($files_to_zip, $outfiles);
	}
	
	
	# WRITE README
	$readme = write_readme($qobjects, $outputs);
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
		return $zn;
	}
}

#=================================================================================================================


function write_output($db_handle, $config, $qobjects, $names, &$output, $sources) {

	# WRITE INDIVIDUAL DATA OUTPUT TO TEMPORARY FILE
	
	$term = $output['term'];
	
	switch ($term) {
		case 'biotable':
			$outfiles = write_biotable($db_handle, $config, &$output, $sources, $names);
			break;
		case 'biogeographic':
			$outfiles = write_biogeographic($db_handle, $config, $qobjects, &$output, $sources, $names);
			break;	
		case 'biotree':
			write_biotree($db_handle, $config, &$output, $sources, $names);
			break;
		case 'biorelational' :
			write_biorelational($db_handle, $config, $qobjects, &$output, $sources, $names);
			break;
		}
	#echo "n: $n";
	#$output['outfiles'] = $outfiles;
	#$output['nout'] = $n;
	#echo "After write<br>";
	}

#=================================================================================================================
	
	function write_biogeographic($db_handle, $config, $qobjects, &$output, $sources, $names) {
		
		$source = get_obj($sources, $output['sourceid']);
		$term = $source['term'];
		$dbloc = $source['dbloc'];
		$namefield = $source['namefield'];
		$format= $output['sp_format'];
		$filename = $output['filename'];
		$outfilename = $filename;
		$outpath = $config['out_path']. "/";;

		$str = "SELECT * FROM $dbloc";
		if ($names) {
			$names_arr = array_to_postgresql($names,'text');
			$str = $str . " WHERE $namefield = ANY($names_arr)";
		}
		
		#$outpath = substr($config['tmp_path'], strpos($config['tmp_path'],'/') + 1) . '/';
		//$outpath = "/ms4w/Apache/htdocs/eclipse/entangled_bank_db_dev/tmp/";
		
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

		//echo "<BR>$cmdstr<br>";
		$out = shell_exec($cmdstr);
		#$out = shell_exec($cmdstr . " 2> output");
		#echo $out ? $out : join("", file("output"));
		echo "out: $out<br>";
		#$outfiles = array('/ms4w/Apache/htdocs/eclipse/entangled_bank_db_dev/tmp/' . $outfilename);
		if (!$output['outfiles']) {
			$output['outfiles'] = $outfiles;
		} else {
			array_push($output['outfiles'], $outfiles);
		}
	}
#=================================================================================================================
	
	function write_biorelational($db_handle, $config, $qobjects, &$output, $sources, $names) {
		
		echo "write_biorelational: begin ";
		
		$oid = $_SESSION['oid'];
		$source = get_obj($sources, $output['sourceid']);
		$mids = query_get_mids($qobjects);
		if ($mids) {
			if (!empty($mids)) {
				$midsarr = array_to_postgresql($mids, 'numeric');
			} else {
				$midsarr = array();
			}
		}
		$outpath = $config['outpath'];
		$outfiles = array();
		
		# MAIN
		$str = "SELECT * FROM gpdd.main";
		if ($midsarr) $str = $str . "WHERE \"MainID\" = ANY($midsarr)";
		$res = pg_query($db_handle, $str);
		$cols = get_column_names ($db_handle, 'gpdd.main');
		$output['filename'] = str_replace(" ","_", $output['name']) . "_gpdd_main_$oid";
		write_delineated($config, $res, $output);
		
		# TAXON
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
		write_delineated($config, $res, $output);
		
		# DATASOURCE
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
		write_delineated($config, $res, $output);
		
		# LOCATION
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
		write_delineated(config, $res, $output);
		
		# DATA
		
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
			t.\"TimePeriod\",
			d.\"Generation\",
			d.\"SeriesStep\",
			d.\"DecimalYearBegin\",
			d.\"DecimalYearEnd\"
			FROM gpdd.data d, gpdd.timeperiod t, gpdd.main m, gpdd.taxon t
			WHERE d.\"TimePeriodID\" = t.\"TimePeriodID\"
			AND d.\"MainID\" = m.\"MainID\"
			AND m.\"TaxonID\" = m.\"TaxonID\"
			AND t.binomial IS NOT NULL";
		}
		$res = pg_query($db_handle, $str);
		$cols = array('DataID',"MainID", "Populations","PopulationUntransformed","SampleYear","TimePeriod",
			"Generation","SeriesStep","DecimalYearBegin","DecimalYearEnd");
		$output['filename'] =  str_replace(" ","_",$output['name']) . "_gpdd_data_$oid";
		write_delineated(config, $res, $output);
		
		# LOCATION GEOGRAPHIC
		$filename_pt = str_replace(" ","_",$output['name']) . "_gpdd_location_pt$oid";
		$filename_bbox = str_replace(" ","_",$output['name']). "_gpdd_location_bbox$oid";
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
		$output['outfiles'] = $outfiles;
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
	//array_unshift($columns, $namefield);
	$colstr = array_dbcols($columns, null, true);
	$str = "SELECT $colstr FROM $dbloc";
	if ($names) $str = $str . " WHERE $namefield = ANY($names_arr)";
	//echo "$str<br>";
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
	//$spath = $config['out_tree_path'];
	$spath = session_save_path();
	$outpath = $config['out_path'] . "/";
	$perl_script_path = $config['perl_script_path'];
	//echo "perl_script_path $perl_script_path<br>";
	
	# LINUX HARDCODE
	//if (strpos ($spath, ";") !== FALSE)
	#$spath = substr ($spath, strpos ($spath, ";")+1);
	#echo "spath $spath<br>";
	
	$tree_id = $output['tree_id'];	
	$filename = $output['filename'];
	$output_sid = $output['sourceid']; 
	$brqual = $output['brqual'];
	//echo "output: <br>";
	//print_r($output);
	//echo "<br>";

	
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
		
	# PRUNED
	if ($output['brqual'] == 'none') {
		$str = "SELECT biosql.pdb_as_newick_label($tree_id, $arr)";
	} else {
		$str = "SELECT biosql.pdb_as_newick_label($tree_id, $arr, $brqual, FALSE)";
	}

	//echo "str: $str<br>";
	$res = pg_query($str);
	$row = pg_fetch_row($res);
	$tree = $row[0];	
	
	# Convert and/or prune
	$subtree = $output['subtree'];
	$format = $output['format'];
	
	//echo "format: $format<br>";
	if ($format !== 'newick') {
		session_write_close(); 
		echo "<br>***BEGIN PERL***<br>";
		$str = "$perl_script_path\convert_tree.pl $sid $spath $tree $format 2>&1";
		//echo "$perl_script_path\convert_tree.pl $sid $spath $tree $format 2>&1";
		$tree = shell_exec($str);
		echo "$tree<br>";
		echo "<br>***END PERL***<br>";
	} 
	//echo "tree, $tree<br>";
	//echo "Writing tree to $filename<BR>";
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
	
	function write_readme($qobjects, $outputs) {
		
	# Writes readme file
	
	$dul = "================================================================\r\n";
	$sul = "----------------------------------------------------------------\r\n";
	#BEGIN README
	$readme = "Entangled Bank Output " . strftime('%c') . "\r\n$dul\r\n";

	
	# ADD QUERIES TO README
	if ($qobjects) {
		$c = count($qobjects);
	} else {
		$c = 0;
	}
	
	switch ($c) {
		case 0 :
			$readme =  "$readme 0 queries, all data in outputs returned";
			break;
		case 1:
			$readme = "$readme 1 query";
		default:
			$readme = "$readme $c queries";
			break;
	}
		
	$readme = "$readme\r\n\r\n";
	#$readme = $readme . "Query: ";

	$qstack = array();
	$i = 0;
	if ($qobjects) {
		foreach ($qobjects as $qobj) {
			$str = '';
			if ($i > 0) $str = "$str ";
			$str = $str . $qobj['name'];
			if ($i > 0) $str = "$str " . $qobj['queryoperator'];
			array_unshift($qstack,$str);
			$i++;
			$readme = $readme. " $str";
		}
	}
	
	# OUTPUTS
	$readme =  "$readme\r\n\r\n";
	$readme = $readme . count($outputs) . " outputs\r\n\r\n";
	$i = 0;
	foreach ($outputs as $output) {
		$i++;
		$readme = $readme . $output['name'] . ": ";

		$readme = $readme . $output['as_string'] . "\r\n";			
		$readme = $readme . "files: \r\n";
		$j = 0;
		$outfiles = $output['outfiles'];
		foreach ($outfiles as $outfile) {
			#if ($j > 0) $readme = $readme . "\r\n";
			$str = substr($outfile, strrpos($outfile,"/"));
			#echo "$outfile ".strrpos("/",$outfile)." $str<br>";
			$readme = "$readme $str\r\n";
			$j++;
		}
		#echo "outfiles: " . print_r($outfiles) . '<br><br>';
	}
	$readme = "$readme\r\n\r\n";	
	
	# SQL
	$readme = $readme . "SQL\r\n$dul\r\n";
	$i = 0;
	if ($qobjects) {
		foreach (array_reverse($qobjects) as $qobj) {
			$readme = $readme . $qobj['name'] . " ";
			#$readme = $readme . $qstack[$i] . $sul;
			$readme = $readme . "Names SQL:\r\n" . $qobj['sql_names'] . "\r\n\r\n";
			if ($qobj['sql_series']) {
				$readme = $readme . $qobj['name'] . "Series SQL:\r\n" . $qobj['sql_series'] . "\r\n\r\n";
			}
			$i++;
			$readme = "$readme \r\n$sul\r\n";
		}
	}
	return $readme;
		
}
	
#=================================================================================================================
/*
function write($db_handle, $config, $qobjects, $names, $outputs, $sources, $oid) {

	#Writes all data output 
	#echo "begin write_outputs<br>";
	
	foreach ($outputs as $output) {
		# add output file name to outputs
		$filename = str_replace(" ","_",$output['name']) . "_$oid";
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
	}*/
#=================================================================================================================
?>