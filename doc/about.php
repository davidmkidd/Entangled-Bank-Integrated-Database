<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="content-type">
  <title>About The Entangled Bank</title>
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
<LI><a href='#problem'>The Problem</a></LI>
<LI><a href='#ebdb'>The Entangled Bank Database (EBDB)</a></LI>
	<OL>
	<LI><a href='what'>What is the EBDB?</a></LI>
	<LI><a href='architecture'>Architecture</a></LI>
	<LI><a href='imagery'>Imagery</a></LI>
	</OL>
<LI><a href='#discovery'>Entangled Bank Discovey</a></LI>
</OL>

<a name='#problem'></a><h3>The Problem</h3>

<p>Ecological data are highly heterogeneous and widely distributed among institutions
and individual researchers. Difficulty in locating and accessing ecological data sources 
prevents researchers from discovering available data, and once located, synthesis may be
problematic due to syntactic and semantic ambiguity, restricted metadata, and the
inherent heterogeneity of the data itself. These difficulties mean synthetic
ecological science can be enormously labour intensive as data integration must be
done by hand. Despite these obstacles, integration of these disparate data sources is vital for research that
spans wide geographical areas or attempts to integrate across and study
feedbacks between the multiple levels of biological organization from individual
organisms to ecosystems; studies that are vital to developing the kind
of understanding of the natural world necessary to deal with the pressures
it faces in the 21<sup>st</sup> century.</p>

<p>
The 'Entangled Bank' was a joint undertaking by the <a href="http://www3.imperial.ac.uk/cpb">NERC Centre for
Population Biology</a>, Biology Division, Imperial College London, and
the <a href="http://research.microsoft.com/en-us/groups/ecology/default.aspx">
 Computational Ecology and Environmental Science Group</a>, Microsoft Research, Cambridge to develop web-based 
 data management system and associated interactive tools to enhance the identification, management, integration, 
 processing, analysis and visualization of ecological data.
The Imperial team are <a href="http://www3.imperial.ac.uk/people/t.coulson">Prof. Tim Coulson</a>,
 <a href="http://www3.imperial.ac.uk/people/g.mace">Prof. Georgina Mace FRS</a>,
 <a href="http://www3.imperial.ac.uk/people/a.purvis">Prof. Andy Purvis</a>,
 <a href="http://www3.imperial.ac.uk/people/d.orme">Dr. David Orme</a>, and
 <a href="http://entangled-bank.org/davidkidd/">Dr. David Kidd</a>.
The project has two strands, The Entangled Bank Database and <a href='#discovery'>Entangled Bank Discovery</a></p>

<a name='#ebdb'></a><h3>1. The Entangled Bank Database (EBDB)</h3>

<h4><a name="what">What is the EBDB?</a></h4>
<p>The Entangled Bank  Database (EBDB) provides integrated access to a number of mammal datasets 
 (a taxonomy, phylogeny, trait database and range maps) and the 
<a href="http://www3.imperial.ac.uk/cpb/research/patternsandprocesses/gpdd">Global Population Dynamics Database</a> of long-term abundance records.
These data may be queried by biological name, tree topology, data set attributes, geography and time
 to answer questions that span multiple data sets. Examples of such linked queries include,</p>
<ul>
<LI>Which taxa are present in these datasets?</LI>
<LI>Which taxa found here have abundance records for this period?</LI>
<LI>What are the ranges of Cervidae with body mass greater than 20kg.</LI>
<LI>Which South American taxa are descended from the last common ancestor of these genera?</LI>
</ul>

<h4><a name="work">How does it work?</a></h4>
<p>
The EBDB finds taxon names in data sets that meet the selection criteria...
</p>

<h4><a name="architecture">Architecture</a></h4>
<p>The EBDB is a <a href="http://www.postgresql.org/">PostgreSQL</a> database which implements a variety of schemas that support various data types.
 Tabular data are stored as relational tables
, spatial data in the <a href="http://postgis.refractions.net/"> PostGIS</a> schema, and trees in the  
 <a href="http://biosql.org/wiki/Extensions">PhyloDB</a> extension to BioSQL . Controlled vocabularies are managed with the BioSQL ontology schema. 
The <a href="http://www3.imperial.ac.uk/cpb/research/patternsandprocesses/gpdd">Global Population Dynamics Database<a> schema stores population abundance time series.
The EB Data Model is the 'glue' that connects data within in these schema. 
It stores two types of information: (1) semantic metadata describing datasets, and (2) structural metadata the defines dataset structure, 
including the location of biological names and spatial and temporal information.
 The interface is written in PHP, JavaScript and Perl. 
<a href="http://openlayers.org/"> OpenLayers</a> is used for maps and
 <a href="http://doc.bioperl.org/releases/bioperl-1.4/Bio/TreeIO.html">BioPERL Tree::I/O</a> and 
<a href="http://search.cpan.org/dist/Bio-Phylo/">Bio::Phylo</a> for tree I/O. 
Geographic I/O is through <a href="http://www.gdal.org/ogr2ogr.html">GDAL/OGR2OGR</a>.
</p>
<p>
The EBDB is open-source and code can be downlaoded from 
<a href="https://github.com/davidmkidd/Entangled-Bank-Integrated-Database">Github</a>. 
Instructions are limited so contact with the development team is stongly encouraged.
</p>

<center>
<img src="./image/eb_architecture.png">
<p class='legend'>Entangled Bank Architecture</p>
</center>

<h4><a name="imagery">Metaphor and Imagery</a></h4>
<p>
The 'entangled bank' is the endearing metaphor with which Charles
Darwin's <a href="http://darwin-online.org.uk/content/frameset?viewtype=image&itemID=F373&pageseq=1">
<span style="font-style: italic;">Origin of Species</span></a>
(1859) ends. By the 5th edition published in 1869 the
'entangled bank' had been truncated to simply 'a tangled bank'. As the
prefix en- means 'becoming' the image was subtly changed from organic
growth and evolution to static observation.
</p>

<center>
<table border="0">
  <tbody>
    <tr>
      <th rowspan='2'>
 		<img style="width: 345px;"  alt="Darwin1859_EntangledBank.gif"
 		src="./image/Darwin1859_EntangledBank.gif">
	 </th>
     	<td>
      	<img style="width: 180px;" alt="1839_Zoology_F8.9_050.gif"
 			src="./image/1839_Zoology_F8.9_050.gif">
 		</td>
    </tr>
    <tr>
      <td>
      	<img style="width: 180px;" alt="DarwinPortrait.gif"
 			src="./image/DarwinPortrait.gif">
 		</td>
    </tr>
  </tbody>
</table>
<p class='legend'>Origin of Species Chapter 14, Conclusion, p489-490<br>
<a href='http://darwin-online.org.uk'>(Source: Darwin Online)</a>.</p>
</center>

<p>
Imagery is used to represent different aspects of biological data.
 An extract of the title of <a href='http://en.wikipedia.org/wiki/File:Linnaeus1758-title-page.jpg'>
 Linnaeus' <i>Systema Naturae</i> 1758</a> (center) represents biological names.
 Trees are represented by Darwin's sketch of an evolutionary tree (top) from his <a href='http://en.wikipedia.org/wiki/File:Darwin_tree.png'>First Notebook on Transmutation of Species (1837)</a>. 
 <a href='http://oceanmotion.org/html/background/climate.htm'>NASA's 'Blue Marble'</a> represents geography (left), while an extract of <a href='http://en.wikipedia.org/wiki/File:Haeckel_Arachnida.jpg'>
 Ernst Haekel's plate 66: Arachnida, Kunstformen der Natur (1904)</a> denotes 'attributes'.
 Finally, an <a href='http://farm4.static.flickr.com/3605/3639291429_f19524c475.jpg'>'old' clock face</a> represents time.
 The background and banner is an English Hedgerow on the <a href='http://www3.imperial.ac.uk/silwoodparkcampus'>
 Silwood Park Campus</a> of Imperial College with a path leading to new horizons.
</p>
<center>
<img src='../image/logo.png'/><br>
<p class='legend'>Entangled Bank Imagery</p>
</center>

<a name='discovery'></a><h3>2. Entangled Bank Discovey</h3>

<p>
Entangled Bank Discovery (EBDD): a web-based tool for discovering and preserving data. 
Search for datasets by taxonomy, space, time and type. Enter metadata and upload data to the Microsoft Azurus cloud.
For further information on the EBD contact Microsoft Research <a href = "mailto:ricw@microsoft.com">??email??</a>.
</p>
<center>
<a href="./image/ebdd.gif"><img src="./image/ebdd.gif" height=350px/></a><br>
<p class="legend">Entangled Bank Data Discovery Tool</p>
</center>

<br />
<?php html_entangled_bank_footer(); ?>
</div>
</body>
</html>
