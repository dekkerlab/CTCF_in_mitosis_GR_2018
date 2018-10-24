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

#$string=/user/,ar/desk/ti
#my @tmp=split(/\//,$string);

#$name=$tmp[-1]

#open(A,outputWrapper($samFile.".0025.bed.gz"));
open(B,outputWrapper($samFile.".0050.bed.gz"));
open(C,outputWrapper($samFile.".0075.bed.gz"));
open(D,outputWrapper($samFile.".0100.bed.gz"));
open(E,outputWrapper($samFile.".0125.bed.gz"));
open(F,outputWrapper($samFile.".0150.bed.gz"));
open(G,outputWrapper($samFile.".0175.bed.gz"));
open(H,outputWrapper($samFile.".0200.bed.gz"));
open(I,outputWrapper($samFile.".0225.bed.gz"));
open(J,outputWrapper($samFile.".0250.bed.gz"));
open(K,outputWrapper($samFile.".0275.bed.gz"));
open(L,outputWrapper($samFile.".0300.bed.gz"));
open(M,outputWrapper($samFile.".0325.bed.gz"));
open(N,outputWrapper($samFile.".0350.bed.gz"));
open(O,outputWrapper($samFile.".0375.bed.gz"));
open(P,outputWrapper($samFile.".0400.bed.gz"));
open(Q,outputWrapper($samFile.".0425.bed.gz"));
open(R,outputWrapper($samFile.".0450.bed.gz"));
open(S,outputWrapper($samFile.".0475.bed.gz"));
open(T,outputWrapper($samFile.".0500.bed.gz"));
open(U,outputWrapper($samFile.".0525.bed.gz"));
open(V,outputWrapper($samFile.".0550.bed.gz"));
open(W,outputWrapper($samFile.".0575.bed.gz"));
open(X,outputWrapper($samFile.".0600.bed.gz"));
open(Y,outputWrapper($samFile.".0625.bed.gz"));
open(Z,outputWrapper($samFile.".0650.bed.gz"));
open(AA,outputWrapper($samFile.".0675.bed.gz"));
open(AB,outputWrapper($samFile.".0700.bed.gz"));
open(AC,outputWrapper($samFile.".0725.bed.gz"));
open(AD,outputWrapper($samFile.".0750.bed.gz"));
open(AE,outputWrapper($samFile.".0775.bed.gz"));
open(AF,outputWrapper($samFile.".0800.bed.gz"));
open(AG,outputWrapper($samFile.".0825.bed.gz"));
open(AH,outputWrapper($samFile.".0850.bed.gz"));
open(AI,outputWrapper($samFile.".0875.bed.gz"));
open(AJ,outputWrapper($samFile.".0900.bed.gz"));
open(AK,outputWrapper($samFile.".0925.bed.gz"));
open(AL,outputWrapper($samFile.".0950.bed.gz"));
open(AM,outputWrapper($samFile.".0975.bed.gz"));
open(AN,outputWrapper($samFile.".1000.bed.gz"));



#print OUT "track name=$samFile description='ATAC-seq signal'\n";


my $lineNum=0;

my %chrCounterHash=();
my %lengthCounterHash=();


while(my $line = <IN>) { 
	chomp($line);
	
 	if($line =~ /^@/) {
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
	my $chromosome=$array[2];
	my $posL=$array[3];
	my $posR=$array[7];
	my $sequence=$array[9];
	my $length_of_molecule=$array[8];
	
	# add 1bp on either side of the read 
	my $posL_1 = ($posL+1);
	my $pos_outer_R = ($posL+$length_of_molecule);
	my $posR_outer_R_1 = ($pos_outer_R+1);
	my $midpoint= ($posL + ($length_of_molecule * 0.5));
	my $midpoint_rounded = round($midpoint,0);
	my $midpoint_1= ($midpoint_rounded + 1);
	#print "$midpoint\t$midpoint_rounded\t$midpoint_1\n";
	
	
	#if($length_of_molecule < 25) {
		#print A "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		#next;
	#}
	
	if(($length_of_molecule >= 25) and ($length_of_molecule < 50)) {
		print B "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 50) and ($length_of_molecule < 75)) {
		print C "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 75) and ($length_of_molecule < 100)) {
		print D "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 100) and ($length_of_molecule < 125)) {
		print E "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 125) and ($length_of_molecule < 150)) {
		print F "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 150) and ($length_of_molecule < 175)) {
		print G "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 175) and ($length_of_molecule < 200)) {
		print H "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 200) and ($length_of_molecule < 225)) {
		print I "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 225) and ($length_of_molecule < 250)) {
		print J "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 250) and ($length_of_molecule < 275)) {
		print K "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 275) and ($length_of_molecule < 300)) {
		print L "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 300) and ($length_of_molecule < 325)) {
		print M "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 325) and ($length_of_molecule < 350)) {
		print N "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 350) and ($length_of_molecule < 375)) {
		print O "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 375) and ($length_of_molecule < 400)) {
		print P "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 400) and ($length_of_molecule < 425)) {
		print Q "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 425) and ($length_of_molecule < 450)) {
		print R "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 450) and ($length_of_molecule < 475)) {
		print S "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 475) and ($length_of_molecule < 500)) {
		print T "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 500) and ($length_of_molecule < 525)) {
		print U "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 525) and ($length_of_molecule < 550)) {
		print V "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 550) and ($length_of_molecule < 575)) {
		print W "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 575) and ($length_of_molecule < 600)) {
		print X "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 600) and ($length_of_molecule < 625)) {
		print Y "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 625) and ($length_of_molecule < 650)) {
		print Z "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 650) and ($length_of_molecule < 675)) {
		print AA "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 675) and ($length_of_molecule < 700)) {
		print AB "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 700) and ($length_of_molecule < 725)) {
		print AC "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 725) and ($length_of_molecule < 750)) {
		print AD "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 750) and ($length_of_molecule < 775)) {
		print AE "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 775) and ($length_of_molecule < 800)) {
		print AF "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 800) and ($length_of_molecule < 825)) {
		print AG "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 825) and ($length_of_molecule < 850)) {
		print AH "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 850) and ($length_of_molecule < 875)) {
		print AI "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 875) and ($length_of_molecule < 900)) {
		print AJ "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 900) and ($length_of_molecule < 925)) {
		print AK "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 925) and ($length_of_molecule < 950)) {
		print AL "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 950) and ($length_of_molecule < 975)) {
		print AM "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	if(($length_of_molecule >= 975) and ($length_of_molecule < 1000)) {
		print AN "$chromosome\t$midpoint_rounded\t$midpoint_1\t$readID\t1000\n";
		next;
	}
	
	
}	

#close(A);
close(B);
close(C);
close(D);
close(E);
close(F);
close(G);
close(H);
close(I);
close(J);
close(K);
close(L);
close(M);
close(N);
close(O);
close(P);
close(Q);
close(R);
close(S);
close(T);
close(U);
close(V);
close(W);
close(X);
close(Y);
close(Z);
close(AA);
close(AB);
close(AC);
close(AD);
close(AE);
close(AF);
close(AG);
close(AH);
close(AI);
close(AJ);
close(AK);
close(AL);
close(AM);
close(AN);


print "done\n";