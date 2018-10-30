#!/bin/bash

echo " ";
echo "Hi! Start AggregateMatrix pipeline";
echo " ";

inputFile=${1};
outputFolder=${2};
aggregateFile=${3};

foldername=$(basename $inputFile);
echo "$foldername";
aggregateName=$(basename $aggregateFile);
echo "$aggregateName";

mkdir -p $outputFolder/$foldername;
mkdir -p $outputFolder/$foldername/size_bins;
mkdir -p $outputFolder/$foldername/tagDirectory;
mkdir -p $outputFolder/$foldername/aggregateVectors;
mkdir -p $outputFolder/$foldername/norm_aggregateVectors/;


cp $inputFile $outputFolder/$foldername/.;

perl ~/scripts/git/ATACpipe/perl/pebam225bp_size_classes_bed_midpoints.pl $outputFolder/$foldername/$foldername;

mv $outputFolder/$foldername/*.bed.gz $outputFolder/$foldername/size_bins/.;

for f in $outputFolder/$foldername/size_bins/*.bed.gz;
	do
		filename_bin=$(basename $f);
		mkdir -p $outputFolder/$foldername/tagDirectory/$filename_bin;
		echo " ";	
		echo "$filename_bin"
		bsub -q short -W 02:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=8192] -N -u $USER -J bin2tagDir$filename_bin "makeTagDirectory $outputFolder/$foldername/tagDirectory/$filename_bin $f";
		bsub -q short -W 02:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=8192] -N -u $USER -J bin2aggregate$filename_bin -w bin2tagDir$filename_bin "annotatePeaks.pl $aggregateFile hg19 -size 4000 -noadj -hist 25 -d $outputFolder/$foldername/tagDirectory/$filename_bin > $outputFolder/$foldername/aggregateVectors/$filename_bin.$aggregateName.aggregateVector.txt";
		bsub -q short -W 02:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=8192] -N -u $USER -J mv2norm$filename_bin -w bin2aggregate$filename_bin "rm $outputFolder/$foldername/size_bins/$filename_bin";
		bsub -q short -W 02:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=8192] -N -u $USER -J mv2norm$filename_bin -w bin2aggregate$filename_bin "rm $outputFolder/$foldername/tagDirectory/$filename_bin";
	done	

rm $outputFolder/$foldername/$foldername;

echo "done";