#!/usr/bin/perl

#use strict; # I turned this off so that I could write my subroutines only once
use warnings;
use List::Util qw(sum);
# usage: gff_to_name_and_length.pl [gff3_file] [name_and_length_output.txt] [averages_output.txt]
# initialized value of $i and declare variables
my $infile=$ARGV[0];
my $outfile=$ARGV[1];
my $outfile2=$ARGV[2];
my $i=0;
my (@columns,@attributes,@name);

# Open the file for over-writing, use the filehandle NAMELENGTH
open(NAMELENGTH, ">$outfile");

# Open the file for over-writing, use the filehandle AVERAGE
open(AVER, ">$outfile2");

# Open the file for reading only, use the filehandle GFF
open(GFF, "<$infile");
# Subroutines
sub lengths # get length of feature if the parameter used when lengths was called matches $columns[2]
{
    if ("$columns[2]" eq "$_[0]")
    {
       push (@{$_[0]."length"},($columns[4]-$columns[3]));
    }
}
sub aves # print averages of feature length if the parameter used when aves was called matches the array name (e.g. @genelength)
{
    print AVER "$_[0] = ".((sum(@{$_[0]."length"}))/(scalar(@{$_[0]."length"})))."\n";
    
}

#reading from file while loop
while(<GFF>)
{
    if ($i != 0) # this loop finds and prints name and length for rows where $columns[2] matches 'gene'
    {
        @columns=split('\t');
        if ("$columns[2]" eq 'gene')
        {
            chomp(@attributes=split(';',$columns[8])); # I chomped here because this is the only line with a \n 
            @name=split('Name=',$attributes[1]); # this breaks appart 'Name=' from the name
            print NAMELENGTH "$name[1]\t".($columns[4]-$columns[3])."\n";
            lengths('gene'); # calls the length subroutine for rows where $columns[2] matches 'gene'
        }
        else # calls the length subroutine for rows where $columns[2] don't matche 'gene'
        {
            lengths('mRNA');
            lengths('CDS');
            lengths('five_prime_UTR');
            lengths('three_prime_UTR');
        }
    }
    elsif ($i == 0) # skips the first line and makes $i=1 after the first loop
    {
            $i++;
    }
}
# printing averages for rows where $columns[2] don't matche 'gene'
aves('gene');
aves('mRNA');
aves('CDS');
aves('five_prime_UTR');
aves('three_prime_UTR');
