<?php

# ENTANGLED BANK CONFIGURATION

# ---------------------
# DB CONNECTION
# ---------------------

$config['host'] = '<IP or Domain>';
$config['dbname'] = '<db name>';
$config['port'] = '<port>';
$config['user'] = '<user name>';
$config['password'] = '<password>';

# --------------------
# PATHS
# --------------------

# Name of host running Apache
$config['ebhost'] = 'localhost';

# Name of host with Apache
#$config['htmlhost'] = 'entangled-bank.org';

# -----------------------------------------------------------------
# Relative Paths from web server DocumentRoot ( w/o following slash)
# -----------------------------------------------------------------
#
# path to entangled bank programs from  
#
$config['eb_path'] = 'entangled-bank';
#
# path to tmp (output files)
#
$config['tmp_path'] = 'entangled-bank/tmp';
#
# depreciate
$config['out_path'] = '/ms4w/Apache/htdocs/entangled-bank/tmp';
#
# path to shared resources
#
$config['share_path'] = 'entangled-bank/share';
#
# pat to PERL
# On LINUX
# perl_path=/ic-utils/perlic5.8.8.820.4/bin
#
$config['perl_path'] = '/Perl/bin';
#
# path to perl scripts
#
$config['perl_script_path'] = 'c:\ms4w\Apache\htdocs\entangled-bank\perl';
#
# path to ogr2ogr
#
$config['ogr2ogr_path'] = "C:\\Program Files\\FWTools2.4.7\\bin\\";
#
#
?>