#!/usr/bin/bash
#SBATCH --job-name=final_proj_mcc
#SBATCH --ntasks=1 --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=15gb
#SBATCH --time=0:20:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=krishna.dasari@yale.edu

module load Beast/2.6.3-GCCcore-10.2.0

treeannotator 407_combined.trees 407_mcc.tree
