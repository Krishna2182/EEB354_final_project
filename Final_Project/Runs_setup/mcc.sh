#!/usr/bin/bash
#SBATCH --partition=pi_townsend
#SBATCH --job-name=mcc
#SBATCH --ntasks=1 --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=20gb
#SBATCH --time=0:20:00

module load Beast/2.6.3-GCCcore-10.2.0

treeannotator "combined_c$1_$2.trees" "mcc_$1_$2.tree"