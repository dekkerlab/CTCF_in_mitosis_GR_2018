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

open(OUT,outputWrapper($samFile.'.unique.sam.gz'));
#print OUT "track name=$samFile description='ATAC-seq signal'\n";

open (LOG, ">", $samFile.'.unique.LOG') or die "Could not open file $!";
print LOG "track name=$samFile description='LOG ATAC-seq'\n";

my $lineNum=0;
my $lastLine="";

my $dup=0;

close (IN);

open(IN,inputWrapper($samFile)) or die "cannot open < $samFile - $!";

while(my $line = <IN>) {
	chomp($line);
	
	next if($line =~ /^track/);
	
	if($line =~ /^@/) {
		print OUT "$line\n";
		next;
	}
	
	print "$lineNum ... \n" if(($lineNum % 100000) == 0);
	
	$lineNum = $lineNum + 1;
	
	my @array=split(/\t/,$line);
	my $numColumns=@array;
	#print "\tfound $numColumns columns\n";

	
	my $chromosome1=$array[2];
	my $posL=$array[3];
	my $posR=$array[7];

	
	my $index=$chromosome1."___".$posL."___".$posR;
	#print "last=$lastLine vs index=$index\n";
	
	
	if ($index eq $lastLine) {
		$dup = $dup+1;
		#print "\tfound a dup! $dup\n";
		$lastLine=$index;
		next;
	} else {
		#print "\tnot a dup!\n";
		print OUT "$line\n";
	}
	
	
	
	$lastLine=$index;
	

	
}

my $duplicate_pc=(($dup/$lineNum)*100);

print LOG "done\n";

print LOG "\n";
	
print LOG "lineNum\t$lineNum\n";
print LOG "duplicates\t$dup\n";
print LOG "duplicate_pc\t$duplicate_pc\n";


close(IN);

#print OUT "$chromosome1\t$posL\t$posR_50\t$readID\t1000\t.\t$posL\t$posR_50\t0\t2\t50,50\t$totalread\n";

close(OUT);
		
print "done\n"; 

