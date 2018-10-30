#!/bin/bash
echo "Hi! Start ATAC pipelineA_ALL";

inputFolder=${1};
name=$(basename $inputFolder);
echo "$name";

mkdir $inputFolder/ALL;

bsub -q short -W 04:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=1024] -N -u $USER -J bam2cat$name "samtools merge $inputFolder/ALL/$name.ALL.bam $inputFolder/unique_quality/*.bam";

bsub -q short -W 04:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=9000] -N -u $USER -J cat2sort$name -w bam2cat$name "samtools sort $inputFolder/ALL/$name.ALL.bam $inputFolder/ALL/$name.ALL.sort";

bsub -q short -W 04:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=1000] -N -u $USER -J cat2unique$name -w cat2sort$name "perl $HOME/scripts/git/CTCF_in_mitosis_GR_2018/scripts/perl/pebam2unique.pl $inputFolder/ALL/$name.ALL.sort.bam"; 

bsub -q short -W 04:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=3000] -N -u $USER -J unique2bam$name -w cat2unique$name "samtools view -bS $inputFolder/ALL/$name.ALL.sort.bam.unique.sam.gz > $inputFolder/ALL/$name.ALL.sort.bam.unique.bam";

bsub -q short -W 04:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=1000] -N -u $USER -J bam2index$name -w unique2bam$name "samtools index $inputFolder/ALL/$name.ALL.sort.bam.unique.bam";

bsub -q short -W 01:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=500] -N -u $USER -J rmUniqueSam$name -w unique2bam$name "rm $inputFolder/ALL/$name.ALL.sort.bam.unique.sam.gz";

bsub -q short -W 04:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=1000] -N -u $USER -J unique2lengths$name -w unique2bam$name "perl $HOME/scripts/git/CTCF_in_mitosis_GR_2018/scripts/perl/pebam2lengths.pl $inputFolder/ALL/$name.ALL.sort.bam.unique.bam";

bsub -q short -W 04:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=2000] -N -u $USER -J lengths2plot$name -w unique2lengths$name "Rscript $HOME/scripts/git/CTCF_in_mitosis_GR_2018/scripts/R/lengths.R $inputFolder/ALL/$name.ALL.sort.bam.unique.bam.LENGTHS $name";

echo "done"; 
