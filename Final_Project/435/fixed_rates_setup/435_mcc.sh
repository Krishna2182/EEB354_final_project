#!/usr/bin/bash
#SBATCH --job-name=final_proj_mcc
#SBATCH --ntasks=1 --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=10gb
#SBATCH --time=0:10:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=krishna.dasari@yale.edu

module load Beast/2.6.3-GCCcore-10.2.0

treeannotator 435_combined.trees 435_mcc.tree
