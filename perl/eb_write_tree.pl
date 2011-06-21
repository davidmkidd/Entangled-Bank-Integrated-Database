#!/usr/bin/perl

#!/usr/bin/perl -w
#
# $Id: eb_write_tree.pl 270 2011-06-21
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
# eb_write_tree.pl - Import data from common file formats  |
#                                                           |
#-----------------------------------------------------------+
#                                                           |
# CONTACT: dkidd_at_imperial.ac.uk                          |
#                                                           |
# DESCRIPTION:                                              |
# Exports a tree from PhyloDB as a NEWICK string given a    |
# tree_id, array of node names, subtree specification       |
# and optional branch length specifier in a PHP Session.    |
# Edit connect_to_pg() with your own database connect string|
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
use Time::HiRes qw(gettimeofday);


#use warnings;
#use diagnostics;

#print "BEGIN write_tree_new.pl<br>";
my $t0 = gettimeofday();

# =======================================
# The Session 
# =======================================
my $sid = $ARGV[0];    #PHP session id
my $spath = $ARGV[1];  #PHP session dir
my $session = PHP::Session->new($sid, { save_path => $spath });

# =======================================
# Session variables
# =======================================
my $outputid = $session->get('output_id');
my $output;
my $outputs = $session->get('outputs');
my $names = $session->get('names');
my $sources = $session->get('sources');

# WINDOWS HARDCODE
#my $tmp_path = $session->get('tmp_path');
my $tmp_path = '/ms4w/Apache/htdocs/eclipse/entangled_bank_db_dev/tmp';
my $source;	# the source
$tmp_path = substr($tmp_path, index($tmp_path, '/') + 1);
#print "<br>tmp_path: " . $tmp_path . "<br>";

# ===============================
# Session vars to PERL variables  
# ===============================

# Dereference names
my @mynames;		#Names array
while ( my ($key, $value) = each(%$names) ) {
	push(@mynames, $value);
    }

# Get output from outputs given output_id
while ( my ($key, $value) = each(%$outputs) ) {
	# print "key: " . $key . ", value: " . $$value{id} . "<br>";
	if ($outputid eq $$value{id}) {
		$output = $value;
		}
    }
#print "<br>output: " . $$output{filename} . "<br>";	

# Get source from output
my $sourceid = $$output{sourceid};
#print "sourceid: " . $sourceid . "<br>";
while ( my ($key, $value) = each(%$sources) ) {
	##print "key: " . $key . ", value: " . $$value{id} . "<br>";
	if ($$value{id} == $sourceid) {
		$source = $value;
		};
    }

# Get tree_id, edge qual val, subtree, file name and format
my $treedbid = $$source{tree_id};		#tree_idprint 'Perl treeid: ' . $treedbid;
my $edgequal = $$output{brqual};
my $subtree = $$output{subtree};
my $outfile = $$output{filename};   # Full path to output the tree file to 
my $format = $$output{format};      # Data format used in outfile
									
# =======================================
# Program variables
# =======================================
my @mynodes;		#Nodes array
my $names_pgarray;  #postgres array for SQL queries
my $nodes_pgarray;  #postgres array for SQL queries
my @row;        	# array to store database row
my $lca;			#LCA
my $i;          	#counter
my $parent;			#bio::node
my $child;			#bio::node
my $biotree;		#bio::tree
#my $dist;			#cumulative distance for singletons


# =======================================
#        Database variables
# =======================================
my $statement;      #database statement
my $sth;            #prepared statement

# =======================================
#          Connect to database	   
# =======================================
my $dbh = &connect_to_pg();

# =======================================
#          Build BioPerl tree
# =======================================


# GET NODE IDS FROM NAMES
# =======================
if (@mynames > 0) {
	$names_pgarray = &array_to_postgresql(@mynames, 'text');
	$statement = "SELECT biosql.label_to_id(" . $names_pgarray . ", " . $treedbid . ") AS nodeid";
	} else {
	$statement = "SELECT label FROM biosql.node WHERE tree_id = " . $treedbid . ' AS nodeid';
	}
$sth = &prepare_sth($dbh, $statement);
$sth->execute();
my $nodes_ref = $sth->fetchall_arrayref({ nodeid => 1});

# Dereference nodes
foreach my $row_ref (@$nodes_ref) {
	#print $row_ref->{nodeid} . "<br>";
    push(@mynodes, $row_ref->{nodeid});
	}

#      GET LCA TREE
# =======================
if (@mynodes > 0) {
	$nodes_pgarray = &array_to_postgresql(@mynodes, 'numeric');
	$statement = "SELECT biosql.lca(" . $nodes_pgarray . ", $treedbid)" 
	} else {
	$statement = "SELECT node_id FROM biosql.tree WHERE tree_id = " . $treedbid;
	}
$sth = &prepare_sth($dbh, $statement);
$sth->execute();
@row = $sth->fetchrow_array;
$lca = $row[0];

# GET LCA
$statement = "SELECT biosql.id_to_label(" . $lca . ")";
$sth = &prepare_sth($dbh, $statement);
$sth->execute();
@row = $sth->fetchrow_array;

# ADD LCA AS ROOT NODE OF BIOTREE
my $p_label = $row[0];
$parent = Bio::Tree::Node->new(-id => $p_label);
$biotree = Bio::Tree::Tree->new(-root => $parent);

# WALK THE BIOTREE TO ADD SUBNODES (removed $parent, 0 from end)
&treewalk(\$biotree, $treedbid, $lca, $edgequal);
my $t1 = gettimeofday();
my $elapsed = $t1 - $t0;
print "LCA Subtree: $elapsed<br>";

# CONVERT TO BIO:PHYLO TREE
# =========================
my $tree = Bio::Phylo::Forest::Tree->new_from_bioperl($biotree);
#print "new Bio::Phylo tree has $n1 nodes\n";
my $t1 = gettimeofday();
my $elapsed = $t1 - $t0;
print "Converted to Bio::Phylo: $elapsed<br>";

# Prune
if ($subtree == 'pruned') {
	my $n1 = $tree->calc_number_of_nodes;
	my $tree = $tree->keep_tips(\@mynames);
	my $n2 = $tree->calc_number_of_nodes;
	while ($n1 ne $n2) {
		#$tree1 = $tree2;
		$n1 = $n2;
		$tree = $tree->keep_tips(\@mynames);
		$n2 = $tree->calc_number_of_nodes;
	}
}
$t1 = gettimeofday();
$elapsed = $t1 - $t0;
print "Pruned: $elapsed<br>";

# GET NEWICK STRING
my $tree_string = $tree->to_newick();
#print $tree_string;

# WRITE FILE
#OS HARDCODE

my $ext;
switch ($format) {
	case "newick" {$ext = '.tre';}
	case "nhx" {$ext = '.nhx';}
	case "tabtree" {$ext = '.tab';}
	case "lintree" {$ext = '.lin';}
	}
my $out_path = 'C:/ms4w/Apache/htdocs/eclipse/entangled_bank_db_dev\/tmp';
my $out_treefile = $out_path . '/' . $outfile . $ext;

# WRITE TO FILE
open FILEHANDLE, "> $out_treefile"
	 or die "Failed to create tree file : $!";
print FILEHANDLE $tree_string;
close FILEHANDLE;
$t1 = gettimeofday();
$elapsed = $t1 - $t0;
print "Written: $elapsed<br>";

#print $out_treefile;


sub treewalk {

	# PASSED VARIABLES
	my $biotree_ref = shift;			# Perl Tree object
	my $biotree = $$biotree_ref;
	my $treedbid = shift;			# databaseid of tree
	my $parentdbid = shift;			# Parent node dbid
	my $edgequal = shift; 			# the term_id of the edge_qualifier_value or null id none
	
	#INTERNAL VARIABLES
	my $childdbid;					# Child DB node id
	my $statement;					# DB query
	my $sth;						# prepared DB query 1
	my @row;						# DB query 1 row
	my $distance;
		
	# GET CHILDREN OF PARENT
	$statement = "SELECT biosql.children_of_node($parentdbid)";
	$sth = &prepare_sth($dbh, $statement);
	$sth->execute();
	
	while (@row = $sth->fetchrow_array) {
		$childdbid = $row[0];
		if ($edgequal && $edgequal ne 'none') {
			$distance = &get_distance($dbh, $parentdbid, $childdbid, $edgequal);
			&add_child($dbh, $biotree, $parentdbid, $childdbid, $distance);
			} else {
			&add_child($dbh, $biotree, $parentdbid, $childdbid);
			}
		&treewalk(\$biotree, $treedbid, $childdbid,$edgequal);
		}		
	}
		

sub add_child {
	
	# &add_child($dbh, $biotree, $parentdbid $childdbid, $cumdist)
	
	use strict;
	use Bio::Tree::TreeI;
	use Bio::Tree::Node;
	
	my $dbh = shift;
	my $biotree = shift;
	my $parentdbid = shift;
	my $childdbid = shift;
	my $distance = shift;
	
	my $statement;
	
	#print "parentdbid: $parentdbid<br>";
	#print "childdbid: $childdbid<br>";
	#print "biotree: $biotree<br>";

	#GET PARENT NODE FROM BIOTREE GIVEN PARENTDBID
	$statement = "SELECT biosql.id_to_label($parentdbid)";
	$sth = &prepare_sth($dbh, $statement);
	$sth->execute();
	@row = $sth->fetchrow_array;
	my $parent_label = $row[0];
	$parent = $biotree->find_node(-id => $parent_label);
	
	# NEW CHILD
	$statement = "SELECT biosql.id_to_label($childdbid);";
	my $sth = &prepare_sth($dbh, $statement);
	$sth->execute();
	my @row = $sth->fetchrow_array;
	my $child_label = $row[0];
	my $child = Bio::Tree::Node->new();
	$child->id($child_label);
	$child->branch_length($distance);
	$parent->add_Descendent($child);
	#print "<FONT color=red>$childdbid ($child_label) added to $parentdbid with $cumdist</FONT><br>";
	}

	
sub get_distance {

	my $dbh = shift;
	my $parentdbid = shift;
	my $childdbid = shift;
	my $edgequal = shift;
	
	my $str = "SELECT eq.value FROM 
		biosql.edge_qualifier_value eq,
		biosql.edge e,
		biosql.node n
		WHERE n.node_id = $parentdbid
		AND e.parent_node_id = n.node_id
		AND e.child_node_id = $childdbid
		AND e.edge_id = eq.edge_id
		AND eq.term_id = $edgequal";
		
	#print "statement = $str<br>";
	my $sth = &prepare_sth($dbh,$str);
	$sth->execute();
	my @eqrow = $sth->fetchrow_array;
	#print $eqrow[0];
	return $eqrow[0];
	}
	

# =======================================
#           sub connect_to_pg
# =======================================

sub connect_to_pg {

	# Replace <...> with your database connection information
	my $cstr = "dbi:PgPP:dbname=<db_name>;host=<host>";
	my $user = "<user>";
	my $pass = "<password>";

	my $dbh1 = DBI->connect($cstr, $user, $pass);
		
	return($dbh1);
} # End of ConnectToPG subfunction

sub prepare_sth {
    $dbh = shift;
    $sth = $dbh->prepare(@_);
    die "failed to prepare statement '$_[0]': ".$dbh->errstr."\n" unless $sth;
    return $sth;
}

sub array_to_postgresql {
	#print "Array_to_postgreSQL<br>";
	$i = @_;    				# no of args passed. Last must be $type
	my $type = $_[$i - 1]; 		#'text' or 'numeric' if omitted use text
	
	if ($type ne 'text' && $type ne 'numeric') {
		$type = 'text';
		}
	my $val;
	my $retval = 'ARRAY[';

	my $first = 1;
	foreach $val (@_) {
	    #print $val . "<br>";
		if ($val eq 'numeric' || $val eq 'text') {
			} else {
			if ($first == 1) {
				if ($type eq 'numeric') {
					$retval = $retval . $val;
					} else {
					$retval = $retval . "'$val'";
				}
				$first = 0;
				} else {
				if ($type eq 'numeric') {
					$retval = $retval . "," . $val;
					} else {
					$retval = $retval . ",'$val'" ;
					}
				}
			}
		}
	$retval = $retval . "]";
	# print length($retval);
	# print "<br>";
	return $retval;
}
