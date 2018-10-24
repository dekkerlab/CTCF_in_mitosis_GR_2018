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

open(OUT,outputWrapper($samFile.'.quality.sam.gz'));
#print OUT "track name=$samFile description='ATAC-seq signal'\n";

open (LOG, ">", $samFile.'.LOG') or die "Could not open file $!";
print LOG "track name=$samFile description='LOG ATAC-seq'\n";

open (chrM,outputWrapper($samFile.'.chrM.sam.gz')) or die "Could not open file $!";
#print chrM "track name=$samFile description='LOG ATAC-seq'\n";

open (UNMAPPED,outputWrapper($samFile.'.unmapped.sam.gz')) or die "Could not open file $!";

open (LARGE,outputWrapper($samFile.'.large_fragments.sam.gz')) or die "Could not open file $!";

open (ZEROS,outputWrapper($samFile.'.zeros.sam.gz')) or die "Could not open file $!";

open (LOW_QUALITY,outputWrapper($samFile.'.low_quality.sam.gz')) or die "Could not open file $!";


my $lineNum=0;
my $number_of_reads=0;
my $cis=0;
my $unmapped=0;
my $zeros=0;
my $chrM=0;
my $low_quality=0;

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
		print chrM "$line\n";
		print UNMAPPED "$line\n";
		print LARGE "$line\n";
		print ZEROS "$line\n";
		print LOW_QUALITY "$line\n";
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
	my $mapping_quality=$array[4]; 
	
	if($length_of_molecule < 0) {
		#print "found a negative\n";
		next;
	}
	
	if($length_of_molecule >= 0) {
		$number_of_reads = $number_of_reads + 1;
	}
	
	
	if($chromosome1 eq "chrM") {
		$chrM = $chrM +1;
		print chrM "$line\n";
		next;
	}
	
	if($chromosome2 eq "=") {
		$cis = $cis + 1;
		#$cis += 1;
		#$cis++;
	} else {
		$unmapped = $unmapped + 1;
		print UNMAPPED "$line\n";
		next;
	}
	
	if($length_of_molecule == 0) {
		$zeros = $zeros +1;
		print ZEROS "$line\n";
		next;
	}
	
	if($length_of_molecule > 2000) {
		print LARGE "$line\n";
		next;
	}
	
	if($mapping_quality < 3) {
		$low_quality = $low_quality +1;
		print LOW_QUALITY "$line\n";
		next;
	}
	
	
	$chrCounterHash{$chromosome1}++;
	
	$lengthCounterHash{$length_of_molecule}++;	

	
		if(($lineNum % 1000000) == 0) {
		print "$readID\t$chromosome1\t$posL\t$length_of_molecule\t$sequence\n";
	}
	
	
	if($length_of_molecule < 180) {
		$smaller_180bp = $smaller_180bp +1;
	}
	
	if(($length_of_molecule > 180) and ($length_of_molecule < 320)) {
		$one_nucleosome = $one_nucleosome + 1;
	}
	
	if(($length_of_molecule > 320) and ($length_of_molecule < 500)) {
		$two_nucleosome = $two_nucleosome + 1;
	}
	
	if(($length_of_molecule > 500) and ($length_of_molecule < 750)) {
		$three_nucleosome = $three_nucleosome + 1;
	}
	
	if($length_of_molecule > 750) {
		$large_fragments = $large_fragments +1;
	}
	
	print OUT "$line\n";
	
}	

close(IN);
close(OUT);
close(ZEROS);
close(UNMAPPED);
close(chrM);
close(LARGE);
close(LOW_QUALITY);
print LOG "done\n";

print LOG "\n";
	
print LOG "lineNum\t$lineNum\n";
print LOG "number of reads\t$number_of_reads\n";
print LOG "chrM\t$chrM\t";
my $chrM_pc=(($chrM/$number_of_reads)*100);print LOG "chrM_pc\t$chrM_pc\n";
print LOG "cis\t$cis\t";
my $cis_pc=(($cis/$number_of_reads)*100);print LOG "cis_pc\t$cis_pc\n";
print LOG "unmapped\t$unmapped\t";
my $unmapped_pc=(($unmapped/$number_of_reads)*100);print LOG "unmapped_pc\t$unmapped_pc\n";
print LOG "zeros\t$zeros\t";
my $zeros_pc=(($zeros/$number_of_reads)*100);print LOG "zeros_pc\t$zeros_pc\n";
print LOG "low_quality\t$low_quality\t";
my $low_quality_pc=(($low_quality/$number_of_reads)*100);print LOG "low_quality_pc\t$low_quality_pc\n";

my $valid_reads = ($number_of_reads - $chrM - $unmapped - $zeros - $low_quality);
print LOG "valid reads\t$valid_reads\t";
my $valid_reads_pc=(($valid_reads/$number_of_reads)*100);
print LOG "valid_reads_pc\t$valid_reads_pc\n";

print LOG "\n";

print LOG "chrCounterHash\n";
foreach my $chromosome ( sort keys %chrCounterHash ) {
	my $occurance=$chrCounterHash{$chromosome};
	print LOG "\t$chromosome\t$occurance\n";
	my $pc=(($occurance/$number_of_reads)*100);
	print LOG "\tpc\t$pc\n";
	my $pc_valid=(($occurance/$valid_reads)*100);
	print LOG "pc_valid\t$pc_valid\n";
	print LOG "\n";
}



print LOG "\n";

print LOG "smaller_180bp\t$smaller_180bp\t";my $smaller_180bp_pc=(($smaller_180bp/$valid_reads)*100);
print LOG "smaller_180bp_pc_valid\t$smaller_180bp_pc\n";
print LOG "one_nucleosome\t$one_nucleosome\t";my $one_nucleosome_pc=(($one_nucleosome/$valid_reads)*100);
print LOG "one_nucleosome_pc_valid\t$one_nucleosome_pc\n";
print LOG "two_nucleosome\t$two_nucleosome\t";my $two_nucleosome_pc=(($two_nucleosome/$valid_reads)*100);
print LOG "two_nucleosome_pc_valid\t$two_nucleosome_pc\n";
print LOG "three_nucleosome\t$three_nucleosome\t";my $three_nucleosome_pc=(($three_nucleosome/$valid_reads)*100);
print LOG "three_nucleosome_pc_valid\t$three_nucleosome_pc\n";
print LOG "large_fragments\t$large_fragments\t";my $large_fragments_pc=(($large_fragments/$valid_reads)*100);
print LOG "large_fragments_pc_valid\t$large_fragments_pc\n";

print LOG "\n";

close(LOG);

print "done\n";