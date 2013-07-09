#!/usr/bin/perl
#2013-07-08 Tara Marriage
#Kansas State University
#Summer Perl Course
#determining the average length of each read in the SRR014849_1.fastq file

use strict;
use warnings;

my $infile=$ARGV[0];

open (INFILE, "<$infile");

#ideally, would want to remove any reads that have N's in them, and not include these reads in the average
#removal of unwanted reads in subroutine, save wanted and unwanted reads in their own arrays

#call to subroutine that calculates average length of sequence reads
&Average($infile);


sub Average #subroutine that calculates the average length of the sequence reads
{
	my $i=0; 
	my $sum =0; 
	my $avg=0;
	
	while (<INFILE>) {
		if (/^[ACGT]/ && /[ACGTN]*/ && /[ACGT]$/) {
		chomp;
		$sum += length($_);
		$i++;
		}
	}
	$avg=$sum/$i;
	print "The average length of the sequence read is $avg\n";
}



	
	