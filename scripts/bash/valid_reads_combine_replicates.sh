	#!/bin/bash
echo "Hi! Start ATAC pipelineA_ALL for different libraries";

inputFolder=${1};
outputFolder=${2};
name=${3};

mkdir -p $outputFolder/$name/;

bsub -q short -W 04:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=1024] -N -u $USER -J bam2cat$name "samtools merge $outputFolder/$name/$name.bam $inputFolder/*/ALL/*.sort.bam.unique.bam";

bsub -q short -W 04:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=1000] -N -u $USER -J bam2index$name -w bam2cat$name "samtools index $outputFolder/$name/$name.bam";

bsub -q short -W 04:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=1000] -N -u $USER -J bam2lengths$name -w bam2cat$name "perl $HOME/scripts/git/ATACpipe/perl/pebam2lengths.pl $outputFolder/$name/$name.bam";

bsub -q short -W 04:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=2000] -N -u $USER -J lengths2plot$name -w bam2lengths$name "Rscript $HOME/scripts/git/ATACpipe/R/lengths.R $outputFolder/$name/$name.bam.LENGTHS $name";


echo "done";

