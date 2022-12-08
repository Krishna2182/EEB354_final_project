#!/bin/bash
#SBATCH --partition=pi_townsend
#SBATCH --job-name=compress
#SBATCH --ntasks=1 --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=10gb
#SBATCH --time=0:10:00
shopt -s globstar; tar -czvf Runs.tar.gz **/combined*.log **/mcc*.tree

#find . -name "*.out" -exec tail -n 50 {} \;