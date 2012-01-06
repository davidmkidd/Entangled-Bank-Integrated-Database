<?php
session_start();
$_SESSION['lastaction'] = 'doc';
session_write_close();
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="content-type">
  <title>Entangled Bank Data</title>
  <meta content="webmaster@entangled-bank.org" name="author">
  <meta content="Index page" name="description">
  <link type="text/css" rel="stylesheet" href="../share/entangled_bank.css">
</head>

<body>
<div id='page'>

<?php 
include("../lib/html_utils.php"); 
$stage = html_entangled_bank_header('doc', '../');
#include("./contents.html");
?>
<div id='content'>

<h3 name='data'>Data</h3>
<p>
The EBDB contains these datasets:
</p>

<OL id='contents'>
<LI><a href="#mammal_taxonomy"> Wilson and Reeder MSW3 Mammal Taxonomy</a></LI>
<LI><a href="#mammal_geographic"> Mammal Range (MSW3)</a></LI>
<LI><a href="#mammal_pantheria"> Pantheria Mammal Trait Database (MSW3)</a></LI>
<LI><a href="#mammal_supertree"> Mammal Supertree (MSW3)</a></LI>
<LI><a href="#gpdd"> Global Population Dynamics Database</a></LI>
</OL>

<p>Data sets with the '(MSW3)' suffix are based on the <a href="#mammal_taxonomy">Wilson & Reeder, Mammal Species of the World 2005 taxonomy</a></p>

<h4><a name="mammal_taxonomy">1. Wilson and Reeder MSW3 Mammal Taxonomy</a></h4>
<p>
outlink: <a href="http://www.bucknell.edu/msw3/">The Wilson and Reeder (2005) MSW3 taxonomy</a> 
</p>
<p class='citation'>Don E. Wilson & DeeAnn M. Reeder (editors). 2005. Mammal Species of the World. 
A Taxonomic and Geographic Reference (3rd ed), Johns Hopkins University Press, 2,142 pp.
</p>

<h4><a name="mammal_pantheria">2. Panteria Mammal Trait Database (MSW3)</a></h4>
<p>
A species-level database of life history, ecology, and geography of extant and recently extinct mammals.
</p>
outlink: <a href="http://esapubs.org/archive/ecol/E090/184/default.htm">Pantheria trait database</a>
<p class='citation'>Jones, Kate E., Jon Bielby, Marcel Cardillo, Susanne A. Fritz, Justin O'Dell, C. David L. Orme, Kamran Safi, Wes Sechrest, Elizabeth H. Boakes, Chris Carbone, Christina Connolly, Michael J. Cutts, Janine K. Foster, Richard Grenyer, Michael Habib, Christopher A. Plaster, Samantha A. Price, Elizabeth A. Rigby, Janna Rist, Amber Teacher, Olaf R. P. Bininda-Emonds, John L. Gittleman, Georgina M. Mace, and Andy Purvis. 2009.
PanTHERIA: a species-level database of life history, ecology, and geography of extant and recently extinct mammals.
Ecology 90:2648. Ecological Archives E090-184.
</p>

<h4><a name="mammal_geographic">3. Mammal Range Maps (MSW3)</a></h4>
<p>
A database of mammal range maps. The  range maps were originally developed by 
Sechrest (World Wide Global Diversity, Endemism, and Conservation of Mammals. PhD Thesis, Univ. Virginia 2003) as part of a collaboration 
between the University of Virginia, Imperial College London and the Zoological Society of London. 
 Selchrest's maps were then updated to the <a href="#mammal_taxonomy">MSW3 taxonomy</a> 
 so data geographical-based data could be calculated for the <a href="#mammal_pantheria">Pantheria Trait Database</a>.
 The range maps are s the WGS84 projection. The 'Range Area Km' field was calculated on the Behrmann projection.
</p>
<p class='citation'>Jones, Kate E., Jon Bielby, Marcel Cardillo, Susanne A. Fritz, Justin O'Dell, C. David L. Orme, Kamran Safi, Wes Sechrest, Elizabeth H. Boakes, Chris Carbone, Christina Connolly, Michael J. Cutts, Janine K. Foster, Richard Grenyer, Michael Habib, Christopher A. Plaster, Samantha A. Price, Elizabeth A. Rigby, Janna Rist, Amber Teacher, Olaf R. P. Bininda-Emonds, John L. Gittleman, Georgina M. Mace, and Andy Purvis. 2009.
PanTHERIA: a species-level database of life history, ecology, and geography of extant and recently extinct mammals.
Ecology 90:2648. Ecological Archives E090-184.
</p>

<h4><a name="mammal_supertree">4. Mammal Supertree (MSW3)</a></h4>
<p>
A dated supertree of mammals based on the <a href="#mammal_taxonomy">MSW3 taxonomy</a>
</p>
outlink: <a href="http://www.nature.com/nature/journal/v446/n7135/abs/nature05634.html">Mammal supertree</a> 
<p class='citation'>Bininda-Emonds, O. R. P., Cardillo, M., Jones, K. E., MacPhee, R. D. E., Beck, R. M. D., Grenyer, R., Price, S. A., Vos, R. A., Gittleman, J. L. & Purvis, A. (2007) 
The delayed rise of present-day mammals. Nature, 446, 507-512.
</p>

<h4><a name="gpdd">5. Global Population Dynamics Database</a></h4>
<p>
The Global Population Dynamics Database (GPDD) is a database of over 5000 long-term abundance records.
The EDBD provides access to the 4471 unrestricted series for 1347 taxa. Where taxa a classified to species level the 'name' queried is the Latin binomial, 
otherwise it is the full 'TaxonName' which varies in format. Note that mammal names are NOT necessarily consistent with the <a href="#mammal_taxonomy">MSW3 taxonomy</a>.
Metadata on restricted GPDD series can be accessed through the 
<a href='https://www.imperial.ac.uk/cpb/gpdd2/secure/login.aspx?ReturnUrl=/cpb/gpdd2/gpdd.aspx'></a>GPDD Web Interface</a>.
</p>
outlink:<a href='http://www3.imperial.ac.uk/cpb/research/patternsandprocesses/gpdd'>The Global Population Dynamics Database (GPDD)</a>
<p class='citation'>NERC Centre for Population Biology, Imperial College (2010) The Global Population Dynamics Database Version 2. http://www3.imperial.ac.uk/cpb/research/patternsandprocesses/gpdd. 
</p>

<?php html_entangled_bank_footer(); ?>
</div>
</div>
</body>
</html>
