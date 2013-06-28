#!/usr/bin/perl
#
# Bradley Olson
# Kansas State University
#
# This is a demo script that prints out interesting things from a GFF3 file

use warnings;
use strict;


#Read a GFF3 file in for parsing
my $gffin=$ARGV[0];

#Open file for reading
open(GFF3, "<$gffin");


my (@gene_len, @exon_len, @three_utr_len, @five_utr_len); #Place to store data
while(<GFF3>)
{
	chomp;
	unless ($_=~/^#/) #Ignore comment lines
	{
		#split the line into individual values
		my @line=split("\t", $_);
		if ($line[2] eq 'gene') #position 2 in the array contains the element type, if a gene, process the line
		{	my $len=$line[4]-$line[3]; #Columns 4 and 3 have the stop and start respectively, subtract to get length
			print "Gene length is $len\n";
			push(@gene_len, $len);
		}
		elsif ($line[2] eq 'CDS')
		{
			my $len=$line[4]-$line[3];
			print "CDS is $len\n";
			push(@exon_len, $len);
		}
		elsif ($line[2] eq 'three_prime_UTR') #If this is a 3UTR element
		{
			my $len=$line[4]-$line[3];
			print "3-UTR is $len\n";
			push(@three_utr_len, $len);
		}
		elsif ($line[2] eq 'five_prime_UTR') #If this is a 5UTR element
		{
			my $len=$line[4]-$line[3];
			print "5UTR is $len\n";
			push(@five_utr_len, $len);
		}
	
	}
}
close GFF3;

#Now print the averages by calling a subroutine to calculate the average gene length
my $g_len=&average_len(@gene_len);
print "The average gene length in $gffin is $g_len\n";

my $ex_len=&average_len(@exon_len);
print "The average exon length in $gffin is $ex_len\n";

my $t_utr_len=&average_len(@three_utr_len);
print "The average 3UTR length in $gffin is $t_utr_len\n";

my $f_utr_len=&average_len(@five_utr_len);
print "The average 5UTR length in $gffin is $f_utr_len\n";


#sub routine takes an array as an argument and returns the average
sub average_len
{
	my $i=0;
	my $rolling=0;
	foreach my $ele (@_)
	{
		$rolling+=$ele;
		$i++;
	}
	my $average=$rolling / $i;
	return $average;
}
	
