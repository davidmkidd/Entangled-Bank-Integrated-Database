#!/usr/bin/perl -w

#
# $Id: write_tree.pl 270 2011-06-21
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
# output_tree.pl - converts and prunes trees
#                                                           |
#-----------------------------------------------------------+
#                                                           |
# CONTACT: dkidd_at_imperial.ac.uk                          |
#                                                           |
# DESCRIPTION:                                              |
# Entangled Bank utility that prunes a tree to an array of  |
# names and converts between tree formats                   |
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
use DBI;
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
my $newick = $ARGV[2];  # newick string
my $subtree = $ARGV[3];  # subtree
my $format = $ARGV[4];  # output format

my $session = PHP::Session->new($sid, { save_path => $spath });
my $names = $session->get('names');
#print $sid . ", " , $spath . "\n";
#print "$newick<br>";


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
 
if ($subtree eq 'pruned' || $format eq "nexus" || $format eq "xml" || $format eq "svg") {
	
	# ================================================
	#  Parse newick string to Bio::Phylo::Forest::Tree
	# ================================================
	
	$forest = Bio::Phylo::IO->parse(
		-format => 'newick',
		-string => $newick
		);
		
	$tree = $forest->first;
	
	# =======================================
	#  Prune
	# =======================================
	
	my $n = 0;
	if ($subtree eq 'pruned') {
		my $n1 = $tree->calc_number_of_nodes;
		print "initial tree: " . $n1 . "<br>";
		$tree = $tree->keep_tips(\@mynames);
		$n++;
		my $n2 = $tree->calc_number_of_nodes;
		print "after prune tree " . $n . ": " . $n2 . "<br>";
		while ($n1 ne $n2) {
			#$tree1 = $tree2;
			$n1 = $n2;
			$tree = $tree->keep_tips(\@mynames);
			$n2 = $tree->calc_number_of_nodes;
			$n++;
			print "after prune tree " . $n . ": " . $n2 . "<br>";
		}
		$tree->remove_unbranched_internals;
		print "after remove internals tree: " . $tree->calc_number_of_nodes . "<br>";
	}
}

## =======================================
## Write tree
## =======================================
print $subtree . ", " . $format . "\n"; 
if (($subtree eq 'pruned' && $format eq 'newick') ||
	($format eq "nexus" || $format eq "xml" || $format eq "svg")) {

	# Write from Bio:Phylo::Forest::Tree
	print "Write from Bio:Phylo::Forest::Tree\n";
	switch ($format) {
		case "newick" { $out = $tree ->	to_newick;}
		case "nexus" { $out = $tree ->to_nexus;}
		case "xml" { $out = $tree ->to_xml;}
		case "svg" { $out = $tree ->to_svg;}
	}
} elsif ($subtree eq 'subtree' && $format eq 'newick') {
	$out = $newick; 
} elsif ($format eq "nhx" || $format eq "tabtree" || $format eq "lintree") {
	# Import to Bio::TreeI/O
	if ($subtree eq 'pruned') { $newick = $tree -> to_newick;}
	my $io = IO::String -> new($newick);
	my $treeIO = Bio::TreeIO -> new(-fh => $io, -format => 'newick');
	switch ($format) {
		#case 'nhx' {$treeout = Bio::TreeIO -> new (-format 'nhx');}
	}
}

print $out;
	
