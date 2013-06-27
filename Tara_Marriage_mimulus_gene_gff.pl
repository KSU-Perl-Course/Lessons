#!/usr/bin/perl -w
#2013-06-27 Tara Marriage
#Kansas State University
#Summer Perl Course
#Mimulus gff GENES ONLY

use strict;

#file to be processed, mimulus gff3 file
my $infile=$ARGV[0];

#open file for reading only	
open (INFILE, "<$infile");

#process each line of the file until the end of the file is reached
while (<INFILE>)
{

	#convert file to tab delimited file
	my @line = split ("\t", $_);
	
	#if the third column entry is gene, print out the gene and it's length
	#I also kept the scaffold because just having the gene and it's length isn't very informative
	if ($line[2] eq "gene")
	{
		print "$line[0]\t";
		print "$line[2]\t";
		print "$line[3]\t";
		print "$line[4]\n";
		
	}
}
	