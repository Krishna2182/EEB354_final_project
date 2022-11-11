setwd('~/Desktop/Phylogenetics/Final_Project/estimated_rates_setup/')

beast_c_template = 
"#!/usr/bin/bash
#SBATCH --job-name=final_proj
#SBATCH --ntasks=1 --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=10gb
#SBATCH --time=8:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=krishna.dasari@yale.edu

module load R
module load Beast/2.6.3-GCCcore-10.2.0

Rscript ../../submit_job.R ../435_aln.xml"

for(i in 1:6){
  dir.create(file.path(paste0('run',i)), recursive = T)
}
for(i in 1:6){
  output_file = file(paste0('run',i,'/435_beast.sh'))
  writeLines(as.character(beast_c_template), output_file)
}
