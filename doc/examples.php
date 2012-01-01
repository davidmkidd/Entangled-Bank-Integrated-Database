<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="content-type">
  <title>Entangled Bank Examples</title>
  <meta content="webmaster@entangled-bank.org" name="author">
  <meta content="Index page" name="description">
  <link type="text/css" rel="stylesheet" href="../share/entangled_bank.css">
</head>

<body>
<div id='page'>

<?php 
include("../lib/html_utils.php"); 
$stage = html_entangled_bank_header('doc', '../');
?>
<hr>

<div id='content'>
<h4>Contents</h4>
<OL id='contents'>
<LI><a href="#ex1"> Which names are in all sources?</a>
<LI><a href="#ex2"> Get the spatial ranges of all Cervidae 
	with a mean weaning body mass greater than 20kg
<LI><a href="#ex3"> Which species in the taxonomy are not in the phylogeny?</a>
<LI><a href="#ex4"> Which species are restricted to the southern hemisphere between 90°E and 90°W and have ranges of less than 10,000km2?</a>
<LI><a href="#ex5"> Get a phylogeny pruned to species in Cervidae or Monotremata</a>
</OL>


<h3><a name="ex1">Which names are in all sources?</a></h3>
<p>
<OL type=i>
<LI> <b>Sources:</b> click 'Next' to select all sources.</LI>
<LI> <b>Query by:</b> 'Name'.</LI>
<LI> <b>Select source(s) to apply query to:</b> 'All sources'.<br></LI>
<LI> <b>New names query:</b>: check 'All names'. Keep the default number of sources names must be in, i.e. all query sources.</LI>
<LI> The query will run and you will return to <b>Query by</b>. The 'Shopping Cart' contains the number of names returned by the query and
links to obtain further information. Click 'list names' to open a new browser tab which list selected names.</LI>
</OL>
</p>

<h3><a name="ex2">2. Get the spatial ranges of all Cervidae 
	with a mean weaning body mass greater than 20kg</a></h3>
<p>
This is a two part query (1) find all taxa in the family Cervidae, and (2) subset by mean weaning body mass, and a single spatial output.
<OL>
<LI> All taxa in the family Cervidae
<OL type=i>
<LI> <b>Sources :</b> Select 'Mammal taxonomy msw05', 'Pantheria mammal traits msw05' and 'Mammal ranges geographic msw05'.
<LI> <b>Query by:</b> 'Tree'.
<LI> <b>Select source to apply query to:</b> 'Mammal taxonomy msw05
<LI> <b>How do you want to specify names:</b> 'Input names'.
<LI> Type 'Cervidae' into the text box and keep the default settings.
'Least Common Ancestor subtree of names' returns names at all hierarchical levels below the least common ancestor of the input names.
<LI> 71 names should be returned which include the family and genera names.
</OL type=i>
<LI> Subset by mean weaning body mass
<OL>
<LI> <b>Query by:</b> 'Attribute'.
<LI> <b>Select source to apply query to:</b>: 'Pantheria mammal traits msw05'.
<LI> <b>Select Pantheria mammal traits msw05 fields to query by:</b> 'Select fields' and check '5-4_WeaningBodyMass_g'.
<LI> <b>Select from Pantheria mammal traits msw05:</b>
 enter '20000' in the minimum text box and select the AND 'between query operator' to return names that are selected by both this the previous query.
<LI> 5 names should be returned. 'List names' shows that they are all species binomials, this is because Pantheria only contains data on species.
</OL>
<LI> Output ranges as a spatial file
<OL type=i>
<LI> <b>Query by:</b>: 'Return data'
<LI> <b>Select data to output:</b> 'Mammal ranges geographic msw05'.
<LI> <b>Output for Mammal ranges geographic msw05:</b> select the desired spatial data format, e.g. shapefile for ArcGIS or KML for Google Earth.
<LI> <b>Select data to output:</b>: 'Return data'</i>.
<LI> <b>Entangled Bank Download:</b> right-click and 'save as...' to download requested data</i>.
</OL>
</OL>
</p>

<h3><a name="ex3">3. Which species in the taxonomy not are in the phylogeny?</a></h3>
<p>
As the tips of both the taxonomy and phylogeny are species and the phylogeny contains a subset of the species in the taxonomy,
 (1) select all tip names in the taxonomy, and (2) subtract all tip names in the phylogeny. 
<OL>
<LI> Select all tip names in the taxonomy
<OL type=i>
<LI> <b>Sources:</b>: 'Mammal taxonomy msw05' and 'Mammal phylogeny msw05'.
<LI> <b>Query by:</b> 'Tree'.
<LI> <b>Select source to apply query to:</b> 'Mammal taxonomy msw05'.
<LI> <b>How do you want to specify names:</b> check 'All names'.
<LI> <b>New tree query</b>: check to return 'Tip nodes' from the tree.
<LI> 5416 names should be returned.
</OL>
<LI> Subtract all tip names in the phylogeny
<OL type = i> 
<LI> <b>Query by:</b> 'Tree'.
<LI> <b>Select source to apply query to:</b> check 'Mammal phylogeny msw05'.</LI>
<LI> <b>How do you want to specify names:</b>: check 'All names'.
<LI> <b>New tree query</b>: check to return 'Tip nodes' from the tree and the 'MINUS' between query operator to subtract names from the current selection.
<LI> 396 names should be returned. Clicking 'names in sources' shows these names are in the taxonomy but ot the phylogeny.
</OL>
</OL>
</p>

<h3><a name="ex4">4. Which species are restricted to the southern hemisphere between 90°E and 90°W and have ranges of less than 10,000km2?</a></h3>
<p>
A two part query, (1) select ranges inside the bounding box, and (2) select species with ranges less than x km2. 
<OL>
<LI> Select ranges inside the bounding box
<OL type=i>
<LI> <b>Sources:</b>: 'Mammal ranges geographic msw05'.
<LI> <b>Query by:</b> 'Geography'.
<LI> <b>Select source to apply query to:</b> 'Mammal ranges geographic msw05'.
<LI> <b>New geographic query:</b> enter 'north'=0, 'south'=-90, 'east'=-90, and 'west'=90, and check 'overlay' INSIDE. As east is smaller than west the bounding box will cross +180/-180 longitude.
<<LI> 597 names should be returned.
</OL>
<LI> Select species with ranges less than 10,000 km2
<OL type=i>
<LI> <b>Query by:</b> 'Attribute'.
<LI> <b>Select source to apply query to:</b> 'Mammal ranges geographic msw05'.
<LI> <b>Select Mammal ranges geographic msw05 fields to query by:</b> check 'Select fields' and 'area_km_behrmann'.
<LI> <b>Select from Mammal ranges geographic msw05:</b> change max area_km_behrman to 10000, and select the AND 'between query operator'.
<<LI> 177 names should be returned.
</OL>
</OL>
</p>

<h3><a name="ex5">5. Get the phylogeny pruned to species in Cervidae or in Monotremata</a></h3>
<p>
A two part query, (1) select species in Cervidae, and (2) add species in Monotremata, then (3) return the phylogeny.
<OL>
<LI> Select species in Cervidae
<OL type=i>
<LI> <b>Sources :</b> Select 'Mammal taxonomy msw05' and 'Mammal phylogeny msw05'.
<LI> <b>Query by:</b> 'Tree'.
<LI> <b>Select source to apply query to:</b> 'Mammal taxonomy msw05'.
<LI> <b>How do you want to specify names:</b> 'Input names'.
<LI> Type 'Cervidae' into the text box and keep the default settings.
'Least Common Ancestor subtree of names' returns names at all hierarchical levels below the least common ancestor of the input names.
<LI> 71 names should be returned which include the family and genera names.
</OL>
<LI> Select species in Monotremata
<OL type=i>
<LI> <b>Query by:</b> 'Tree'.
<LI> <b>Select source to apply query to:</b> 'Mammal taxonomy msw05'.
<LI> <b>How do you want to specify names:</b> 'Input names'.
<LI> Type 'Monotremata' into the text box and OR(UNION) the names using the 'between query operator'.
'Least Common Ancestor subtree of names' returns names at all hierarchical levels below the least common ancestor of the input names.
<LI> 82 names should returned.
</OL>
<LI> Get tree
<OL type=i>
<LI> <b>Query by:</b> 'Return data'.
<LI> <b>Select data to output:</b> 'Mammal phylogeny msw05'.
<LI> <b>Output for Mammal phylogeny msw05:</b> select 'Pruned subtree defined by bionames', tree format and branch attribute to output.
<LI> <b>Select data to output:</b> 'Return data'.
</OL>
</OL>
</p>

<?php include("./insert/footer.html"); ?>
</body>
</html>
