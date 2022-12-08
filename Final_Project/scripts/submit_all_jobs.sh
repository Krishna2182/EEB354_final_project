#!/usr/bin/bash
#SBATCH --partition=pi_townsend
#SBATCH --job-name=mut_rates
#SBATCH --ntasks=1 --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1gb
#SBATCH --time=0:05:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=krishna.dasari@yale.edu

for file in Runs/*/
do 
	file_name=${file#*/}
	file_name=${file_name%/}
	for i in {1..6}
	do
		(cd "/home/scd47/project/mut_rates/Runs/$file_name/run$i/"; sbatch "$file_name.sh")
	done
done