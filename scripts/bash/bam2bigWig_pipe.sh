#!/bin/bash

bamFile=${1};
outputFolder=${2};
binFolder=${3};
chrSizes=${4};

filename_bam=$(basename ${bamFile});
echo "$filename_bam"

mkdir -p $outputFolder/$filename_bam;
mkdir -p $outputFolder/$filename_bam/se_bedGraph;
mkdir -p $outputFolder/$filename_bam/binned_data;
mkdir -p $outputFolder/$filename_bam/binned_data/bedGraph;
mkdir -p $outputFolder/$filename_bam/binned_data/bigWig
mkdir -p $outputFolder/$filename_bam/merged_data;
mkdir -p $outputFolder/$filename_bam/merged_data/bedGraph;
mkdir -p $outputFolder/$filename_bam/merged_data/bigWig;


echo " ";
echo "Hi! Start of pipelineB for $filename_bam";
echo " ";

#convert pe_bam to se_bedGraph
bsub -q short -W 04:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=500] -N -u $USER -J pebam2bed$filename_bam "perl $HOME/scripts/git/ATACpipe/perl/pebam2se_bedGraph_4_5bp.pl $bamFile";
bsub -q short -W 02:30 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=100] -N -u $USER -J move_bed$filename_bam -w pebam2bed$filename_bam "mv $bamFile.single_end.bedGraph.gz $outputFolder/$filename_bam/se_bedGraph/$filename_bam.single_end.bedGraph.gz";
bsub -q long -W 24:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=12288] -N -u $USER -J bed2sort$filename_bam -w move_bed$filename_bam "zcat $outputFolder/$filename_bam/se_bedGraph/$filename_bam.single_end.bedGraph.gz | sort -s -k 1,1 -k 2,2n | gzip > $outputFolder/$filename_bam/se_bedGraph/$filename_bam.single_end.sort.bedGraph.gz";
 
echo "converting paired-end bam file $filename_bam to single-end bedGraph";
echo " ";

#binning
for f in  $binFolder/*;
	do 
		filename_bin=$(basename $f);
		bsub -q long -W 24:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=12288] -N -u $USER -J bed2bin$filename_bam$filename_bin -w bed2sort$filename_bam "bedtools intersect -a $f -b $outputFolder/$filename_bam/se_bedGraph/$filename_bam.single_end.sort.bedGraph.gz -c -sorted | gzip > $outputFolder/$filename_bam/binned_data/bedGraph/$filename_bam.single_end.sort.bedGraph.$filename_bin.bedGraph.gz";
		bsub -q short -W 04:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=8192] -N -u $USER -J normalizing$filename_bam$filename_bin -w bed2bin$filename_bam$filename_bin "perl $HOME/scripts/git/ATACpipe/perl/bedGraph2norm.pl $outputFolder/$filename_bam/binned_data/bedGraph/$filename_bam.single_end.sort.bedGraph.$filename_bin.bedGraph.gz";
		echo "binning $filename_bam.single_end.sort.bedGraph for $filename_bin"; 
		echo " ";
		#convert binned file to bigWig
		bsub -q short -W 04:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=500] -J gunzipBin$filename_bam$filename_bin -w normalizing$filename_bam$filename_bin -N -u $USER "gunzip $outputFolder/$filename_bam/binned_data/bedGraph/$filename_bam.single_end.sort.bedGraph.$filename_bin.bedGraph.gz.norm.bedGraph.gz";
		bsub -q short -W 04:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=8192] -J bed2bigwigBin$filename_bam$filename_bin -w gunzipBin$filename_bam$filename_bin -N -u $USER "bedGraphToBigWig $outputFolder/$filename_bam/binned_data/bedGraph/$filename_bam.single_end.sort.bedGraph.$filename_bin.bedGraph.gz.norm.bedGraph $chrSizes $outputFolder/$filename_bam/binned_data/bigWig/$filename_bam.single_end.sort.bedGraph.$filename_bin.norm.bw";
		bsub -q short -W 04:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=500] -J gzipBin$filename_bam$filename_bin -w bed2bigwigBin$filename_bam$filename_bin -N -u $USER "gzip $outputFolder/$filename_bam/binned_data/bedGraph/$filename_bam.single_end.sort.bedGraph.$filename_bin.bedGraph.gz.norm.bedGraph";
		echo "converting $filename_bam.single_end.sort.bedGraph.$filename_bin.norm.bedGraph to bigWig"; 
		echo " ";
	done
	
#merging
bsub -q short -W 02:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=4096] -N -u $USER -J bed2merge$filename_bam -w bed2sort$filename_bam "bedtools merge -i $outputFolder/$filename_bam/se_bedGraph/$filename_bam.single_end.sort.bedGraph.gz -c 4 -o sum | gzip > $outputFolder/$filename_bam/merged_data/bedGraph/$filename_bam.single_end.merged_sum.bedGraph.gz";	
bsub -q short -W 02:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=4096] -N -u $USER -J normalizingMerge$filename_bam -w bed2merge$filename_bam "perl $HOME/scripts/git/ATACpipe/perl/bedGraph2norm.pl $outputFolder/$filename_bam/merged_data/bedGraph/$filename_bam.single_end.merged_sum.bedGraph.gz";
echo "merging $filename_bam.single_end.sort.bedGraph";  
echo " ";

#convert merged file to bigwig
bsub -q short -W 02:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=1024] -J gunzipMerge$filename_bam -w normalizingMerge$filename_bam -N -u $USER "gunzip $outputFolder/$filename_bam/merged_data/bedGraph/$filename_bam.single_end.merged_sum.bedGraph.gz.norm.bedGraph.gz";
bsub -q short -W 02:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=4096] -J bed2bigwigMerge$filename_bam -w gunzipMerge$filename_bam -N -u $USER "bedGraphToBigWig $outputFolder/$filename_bam/merged_data/bedGraph/$filename_bam.single_end.merged_sum.bedGraph.gz.norm.bedGraph $chrSizes $outputFolder/$filename_bam/merged_data/bigWig/$filename_bam.single.end.merged_sum.norm.bw";
bsub -q short -W 02:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=1024] -J gzipMerge$filename_bam -w bed2bigwigMerge$filename_bam -N -u $USER "gzip $outputFolder/$filename_bam/merged_data/bedGraph/$filename_bam.single_end.merged_sum.bedGraph.gz.norm.bedGraph";
echo "converting $filename_bam.merged_sum.norm.bedGraph to bigWig"; 
echo " ";


echo "done";
echo " ";