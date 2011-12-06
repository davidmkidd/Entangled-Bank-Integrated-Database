#!/usr/bin/perl

#
# $Id: convert_tree.pl 270 2011-06-21
#
# Copyright 2010-2011 David Kidd
#
#  This file is part of BioSQL.
#
#  BioSQL is free software: you can redistribute it and/or modify it
#  under the terms of the GNU Lesser General Public License as
#  published by the Free Software Foundation, either version 3 of the
#  License, or (at your option) any later version.
#
#  BioSQL is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Lesser General Public License for more details.
#
#  You should have received a copy of the GNU Lesser General Public License
#  along with BioSQL. If not, see <http://www.gnu.org/licenses/>.
#
#-----------------------------------------------------------+
#                                                           |
# convert_tree.pl - converts and prunes trees
#                                                           |
#-----------------------------------------------------------+
#                                                           |
# CONTACT: dkidd_at_imperial.ac.uk                          |
#                                                           |
# DESCRIPTION:                                              |
# Entangled Bank utility converts trees between formats     |
#                                                           |
#                                                           |
# LICENSE:                                                  |
#  GNU Lesser Public License                                |
#  http://www.gnu.org/licenses/lgpl.html                    |
#                                                           |
#-----------------------------------------------------------+
#
# THIS SOFTWARE COMES AS IS, WITHOUT ANY EXPRESS OR IMPLIED
# WARRANTY. USE AT YOUR OWN RISK.
#

# LINUX?
#use lib "/root/.cpan/build/BioPerl-1.6.1-_d3kvu";

use strict;
use PHP::Session;
use Switch; 
#use DBI;
use Bio::TreeIO;                # creates Bio::Tree::TreeI0 objects
use Bio::Tree::TreeI;
use Bio::Tree::Node;
use Bio::Phylo::Forest::Tree; 
use IO::String;
#use Time::HiRes qw(gettimeofday);

# =======================================
# Get Variables 
# =======================================
my $sid = $ARGV[0];    # PHP session id
my $spath = $ARGV[1];  # PHP session dir

my $format = $ARGV[2];  # output format

my $session = PHP::Session->new($sid, { save_path => $spath });
my $newick = $session->get('newick');  # newick string
my $names = $session->get('names');

##print "Welcome from PERL<br>";

# =======================================
# Internal Variables 
# =======================================
my $forest;      # forest object
my $tree;        # tree object
my $out = "Ugg!";

# Dereference names
my @mynames;		#Names array
while ( my ($key, $value) = each(%$names) ) {
	push(@mynames, $value);
    }
 
if ($format eq "nexus" || $format eq "xml" || $format eq "svg") {
	
	# ================================================
	#  Parse newick string to Bio::Phylo::Forest::Tree
	# ================================================
	
	$forest = Bio::Phylo::IO->parse(
		-format => 'newick',
		-string => $newick
		);
		
	$tree = $forest->first;

	# Write from Bio:Phylo::Forest::Tree
	#print "Write from Bio:Phylo::Forest::Tree\n";
	switch ($format) {
		#case "newick" { $out = $tree -> to_newick;}
		case "nexus" { $out = $tree ->to_nexus;}
		case "xml" { $out = $tree ->to_xml;}
		case "svg" { $out = $tree ->to_svg;}
	}
	print $out;
	
} elsif ($format eq "nhx" || $format eq "tabtree" || $format eq "lintree") {
	
	# Import to Bio::TreeI/O
	
	my $io = IO::String -> new($newick);
	my $treeIO = Bio::TreeIO -> new(-fh => $io, 
							-format => 'newick');
	$tree = $treeIO->next_tree;
	
	my $outIO = IO::String->new;
	my $outTreeIO = Bio::TreeIO -> new(-format=>$format, -fh => $outIO);
	$outTreeIO->write_tree($tree);
	$outIO->print();
}


	
