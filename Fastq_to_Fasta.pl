#!/usr/bin/perl

use strict;
use warnings;
# usage: Fasta_to_Fastq.pl [fasta_file] [fastq_file]
#initialized value of $i and declare variables
my $infile=$ARGV[0];
my $outfile=$ARGV[1];
my $i=0;
my($identifier, $description);

#Open the file for over-writing, use the filehandle OLDFASTA
open (NEWFASTA, ">$outfile");

#Open the file for reading only, use the filehandle NEWFASTA
open(OLDFASTA, "<$infile");

#Process the in file via its file handle IN
while(<OLDFASTA>)

{
    if($i==0) #loop for headers
        {
            s/^@/>/; #find and replace '@'
            ($identifier, $description)=split(' '); #split fasta header into two variables
            print NEWFASTA "$identifier\n"; #print '>' and identifier
        }
    #would be better if line 29 read elsif and then the rest of this loop
    if($i==1) #loop for sequence
        {
            print NEWFASTA; #print sequence
            $i=-3; #make $i -2 to skip printing '+' and quality scores
        }
    $i++;
}
