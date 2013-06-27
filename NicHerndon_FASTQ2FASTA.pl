#!/usr/bin/perl

use warnings;
use strict;

open FASTQ, '<', "SRR014849_1.fastq" or die "Can't open the FASTQ file";

while(<FASTQ>) {
  if(/^@/) {
    s/@/>/;				# replace @ with > in $_
    my @fields = split;			# split $_ on whitespace
    print $fields[0], "\n";		# print the sequence ID

    my $seq = <FASTQ>;			# get the next line from input file
    print "$seq\n";			# and print it out with a blank line after it
  }
}

close FASTQ;
