#!/bin/bash

fastQFolder=${1};
fastQcpFolder=${2};
splitNumber=${3};
samFolder=${4};
genome=${5};

foldername=$(basename $fastQFolder);
echo " ";
echo "Hi! Start of mapping fastQ files in $foldername to sam";
echo " ";

mkdir -p $fastQcpFolder/$foldername;
mkdir -p $fastQcpFolder/$foldername/R1;
mkdir -p $fastQcpFolder/$foldername/R2;
mkdir -p $samFolder/$foldername;
mkdir -p $samFolder/LOG_mapping/$foldername;


zcat $fastQFolder/*_R1_*.gz > $fastQcpFolder/$foldername/"$foldername"_R1_.fastq;
echo "copy and cat all R1 files in $foldername";
zcat $fastQFolder/*_R2_*.gz > $fastQcpFolder/$foldername/"$foldername"_R2_.fastq;
echo "copy and cat all R2 files in $foldername";


split -l $splitNumber -d $fastQcpFolder/$foldername/"$foldername"_R1_.fastq $fastQcpFolder/$foldername/R1/"$foldername"_R1_.fastq_0;
split -l $splitNumber -d $fastQcpFolder/$foldername/"$foldername"_R2_.fastq $fastQcpFolder/$foldername/R2/"$foldername"_R2_.fastq_0;
echo "split all R1 and R2 in $foldername in chuncks of $splitNumber reads"


gzip $fastQcpFolder/$foldername/R1/"$foldername"_R1_.fastq_0*;
gzip $fastQcpFolder/$foldername/R2/"$foldername"_R2_.fastq_0*; 
echo "zipped all files back to fastq.gz" 


for f in $fastQcpFolder/$foldername/R1/*.gz;
	do 
		filename=$(basename $f);
		name_no_ext=$(echo $filename | cut -f -4 -d '_');
		file_ext=$(echo $filename | rev | cut -f -2 -d '_' | rev );
		echo "$filename";
		echo "$name_no_ext";
		echo "$file_ext";
		nameR2=$"$name_no_ext"_*_"$file_ext";
		echo "$nameR2";
		bsub -q long -W 24:00 -e $samFolder/LOG_mapping/$foldername/$filename.LOG -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=6000] -N -u $USER -J bowtie2$filename "bowtie2 -X2000 -3 26 -x $genome -1 $f -2 $fastQcpFolder/$foldername/R2/$nameR2 -S $samFolder/$foldername/'$name_no_ext'_'$file_ext'.sam";
		bsub -q short -W 04:00 -e $HOME/lsf_jobs/LSB_%J.err -o $HOME/lsf_jobs/LSB_%J.log -n 1 -R select[ib] -R rusage[mem=500] -N -u $USER -J sam$filename -w bowtie2$filename "gzip $samFolder/$foldername/'$name_no_ext'_'$file_ext'.sam"
		echo " ";
	done

gzip $fastQcpFolder/$foldername/*.fastq;	

echo "done"; 
 