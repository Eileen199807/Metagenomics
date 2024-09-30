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
#SBATCH --job-name=RGI
#SBATCH --mail-type=FAIL,END                      # Mail events
#SBATCH --mail-user=lwleen@hku.hk                 # Update your email address
#SBATCH --partition=intel                         # Specific Partition (intel/amd)
#SBATCH --time=5-10:00:00                         # Wall time limit (days-hrs:min:sec)
#SBATCH --ntasks=1                                # Total number of MPI tasks(processes)
#SBATCH --nodes=1                                 # Total number of compute node(s)
#SBATCH --ntasks-per-node=1                       # Number of MPI Tasks on each node
#SBATCH --cpus-per-task=6                         # Number of CPUs per each MPI task
#SBATCH --mem-per-cpu=6G                          # Memory setting
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

for SampleID in CZ050
do
rgi bwt -1 /lustre1/g/sph_pengwu/tutorial/2023_RIF_WGS_workshop/workshop3/Eileen/07_WGS_Meta/02_Fastp/Clean_fastq/paired_reads/${SampleID}_remove_kraken/${SampleID}_fastp_1.fq.gz \
-2 /lustre1/g/sph_pengwu/tutorial/2023_RIF_WGS_workshop/workshop3/Eileen/07_WGS_Meta/02_Fastp/Clean_fastq/paired_reads/${SampleID}_remove_kraken/${SampleID}_fastp_2.fq.gz \
-a kma --clean --local -o /lustre1/g/sph_pengwu/tutorial/2023_RIF_WGS_workshop/workshop3/Eileen/07_WGS_Meta/06_ARG/RGI/${SampleID}.card5.out
done