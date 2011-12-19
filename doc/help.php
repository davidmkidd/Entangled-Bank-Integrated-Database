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
$stage = html_entangled_bank_header(null, '../');
?>
<h4>Contents</h4>
<OL>
<LI><a href="#what">What does the EBDB do?</a></LI>
<LI><a href="#start">Select data to query</a></LI>
<LI><a href="#main">The EBDB main screen</a></LI>
<LI><a href="#query">How to query</a></LI>
<ol>
<LI><a href="#name">Biological Name</a></LI>
<LI><a href="#tree">Tree (taxonomy or phylogeny)</a></LI>
<LI><a href="#attribute">Attribute Value</a></LI>
<LI><a href="#geography">Geography</a></LI>
<LI><a href="#time">Time</a></LI>
</ol>
<LI><a href="#output">How to return data</a></LI>
<LI><a href="#examples" alt='Entangled Bank Examples'>Examples</a></LI>
<LI><a href="#browser">Browser compatability</a></LI>
</OL>

<h3><a name="what">What does the EBDB do?</a></h3>
<p>
The Entangled Bank Database (EBDB) supports the querying, subsetting and extraction of data sets by biological name, tree topology,
attribute values, geography and time through a Web-based interface.
It is currenlty populated with a number of <a href="./doc/data.php#mammal">datasets for all mammals</a> 
and the <a href="./doc/data.php#gpdd">Global Population Dynamics Database</a> of long-term abundance records.
</p>


<h3><a name="start">Select Data</a></h3>
<p>
The first step in using the EBDB is select the data sets <a href='data.php'>data sets</a> you wish to query and return data from. 
Only selecting the data of interest increases speed and reduces interface complexity.
</p>
<Center>
<a href='./image/start.gif'><IMAGE src='./image/start.gif' width='600px'/></a>
<p class='caption'>Figure 1. Start Screen</p>
</Center>


<h3><a name="main">The Main Screen</a></h3>
<p>
You control your session from the EBDB main screen. 
The <a href='#find'>FIND</a> tool provides a quick way of discovering which data sets a taxon is in. 
The <a href='#session'>SESSION</a> bar provides information on your current selection,
 initially all names and GPDD time series in the EBDB.
 The <a href='#query'>QUERIES</a> bar is present once a query has been run; it shows your query chain. 
 Click to edit queries.
 The <a href='#query'>ADD QUERY</a> buttons open query dialogs.
 The <a href='#output'>OUTPUTS<a> bar is visible once an output has been added. Click to edit outputs.
 The <a href='#output'>ADD OUTPUT<a> tool creates a new data set output. 
</p>
<p>
TOOL TIPS provide tool-specific information. Reveal by hovering over page elements.
</p>
<Center>
<a href='./image/main.gif'><IMAGE src='./image/main.gif' width='600px'/></a>
<a name="fig2"><p class='caption'>Figure 2. Main Screen</p></a>
</Center>

<a name='find'></a><h3 >Find</h3>
<p>
'Find' simply shows presence or absence of names in data sets and does not effect queries.
Type a comma-seperated list into the input, then press 'find' to discover which names are in which data sets.
Find searches are case-sensitive and do not support wildcards.
</p>
<Center>
<a href='./image/find.gif'><IMAGE src='./image/find.gif' width='600px'/></a>
<p class='caption'>Figure 3. Find</p>
</Center>
<p>
Find results are displayed on the main screen as a table with one line for each taxon and columns for each data set.
A green dot is displayed where the taxon is found in a data set, otherwise a red dot is displayed. 
A tool tip gives column data set name.
</p>


<h3><a name="query">How to query</a></h3>
<p>
Data may be queried by <a href="#names">biological name</a>, <a href="#tree">tree topology</a>,
 <a href="#attribute">attributes</a>, <a href="#geography">geography</a> or <a href='#time'>time</a>.
 Name, geography and time queries may be applied to one or more data sets, 
 attribute and tree queries operate on single data sets.
 Queries connected by AND, OR and MINUS interquery operators form the 'query chain' that is displyed as the query bar. 
 Queries are displayed with the same symbols as the add query buttons. 
 Interquery operators are displayed as Venn diagrams diagram and tool tips (<a href='#fig2'>Fig 2</a>).
</p>
<p>
Queries are intiated by selecting one of the query types.
 Tree and attribute queries present a dialog to select a data set to query.
</p>
<Center>
<a href='./image/single-source.gif'><IMAGE src='./image/single-source.gif' width='500px'/></a>
<p class='caption'>Figure 4. Single source prompt</p>
</Center>
 
<p>
In multi-source queries (names, geography and time) data set selection is part of the query dialog.
Queries must be applied to at least one dataset. 
N SOURCES set a criteria for how many datasets each names must be in. 
In the below figure only names present in all three selected datasets are returned.
This figure also shows <a href='#query_name'>QUERY NAME</a>, interquery operator dialog (which must be set for all but the first query in the chain) and the
 <a href='#query_buttons'>CANCEL</a>, <a href='#query_buttons'>DELETE</a> and <a href='#query_buttons'>RUN ></a> buttons.
</p>
<p>
Once a query has been run QUERY SQL is added to the query dialog. 
By default the SQL that returns names for the selected query is displayed.
This can be changed to SQL that returns GPDD series identifiers or, 
 if more than one query exists, the SQL for the entire query chain <a href='fig6'>(fig 6)</a>.
</p>
<Center>
<a href='./image/multi-source.gif'><IMAGE src='./image/multi-source.gif' width='600px'/></a>
<p class='caption'>Figure 5. Multi-source prompt for a names query</p>
</Center>

<p>
<a name='query_name'></a>All queries have a name. Names must not include white space.
The default is a numerical increment on the query type, 
i.e. the first bionames will be 'bionames1' and the second 'bionames2' irrespective of whether the first name was changed.
Query names do not have to be unique as they have a unique internal reference; however using the same name is not recommended.
</p>
<p>
<a name='query_buttons'></a>Unsurprisinly, 'Run >' runs a query. 'Delete' deletes the query. 
'Cancel' returns to the main screen from an existing query edit. No changes are saved following a cancel. 
To implement changes to a query run the query.
</p>

<h4><a name="names">Biological Name</a></h4>
<p>
Names queries search for names across one or more data sets. 
Names may be found with the FILTER tool or may be entered as one per line to the text box.
FIND performs an 'case-sensitive double-wild card' search on input text given the N SERIES criterion, 
thus in Fig 6. the find on 'Mus' returns all names containing 'Mus' found in all five datasets.
Alternatively, checking 'All names' will return all names that match the name-dataset criteria.
'All names' overrides any entered names.
</p>
<center>
<a name="fig6">
<a href='./image/names.gif'><IMAGE src='./image/names.gif' width='600px'/></a>
<p class='caption'>Figure 6. Names query</p>
</center>
</a>
<p>
Run names queries include a taxon name REPORT and the QUERY SQL.
</p>


<h4><a name="tree">Tree</a></h4>
<p>
Tree queries select names from a single phylogeny or taxonomy dataset. 
Phylogeny and taxonmy queries only differ in their FILTER options.
</p>
<p>
Four TREE OPERATORS are supported:
</p>
<table border='1'>
<tr>
<th>Operator</th>
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
<p>
FILTER SCOPE controls whether FILTER classes are applied to both Find and Query results, or just to Find.
FILTER classes control the taxonomic level of names returned by Find and Query. Checked classes are returned.
Phylogeny classes are 'internal' and 'tip' nodes.
FIND performs an 'case-sensitive double-wild card' search on input text given the FILTER criteria.
</p>
<center>
<a name="fig7">
<a href='./image/taxonomy.gif'><IMAGE src='./image/taxonomy.gif' width='600px'/></a>
<p class='caption'>Figure 7. Taxonomy query</p>
</center>

<h4><a name="attribute">Attribute</a></h4>
<p>
Attribute queries select names from the values of variables in a normal and spatial table.
</p>
<center>
<a name="fig8">
<a href='./image/table.gif'><IMAGE src='./image/table.gif' width='600px'/></a>
<p class='caption'>Figure 8. Querying the attributes of the GPDD</p>
</center>
<p>
Attribute fields are grouped into general classes of
 Count, Identifier, Taxonomy, Time, Geography, Place, Sampling,Referece and notes.
 Hover over field names for descriptions. Check field name to open QUERY DIALOG. Query dialogs are of two types, numerical and catagorical. 
</p>
<p>
The numerical dialog ('GR Min Lat dd' in fig. 8) has an OPERATOR and VALUE. 
When a field includes null values a check box is provided to include names with NULLs for that field in the query result.
</p>
<p>
Use the case sensitive double-wildcard FIND to discover catagory VALUES ('Activity Cycle' in fig. 8).
Copy values from the lefthand find return box to the righthand query box.
The check box controls whether find returns NULL or not.
</p>


<h4><a name="geography">Geography</a></h4>
<p>
Geographic queries select names from spatial datasets.
Polygon, line and point QUERY FEATRUES can be drawn on the map using the drawing tools in the upper right of the map.
BOUNDING BOX features are added numerically. CLEAR MAP to erase all query features.
Use <IMAGE src='./image/openlayers_layerswitcher.gif'/> to change background map.
Features can not cross the anti-meidian (-180/+180 longitude).
</p>

<center>
<a name="fig9">
<a href='./image/geography.gif'><IMAGE src='./image/geography.gif' width='600px'/></a>
<p class='caption'>Figure 9. Geographic query</p>
</center>

<p>
Four SPATIAL OPERATORS are suppoted:
</p>
<table border='1'>
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
<br>

<h4><a name="time">Time</a></h4>
<p>
Temporal queries select names and data that exists BEFORE, DURING or AFTER a particular day.
</p>
<center>
<a name="fig9">
<a href='./image/time.gif'><IMAGE src='./image/time.gif' width='600px'/></a>
<p class='caption'>Figure 10. Temporal query</p>
</center>
<br>

<h3><a name="output">Returning data</a></h3>
<p>
Data is returned by adding dataset OUTPUTS.
Output dialogs reflect the composition of data types that compose each dataset, so, for example,
 mammal ranges may be exported as either spatial or tabular formats, whereas the GPDD is comprised of
 tabular and spatial data. Data extracts are returned compressed within a zip file with a
  SESSION METADATA file (readme.txt) that describes the queries undertaken and data returns.
</p>

<h4><a name="output_table">Tabular Output</a></h4>
<p>
Tabular data such as Panthria or the GPDD may be exported as comma-delineated (*.csv)' 
or 'tab-delineated (*.txt)' ascii files. All or a subset of fields may be output.
</p>

<center>
<a name="fig10">
<a href='./image/output-table.gif'><IMAGE src='./image/output-table.gif' width='600px'/></a>
<p class='caption'>Figure 11. Pantheria Output</p>
</center>

<h4><a name="output_spatial">Geographic Output</a></h4>
<p>
Spatial data such as can be exported as a <a href=''>ESRI Shapefile</a>, <a href=''>MapInfo</a>, <a href=''>DGN</a>, 
 <a href=''>DXF</a>, <a href=''>Geographic Markup Language (GML)</a>
 and <a href=''>Keyhole Markup Language (KML)</a> formats. [Add non-spatial]
</p>
<center>
<a name="fig_output-geography">
<a href='./image/output-geography.gif'><IMAGE src='./image/output-geography.gif' width='600px'/></a>
<p class='caption'>Figure 12. Pantheria Output</p>
</center>

<h4><a name="output_tree">Tree Output</a></h4>
<p>
Trees may be exported in <a href=''>newick</a>, <a href=''>nhx</a>, 
<a href=''>tab-indented ascii</a> or <a href=''>lintree formats</a>.
Trees may be the subtree defined by the last common ancestor of the selected names or pruned to only the name set.
Branch attributes (e.g. ages) may be be output in the tree file.
</p>
<center>
<a name="fig_output-tree">
<a href='./image/output-tree.gif'><IMAGE src='./image/output-tree.gif' width='600px'/></a>
<p class='caption'>Figure 12. Mammal Phylogeny Output</p>
</center>


<h4><a name="output-gpdd">GPDD Output</a></h4>
<p>
Trees may be exported in <a href=''>newick</a>, <a href=''>nhx</a>, 
<a href=''>tab-indented ascii</a> or <a href=''>lintree formats</a>.
Trees may be the subtree defined by the last common ancestor of the selected names or pruned to only the name set.
Branch attributes (e.g. ages) may be be output in the tree file.
</p>
<center>
<a name="fig_output-gpdd">
<a href='./image/output-gpdd.gif'><IMAGE src='./image/output-gpdd.gif' width='600px'/></a>
<p class='caption'>Figure 12. GPDD Output</p>
</center>

<h4><a name="readme">Session metadata</a></h4>
<p>
Readme.txt contains information on the queries undertaken and returned data.
</p>

<h3><a name="browser">Browser Compatability</a></h3>
<p> 
The interface was developed for the Chrome Browser (v15) [??link??]. 
 Compatability with other Internet browsers has not been tested.
</p>

<br />
<?php html_entangled_bank_footer(); ?>
</div>
</body>
</html>
