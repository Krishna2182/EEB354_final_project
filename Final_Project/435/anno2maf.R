library(data.table)

setwd('~/Desktop/Phylogenetics/Final_Project/')

maf=fread('luad_patient_435.csv')

#adding sample id column
maf$Sample_ID = '435'
colnames(maf) = sub('Position','Start_Position',colnames(maf))
#converting normal sequence into reference sequence
maf$Reference_Allele=maf$Normal
maf$Normal='REF'

cancer_subset = maf[,which(colnames(maf)=='Prim'):which(colnames(maf)=='Met7')]
states = apply(cancer_subset,1,unique)

alt_seq = rep(NA,nrow(maf))
for(i in 1:length(states)){
  alt_seq[i]=(states[[i]][states[[i]] != maf$Reference_Allele[i] & states[[i]] != '-'])
}

maf$Tumor_Seq_Allele2 = alt_seq

maf_backup = maf

maf[,Prim:=fifelse(Prim==Tumor_Seq_Allele2,'ALT',fifelse(Prim=='-','missing','REF'))]
maf[,Met0:=fifelse(Met0==Tumor_Seq_Allele2,'ALT',fifelse(Met0=='-','missing','REF'))]
maf[,Met1:=fifelse(Met1==Tumor_Seq_Allele2,'ALT',fifelse(Met1=='-','missing','REF'))]
maf[,Met3:=fifelse(Met3==Tumor_Seq_Allele2,'ALT',fifelse(Met3=='-','missing','REF'))]
maf[,Met4:=fifelse(Met4==Tumor_Seq_Allele2,'ALT',fifelse(Met4=='-','missing','REF'))]
maf[,Met5:=fifelse(Met5==Tumor_Seq_Allele2,'ALT',fifelse(Met5=='-','missing','REF'))]
maf[,Met6:=fifelse(Met6==Tumor_Seq_Allele2,'ALT',fifelse(Met6=='-','missing','REF'))]
maf[,Met7:=fifelse(Met7==Tumor_Seq_Allele2,'ALT',fifelse(Met7=='-','missing','REF'))]

#checking if transformation worked as intended
#checked '-',Reference Allele, and Alt Allele
tmp1 = which(cancer_subset==maf$Tumor_Seq_Allele2,arr.ind = T)
#new_cancer_subset = maf[,which(colnames(maf)=='Prim'):which(colnames(maf)=='Met7')]
tmp2 = which(new_cancer_subset=='ALT',arr.ind = T)
all(tmp1==tmp2)

fwrite(maf, '435_maf.maf',sep = '\t')
