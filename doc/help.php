<?php 
session_start();
$_SESSION['lastaction'] = 'doc';
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="content-type">
  <title>EBDB Help</title>
  <meta content="webmaster@entangled-bank.org" name="author">
  <meta content="Index page" name="description">
  <link type="text/css" rel="stylesheet" href="../share/entangled_bank.css">
</head>

<body>
<div id='page'>

<?php 
include("../lib/html_utils.php"); 
$stage = html_entangled_bank_header('ebdb', '../');
?>
<div id='content'>
<!--<h4><a name="help">Help Contents</a></h3>-->

<OL id='contents'>
<LI><a href="#start">Select Datasets</a></LI>
<LI><a href="#main">The Main Screen</a></LI>
<OL>
<LI><a href="#find">Find</a></LI>
<LI><a href="#session">Session Bar</a></LI>
</OL>
<LI><a href="#query">Query</a></LI>
<ol>
<LI><a href="#name">Names Query</a></LI>
<LI><a href="#tree">Tree Query (taxonomy or phylogeny)</a></LI>
<LI><a href="#attribute">Attribute Query</a></LI>
<LI><a href="#geography">Geographic Query</a></LI>
<LI><a href="#time">Temporal Query</a></LI>
</ol>
<LI><a href="#output">Data Download</a></LI>
<ol>
<LI><a href="#output-table">Attribute Tables</a></LI>
<LI><a href="#output-geography">Geographic Tables</a></LI>
<LI><a href="#output-tree">Trees</a></LI>
<LI><a href="#output-gpdd">GPDD</a></LI>
<LI><a href="#output-meta">Metadata</a></LI>
</ol>
</OL>


<h3><a name="start">Select Data</a></h3>
<p>
The first step in using the EBDB is select the <a href='data.php'>data sets</a> you wish to query and return data from. 
Maximise performance by only selecting relevant data.
</p>
<Center>
<a href='./image/start.gif'><IMAGE src='./image/start.gif' width='600px'/></a>
<p class='legend'>Select Sources</p>
</Center>
<BR>

<h3><a name="main">The Main Screen</a></h3>
<p>
Control your database session from the EBDB Main Screen.
</p>
<Center>
<a href='./image/main.gif'><IMAGE src='./image/main.gif' width='600px'/></a>
<a name="fig2"><p class='legend'>EBDB Main Screen</p></a>
</Center>
<p>
<a href='#find'>FIND NAMES</a> is a quick way of discovering which data sets contain data on a taxon. 
<a href='#session'>SESSION</a> bar provides information on your current selection, i.e.
  names and GPDD time series. All names are selected on starting an EBDB session.
 The <a href='#query'>QUERIES BAR</a> is visible once a query has been run; it shows your query chain. 
 Click query to edit or delete queries. 
 <img alt='red cross' src='../image/red-cross.gif' width='15px' /> deletes the query chain.
 The <a href='#query'>ADD QUERY</a> buttons open a new query dialog.
 <a href='#output'>ADD OUTPUT<a> creates a new data set output.
 When an output has been added the <a href='#output'>OUTPUTS BAR<a> becomes visible. 
 Click icons to edit or delete outputs. 
CHECK OUT <img alt='shopping cart' src='../image/returndata.gif' width='20px' /> returns 
 subsetted data as a single DATA PACKAGE 
 <img alt='shopping cart' src='../image/parcel.gif' width='20px' /> zip archive.
Hover over page elements to reveal TOOL TIPS.
</p>

<a name='find'></a><h4>Find Names</h4>
<p>
FIND is a quick way to discover which names are present in which data sets. 
Add a comma-seperated list of names, then press GO.
Find searches are case-sensitive and does not support wildcards.
</p>
<Center>
<a href='./image/find.gif'><IMAGE src='./image/find.gif' width='800px'/></a>
<p class='legend'>Find</p>
</Center>
<p>
Find returns a find box, without altering the current selection.
The box has one line for each taxon and columns for each data set.
Dataset names are available as tool tips.
A filled-dot is displayed where a taxon is present in a data set. 
An open-dot when the name is absent. 
</p>

<a name='session'></a><h4>Session Bar</h4>
<p>
The SESSION BAR provides information on your EBDB session.</p>
<p>
SOURCES shows the number of datasets being queried. 
Click to open the DATASETS SUMMARY PAGE that summaries the current selection by datatset.
</p>
<Center>
<a href='./image/page-sources.gif'><IMAGE src='./image/page-sources.gif' width='500px'/></a>
<p class='legend'>Datasets Summary</p>
</Center>
<p>
NAMES shows the number of names selected.
Click to open the NAMES PAGE that lists names in the selection selected and the underlying SQL.
</p>
<Center>
<a href='./image/page-names.gif'><IMAGE src='./image/page-names.gif' width='500px'/></a>
<p class='legend'>Names Page</p>
</Center>
<p>
There follows one box for each dataset that shows the number of names selected in that dataset 
and the number of any supplementary data elements, currenlty just GPDD series.
Boxes are colour-coded by dataset type; trees green, attribute tables brown, geographic tables blue and relational datsets pink.
Click a box to open the associated DATASET SUMMARY PAGE that provides information on data selected.
Information on pages vary by dataset type.
</p>
<Center>
<a href='./image/page-dataset.gif'><IMAGE src='./image/page-dataset.gif' width='500px'/></a>
<p class='legend'>GPDD Dataset Summary Page</p>
</Center>
<BR>


<h3><a name="query">Querying</a></h3>
<p>
Data may be queried by <a href="#name">biological name</a>, <a href="#tree">tree topology</a>,
 <a href="#attribute">attributes</a>, <a href="#geography">geography</a> or <a href='#time'>time</a>.
 Name, geography and time queries may be applied to one or more data sets; 
 attribute and tree queries operate on single data sets.
 </p>
 <p>
 Queries are connected by AND, OR and MINUS interquery operators to form the query chain displyed in the QUERY BAR. 
 Queries are displayed with the same symbols as the add query buttons. 
 Interquery operators are displayed as Venn diagrams diagram and tool tips.
</p>
<Center>
<a href='./image/sets.gif'><IMAGE src='./image/sets.gif'/></a>
<p class='legend'>Interquery Venn Diagrams</p>
</Center>

<p>
ADD QUERIES by selecting a query type.
</p>
<p> 
SINGLE-SOURCE QUERIES (tree and attribute queries) prompt for a dataset to query.
</p>
<Center>
<a href='./image/single-source.gif'><IMAGE src='./image/single-source.gif' width='500px'/></a>
<p class='legend'>Single-Source Query</p>
</Center>

<p>
In MULTI-SOURCE QUERIES (names, geography and time) dataset selection is part of the query dialog.
Queries must be applied to at least one dataset. 
<a name='nsource'></a>N SOURCES sets the number of datasets a names must be in to be returned. 
In the example below, only names present in all three selected datasets are returned.
The figure also shows the INTERQUERY OPERATOR that must be set for all but the first query in the chain, 
as well as the <a href='#query_buttons'>CANCEL</a>, <a href='#query_buttons'>DELETE</a> and <a href='#query_buttons'>RUN ></a> buttons.
</p>
<Center>
<a href='./image/multi-source.gif'><IMAGE src='./image/multi-source.gif' width='600px'/></a>
<p class='legend'>Multi-Source Query</p>
</Center>

<p>
Once a query has been run the SQL is displayed in the query edit dialog. 
By default the SQL that returns names for the selected query is displayed.
This can be changed to SQL that returns GPDD series identifiers.
</p>

<p>
<a name='query_name'></a>All queries have a QUERY NAME. 
The default is a numerical increment on the query type, 
i.e. the first bionames will be 'bionames1' and the second 'bionames2' irrespective of whether the first name was changed.
Query names do not have to be unique as they have a unique internal reference; however, using the same name is not recommended.
</p>

<p>
<a name='query_buttons'></a>'RUN >' runs a query. 
DELETE deletes the query from the chain. 
CANCEL returns to the main screen from an existing query edit.
No changes are saved following a cancel. 
To implement changes to a query run the query.
</p>


<h4><a name="name">Names Query</a></h4>
<p>
A NAMES QUERY selects names across one or more datasets.
Names may be entered one per line to the NAMES BOX or using FIND.
FIND performs an case-sensitive 'double' wildcard search (*text*)on input text given the N SERIES criterion, 
In the example below the search *Mus* returns all names containing 'Mus' found in all five datasets.
ALL NAMES returns all names that match the <a href='#nsource'>N SOURCES</a> criterion.
All names overrides any names in the names box.
</p>

<p>
Run names queries also have a names REPORT and QUERY SQL.
</p>
<center>
<a name="fig6">
<a href='./image/names.gif'><IMAGE src='./image/names.gif' width='600px'/></a>
<p class='legend'>A Names Query</p>
</center>
</a>


<h4><a name="tree">Tree Query</a></h4>
<p>
A TREE QUERY selects names from a single tree (phylogeny or taxonomy). 
Phylogeny and taxonmy queries differ only in their FILTER options.
</p>

<center>
<a href='./image/taxonomy.gif'><IMAGE src='./image/taxonomy.gif' width='600px'/></a>
<p class='legend'>Taxonomy query</p>
</center>
<p>
FILTER SCOPE controls whether selected FILTER CLASSES are applied to both FIND and QUERY, or just to FIND.
Depending on tree type FILTER CLASSES may be taxonomic level or simply internal and tip nodes.
Checked classes are returned.
FIND runs a case-sensitive double wildcard search on input text given the FILTER criteria.
</p>
<p>
The TREE OPERATOR determines what component of the tree is returned given the query names. 
Four are supported.
</p>
<table border='0'>
<tr>
<th>Tree Operator</th>
<th>Description</th>
</tr>
<tr>
<td>Most Recent Common Ancestor Subtree (default)</td>
<td>Returns all names in the subtree defined by the most recent common ancestor of the selected names</td>
</tr>
<tr>
<td>Most Recent Common Ancestor</td>
<td>Returns the name of the most recent common ancestor of the selected names</td>
</tr>
<tr>
<td>Selected</td>
<td>Returns selected names only</td>
</tr>
<tr>
<td>All</td>
<td>Returns all names in the tree. Ignores any selected names.</td>
</tr>
</table>
<center><p class='legend'>Tree Operators</p></center>


<h4><a name="attribute">Attribute Query</a></h4>
<p>
An ATTRIBUTE QUERY selects names from a single dataset given a set of CONSTRAINTS on
attributes of the dataset. 
Constraints are may be on a field in a table or a group statistic. 
In the example below, 'Latin Bionmial or other name' constrains time-series by field value, whereas
 'Count', constrains on the number of time-series that also match other constraints.
This is an example of the rule that constraints  are 'ANDed' within a query.
</p>
<center>
<a href='./image/table.gif'><IMAGE src='./image/table.gif' width='600px'/></a>
<p class='legend'>Querying the attributes of the GPDD</p>
</center>
<p>
CONSTRAINTS are grouped into general classes of
 Count, Identifier, Taxonomy, Time, Geography, Place, Sampling,Referece and notes.
 Hover over field names for descriptions.
 Check field name to open FIELD DIALOG. 
 Field dialogs are of two types, numeric and catagoric.
 If a field includes NULLS a check box is provided that, if checked, will nulls in the selection.
</p>
<p>
Numeric constraints ('Count' above) have an OPERATOR and VALUE. 
</p>
<p>
Catagoric constraints have case-sensitive double-wildcard FINDs to discover catagory VALUES 
(Latin Binomial above, which also shows a NULL checkbox).
</p>


<h4><a name="geography">Geographic Query</a></h4>
<p>
A GEOGRAPHIC QUERY selects names based on spatial location.
Use the tools <img src='./image/openlayers_tools.gif' height='20px'/> to add QUERY FEATRUES to the map.
Add BOUNDING BOX FEATURES numerically. 
CLEAR MAP to erase all query features.
Use <IMAGE src='./image/openlayers_layerswitcher.gif'/> to select background map.
Features cannot cross the anti-meidian (-180/+180 longitude).
</p>
<center>
<a href='./image/geography.gif'><IMAGE src='./image/geography.gif' width='600px'/></a>
<p class='legend'>Geographic Query</p>
</center>
<p>
Four SPATIAL OPERATORS are suppoted,
</p>
<table border='0'>
<tr>
<th>Operator</th>
<th>Description</th>
</tr>
<tr>
<td>Overlap by Box</td>
<td>Returns names and data associated with geographical features whose bounding box INTERSECTS the bounding boxes of the query features
(&amp&amp PostGIS operator).</td>
</tr>
<tr>
<td>Overlap by Box</td>
<td>Returns names and data associated with geographical features whose bounding box is WITHIN the bounding boxes of the query features
(&#126; PostGIS operator).</td>
</tr>
<tr>
<td>Overlap Features</td>
<td>Returns names and data associated with geographical features which INTERSECT the query features
(ST_Overlaps PostGIS function).</td>
</tr>
<tr>
<td>Within Polygons</td>
<td>Returns names and data associated with geographical features that are WITHIN query features
(ST_Within PostGIS function).</td>
</tr>
</table>

<h4><a name="time">Temporal Query</a></h4>
<p>
A TEMPORAL QUERY selects names and data that exists BEFORE, DURING or AFTER a particular day.
</p>
<center>
<a href='./image/time.gif'><IMAGE src='./image/time.gif' width='600px'/></a>
<p class='legend'>Temporal query</p>
</center>
<br>

<h3><a name="output">Download Data</a></h3>
<p>
Data is returned by adding OUTPUTS.
OUTPUT dialogs reflect the composition of data types that compose each dataset. 
Data extracts are returned as a single DATA PACKAGE compressed within a ZIP FILE.
Data packages also contain a METADATA file (readme.txt)which details information on queries and data returned.
</p>

<h4><a name="output-table">Attribute Tables</a></h4>
<p>
ATTRIBUTE TABLES such as Panthria may be exported as comma-delineated (*.csv)' 
or 'tab-delineated (*.txt)' ascii files. All or a subset of fields may be output.
</p>
<center>
<a href='./image/output-table.gif'><IMAGE src='./image/output-table.gif' width='600px'/></a>
<p class='legend'>Pantheria Output</p>
</center>

<h4><a name="output-geography">Geographic Tables</a></h4>
<p>
GEOGRAPHIC TABLES can be exported as a <a href=''>ESRI Shapefile</a>, <a href=''>MapInfo</a>, <a href=''>DGN</a>, 
 <a href=''>DXF</a>, <a href=''>Geographic Markup Language (GML)</a>
 and <a href=''>Keyhole Markup Language (KML)</a> formats.
</p>
<center>
<a href='./image/output-geography.gif'><IMAGE src='./image/output-geography.gif' width='600px'/></a>
<p class='legend'>Geographic Output</p>
</center>

<h4><a name="output-tree">Trees</a></h4>
<p>
TREES may be exported in <a href=''>newick</a>, <a href=''>nhx</a>, 
<a href=''>tab-indented ascii</a> or <a href=''>lintree formats</a>.
They may be the subtree defined by the last common ancestor of the selected names or pruned to only the name set.
Branch attributes (e.g. ages) may be be output in the tree file.
</p>
<center>
<a href='./image/output-tree.gif'><IMAGE src='./image/output-tree.gif' width='600px'/></a>
<p class='legend'>Mammal Phylogeny Output</p>
</center>

<h4><a name="output-gpdd">GPDD</a></h4>
<p>
The GPDD is a relational dataset with geographic data. 
Both ATTRIBUTE and GEOGRAPHIC OUTPUT dialogs are presented. 
</p>
<center>
<a href='./image/output-gpdd.gif'><IMAGE src='./image/output-gpdd.gif' width='600px'/></a>
<p class='legend'>GPDD Output</p>
</center>

<h4><a name="readme">Metadata</a></h4>
<p>
Readme.txt contains METADATA on the queries undertaken and returned data.
</p>
</div>
<?php html_entangled_bank_footer(); ?>
</div>

</div>
</body>
</html>
