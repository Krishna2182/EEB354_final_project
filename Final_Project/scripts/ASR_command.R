fastml_command_template = "/Applications/FastML/programs/fastml/fastml -s ../../alignments/ALN_ID_aln.fasta -t ../../Runs/ALN_ID_RATES/mcc_ALN_ID_RATES.newick -g -c 4 -mh -qf"

for(i in alignments){
  for(j in c('estimated','fixed')){
    dir.create(file.path(paste0('~/Desktop/Phylogenetics/EEB354_final_project/Final_Project/ASR/',i,'_',j)), recursive = T)
    fastml_command = gsub('ALN_ID',i,fastml_command_template)
    fastml_command = gsub('RATES',j,fastml_command)
    setwd(paste0('~/Desktop/Phylogenetics/EEB354_final_project/Final_Project/ASR/',i,'_',j))
    system(fastml_command)
  }
}