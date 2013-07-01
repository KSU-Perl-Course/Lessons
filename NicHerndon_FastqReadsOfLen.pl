#!/usr/bin/perl

use warnings;
use strict;

if(@ARGV < 2) {
  die "Not enough arguments\n";
}

open FASTQ, '<', $ARGV[0] or die "Can't open the FASTQ file: $!";

my $len = $ARGV[1];			# the expected 2nd argument is the lenght of the read
my $seqID;

while(<FASTQ>) {
  if(s/^\@SRR/>SRR/) {			# if $_ starts with @SRR replace it with >SRR and execute the block
					# since each identifier starts with SRR, this prevents matching
					# quality scores that start with @, e.g., "@;&<3A9;<76EA0"
					# `tail SRR014849_1.fastq`
    $seqID = $_;			# assign the sequence identifier to $seqID
  }
  elsif (/^[ACGT]/ && /[ACGTN]*/ && /[ACGT]$/) {	# sequence begins and ends with A, C, G, or T
							# and contains any combination of A, C, G, T, or N
    if($len == length($_) - 1) {
      print "$seqID$_\n";		# print the sequence identifier, the sequence, and a blank line
    }
  }
}

close FASTQ;
