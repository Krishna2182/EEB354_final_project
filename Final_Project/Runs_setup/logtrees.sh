#!/usr/bin/bash
#SBATCH --partition=pi_townsend
#SBATCH --job-name=logcombiner
#SBATCH --ntasks=1 --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=15gb
#SBATCH --time=0:30:00

module load Beast/2.6.3-GCCcore-10.2.0

#using 20% burn-in
logcombiner -b 20 -log */*.log -o "combined_$1_$2.log"
logcombiner -b 20 -log */*.trees -o "combined_$1_$2.trees"
