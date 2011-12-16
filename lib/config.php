<?php

# ENTANGLED BANK CONFIGURATION

# ---------------------
# DB CONNECTION
# ---------------------

$config['host'] = '129.31.4.53';
$config['dbname'] = 'entangled_bank';
$config['port'] = '5432';
$config['user'] = 'entangled_bank_user';
$config['password'] = 'm0nkeypu22le';

# --------------------
# PATHS
# --------------------

$config['ebhost'] = 'localhost';
$config['htmlhost'] = 'entangled-bank.org';

# -----------------------------------------------------------------
# Relative Paths from web server DocumentRoot ( w/o following slash)
# -----------------------------------------------------------------
# path to entangled bank programs
#
$config['eb_path'] = 'entangled-bank';
#
# path to perl scripts
#
$config['perl_script_path'] = 'c:\ms4w\Apache\htdocs\entangled-bank\perl';
#
# path to shared resources
#
$config['share_path'] = 'entangled-bank/share';
#
# path to tmp (output files)
#
$config['tmp_path'] = 'entangled-bank/tmp';
#
$config['out_path'] = '/ms4w/Apache/htdocs/entangled-bank/tmp';
#
# ------------------
# Paths to Utilities
# ------------------
#
# path to ogr2ogr
#
$config['ogr2ogr_path'] = "C:\\FWTools2.4.7\\bin\\";

##
# to PERL
# perl_path=/ic-utils/perlic5.8.8.820.4/bin

$config['perl_path'] = '/Perl/bin';

?>