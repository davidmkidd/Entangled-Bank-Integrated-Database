<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="content-type">
  <title>EB - Data Sets</title>
  <meta content="webmaster@entangled-bank.org" name="author">
  <meta content="Index page" name="description">
  <link type="text/css" rel="stylesheet" href="../entangled_bank.css">
</head>

<body>
<?php include("../insert/banner.html"); ?>

<h2>Sources in the Entangled Bank</h2>
<OL>
<LI><a href="#mammal_geographic"> Mammal Range (MSW05)</a></LI>
<LI><a href="#gpdd"> Global Population Dynamics Database</a></LI>
<LI><a href="#pantheria"> Pantheria Mammal Traits Database (MSW05)</a></LI>
<LI><a href="#mammal_supertree"> Mammal Supertree (MSW05)</a></LI>
<LI><a href="#mammal_taxonomy"> Mammal Taxonomy (MSW05)</a></LI>
</OL>

<p>Sources suffixed with '(MSW05)' are based on the <a href="#mammal_taxonomy">Wilson & Reeder, Mammal Species of the World (2005)</a> taxonomy</p>

<h3><a name="mammal_geographic">Mammal Range Maps (MSW05)</a></h3>
<p>
The mammal range maps were originally developed by Sechrest (World Wide Global Diversity, Endemism, and Conservation of Mammals. PhD Thesis, Univ. Virginia 2003) as part of a collaboration between the University of Virginia,
 Imperial College London and the Zoological Society of London. They have since been updated to the Wilson and Reeder (2005).
 The range maps are in the WGS84 projection. The area_m_behrmann field contains range area in meters calculated nn the Behrmann projection. 
 As area is a field, ranges can be subsetted by area by applying a tablular query to the range table.
</p>

<h3><a name="mammal_worldclim">2. WorldClim Bioclimatic variables in Mammal Ranges</a></h3>
<p>
Mean, minimum, maximum, variance and standard deviation of 19 10-arc minute resolution<a href="http://www.worldclim.org/"> 
Worldclim Bioclimatic<a> variables with <a href="http://entangled-bank.org/datasets.html#mammal_geographic">mammal ranges</a>.
</p>

<?php include("./insert/footer.html"); ?>
</body>
</html>
