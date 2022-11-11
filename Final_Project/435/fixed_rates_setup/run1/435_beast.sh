#!/usr/bin/bash
#SBATCH --job-name=final_proj
#SBATCH --ntasks=1 --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=4gb
#SBATCH --time=0:30:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=krishna.dasari@yale.edu

module load Beast/2.6.3-GCCcore-10.2.0

beast -threads 1 ../435_aln.xml