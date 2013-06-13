#!/usr/bin/perl -w
# 2013-06-13 Bradley Olson
# Kansas State University
# Summer Perl Course
#
# Examples if control structure

<<<<<<< HEAD
use strict;

#SANDRA WAS WRONG HERE DO THIS INSTEAD

my $gene_name = 'p53';
=======
>>>>>>> 5f45657659993ad31105f9f5d53b56d5627dbb3e

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
