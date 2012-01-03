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
include("./contents.html");
?>

<div id='content'>

<a name='#problem'></a><h3>The Entangled Bank Project</h3>
<img alt="data cylce" src="./image/datacycle.png" width='275px' style="border:1px solid grey; float: right;">
<!--<p class='legend'>Figure 1. The 'data cycle'</p>-->
<p>
Science that spans wide geographical areas or attempts to integrate across and study
feedbacks between the multiple levels of biological organization from individual
organisms to ecosystems is vital to developing the kind
of understanding of the natural world necessary to deal with the pressures
it faces in the 21<sup>st</sup> Century.</p>
<p>Such 'synthetic' studies that 
re-purpose exist information are particularly problematic in ecology as:
</p>

<UL>
<LI>Data is widely distributed</LI>
<LI>Archives are basic and few</LI>
<LI>Metadata is limited non-standardised and with ambigious vocabularies</LI>
<LI>Data structures inherently heterogenous</LI>
<LI>Data and metadata poorly exposed</LI>
<LI>Analytical tools isolated by data format and discipline</LI>
</UL>
<p>
Systems and tools are required that mobilise ecological data by removing friction
 in the data cycle (fig 1). These will include data archives and tools to aid
 data discovery and integration. 
 The Entangled Bank Project has developed two such systems:
 </p>
 
<center>
<table border='0'>
<tr>
<td>
<a href='eb_database.php#ebdb'><img src='../image/logo.png' alt='the entangled bank integrated database', height='300px'></a>
</td>
<td>&nbsp;&nbsp;</td>
<td>
<a href='eb_discovery.php#discovery'><img src='./image/ebdd_clipped.gif' alt='the entangled bank integrated database', height='300px'></a>
</td>
</tr>
<tr>
<td align='center'><p class='legend'><a href='eb_database.php#ebdb'>Entangled Bank Integrated Database</a></p></td>
<td>&nbsp;&nbsp;</td>
<td align='center'><p class='legend'><a href='eb_discovery.php#discovery'>Entangled Bank Discovery</a></p></td>
</tr>
</table>
 </center>
 
 <a name='#people'></a><h4>People</h3>
The Entangled Bank project, a joint undertaking by the <a href="http://www3.imperial.ac.uk/cpb">NERC Centre for
Population Biology</a>, Biology Division, Imperial College London, and
the <a href="http://research.microsoft.com/en-us/groups/ecology/default.aspx">
 Computational Ecology and Environmental Science Group</a>, Microsoft Research, Cambridge.
The team at Imperial  were <a href="http://www3.imperial.ac.uk/people/t.coulson">Prof. Tim Coulson</a>,
 <a href="http://www3.imperial.ac.uk/people/g.mace">Prof. Georgina Mace FRS</a>,
 <a href="http://www3.imperial.ac.uk/people/a.purvis">Prof. Andy Purvis</a>,
 <a href="http://www3.imperial.ac.uk/people/d.orme">Dr. David Orme</a>, and
 <a href="http://entangled-bank.org/davidkidd/">Dr. David Kidd (Developer)</a>. 
 The Microsoft Research team were Rich Williams 
 and <a href="mailto:i-anrobe@microsoft.com?Subject=Entangled%20Bank%20aDiscovery">Andy Roberts (Developer)</a>.
</p>
 
 <a name='#funding'></a><h4>Funding</h3>
 <center>
<img src='./image/funding-logo.gif' alt='funding logo'/>
<p class='legend'>Funding by the Natural Environment Research Council, Imperial College and Microsoft.</p>
</center>
</div>

<?php html_entangled_bank_footer(); ?>
</div>
</body>
</html>
