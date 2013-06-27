#!/usr/bin/perl

use warnings;
use strict;

if(@ARGV < 1) {
  die "Not enough arguments\n";
}

open GFF3, '<', $ARGV[0] or die "Can't open the GFF3 file";

# initialize count variables
my $c_gene = 0; my $c_exon = 0; my $c_utr3 = 0; my $c_utr5 = 0;
# initialize length variables
my $l_gene = 0; my $l_exon = 0; my $l_utr3 = 0; my $l_utr5 = 0;

while(<GFF3>) {
  unless(/^##/) {
    chomp;
    my @fields = split("\t", $_);
    if($fields[2] eq "gene") {
      gene(@fields);
    }
    elsif($fields[2] eq "CDS") {
      $c_exon++;
      $l_exon += $fields[4] - $fields[3];
    }
    elsif($fields[2] eq "three_prime_UTR") {
      $c_utr3++;
      $l_utr3 += $fields[4] - $fields[3];
    }
    elsif($fields[2] eq "five_prime_UTR") {
      $c_utr5++;
      $l_utr5 += $fields[4] - $fields[3];
    }
  }
}

close GFF3;

print "\nAvg gene size:\t", $l_gene / $c_gene, "\n";
print "Avg exon size:\t", $l_exon / $c_exon, "\n";
print "Avg 3'UTR size:\t", $l_utr3 / $c_utr3, "\n";
print "Avg 5'UTR size:\t", $l_utr5 / $c_utr5, "\n";

sub gene {
  $c_gene++;					# increment the gene count
  my $gene_len = $_[4] - $_[3];			# get the length of the gene
  $l_gene += $gene_len;				# add the length of this gene to the running total
  my @gene = split(/=/, $_[8]);			# split the last field on =
  print "gene: $gene[2]\tlength: $gene_len\n";	# print the gene and its length
}
