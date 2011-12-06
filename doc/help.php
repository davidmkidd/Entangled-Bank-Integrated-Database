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
<LI><a href="#start">Select some data sets to query</a></LI>
<LI><a href="#find"> Find taxa data in data sets</a></LI>
<LI><a href="#query">Query data sets by</a></LI>
<ol>
<LI><a href="#name">Biological Name</a></LI>
<LI><a href="#tree">Taxonomy or Phylogeny</a></LI>
<LI><a href="#tree">Attribute Values</a></LI>
<LI><a href="#query">Geography</a></LI>
<LI><a href="#query">Time</a></LI>
</ol>
<LI><a href="#output">Return data</a></LI>
<LI><a href="#browser">Browser compatability</a></LI>
</OL>

<h3><a name="what">What does the EBDB do?</a></h3>
<p>
The Entangled Bank Database (EBDB) supports the querying, subsetting and extraction of data sets by biological name, tree topology,
attribute values, geography and time through a Web-based interface.
It is currenlty populated with a number of <a href="./doc/data.php#mammal">datasets for all mammals</a> 
and the <a href="./doc/data.php#gpdd">Global Population Dynamics Database</a> of long-term abundance records. 
Some <a href="./doc/examples.php" alt='Entangled Bank Examples'>use examples</a> are provided.
</p>


<h3><a name="start">Select some data sets to query</a></h3>
<p>
The first action beginning an Entangled Bank session you must select which data sources you are interested in, i.e. that you would like query or return data from. 
Selecting a subset of sources reduces the interface complexity and speed up actions that report information about your queries.
</p>


<h3><a name="cart">3. Shopping Cart</a></h3>
<p>
The shopping cart contains information on your Entangled Bank session including,
<OL>
<LI>The number of sources being queried, with an option to view the number of selected names in each source.</LI>
<LI>The number of bionames selected, with options to view (i) a simple list the names,
 and (ii) a table showing which names are in which sources with out-links to Wikipedia.
 Note: Wikipedia links are based on the name, which in the case of nodes in the phylogeny may not exist or may link to a completely unconnected wikipedia topic.</LI>
<LI>The number of queries, with options to view, (i) a table showing which names are in each query (with Wikipedia out-links), and (ii) query SQL</LI>
<LI>The number of outputs and a a decription of each output.</LI>
</OL>
</p>

<h3><a name="query">4. Query</a></h3>
<p>
The Entangled Bank interface allows users to create a sequential set of queries which return bionames that match the query crieria.
 Queries are connected by AND, OR and MINUS inter-query operators.
 Four types of query are supprted:
<OL>
<LI><a href="#query_names"> Names queries</a> that select bionames across multiple sources.</LI>
<LI><a href="#query_table"> Tabular queries</a> that select bionames from field values in a flat aspatial or spatial table.</LI>
<LI><a href="#query_spatial"> Geographic queries</a> that select bionames across multiple spatial sources.</LI>
<LI><a href="#query_tree"> Tree queries</a> that select bionames from a tree source.</LI></LI>
</OL>
All queries have a name which will be truncated at the first white space.
The default name is a numerical increment on the query type, 
i.e. the first bionames will be 'bionames1' and the second 'bionames2' irrespective of whether the first name was changed.
Query names do not have to be unique as they have a unique internal reference; however using the same name is not recommended.
</p>

<h4><a name="query_names">4.1 Name Query</a></h4>
<p>
Names queries search for bionames across one or more sources. 
Having selected the sources to seach across, the names query interface is displayed.
Bionames are entered one per line in the text area, alternatively check 'All names' to search for all bionames in sources.
 'All names' overrides any entered names.
</p>
<p>
Example names list:
</p>
<p>
Mus musculus<br>
Homo sapiens<br>
Glis glis<br>
Pongo pongo
</p>
<p>
'Number of sources names must be in' removes bionames not found in at least that number of sources. 
The default is the number of sources and thus bionames must be in all query sources.
</p>
<p>
Queries that involve trees can be constrained to return tip or internal names only.
</p>

<h4><a name="query_table">4.2 Tabular Query</a></h4>
<p>
Tabular queries select bionames using the values of variables in a flat or spatial table.
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

<h4><a name="query_tree">4.4 Tree Query</a></h4>
<p>
Tree queries select bionames from a single tree source. 
Phylogenies and taxonomies are examples of tree sources.
All bionames in a tree can be selected, or a subset returned from a free text input, or selection from a list. 
Input or selected bionames may be processed individually or used to obtain all bionames with the least common ancestor subtree they define.
Queries can be constrained to return tip or internal names only.
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
