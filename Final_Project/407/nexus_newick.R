library("ape")

setwd('~/Desktop/Phylogenetics/Final_Project/407/estimated_rates_results/')

file='407_mcc.tree'
mcc_nexus <- read.nexus(file)
output_file = sub('.tree','.newick',file)
write.tree(mcc_nexus,file = output_file)

setwd('~/Desktop/Phylogenetics/Final_Project/407/fixed_rates_results/')

file='407_mcc.tree'
mcc_nexus <- read.nexus(file)
output_file = sub('.tree','.newick',file)
write.tree(mcc_nexus,file = output_file)