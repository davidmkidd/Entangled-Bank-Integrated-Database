#!/usr/bin/perl -w
#
# $Id: eb_import_tree.pl 270 2011-06-21 03:48:41Z lapp $
#
# Copyright 2007-2008 James Estill
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
# eb_import_tree.pl - Import data from common file formats  |
#                                                           |
#-----------------------------------------------------------+
#                                                           |
# CONTACT: dkidd_at_imperial.ac.uk                          |
#                                                           |
# DESCRIPTION:                                              |
#  Import NEXUS and Newick files from text files to the     |
#  PhyloDB. Also imports hierarchies specified as a columns |
#  in a table. Incorporates  code from phyimport.pl and     |
#  parseTreesPG.pl but used the bioperl Tree object to work |
#  with trees.                                              |
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


#-----------------------------+
# INCLUDES                    |
#-----------------------------+
use strict;
use DBI;
use Getopt::Long;
use Bio::TreeIO;                # creates Bio::Tree::TreeI objects
use Bio::Tree::TreeI;
use Bio::Tree::Node;

#-----------------------------+
# VARIABLE SCOPE              |
#-----------------------------+
my $VERSION = "1.0";           # Program version

my $usrname = $ENV{DBI_USER};  # User name to connect to database
my $pass = $ENV{DBI_PASSWORD}; # Password to connect to database
my $dsn = $ENV{DBI_DSN};       # DSN for database connection
my $infile;                    # Full path to the input file to parse
my $format = 'newick';         # Data format used in infile
my $db;                        # Database name (ie. biosql)
my $host;                      # Database host (ie. localhost)
my $driver;                    # Database driver (ie. mysql)
my $schema;						# Schema tree model is in
my $sqldir;                    # Directory that contains the sql to run
                               # to create the tables.
my $tree_name;                 # The name of the tree
                               # For files with multiple trees, this may
                               # be used as a base name to name the trees with
my $statement;                 # Var to hold SQL statement string
my $sth;                       # Statement handle for SQL statement object
my $biodb;		               # The name of the BioSQL biodatabase that the tree is indexed to
my $biodb_id; 					# biodatabase_id
# Phylogeny Arguments
my $branch_len_term;  			# The name of the branch length units
my $branch_len_id;              # The id of the branch length unit name term
my $branch_len_ont;				# The ontology the branch length unit is in
my $branch_len_ont_id;          # The id of the ontology the branch length unit is in
my $tree_db_id;          		# integer ID of the tree in the database
my $node_db_id;          		# integer ID of a node in the database
my $edge_db_id;          		# integer ID of an edge in the database
# Taxonomy Table Arguments
my $taxontable;					# Name of database table containing tabular taxonomy
my $taxon_rank_ont;				# Taxon rank ontology
my $rootlabel;					# Root label
my $rootrank;					# Root rank
my $species_colname;			# Species column
my $genus_colname;				# Genus column
my $family_colname;				# Family column
my $order_colname;				# Order column

my $suffix;
my $predb;
my $prehost;
my $quoted;
my $branchlength = 0;

# BOOLEANS
my $verbose = 0;
my $show_help = 0;             # Display help
my $show_man = 0;              # Show the man page via perldoc
my $show_usage = 0;            # Show the basic usage for the program
my $show_version = 0;          # Show the program version
my $quiet = 0;                 # Run the program in quiet mode
                               # will not prompt for command line options

#-----------------------------+
# COMMAND LINE OPTIONS        |
#-----------------------------+
my $ok = GetOptions(# REQUIRED ARGUMENTS
           "d|dsn=s"    => \$dsn,
           "u|dbuser=s" => \$usrname,
           "p|dbpass=s" => \$pass,
           "i|infile=s" => \$infile,
           "f|format=s" => \$format,
		   "b|biodb=s"  => \$biodb,
		    # ALTERNATIVE TO --dsn
		    "driver=s"   => \$driver,
		    "dbname=s"   => \$db,
		    "host=s"     => \$host,
		    # ADDITIONAL OPTIONS
		    "t|tree=s"   => \$tree_name,
			"schema=s"   => \$schema,
			# PHYLOGENIES
			"l|branchterm=s" => \$branch_len_term,
			"o|branchont=s" => \$branch_len_ont,
			# TABULAR TAXONOMY
			"taxontable=s" => \$taxontable,
			"rankontology=s" => \$taxon_rank_ont,
			"rootlabel=s" => \$rootlabel,
			"rootrank=s" => \$rootrank,					# Root rank
			"species=s" => \$species_colname,			# Species column
			"genus=s" => \$genus_colname,				# Genus column
			"family=s" => \$family_colname,				# Family column
			"order=s" => \$order_colname,				# Order column
		    # BOOLEANS
		    "q|quiet"    => \$quiet,
		    "verbose"    => \$verbose,
		    "version"    => \$show_version,
		    "man"        => \$show_man,
		    "usage"      => \$show_usage,
		    "h|help"     => \$show_help,);

# Exit if format string is not recognized

#Check input arguments

if (!defined $schema) {
	die "Schema is required";
	}

$format = &in_format_check($format);

if ($format eq "tabular") {
	if (!defined $taxontable || !defined $rootlabel || !defined $rootrank) {
		die "-taxontable, -taxonlabel and -rootrank are required when -format is 'tabular'";
		}
	} else {
	if ((defined $branch_len_term && (!defined $branch_len_ont)) || ((!defined $branch_len_term) && defined $branch_len_ont)) {
		die "If branch lengths then both -branchterm and -branchont are required when -format is a tree type";
		} else {
		$branchlength = 1;
		}
	if (!defined $infile) {
		die "-infile is required when -format is a phylogeny type";
		}
	}


print "Requested format: $format\n" if $verbose;


#-----------------------------+
# SHOW REQUESTED HELP         |
#-----------------------------+
if ($show_usage) {
    print_help("");
}

if ($show_help || (!$ok) ) {
    print_help("full");
}

if ($show_version) {
    print "\n$0:\nVersion: $VERSION\n\n";
    exit;
}

if ($show_man) {
    # User perldoc to generate the man documentation.
    system("perldoc $0");
    exit($ok ? 0 : 2);
}

print "Staring $0 ..\n" if $verbose;

if ( ($db) & ($host) & ($driver) ) {
    # Set default values if none given at command line
    $db = "biosql" unless $db;
    $host = "localhost" unless $host;
    $driver = "mysql" unless $driver;
    $dsn = "DBI:$driver:database=$db;host=$host";
	$biodb = "mytrees" unless $biodb;

}
elsif ($dsn) {
    # We need to parse the database name, driver etc from the dsn string
    # in the form of DBI:$driver:database=$db;host=$host
    # Other dsn strings will not be parsed properly
    # Split commands are often faster then regular expressions
    # However, a regexp may offer a more stable parse then splits do
    my ($cruft, $prefix, $suffix, $predb, $prehost);
    ($prefix, $driver, $suffix) = split(/:/,$dsn);
    ($predb, $prehost) = split(/;/, $suffix);
    ($cruft, $db) = split(/=/,$predb);
    ($cruft, $host) = split(/=/,$prehost);
    # Print for debug
    print "\tPRE:\t$prefix\n" if $verbose;
    print "\tDRIVER:\t$driver\n" if $verbose;
    print "\tSUF:\t$suffix\n" if $verbose;
    print "\tDB:\t$db\n" if $verbose;
    print "\tHOST:\t$host\n" if $verbose;
}
else {
    # The variables to create a dsn have not been passed
    print "ERROR: A valid dsn can not be created\n";
    exit;
}


#-----------------------------+
# GET DB PASSWORD             |
#-----------------------------+
# This prevents the password from being globally visible
# I don't know what happens with this in anything but Linux
# so I may need to get rid of this or modify it
# if it crashes on other OS's

unless ($pass) {
    print "\nEnter password for the user $usrname\n";
    system('stty', '-echo') == 0 or die "can't turn off echo: $?";
    $pass = <STDIN>;
    system('stty', 'echo') == 0 or die "can't turn on echo: $?";
    chomp $pass;
}


#-----------------------------+
# CONNECT TO THE DATABASE     |
#-----------------------------+
# Commented out while I work on fetching tree structure
my $dbh = &connect_to_db($dsn, $usrname, $pass);

#-----------------------------+
# EXIT HANDLER                |
#-----------------------------+
END {
    &end_work($dbh);
}

$biodb_id = &get_biodatabase_id($dbh, $driver, $biodb);

#-----------------------------+
# LOAD THE INPUT FILE         |
#-----------------------------+

# global statements for setting the left-right indexing
my $setleft  = $dbh->prepare("UPDATE " . $schema . ".node SET left_idx = ? WHERE node_id = ?");
my $setright = $dbh->prepare("UPDATE " . $schema . ".node SET right_idx = ? WHERE node_id = ?");
my $ctr;

# global statements for calculating the transitive closure
my $deletepaths = $dbh->prepare("DELETE FROM node_path WHERE child_node_id IN (SELECT node_id FROM " . $schema . ".node WHERE tree_id = ?)");

my $init_sql = "INSERT INTO " . $schema . ".node_path (child_node_id, parent_node_id, distance) ";
  $init_sql .= "SELECT e.child_node_id, e.parent_node_id, 1 FROM " . $schema . ".edge e, " . $schema . ".node n ";
  $init_sql .= "WHERE e.child_node_id = n.node_id AND n.tree_id = ?";
my $initialize_paths =  $dbh->prepare("$init_sql"); 
 
my $path_sql = "INSERT INTO " . $schema . ".node_path (child_node_id, parent_node_id, distance)";
  $path_sql .= "SELECT e.child_node_id, p.parent_node_id, p.distance+1 ";
  $path_sql .= "FROM " . $schema . ".node_path p, " . $schema . ".edge e, " . $schema . ".node n ";
  $path_sql .= "WHERE p.child_node_id = e.parent_node_id ";
  $path_sql .= "AND n.node_id = e.child_node_id AND n.tree_id = ? ";
  $path_sql .= "AND p.distance = ?";
my $calc_paths =  $dbh->prepare("$path_sql");


# Different formats
my $tree_num = 0;
my $tree;		#Bio::Tree
my $tree_in;	#Bio::TreeIO
my $parent;		#Bio::Node
my $child;		#Bio::Node
my $i = 0;		#node counter
my $br_len_term_id;
my @row;

if ($format eq "newick" || $format eq "nexus" || $format eq "nhx" ||
	$format eq "lintree" || $format eq "treecluster") { 
	
	print "\nLoading treefile $infile...\n";
	
	# Phylogenetic formats
	
	if ($branchlength == 1) {
		$br_len_term_id = get_term_id($dbh, $driver, $branch_len_ont, $branch_len_term);
	}
	
	$tree_in = new Bio::TreeIO(-file   => "$infile",
					  -format => $format) ||
		die "Can not open $format format tree file:$infile\n";
	
	# Store trees in TreeIO
	&treeIO_store($dbh, $driver, $biodb_id, $schema, $tree_in, $br_len_term_id, $taxon_rank_ont);

} elsif ( $format eq "tabular" ) {

	#Table with columns for each taxomonic rank
	print "\nBuilding tree from table $taxontable...\n";
	$tree = &build_taxonomy_from_table ($rootlabel, $rootrank, $species_colname, $genus_colname,$family_colname, $order_colname);
	&tree_store($dbh, $driver, $biodb_id, $tree, $tree_name, $br_len_term_id, $taxon_rank_ont)
	}

$dbh->disconnect();
print "Finished!\n";
exit;

# End of program


#-----------------------------------------------------------+
# SUBFUNCTIONS                                              |
#-----------------------------------------------------------+


sub get_term_id {

	my $dbh = shift;
	my $driver = shift;
	my $ontology = shift;
	my $term = shift;

	#Get ontology_id
	my $ontology_id = &get_ontology_id($dbh, $driver,$ontology);

	# Get the id for any terms or insert a new term
	my $term_id;
	my $term_quoted = $dbh-> quote($term);
	my @term_row;

	my $statement = "SELECT term_id, name FROM biosql.term WHERE name = $term_quoted AND ontology_id = $ontology_id";
	my $sth = &prepare_sth($dbh,$statement);
	$sth->execute();

	if (@term_row = $sth->fetchrow_array) {
		$term_id = $term_row[0];
	} else {
		$statement = "INSERT INTO biosql.term (term_id, name, ontology_id) VALUES (DEFAULT, $term_quoted,$ontology_id)";
		$sth = &prepare_sth($dbh,$statement);
		$sth->execute();
		$dbh->commit();

		$term_id = &last_insert_id($dbh, "biosql.term" ,$driver);
	}
	return $term_id;
}


sub get_ontology_id {

	my $dbh = shift;
	my $driver = shift;
	my $ontology = shift;
	
	my $ontology_id;
	
	# Get the id of the ontology or insert a new ontology
	my @ont_row;
	my $ontology_quoted = $dbh-> quote($ontology);
	my $statement = "SELECT ontology_id FROM biosql.ontology WHERE name = $ontology_quoted";
	my $sth = &prepare_sth($dbh,$statement);
	$sth->execute();

	if (@ont_row = $sth->fetchrow_array) {
		$ontology_id = $ont_row[0];
	} else {
		$statement = "INSERT INTO biosql.ontology (ontology_id, name) VALUES (DEFAULT, $ontology_quoted)";
		$sth = &prepare_sth($dbh,$statement);
		$sth->execute();
		$dbh->commit();
		$ontology_id = &last_insert_id($dbh, "biosql.ontology", $driver);
	}
	return $ontology_id;
}


#-----------------------------+
# BIODATABASE                 |
#-----------------------------+

sub get_biodatabase_id {

	#If $biodb_row exists then get id, otherwise create new row and get id

	my $dbh = shift;
	my $driver = shift;
	my $biodb = shift;

	my $biodb_quoted = $dbh->quote($biodb);
	my @row;        # array to store database row

	$statement = "SELECT biodatabase_id, name FROM biosql.biodatabase WHERE name = $biodb_quoted";
	$sth = &prepare_sth($dbh,$statement);
	$sth->execute();
	if (@row = $sth->fetchrow_array) {
		$biodb_id = $row[0];
	} else {
		$statement = "INSERT INTO biosql.biodatabase (biodatabase_id, name) VALUES (DEFAULT, $biodb_quoted)";
		$sth = &prepare_sth($dbh,$statement);
		$sth->execute();
		$dbh->commit();
		$biodb_id = &last_insert_id($dbh,"biosql.biodatabase",$driver);
	}
	return $biodb_id;
}

sub build_taxonomy_from_table {

	my $rootlabel = shift;
	my $rootrank = shift;
	my $species_colname = shift;
	my $genus_colname = shift;
	my $family_colname = shift;
	my $order_colname = shift;
	
	my $tree;
	my $parent;
	my $child;
	my $i;
	my $nametotest;
	my $name;

	my @ranks;
	my @rankname;
	
	if ($order_colname) {
		push(@ranks, "$order_colname");
		push(@rankname, "order");
		}
	if ($family_colname) {
		push(@ranks, "$family_colname");
		push(@rankname, "family");
		}
	if ($genus_colname) {
		push(@ranks, "$genus_colname");
		push(@rankname, "genus");
		}
	if ($species_colname) {
		push(@ranks, "$species_colname");
		push(@rankname, "species");
		}	
	
	# Get columns from tables
		
	my $statement = "";
	my $first = 1;
	foreach my $rank (@ranks) {
		if ($first == 1) {
			$statement = $rank;
			$first = 0;
		} else {
			$statement = $statement . ", $rank";
		}
	}
		
	$statement = "SELECT $statement FROM $taxontable";
	my $sth = &prepare_sth($dbh,$statement);
	$sth->execute();
	
	my $addtaxon;
	my $value;
	
	if ($sth) {
		#Create Bio::tree and root node
		$parent = Bio::Tree::Node->new(-id => $rootlabel);
		$parent->add_tag_value("rank","$rootrank");
		$tree = Bio::Tree::Tree->new(-root => $parent);	
		$first = 1;
	} else {
		die "SELECT columns from $taxontable failed: $statement";
	}
	
	
	@row = $sth->fetchrow_array;
	#Add all of first row
	my $c = 1;
	$i = 0;
	print "Processing row $c : @row\n";
	foreach my $field (@ranks) {
		if ($rankname[$i] eq 'species') {
			$name = $row[$i - 1] . " " . $row[$i];
			} else {
			$name = $row[$i];
			}
		$child = Bio::Tree::Node->new(-id => $name);
		$child -> add_tag_value("rank","$rankname[$i]");
		$parent-> add_Descendent($child);
		$parent = $child;
		$i++;
	}
	
	while (@row = $sth->fetchrow_array) {
		$c++;
		print "Processing row $ c: @row\n";
		$i = 0;
		foreach my $field (@ranks) {
			#find parent
			if ($i == 0) {
				$parent = $tree->get_root_node();
			} else {
				my @nodes = $tree->find_node(-id => $row[$i - 1]);
				# If exists check rank
				foreach my $node (@nodes) {
					$value = $node->get_tag_values("rank");
					if ($value eq $rankname[$i - 1]) {
						$parent = $node;
					}
				}		
			}
			
			my $pid = $parent->id();
			my $ptag = $parent->get_tag_values('rank');
			#print "parent: $pid, $ptag\n";
			
			# Now look for a matching child
			$addtaxon = 1;
			my @nodes = $parent->each_Descendent;
			foreach my $node (@nodes) {
				my $cid = $node->id();
				$value = $node->get_tag_values("rank");
				#print "child $cid, $value was tested against $row[$i], $rankname[$i]\n";
				if ($value eq "species") {
					$nametotest = $row[$i] . " " . $row[$i - 1];
					} else {
					$nametotest = $row[$i];
					}
					
				if (($cid eq $nametotest) && ($value eq $rankname[$i])) {
					#print "MATCH!\n";
					$addtaxon = 0;
					}
				}
			# If not found add to parent
			if ($addtaxon == 1) {
				if ($rankname[$i] eq "species") {
					$name = $row[$i - 1] . " " . $row[$i];
					} else {
					$name = $row[$i];
					}
				$child = Bio::Tree::Node->new(-id => $name);
				$child -> add_tag_value("rank", $rankname[$i]);
				#print "Added: $row[$i], $rankname[$i]\n";
				$parent->add_Descendent($child);
			} else {
				#print "Ignored: $row[$i], $rankname[$i]\n";
			}
			$i++;
			#print "\n";
		}
	
	}
	return $tree;
}


sub treeIO_store {

	# Writes trees in bio::treeIO to database
	my $dbh = shift;
	my $driver = shift;
	my $biodb_id = shift;
	my $schema = shift;
	my $tree_in = shift;
	my $tree_name = shift;
	
	if (!defined $tree_name) {
		$tree_name = "a tree";
	}
	my $br_len_term_id = shift;
	my $taxon_rank_ont = shift;

	my $tree_num = 1;
	my $quoted;
	my $tcount = 0;
	
	# count trees
	# while( my $tree = $tree_in->next_tree) {
		# $tcount++;
	# }
	
	#print "TreeIO contains $tcount tree(s)\n";
	
	while( my $tree = $tree_in->next_tree) {
	
		print "Writing $tree_num of to database...\n";
		
		if ($tree_num != 1) {
			$quoted = $dbh->quote($tree_name . $tree_num);
			} else {
			$quoted = $dbh->quote($tree_name);
			}
			
		tree_store($dbh, $driver, $biodb_id, $schema, $tree, $tree_name, $br_len_term_id, $taxon_rank_ont, $schema);
		
		$tree_num++
	}
}


sub tree_store {

	# Writes bio::tree to database
	my $dbh = shift;
	my $driver = shift;
	my $biodb_id = shift;
	my $schema = shift;
	my $tree = shift;
	my $tree_name = shift;
	my $br_len_term_id = shift;
	my $taxon_rank_ont = shift;
	
	# Db schema phylodb is in
	my $schema = shift;
	my $quoted;
	my $statement;
	my $rc;
	
	if (!defined $tree_name) {
		$tree_name = "a tree";
	}
	
	print "\n";
	print "Storing tree $tree_name ...\n";
	print "\n";
	
	$quoted = $dbh->quote($tree_name);
	
	#Trees must have unique name and biodatabase_id combinations tree constraint tree_c1.
	$statement = "SELECT t.name, bd.biodatabase_id FROM " . $schema . ".tree t, biosql.biodatabase bd "; 
	$statement = $statement . "WHERE t.name = $quoted AND bd.biodatabase_id = $biodb_id";
	#print "statement: $statement";
	my $sth = &prepare_sth($dbh,$statement);
	$sth->execute();
	if (my @row = $sth->fetchrow_array) {
		die "Failed to insert tree as UNIQUE($tree_name, $biodb_id) already exists in the database";
	}
	
	print "Writing $tree_name to database...\n";
	
	#BEGIN WORK
	#$rc  = $dbh->begin_work   or die $dbh->errstr;
	
	# create a new tree record, specifying the tree's name and its root node
	$statement = "INSERT INTO " . $schema . ".tree (tree_id, name, is_rooted, node_id, biodatabase_id) VALUES (DEFAULT, $quoted, TRUE, 0, $biodb_id)";
	
	#print "$statement\n";
	$dbh->do( $statement );
	my $tree_id = &last_insert_id($dbh, $schema . ".tree", $driver);
	
	print "treeid = $tree_id\n";
	my $root = $tree->get_root_node;
	
	my $rootlabel = $dbh->quote($root->id());
	#print "root label = $rootlabel\n";
	
	# create a new node record, which will be the root of this tree
	$statement = "INSERT INTO " . $schema . ".node (node_id, label, tree_id) VALUES (DEFAULT,$rootlabel,$tree_id) ";
	$dbh->do( $statement );
	my $root_node_id = &last_insert_id($dbh, $schema . ".node", $driver);
	#print "root node db id = $root_node_id\n";
	
	# update the newly created node so that it knows what tree it belongs to
	$statement = "UPDATE " . $schema . ".tree SET node_id = $root_node_id WHERE tree_id = $tree_id ";
	$dbh->do( $statement );
	
	#Insert tree_root record
	$statement = "INSERT INTO " . $schema
		. ".tree_root (tree_root_id, tree_id, node_id, is_alternate) VALUES (DEFAULT,$tree_id, $root_node_id,TRUE) ";
	$dbh->do( $statement );
	
	$rc  = $dbh->commit     or die $dbh->errstr;
	#END WORK
	
	
	# depth-first traversal through each tree
	walktree($schema, $tree_id, $root, $root_node_id, $br_len_term_id, $taxon_rank_ont);

	# compute the transitive closure
	compute_tc($tree_id);
	$dbh->commit();
	
}


#-----------------------------+
# WALKTREE                    |
#-----------------------------+
# Derived from Importtrees (Bill Piel)
# Writes Bio::Tree to database
#

sub walktree {
	my $schema = shift;
	my $tree_id = shift;
	my $parent = shift;
	my $parent_id = shift;
	my $br_len_term_id = shift;
	my $taxon_rank_ont = shift;
	
	my $taxon_label;
	my $node;
	my $quoted;
	
	$setleft->execute($ctr++, $parent_id);
	
	my @desc_nodes = $parent->each_Descendent;
		
	foreach my $child (@desc_nodes) {
		
		# create a new child record
		if ($child->id) {
			my $taxon_label = $child->id;
			# Remove any enclosing single quotes
			my $qidx = index($taxon_label,"'");
			my $ridx = rindex($taxon_label,"'");
			my $strlen = length($taxon_label);
			if (($qidx eq 0) and ($ridx eq $strlen - 1)) {
				$taxon_label = substr($taxon_label,1,($ridx - 1));
			}
			#replace "_" with " "
			$taxon_label =~ tr/_/ /;
			
			$taxon_label = $dbh->quote($taxon_label);
			$statement = "INSERT INTO " . $schema . ".node (label, tree_id) VALUES ($taxon_label, $tree_id)";
			$dbh->do( $statement );
		} else {
			$statement = "INSERT INTO " . $schema . ".node (label, tree_id) VALUES (NULL, $tree_id)";
			$dbh->do( $statement );
		}
		
		my $child_id = &last_insert_id($dbh, $schema . ".node",$driver);
		
		my $trank;
		my $trankid;
		# If rank insert as node qualifier value
		if ($child->has_tag('rank')) {
			$trank = $child->get_tag_values('rank');
			#print "child rank = $trank, ont = $taxon_rank_ont\n";
			$trankid = &get_term_id($dbh, $driver, $taxon_rank_ont, $trank);
			#print "trank term_id = $trankid\n";
			$quoted = $dbh->quote($trank);
			$statement = "INSERT INTO " . $schema . ".node_qualifier_value (value, node_id, term_id) VALUES ($quoted, $child_id, $trankid)";
			#print "statement = $statement\n";
			$dbh->do( $statement );
			#print "statement do ok!\n";
		}
		
		# create an edge record between parent and child
		#my @values = ("$parent_id", "$child_id");
		$statement = "INSERT INTO " . $schema . ".edge (edge_id, parent_node_id, child_node_id) VALUES (DEFAULT, $parent_id, $child_id) ";
		$dbh->do( $statement );
		my $edge_id = &last_insert_id($dbh, $schema . ".edge",$driver);
		
		# If edge_qualifier
		if (defined($br_len_term_id)) {
		
			#Insert edge_qualifier_value
			my $branch_length = 0;
			$branch_length = $child->branch_length if ($child->branch_length);
			
			my $edge_support = 0;
			$edge_support = $child->bootstrap if ($child->bootstrap);
			
			# create edge_qualifier_value to store distance
			$statement = "INSERT INTO " . $schema . ".edge_qualifier_value (value, edge_id, term_id) VALUES ($branch_length,$edge_id,$br_len_term_id)";
			$dbh->do( $statement );
		
		}
		
		walktree($schema, $tree_id, $child, $child_id, $br_len_term_id, $taxon_rank_ont);
	}
	
	$setright->execute($ctr++, $parent_id);
}

# Remove nexus tokenization
#==============================================================
sub detokenize {
	my $token = shift;
	
	$token =~ s/_/ /g;
	$token =~ s/^'//g;
	$token =~ s/'$//g;
	$token =~ s/''/'/g;
	
	return($token);
}

# Compute the transitive closure
#==============================================================
sub compute_tc {
   my $tree_id = shift;

   $deletepaths->execute($tree_id);
   $initialize_paths->execute($tree_id);

   my $dist = 1;
   my $rv = 1;
   while ($rv > 0) {
        $rv = $calc_paths->execute($tree_id, $dist);
        $dist++;
   }
}

# From Phyloimport 

sub end_work {
# Copied from load_itis_taxonomy.pl

    my ($dbh, $commit) = @_;

    # skip if $dbh not set up yet, or isn't an open connection
    return unless $dbh && $dbh->{Active};
    # end the transaction
    my $rv = $commit ? $dbh->commit() : $dbh->rollback();
    if(!$rv) {
	print STDERR ($commit ? "commit " : "rollback ").
	    "failed: ".$dbh->errstr;
    }
    $dbh->disconnect() unless defined($commit);

}

sub in_format_check {
    # This will try to make sense of the format string
    # that is being passed at the command line
    my ($In) = @_;  # Format string coming into the subfunction
    my $Out;         # Format string returned from the subfunction

    # NEXUS FORMAT
    if ( ($In eq "nexus") || ($In eq "NEXUS") ||
	 ($In eq "nex") || ($In eq "NEX") ) {
	return "nexus";
    };

    # NEWICK FORMAT
    if ( ($In eq "newick") || ($In eq "NEWICK") ||
	 ($In eq "new") || ($In eq "NEW") ) {
	return "newick";
    };

    # NEW HAMPSHIRE EXTENDED
    if ( ($In eq "nhx") || ($In eq "NHX") ) {
	return "nhx";
    };

    # LINTREE FORMAT
    if ( ($In eq "lintree") || ($In eq "LINTREE") ) {
	return "lintree";
	};
	
	# TABULAR 
	# Columns for each tree/taxonomy level.
    if ( ($In eq "tabular") || ($In eq "TABULAR") ) {
	return "tabular";	
    };

    die "Can not intrepret file format:$In\n";

}

sub connect_to_db {
    my ($cstr) = @_;
    return connect_to_mysql(@_) if $cstr =~ /:mysql:/i;
    return connect_to_pg(@_) if $cstr =~ /:pgPP:/i;
    die "can't understand driver in connection string: $cstr\n";
}

sub connect_to_pg {

	my ($cstr, $user, $pass) = @_;

	my $dbh = DBI->connect($cstr, $user, $pass,
                               {PrintError => 0,
                                RaiseError => 1,
                                AutoCommit => 0});
	$dbh || &error("DBI connect failed : ",$dbh->errstr);

	return($dbh);
} # End of ConnectToPG subfunction


sub connect_to_mysql {

    my ($cstr, $user, $pass) = @_;

    my $dbh = DBI->connect($cstr,
			   $user,
			   $pass,
			   {PrintError => 0,
			    RaiseError => 1,
			    AutoCommit => 0});

    $dbh || &error("DBI connect failed : ",$dbh->errstr);

    return($dbh);
}

sub prepare_sth {
    my $dbh = shift;
#    my ($dbh) = @_;
    my $sth = $dbh->prepare(@_);
    die "failed to prepare statement '$_[0]': ".$dbh->errstr."\n" unless $sth;
    return $sth;
}

sub execute_sth {

    # I would like to return the statement string here to figure
    # out where problems are.

    # Takes a statement handle
    my $sth = shift;

    my $rv = $sth->execute(@_);
    unless ($rv) {
	$dbh->disconnect();
	die "failed to execute statement: ".$sth->errstr."\n"
    }
    return $rv;
} # End of execute_sth subfunction

sub last_insert_id {

    #my ($dbh,$table_name,$driver) = @_;

    # The use of last_insert_id assumes that the no one
    # is interleaving nodes while you are working with the db
    my $dbh = shift;
    my $table_name = shift;
    my $driver = shift;

    # The following replace by sending driver info to the sufunction
    #my $driver = $dbh->get_info(SQL_DBMS_NAME);
    if (lc($driver) eq 'mysql') {
	return $dbh->{'mysql_insertid'};
    }
    elsif ((lc($driver) eq 'pg') || ($driver eq 'PostgreSQL')|| ($driver eq 'PgPP')) {
	my $sql = "SELECT currval('${table_name}_pk_seq')";
	my $stmt = $dbh->prepare_cached($sql);
	my $rv = $stmt->execute;
	die "failed to retrieve last ID generated\n" unless $rv;
	my $row = $stmt->fetchrow_arrayref;
	$stmt->finish;
	return $row->[0];
    }
    else {
	die "don't know what to do with driver $driver\n";
    }
} # End of last_insert_id subfunction

# The following pulled directly from the DBI module
# this is an attempt to see if I can get the DSNs to parse
# for some reason, this is returning the driver information in the
# place of scheme
sub parse_dsn {
    my ($dsn) = @_;
    $dsn =~ s/^(dbi):(\w*?)(?:\((.*?)\))?://i or return;
    my ($scheme, $driver, $attr, $attr_hash) = (lc($1), $2, $3);
    $driver ||= $ENV{DBI_DRIVER} || '';
    $attr_hash = { split /\s*=>?\s*|\s*,\s*/, $attr, -1 } if $attr;
    return ($scheme, $driver, $attr, $attr_hash, $dsn);
}

sub print_help {

    # Print requested help or exit.
    # Options are to just print the full
    my ($opt) = @_;

    my $usage = "USAGE:\n".
	"  phyopt.pl -i infile --dsn DSNString";
    my $args = "REQUIRED ARGUMENTS:\n".
	"  --infile       # File to import to the database.\n".
	"  --dsn          # DSN string for connecting to db\n".
	"\n".
	"OPTIONS:\n".
	"  --dbname       # Name of the database to connect to\n".
	"  --host         # Database host\n".
	"  --driver       # Driver for connecting to the database\n".
	"  --dbuser       # Name to log on to the database with\n".
	"  --dbpass       # Password to log on to the database with\n".
	"  --tree         # Name of the tree to import\n".
	"BOOLEANS:\n".
	"  --version      # Show the program version\n".
	"  --usage        # Show program usage\n".
	"  --help         # Show this help message\n".
	"  --man          # View the full program manual\n".
	"  --verbose      # Run the program with maximum output\n".
	"  --quiet        # Run program with minimal output\n";

    if ($opt =~ "full") {
	print "\n$usage\n\n";
	print "$args\n\n";
    }
    else {
	print "\n$usage\n\n";
    }

    exit;
}


=head1 NAME

phyimport.pl - Import phylogenetic trees from common file formats

=head1 VERSION

This documentation refers to phyimport version 1.0.

=head1 SYNOPSIS

  USAGE: phyimport.pl -d 'DBI:mysql:database=biosql;host=localhost'
                      -u UserName -p dbPass -i InFilePath -f InFileFormat

    REQUIRED ARGUMENTS:
        --dsn        # The DSN string for the DB connection
        --dbuser     # User name to connect with
        --dbpass     # User password to connect with
        --infile     # Full path to the tree file to import to the db
        --format     # "newick", "nexus" (default "newick")
    ALTERNATIVE TO --dsn:
        --driver     # DB Driver "mysql", "Pg", "Oracle"
        --dbname     # Name of database to use
        --host       # Host to connect with (ie. localhost)
    ADDITIONAL OPTIONS:
        --tree       # Tree name to use
        --quiet      # Run the program in quiet mode.
	--verbose    # Run the program in verbose mode.
    ADDITIONAL INFORMATION:
        --version    # Show the program version
	--usage      # Show program usage
        --help       # Print short help message
	--man        # Open full program manual

=head1 DESCRIPTION

Import tree files files from text common text files into the PhyloDB.

=head1 COMMAND LINE ARGUMENTS

=head2 Required Arguments

=over

=item -d, --dsn

The DSN of the database to connect to; default is the value in the
environment variable DBI_DSN. If DBI_DSN has not been defined and
the string is not passed to the command line, the dsn will be
constructed from --driver, --dbname, --host

DSN must be in the form:

DBI:mysql:database=biosql;host=localhost

=item -u, --dbuser

The user name to connect with; default is the value in the environment
variable DBI_USER.

This user must have permission to create databases.

=item -p, --dbpass

The password to connect with; default is the value in the environment
variable DBI_PASSWORD. If this is not provided at the command line
the user is prompted.

=item -i, --infile

Path to the infile to import to the database

=item -f, --format

Format of the input file. Accepted file format options are:

nexus (C<-f nex>) - L<http://www.bioperl.org/wiki/NEXUS_tree_format>

newick (C<-f newick>) - L<http://www.bioperl.org/wiki/Newick_tree_format>

nhx (C<-f nhx>) - L<http://www.bioperl.org/wiki/New_Hampshire_extended_tree_format>

lintree (C<-f lintree>) -L<http://www.bioperl.org/wiki/Lintree_tree_format>

=back

=head2 Alternative to --dsn

An alternative to passing the full dsn at the command line is to
provide the components separately.

=over 2

=item --host

The database host to connect to; default is localhost.

=item --dbname

The database name to connect to; default is biosql.

=item --driver

The database driver to connect with; default is mysql.
Options other then mysql are currently not supported.

=back

=head2 Additional Options

=over 2

=item --tree

The name of the tree that will be imported.

=item -q, --quiet

Run the program in quiet mode. No output will be printed to STDOUT
and the user will not be prompted for intput. B<CURRENTLY NOT IMPLEMENTED.>

=item --verbose

Execute the program in verbose mode.

=back

=head2 Additional Information

=over 2

=item --version

Show the program version.

=item --usage

Show program usage statement.

=item --help

Show a short help message.

=item --man

Show the full program manual.

=back

=head1 EXAMPLES

B<Import single tree nexus format>

The following example would import the tree stored as MyTree.nex with
the name BigTree.

    phyimport -d 'DBI:mysql:database=biosql;host=localhost'
              -u name -p password -t BigTree -i MyTree.nex
              -f nex

=head1 DIAGNOSTICS

The error messages below are followed by descriptions of the error
and possible solutions.

=head1 CONFIGURATION AND ENVIRONMENT

Many of the options passed at the command line can be set as
options in the user's environment.

=over 2

=item DBI_USER

User name to connect to the database.

=item DBI_PASSWORD

Password for the database connection

=item DBI_DSN

DSN for database connection.

=back

For example in the bash shell this would be done be editing your .bashrc file
to contain:

    export DBI_USER=yourname
    export DBI_PASS=yourpassword
    export DBI_DSN='DBI:mysql:database=biosql;host-localhost'

When these are present in the environment, you can initialize a database
with the above variables by simply typing phyinit.pl at the command line.

=head1 DEPENDENCIES

The phyimport.pl program is dependent on the following PERL modules:

=over 2

=item DBI - L<http://dbi.perl.org>

The PERL Database Interface (DBI) module allows for connections
to multiple databases.

=item DBD:MySQL -
L<http://search.cpan.org/~capttofu/DBD-mysql-4.005/lib/DBD/mysql.pm>

MySQL database driver for DBI module.

=item DBD:Pg -
L<http://search.cpan.org/~rudy/DBD-Pg-1.32/Pg.pm>

PostgreSQL database driver for the DBI module.

=item Getopt::Long - L<http://perldoc.perl.org/Getopt/Long.html>

The Getopt module allows for the passing of command line options
to perl scripts.

=item Bio::Tree - L<http://www.bioperl.org>

The Bio::Tree module is part of the bioperl package.

=back

A RDBMS is also required. This can be one of:

=over 2

=item MySQL - L<http://www.mysql.com>

=item PostgreSQL - L<http://www.postgresql.org>

=back

=head1 BUGS AND LIMITATIONS

Known limitations:

=over 2

=item *
Currently only stable with the MySQL Database driver.

=item *
DSN string must currently be in the form:
DBI:mysql:database=biosql;host=localhost

=back

Please report additional problems to
James Estill E<lt>JamesEstill at gmail.comE<gt>

=head1 SEE ALSO

The program phyinit.pl is a component of a package of comand line programs
for PhyloDB management. Additional programs include:

=over

=item phyinit.pl

Initialize a PhyloDB database.

=item phyexport.pl

Export tree data in PhyloDB to common file formats.

=item phyopt.pl

Compute optimization values for a PhyloDB database.

=item phyqry.pl

Return a standard report of information for a given tree.

=item phymod.pl

Modify an existing phylogenetic database by deleting, adding or
copying branches.

=back

=head1 LICENSE

This file is part of BioSQL.

BioSQL is free software: you can redistribute it and/or modify it
under the terms of the GNU Lesser General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

BioSQL is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with BioSQL. If not, see <http://www.gnu.org/licenses/>.

=head1 AUTHORS

James C. Estill E<lt>JamesEstill at gmail.comE<gt>

Hilmar Lapp E<lt>hlapp at gmx.netE<gt>

William Piel E<lt>william.piel at yale.eduE<gt>

=head1 HISTORY

Started: 05/30/2007

Updated: 08/17/2007

=cut
