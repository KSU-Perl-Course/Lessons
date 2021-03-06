#!/usr/bin/perl
#
# Bradley Olson
# Kansas State University
# 2013 Summer Perl Course
# Example of how to convert FASTQ to FASTA using LP Chapters 1-3
#

use warnings;
use strict;

my $fastq_in=$ARGV[0]; #Read a fastq file name in give as the first command line argument

my $i=0; #Iterator to keep track of where we are at in interleaved fastq entries
open(FASTQ, "<$fastq_in");
while(<FASTQ>)
{
	chomp; #remove newlines
	if ($i==0) #Must be first of the sequence
	{	
		#Testing if this is a seqid, we are testing if we can substitute a @ for a > to make it fasta compliant without further work
		if ($_=~s/^\@/>/) #A fastq id line starts with '@', however, quality lines can also start with '@'!, 
		{
			#We are going to parse the seqid to only print the seqid, and not the extra information on the line
			my @seqid=split(' ', $_);
			print "$seqid[0]\n"; #Print the seqid, note we substitute > for @, so we can directly print the seqid, the seqid we care about is element 0 of the split array
			#We could use $i++;, however, we are going to explicitly force this to look for $i==1 next, the sequence next
			$i=1;
		}
	}
	elsif ($i==1) #Must be second line of sequence, it will be the sequence itself
	{
		if ($_=~/^[ATCG]+$/i) #test that it is indeed the sequence, note case insensitive!
		{
			print "$_\n"; #Print the sequence
			#We could use $i++;, however, we are going to explicitly force this to look for $i==2 next, the '+' line
			$i=2;
		}
	}
	elsif ($i==2) #If this is line 3, the '+' line
	{
		if ($_=~/^\+$/) #Make sure the only thing on this line is a +
		{
			#Do nothing but change the iterator 
			$i=3; #see arguments above about forcing tests
		}
	}
	elsif ($i==3) #Is this the 4th line, the quality line, note we are not doing character class tests here!
	{
		#Do nothing but change the iterator
		$i=0; #Reset the iterator to look for an ^@ seqid next
	}
	elsif ($i>3) #If things go wrong, send an error and CONTINUE, reset the iterator to restart looking for @
	{
		print STDERR "Something in the file is messed up\n";
		$i=0;
	}
	else #If things go wrong, send an error and CONTINUE, reset the iterator to restart looking for @
	{
		print STDERR "Something in the file is messed up\n";
	}
	

}
clost FASTQ; #Cleanup