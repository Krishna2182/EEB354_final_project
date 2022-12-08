setwd('~/Desktop/Phylogenetics/EEB354_final_project/Final_Project/')
xmls = list.files('XMLs')

beast_c_template = 
"#!/usr/bin/bash
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

Rscript ../../submit_job.R ../../../XML"

for(file in xmls){
  beast_c = gsub('XML',paste0('XMLs/',file),beast_c_template)
  run_code = sub('\\..*','',file)
  for(i in 1:6){
    dir.create(file.path(paste0('Runs_setup/',run_code,'/run',i)), recursive = T)
  }
  for(i in 1:6){
    output_file = file(paste0('Runs_setup/',run_code,'/run',i,'/',run_code,'.sh'))
    writeLines(as.character(beast_c), output_file)
  }
}
