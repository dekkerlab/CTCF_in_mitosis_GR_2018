#!/bin/bash
echo " ";
echo "Hi! Start ATAC pipelineA";
echo " ";

inputFolder=${1};
outputFolder=${2};

foldername=$(basename $inputFolder);

#sam2bam
mkdir -p $outputFolder/$foldername;
mkdir -p $outputFolder/$foldername/bam_files;
mkdir -p $outputFolder/$foldername/bam_quality;
mkdir -p $outputFolder/$foldername/LOG_quality;
mkdir -p $outputFolder/$foldername/chrM;
mkdir -p $outputFolder/$foldername/unmapped;
mkdir -p $outputFolder/$foldername/zeros;
mkdir -p $outputFolder/$foldername/large_fragments;
mkdir -p $outputFolder/$foldername/sorted_quality;
mkdir -p $outputFolder/$foldername/LOG_unique;
mkdir -p $outputFolder/$foldername/unique_quality;
mkdir -p $outputFolder/$foldername/LENGTHS;
mkdir -p $outputFolder/$foldername/LENGTHS/pdf_plots;


for f in $inputFolder/*;
	do 
		filename=$(basename $f);
		name_no_ext=$(echo $filename | rev | cut -f 2- -d '.' | rev );
		echo "$name_no_ext";
		echo " ";
		
		bsub -q long -W 08:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=2000] -N -u $USER -J sam2bam$filename "samtools view -bS $f > $outputFolder/$foldername/bam_files/$name_no_ext.bam";
		echo "submitted sam2bam$filename";
		echo " ";
		
		bsub -q short -W 03:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=1000] -N -u $USER -J bam2quality$name_no_ext -w sam2bam$filename "perl $HOME/scripts/git/CTCF_in_mitosis_GR_2018/scripts/perl/pebam2quality.pl $outputFolder/$foldername/bam_files/$name_no_ext.bam";
		echo "submitted bam2quality$name_no_ext";
		echo " ";
		
		bsub -q short -W 03:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=2000] -N -u $USER -J sam2bamquality$name_no_ext -w bam2quality$name_no_ext "samtools view -bS $outputFolder/$foldername/bam_files/$name_no_ext.bam.quality.sam.gz > $outputFolder/$foldername/bam_quality/$name_no_ext.bam.quality.bam";
		bsub -q short -W 01:30 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=100] -N -u $USER -J rm2quality$name_no_ext -w sam2bamquality$name_no_ext "rm $outputFolder/$foldername/bam_files/$name_no_ext.bam.quality.sam.gz";
		
		bsub -q short -W 01:30 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=100] -N -u $USER -J mvLogQuality$name_no_ext -w bam2quality$name_no_ext "mv $outputFolder/$foldername/bam_files/$name_no_ext.bam.LOG $outputFolder/$foldername/LOG_quality/.";
		
		bsub -q short -W 03:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=2000] -N -u $USER -J sam2bamchrM$name_no_ext -w bam2quality$name_no_ext "samtools view -bS $outputFolder/$foldername/bam_files/$name_no_ext.bam.chrM.sam.gz > $outputFolder/$foldername/chrM/$name_no_ext.bam.chrM.bam";
		bsub -q short -W 01:30 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=100] -N -u $USER -J rmChrM$name_no_ext -w sam2bamchrM$name_no_ext "rm $outputFolder/$foldername/bam_files/$name_no_ext.bam.chrM.sam.gz";
		
		bsub -q short -W 03:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=2000] -N -u $USER -J sam2bamzeros$name_no_ext -w bam2quality$name_no_ext "samtools view -bS $outputFolder/$foldername/bam_files/$name_no_ext.bam.zeros.sam.gz > $outputFolder/$foldername/zeros/$name_no_ext.bam.zeros.bam";
		bsub -q short -W 01:30 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=100] -N -u $USER -J rmZeros$name_no_ext -w sam2bamzeros$name_no_ext "rm $outputFolder/$foldername/bam_files/$name_no_ext.bam.zeros.sam.gz";
		
		bsub -q short -W 03:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=2000] -N -u $USER -J sam2bamUnmapped$name_no_ext -w bam2quality$name_no_ext "samtools view -bS $outputFolder/$foldername/bam_files/$name_no_ext.bam.unmapped.sam.gz > $outputFolder/$foldername/unmapped/$name_no_ext.bam.unmapped.bam";
		bsub -q short -W 01:30 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=100] -N -u $USER -J rmUnmapped$name_no_ext -w sam2bamUnmapped$name_no_ext "rm $outputFolder/$foldername/bam_files/$name_no_ext.bam.unmapped.sam.gz";
		
		bsub -q short -W 03:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=2000] -N -u $USER -J sam2bamLarge$name_no_ext -w bam2quality$name_no_ext "samtools view -bS $outputFolder/$foldername/bam_files/$name_no_ext.bam.large_fragments.sam.gz > $outputFolder/$foldername/large_fragments/$name_no_ext.bam.large_fragments.bam";
		bsub -q short -W 01:30 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=100] -N -u $USER -J rmLarge$name_no_ext -w sam2bamLarge$name_no_ext "rm $outputFolder/$foldername/bam_files/$name_no_ext.bam.large_fragments.sam.gz";
		
		bsub -q short -W 03:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=1024] -N -u $USER -J bam2sort$name_no_ext -w rm2quality$name_no_ext "samtools sort $outputFolder/$foldername/bam_quality/$name_no_ext.bam.quality.bam $outputFolder/$foldername/sorted_quality/$name_no_ext.bam.quality.sort";
		echo "submitted bam2sort$name_no_ext";
		echo " ";
		
		bsub -q short -W 02:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=2000] -N -u $USER -J bam2unique$name_no_ext -w bam2sort$name_no_ext "perl $HOME/scripts/git/CTCF_in_mitosis_GR_2018/scripts/perl/pebam2unique.pl $outputFolder/$foldername/sorted_quality/$name_no_ext.bam.quality.sort.bam";
		echo "submitted bam2unique$name_no_ext";
		echo " ";
		
		bsub -q short -W 03:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=2000] -N -u $USER -J sam2bamunique$name_no_ext -w bam2unique$name_no_ext "samtools view -bS $outputFolder/$foldername/sorted_quality/$name_no_ext.bam.quality.sort.bam.unique.sam.gz > $outputFolder/$foldername/unique_quality/$name_no_ext.bam.quality.sort.unique.bam";
		bsub -q short -W 01:30 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=100] -N -u $USER -J rm2unique$name_no_ext -w sam2bamunique$name_no_ext "rm $outputFolder/$foldername/sorted_quality/$name_no_ext.bam.quality.sort.bam.unique.sam.gz";
		
		bsub -q short -W 01:30 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=100] -N -u $USER -J mvLogUnique$name_no_ext -w bam2unique$name_no_ext "mv $outputFolder/$foldername/sorted_quality/$name_no_ext.bam.quality.sort.bam.unique.LOG $outputFolder/$foldername/LOG_unique/.";
		
		bsub -q short -W 02:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=1000] -N -u $USER -J bam2index$name_no_ext -w rm2unique$name_no_ext "samtools index $outputFolder/$foldername/unique_quality/$name_no_ext.bam.quality.sort.unique.bam";
		
		bsub -q short -W 02:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=1000] -N -u $USER -J unique2lengths$name_no_ext  -w sam2bamunique$name_no_ext "perl $HOME/scripts/git/CTCF_in_mitosis_GR_2018/scripts/perl/pebam2lengths.pl $outputFolder/$foldername/unique_quality/$name_no_ext.bam.quality.sort.unique.bam";
		bsub -q short -W 04:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=100] -N -u $USER -J mvLengths$name_no_ext -w unique2lengths$name_no_ext "mv $outputFolder/$foldername/unique_quality/$name_no_ext.bam.quality.sort.unique.bam.LENGTHS $outputFolder/$foldername/LENGTHS/.";
		echo "submitted unique2lengths$name_no_ext";
		
		bsub -q short -W 04:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=2096] -N -u $USER -J lengths2plot$name_no_ext -w mvLengths$name_no_ext "Rscript $HOME/scripts/git/CTCF_in_mitosis_GR_2018/scripts/R/lengths.R $outputFolder/$foldername/LENGTHS/$name_no_ext.bam.quality.sort.unique.bam.LENGTHS $name_no_ext";
		bsub -q short -W 01:30 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=100] -N -u $USER -J mvPlot$name_no_ext -w lengths2plot$name_no_ext  "mv $outputFolder/$foldername/LENGTHS/$name_no_ext.bam.quality.sort.unique.bam.LENGTHS.pdf $outputFolder/$foldername/LENGTHS/pdf_plots";	
		echo "submitted lengths2plot$name_no_ext";
		
		echo " ";		
	done
	

echo "done";
