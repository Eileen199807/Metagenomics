#!/bin/bash
#####################################################################################
###                                                                                 #
### slurm-mpi_omp.cmd :                                                             #
### A SLURM submission script for running Hybrid MPI+OpenMP jobs on HPC2021 system  #
###                                                                                 #
### Compilation for Hybrid MPI+OpenMP program                                       #
### (1) Intel MPI Libaries                                                          #
###     module load impi                                                            #
###     mpiifort -qopenmp mpi_omp_hello.f90 -o mpi_omp_hello-f90-impi               #
### (2) OpenMPI Libaries                                                            #
###     module load openmpi                                                         #
###     mpif90 -fopenmp mpi_omp_hello.f90 -o mpi_omp_hello-f90-ompi                 #
###                                                                                 #
### Job submission                                                                  #
###    cd to directory containing program/executable, then:                         #
###    sbatch <location of this script>/slurm-mpi_omp.cmd                           #
###                                                                                 #
### SLURM for Multicore/Multi-thread: https://slurm.schedmd.com/mc_support.html     #
###                                                                                 #
### - Written by Lilian Chan, HKU ITS (2021-3-2)                                    #
###                                                                                 #
#####################################################################################
#SBATCH --job-name=metaphlan
#SBATCH --mail-type=FAIL,END                      # Mail events
#SBATCH --mail-user=lwleen@hku.hk                 # Update your email address
#SBATCH --partition=intel                         # Specific Partition (intel/amd)
#SBATCH --time=2-10:00:00                         # Wall time limit (days-hrs:min:sec)
#SBATCH --ntasks=1                                # Total number of MPI tasks(processes)
#SBATCH --nodes=1                                 # Total number of compute node(s)
#SBATCH --ntasks-per-node=1                       # Number of MPI Tasks on each node
#SBATCH --cpus-per-task=6                         # Number of CPUs per each MPI task
#SBATCH --mem-per-cpu=12G                         # Memory setting
#SBATCH --output=%x.out.%j                        # Standard output file
#SBATCH --error=%x.err.%j                         # Standard error file
#SBATCH --account=sph_pengwu                      # Which group to use sbs_ssin or sph_pengwu
#####################################################################################
### The following stuff will be executed in the first allocated node.               #
### Please don't modify it                                                          #
#####################################################################################
echo "SLURMD_NODENAME       : $SLURMD_NODENAME"
echo "SLURM_NTASKS          : $SLURM_NTASKS"
echo "SLURM_JOB_NUM_NODES   : $SLURM_JOB_NUM_NODES"
echo "SLURM_CPUS_PER_TASK   : $SLURM_CPUS_PER_TASK"
echo "SLURM_CPUS_ON_NODE    : $SLURM_CPUS_ON_NODE"
echo JOBID ${SLURM_JOBID} : ${SLURM_NTASKS} CPUs allocated from ${SLURM_JOB_NODELIST}
echo Working directory is ${SLURM_SUBMIT_DIR}  1>&2
echo This SLURM script is running on host ${SLURMD_NODENAME} 1>&2
#################################################################################
### Install environment using conda
### conda install -c bioconda metaphlan

###conda activate metagenomics
###sampleID="CB031_fastp"
###fastq_dir="/lustre1/g/sph_pengwu/tutorial/2023_RIF_WGS_workshop/workshop3/Eileen/07_WGS_Meta/02_Fastp/Clean_fastq/paired_reads/CB031_remove_kraken"
###output_dir="/lustre1/g/sph_pengwu/tutorial/2023_RIF_WGS_workshop/workshop3/Eileen/07_WGS_Meta/14_Mtphylan"
###fasta_dir="/lustre1/g/sph_pengwu/tutorial/2023_RIF_WGS_workshop/workshop3/Eileen/07_WGS_Meta/03_Assembly"

###cd ${fasta_dir}
###for SampleID in CB012 CB014 CB031
###do
###metaphlan ${SampleID}_megahit/${SampleID}.contigs.fa --input_type fasta --nproc 4 -o  ${output_dir}/${SampleID}_fasta_profile.txt
#done

###cd ${fastq_dir}
###metaphlan ${sampleID}_1.fq.gz,${sampleID}_2.fq.gz --bowtie2out  ${sampleID}.bowtie2.bz2 --nproc 60 --input_type fastq -o  ${output_dir}/${sampleID}_mtphlan.txt

### Merging MetaPhlAn profiles
### merge_metaphlan_tables.py *_mtphlan.txt > merged_abundance_table.txt ###
### grep -E "f__[^|]*\s" merged_abundance_table.txt | awk -F '\t' '{sub(/.*f__/, "", $1); printf $1; for (i = 2; i <= NF; ++i) printf "\t" $i; printf "\n"}' > merge_family_table.txt
### grep -E "g__[^|]*\s" merged_abundance_table.txt | awk -F '\t' '{sub(/.*g__/, "", $1); printf $1; for (i = 2; i <= NF; ++i) printf "\t" $i; printf "\n"}' > merge_genus_table.txt
### grep -E "s__[^|]*\s" merged_abundance_table.txt | awk -F '\t' '{sub(/.*s__/, "", $1); printf $1; for (i = 2; i <= NF; ++i) printf "\t" $i; printf "\n"}' > merge_species_table.txt

fastq_dir="/lustre1/g/sph_pengwu/tutorial/2023_RIF_WGS_workshop/workshop3/Eileen/07_WGS_Meta/02_Fastp/Clean_fastq/paired_reads/"
output_dir="/lustre1/g/sph_pengwu/tutorial/2023_RIF_WGS_workshop/workshop3/Eileen/07_WGS_Meta/14_Mtphylan"

for SampleID in `cat sample.lst`
do
cd ${fastq_dir}/${SampleID}_remove_kraken
metaphlan ${SampleID}_fastp_1.fq.gz,${SampleID}_fastp_2.fq.gz --bowtie2out  ${SampleID}.bowtie2.bz2 --nproc 60 --input_type fastq -o  ${output_dir}/${SampleID}_mtphlan.txt
done

