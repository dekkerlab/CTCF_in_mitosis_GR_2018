#!/usr/bin/perl -w
use English;
use warnings;
use strict;

sub outputWrapper($;$) {
    # required
    my $outputFile=shift;
    # optional
    my $outputCompressed=0;
    $outputCompressed=shift if @_;
               
    $outputCompressed = 1 if($outputFile =~ /\.gz$/);
    $outputFile .= ".gz" if(($outputFile !~ /\.gz$/) and ($outputCompressed == 1));
    $outputFile = "| gzip -c > '".$outputFile."'" if(($outputFile =~ /\.gz$/) and ($outputCompressed == 1));
    $outputFile = ">".$outputFile if($outputCompressed == 0);
               
    return($outputFile);
}
 
sub inputWrapper($) {
     my $inputFile=shift;
               
     $inputFile = "samtools view -Sh '".$inputFile."' | " if(($inputFile =~ /\.bam$/) and (!(-T($inputFile))));
               
     return($inputFile);
}

print "hi - start of the program\n";
print "\n";


# get the input file
my $samFile=$ARGV[0];

print "samFile = $samFile\n";

open(IN,inputWrapper($samFile)) or die "cannot open < $samFile - $!";


open(OUT,outputWrapper($samFile.'.single_end.4_5.bed.gz')) or die "Could not open file $!";;


my $lineNum=0;


while(my $line = <IN>) { 
	chomp($line);
	
	# skip if the line starts with a @ symbol
	if($line =~ /^@/) {
		next;
	}
	
	# linenumber counter and display of running process
	if(($lineNum % 1000000) == 0) {
		print "$lineNum ... \n";
	}

	
	$lineNum = $lineNum + 1;
	
	# split arrays and assign collumns
	my @array=split(/\t/,$line);
	my $numColumns=@array;
	
	my $readID=$array[0];
	my $chromosome=$array[2];
	my $posL=$array[3];
	my $posR=$array[7];
	my $sequence=$array[9];
	my $length_of_molecule=$array[8];
	
	# add 1bp on either side of the read 
	my $posL_1 = ($posL+5);
	my $pos_outer_R = ($posL+$length_of_molecule);
	my $posR_outer_R_1 = ($pos_outer_R-4);
	
	# print line as two single end reads with 1 bp size
	print OUT "$chromosome\t$posL\t$posL_1\t$readID\t1000\n$chromosome\t$posR_outer_R_1\t$pos_outer_R\t$readID\t1000\n";
 
}

close(IN);
close(OUT);

print "done\n";
	
