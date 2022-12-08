library(ape)

setwd('~/Desktop/Phylogenetics/EEB354_final_project/Final_Project/')

files = list.files('Runs',pattern = 'tree$',full.names = T,recursive = T)

for (file in files){
  mcc_nexus <- read.nexus(file)
  output_file = sub('.tree','.newick',file)
  write.tree(mcc_nexus,file = output_file)
}
