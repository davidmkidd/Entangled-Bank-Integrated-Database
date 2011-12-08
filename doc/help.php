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
<div class='main'>
<?php 
include("../lib/html_utils.php"); 
$stage = html_entangled_bank_header(null, '../');
?>
<h4>Contents</h4>
<OL>
<LI><a href="#what">What does the EBDB do?</a></LI>
<LI><a href="#start">Select data to query</a></LI>
<LI><a href="#main">The EBDB main screen</a></LI>
<LI><a href="#query">Query by</a></LI>
<ol>
<LI><a href="#name">Biological Name</a></LI>
<LI><a href="#tree">Tree (Taxonomy or Phylogeny)</a></LI>
<LI><a href="#attribute">Attribute Value</a></LI>
<LI><a href="#query">Geography</a></LI>
<LI><a href="#query">Time</a></LI>
</ol>
<LI><a href="#output">Return data</a></LI>
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


<h3><a name="query">Query</a></h3>
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
Tree queries select bionames from a single phylogeny or taxonomy dataset. 
Phylogeny and taxonmy queries only differ in their FILTER options.
</p>
<p>
Four tree OPERATORS are supported:
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

<h4><a name="attribute">Attribute Value</a></h4>
<p>
Attribute queries select names from the values of variables in a flat or spatial table.
Users select which fields they wish to query from a list and are then presented with options for each selected field.
Field containing discrete values are presented as a set of check boxs, while minimum and and maximum ranges can be set for continious value fields.
To select names between two disjunct ranges, e.g. (between 10 and 100) and (between 200 and 300) two seperate queries must be created linked by an 'OR'.
A check box allows the return of names where the searched fields contain null values.
 Seperate queries are required to include nulls from one field but not from others.
</p>

<h4><a name="query_spatial">4.3 Spatial Query</a></h4>
<p>
Spatial queries select bionames from one or more spatial sources using a bounding box search with OVERLAP and WITHIN operators.
To query an OVERLAP box that crosses -180/+180 longitude, enter the larger longitude in West and the smaller in East.
</p>



<h3><a name="query_manage">5. Query Management</a></h3>
<p>
Queries can be deleted or edited. 
Query re-ordering is not currently supported. 
</p>

<h3><a name="output">6. Output</a></h3>
<p>
Having selected bionames sources can be subsetted by those names and output in a variety of formats.
 Multiple outputs of the same data in different formats can be set.
Outputs are zip compressed into a single file with a text file (readme.txt) describing the queries undertaken and data returned.
<OL>
<LI><a href="#output_table"> Tabular outputs</a>, which output tables as a comma seperated values file</LI>
<LI><a href="#output_spatial"> Spatial outputs</a>, which output spatial layers in a variety of formats</LI>
<LI><a href="#output_tree"> Tree outputs</a>, which trees models with branch attributes in a variety of formats</LI>
<LI><a href="#output_readme"> Tabular outputs</a>, which output tables as a comma seperated values file</LI>
</OL>
</p>

<h4><a name="output_table">6.1 Tabular Output</a></h4>
<p>
All or a subset of the fields in a table can be exported as a csv file.
</p>

<h4><a name="output_spatial">6.2 Spatial Output</a></h4>
<p>
Spatial data can be exported as a ESRI Shapefile, MapInfo, DGN, DXF, Geographic Markup Language (GML) and Keyhole Markup Language (KML) formats.
</p>

<h4><a name="output_tree">6.3 Tree Output</a></h4>
<p>
Trees pruned to the name set or the least common ancestor of the names can be exported as newick, nhx, tab-indented ascii or lintree formats (NeXML will be supported soon).
Optionally, trees branch attributes (e.g. ages) can be output in the tree file.
</p>

<h3><a name="output_manage">7. Output Management</a></h3>
<p>
Outputs can be edited or deleted. 
</p>

<h4><a name="readme">8. Readme.txt</a></h4>
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
