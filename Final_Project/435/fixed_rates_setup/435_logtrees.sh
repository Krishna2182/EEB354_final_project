#!/usr/bin/bash
#SBATCH --job-name=final_proj
#SBATCH --ntasks=1 --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=4gb
#SBATCH --time=0:30:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=krishna.dasari@yale.edu

module load Beast/2.6.3-GCCcore-10.2.0

#using 20% burn-in
logcombiner -b 20 -log run1/435_aln.log -log run2/435_aln.log -log run3/435_aln.log -log run4/435_aln.log -log run5/435_aln.log -log run6/435_aln.log -o 435_combined.log
logcombiner -b 20 -log run1/435_aln.trees -log run2/435_aln.trees -log run3/435_aln.trees -log run4/435_aln.trees -log run5/435_aln.trees -log run6/435_aln.trees -o 435_combined.trees
