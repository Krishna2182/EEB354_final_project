setwd('~/Desktop/Phylogenetics/Final_Project/estimated_rates/')
myAln='../435_aln.fasta'
#unsure if I should input mcc tree ot asr tree but both have the same clade relationships anyway
myMCC='ASR/tree.newick.txt'
myASR='ASR/seq.joint.txt'
myMAF='../435_maf.maf'
normName='Normal'
patientID='435'
iq_or_fast='fast'
outFile='435_asr.maf'

source('../GenASRMAFSv1_0.R')
gen_ASR_MAF(myAln,myMCC,myASR,myMAF,normName,patientID,iq_or_fast,keepExtraMAF = F,outFile)

