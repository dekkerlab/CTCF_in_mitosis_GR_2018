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

#$string=/user/,ar/desk/ti
#my @tmp=split(/\//,$string);

#$name=$tmp[-1]

open(OUT,outputWrapper($samFile.'.75_150bp.sam.gz'));
#print OUT "track name=$samFile description='ATAC-seq signal'\n";


my $lineNum=0;
my $number_of_reads=0;
my $cis=0;
my $unmapped=0;
my $zeros=0;
my $chrM=0;

my %chrCounterHash=();
my %lengthCounterHash=();

my $smaller_180bp=0;
my $one_nucleosome=0;
my $two_nucleosome=0;
my $three_nucleosome=0;
my $large_fragments=0;

while(my $line = <IN>) { 
	chomp($line);
	
 	if($line =~ /^@/) {
		print OUT "$line\n";
		next;
	}
	
	print "$lineNum ... \n" if(($lineNum % 100000) == 0);
	
	#next if($line =~ /^@/);
	
	$lineNum = $lineNum + 1;

	#actions per line
	#print "\n\n";
	#print "lineNumber is $lineNum\n";
	#print" $line\n";
	
	my @array=split(/\t/,$line);
	my $numColumns=@array;
	#print "\tfound $numColumns columns\n";
	
	my $readID=$array[0];
	my $chromosome1=$array[2];
	my $chromosome2=$array[6];
	my $posL=$array[3];
	my $posR=$array[7];
	my $sequence=$array[9];
	my $length_of_molecule=$array[8];
	
	
	if(($length_of_molecule > 75) and ($length_of_molecule < 150)) {
		print OUT "$line\n";
		next;
	}
}	

close(OUT);

print "done\n";