#!/usr/bin/bash
#SBATCH --partition=pi_townsend
#SBATCH --job-name=beast
#SBATCH --ntasks=1 --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=10gb
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=krishna.dasari@yale.edu

module load R
module load Beast/2.6.3-GCCcore-10.2.0

Rscript ../../submit_job.R ../../../XMLs/408_estimated.xml
