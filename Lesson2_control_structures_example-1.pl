#!/usr/bin/perl -w
# 2013-06-13 Bradley Olson
# Kansas State University
# Summer Perl Course
#
# Examples if control structure

use strict;

my $gene_name = 'p53';

if ($gene_name eq 'p53') #If this is an oncogene
{
	print "$gene_name is an oncogene\n";
}
elsif ($gene_name eq '')
{
	print "$gene_name does not have a name\n";
}
else
{
	print "$gene_name is not a known oncogene\n";
}
