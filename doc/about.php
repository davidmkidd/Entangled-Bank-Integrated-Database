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
  <title>The Entangled Bank Project</title>
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

<a name='#problem'></a><h3>The Entangled Bank Project</h3>

<p>
<i>Science that spans wide geographical areas or attempts to integrate across and study
feedbacks between the multiple levels of biological organization from individual
organisms to ecosystems is vital to developing the kind
of understanding of the natural world necessary to deal with the pressures
it faces in the 21<sup>st</sup> Century.</i></p>
<img alt="data cycle" src="./image/datacycle.png" width='260px' style="border:1px solid grey; float: right;">
<p>
Such <a href='http://onlinelibrary.wiley.com/doi/10.1111/j.1558-5646.2009.00892.x/abstract'>synthetic</a> studies that 
re-purpose existing information are particularly problematic in ecology as;
</p>

<UL>
<LI>Data is inherently heterogenous and widely distributed among organisations.</LI>
<LI>Archives are few, and where exist have limited structure and metadata.</LI>
<LI>Data and metadata are often poorly exposed.</LI>
<LI>Analytical tools are isolated by data format and discipline.</LI>
</UL>
<p>
The Entangled Bank Project developed two systems tothat help mobilise ecological data by removing friction
from the data cycle.
</p>
<br>
<center>
<table border='0'>
<tr>
<td align='center' class='eb_projects'><p><a href='eb_database.php#ebdb'>The Entangled Bank<br>Integrated Database</a></p></td>
<td align='center' class='eb_projects'><p><a href='eb_discovery.php#discovery'>Entangled Bank<br>Discovery</a></p></td>
</tr>
<tr>
<td class='eb_projects'>
<a href='eb_database.php#ebdb'><img src='../image/logo.png' alt='the entangled bank integrated database', height='200px'></a>
</td>
<td class='eb_projects'>
<a href='eb_discovery.php#discovery'><img src='./image/ebdd_clipped.gif' alt='the entangled bank integrated database', height='200px'></a>
</td>
</tr>
</table>
</center>
<br>
<p>
The Entangled Bank project was a joint undertaking by the <a href="http://www3.imperial.ac.uk/cpb">NERC Centre for
Population Biology</a>, Biology Division, Imperial College London, and
the <a href="http://research.microsoft.com/en-us/groups/ecology/default.aspx">
 Computational Ecology and Environmental Science Group</a>, Microsoft Research, Cambridge.
The Entangled Bank Integrated Database was developed at Imperial College while Entangled Bank Discovery by Microsoft.
<p>
 
<p>
The team at Imperial  were <a href="http://www3.imperial.ac.uk/people/t.coulson">Prof. Tim Coulson</a>,
 <a href="http://www3.imperial.ac.uk/people/g.mace">Prof. Georgina Mace FRS</a>,
 <a href="http://www3.imperial.ac.uk/people/a.purvis">Prof. Andy Purvis</a>,
 <a href="http://www3.imperial.ac.uk/people/d.orme">Dr. David Orme</a>, and
 <a href="http://entangled-bank.org/davidkidd/">Dr. David Kidd (Developer)</a>. 
 The Microsoft Research team were Rich Williams 
 and <a href="mailto:i-anrobe@microsoft.com?Subject=Entangled%20Bank%20aDiscovery">Andy Roberts (Developer)</a>.
</p>

 <center>
<img src='./image/funding-logo.gif' alt='funding logo'/>
<p class='legend'>Funding by the Natural Environment Research Council, Imperial College and Microsoft.</p>
</center>
</div>

<?php html_entangled_bank_footer(); ?>
</div>
</body>
</html>
