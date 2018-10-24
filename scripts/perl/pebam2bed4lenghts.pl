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

sub round($;$) {
	# required
    my $num=shift;
    # optional
    my $digs_to_cut=0;
    $digs_to_cut = shift if @_;
            
    # my $RoundedNumber = round($myNum,3)
    return($num) if($num eq "NA");
               
    my $roundedNum=$num;
               
    if(($num != 0) and ($digs_to_cut == 0)) {
    	$roundedNum = int($num + $num/abs($num*2));
    } else {
    	$roundedNum = sprintf("%.".($digs_to_cut)."f", $num) if($num =~ /\d+\.(\d){$digs_to_cut,}/);
    }
               
    return($roundedNum);

}


print "hi - start of the program\n";
print "\n";


# get the input file
my $samFile=$ARGV[0];

print "samFile = $samFile\n";

open(IN,inputWrapper($samFile)) or die "cannot open < $samFile - $!";


open(OUT,outputWrapper($samFile.'.midpoint4lengths.bed.gz'));


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
	
	my $half_length = ($length_of_molecule/2);
	my $rounded_half_length = round($half_length,0);
	my $posR_50 = ($posR+50);
	my $midpoint = ($posL+$rounded_half_length);
	my $midpoint_1 = ($midpoint-1);
	
	#print "$length_of_molecule\t$rounded_half_length\n";
	#print "$posL\t$posR\t$posR_50\t$midpoint\n";
	

	print OUT "$chromosome\t$midpoint_1\t$midpoint\t$length_of_molecule\t1\n";

}

close(IN);
close(OUT);

print "done\n";
	
	
	
