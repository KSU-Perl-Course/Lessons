#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw(sum);
# usage: fastq_check.pl [fastq_file] [fastq_output_good] [fastq_output_bad]
#initialized value of $i and $sequence_count; declare variables
my $infile=$ARGV[0];
my $outfile=$ARGV[1];
my $outfile2=$ARGV[2];
my $i=0;
my $sequence_count=0;
my($header,$sequence,$qual,$qual_head,$length_sum,$ave_length,$good_seq);

#Open the file for reading only, use the filehandle OLDFASTQ
open(OLDFASTQ, "<$infile");
#Open the file for over-writing, use the filehandle GOODFASTQ
open (GOODFASTQ, ">$outfile");
#Open the file for over-writing, use the filehandle BADFASTQ
open (BADFASTQ, ">$outfile2");

sub clean #subroutine called with clean with $header= $_[0], $sequence= $_[1], $qual_head= $_[2], $qual= $_[3]
{
    my @score = split(//,$_[3]); #split $qual into array
    @score = map (ord,@score);   #convert charaters into numeric values
    my $mean_score = (sum(@score)/scalar(@score))-33; #calculate mean PHRED
    if ((length($_[1]))!= (length($_[3]))) #compare length of $sequence and $qual
    {
        print "Error length of sequence $_[0] does not match length of quality scores\n";
        return 0;
    }
    elsif (length($_[1]) < 20) #check against minimum length
    {
        print "Sequence $_[0] is too short.\n";
        return 0;
    }
    elsif ($_[1] =~ /A{6}|C{6}|T{6}|G{6}/) #check for homopolymers
    {
        print "Sequence $_[0] has a homopolymer.\n";
        return 0;
    }
    elsif ($_[1] =~ /^[ACTGN][ACTG]*N/) #check for Ns
    {
        print "Sequence $_[0] has a N.\n"; 
        return 0;
    }
    elsif ($mean_score < 20 ) #check against minimum mean $qual score 
    {
        print "Sequence $_[0] is low quality.\n";
        return 0;
    }
    else
    {
        return 1;
    }
}
sub print_good #print passing sequences to GOODFASTQ
{
    print GOODFASTQ map ("$_\n", @_);
}
sub print_bad #print passing sequences to BADFASTQ
{
    print BADFASTQ map ("$_\n", @_);
}
#Process the infile via its file handle OLDFASTQ. Loops through file four times and checks quality, updates GOODFASTQ or BADFASTQ and updates the count and summed length of the good sequences.
while(<OLDFASTQ>)

{
    chomp;
    if($i==0&&/^@/) #loop for headers
    {
        $header=$_;
    }
    if($i==1) #loop for sequence
    {
        $sequence=$_;
    }
    if($i==2) #loop for header (qual)
    {
        $qual_head=$_;
    }    
    if($i==3) #loop for quality cleaning. Loop calls &clean, &print_good, &print_bad with $header= $_[0], $sequence= $_[1], $qual_head= $_[2], $qual= $_[3]
    {
        $qual=$_;        
        $good_seq = &clean ($header, $sequence, $qual_head, $qual);
        if  ($good_seq)
        {
            $length_sum += length($qual);
            $sequence_count++;
            &print_good ($header, $sequence, $qual_head, $qual);            
        }
        else
        {
            &print_bad ($header, $sequence, $qual_head, $qual);
        }
        $i=-1; #make $i -1 to reset loop
     }
    $i++;
}

$ave_length=$length_sum / $sequence_count;
print "Number of good sequences is $sequence_count.\n"; 
print "Average length is $ave_length bp.\n";

#

