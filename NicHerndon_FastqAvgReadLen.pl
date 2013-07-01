#!/usr/bin/perl

use warnings;
use strict;

if(@ARGV < 1) {
  die "Not enough arguments\n";
}

open FASTQ, '<', $ARGV[0] or die "Can't open the FASTQ file: $!";

my $sum = 0; my $i = 0;

while(<FASTQ>) {
  if (/^[ACGT]/ && /[ACGTN]*/ && /[ACGT]$/) {		# sequence begins and ends with A, C, G, or T
							# and contains any combination of A, C, G, T, or N
    chomp;						# remove end of line(s)
    $sum += length($_);					# add the length of this sequence to the running sum
    $i++;						# increment the number sequences
  }
}

close FASTQ;

printf("Average read length: %.2f\n", $sum / $i);	# display the result with 2 decimals
