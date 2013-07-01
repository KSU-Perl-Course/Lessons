#!/usr/bin/perl

use warnings;
use strict;

if(@ARGV < 5) {
  die "Not enough arguments\n";
}

open FASTQ, '<', $ARGV[0] or die "Can't open the FASTQ file: $!";

my $minLen = $ARGV[1];			# the expected 2nd argument is the minimum lenght of the read
my $maxLen = $ARGV[2];			# the expected 3rd argument is the maximum length of the read
my $seqID;

open GOOD, '>', $ARGV[3] or die "Can't open the GOOD file: $!";
open BAD, '>', $ARGV[4] or die "Can't open the BAD file: $!";

while(<FASTQ>) {
  if(s/^\@SRR/>SRR/) {			# if $_ starts with @SRR replace it with >SRR and execute the block
					# since each identifier starts with SRR, this prevents matching
					# quality scores that start with @, e.g., "@;&<3A9;<76EA0"
					# `tail SRR014849_1.fastq`
    $seqID = $_;			# assign the sequence identifier to $seqID
  }
  elsif (/^[ACGTN]+$/) {	# sequence contains any combination of only A, C, G, T, or N
    if(/^N/				# the sequence starts with N, or
    || /N$/				# the sequence ends with N, or
    || /A{10,}/				# the sequence has 10 or more consecutive As, or
    || /C{10,}/				# the sequence has 10 or more consecutive Cs, or
    || /G{10,}/				# the sequence has 10 or more consecutive Gs, or
    || /T{10,}/				# the sequence has 10 or more consecutive Ts, or
    || $minLen > length($_) - 1		# the sequence is too short, or
    || $maxLen < length($_) - 1) {	# the sequence is too long
      print BAD "$seqID$_\n";		# print the sequence identifier, the sequence, and a blank line
    }
    else {
      print GOOD "$seqID$_\n";		# print the sequence identifier, the sequence, and a blank line
    }
  }
}

close FASTQ;
close GOOD;
close BAD;
