setwd('~/Desktop/Phylogenetics/EEB354_final_project/Final_Project/ASR/')
source('../scripts/GenASRMAFSv1_0.R')

for(i in alignments){
  for(j in c('estimated','fixed')){
  #run genASRMAF
    gen_ASR_MAF(myAln = paste0('../alignments/',i,'_aln.fasta'),
                myMCC = paste0(i,'_',j,'/tree.newick.txt'),
                myASR = paste0(i,'_',j,'/seq.joint.txt'),
                myMAF = paste0('../MAFs/',i,'_maf.maf'),
                normName = 'Normal',
                patientID = i,
                iq_or_fast = 'fast',
                keepExtraMAF = F,
                outFile = paste0('asr_',i,'_',j,'.maf'))
  }
}

