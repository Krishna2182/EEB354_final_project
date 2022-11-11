library("ape")

setwd('~/Desktop/Phylogenetics/Final_Project/')

for(direct in c('estimated_rates','fixed_rates')){
  mcc_nexus = read.nexus(paste0(direct,'/435_mcc.tree'))
  write.tree(mcc_nexus, paste0(direct,'/435_mcc.newick'))
}