library(data.table)

setwd('~/Desktop/Phylogenetics/EEB354_final_project/Final_Project/')

mafs = lapply(alignments, function(alignment){as.data.table(read_xls('PNAS Data/mafs.xls',sheet=alignment))})
names(mafs) = alignments

# subsetting columns to the sequences for the samples
sample_subsets = copy(mafs)
sample_subsets = lapply(sample_subsets, function(maf){maf[,4:ncol(maf)]})
alignments_states = lapply(sample_subsets, function(maf){apply(maf,1,unique)})
# check which sites have more than 2 allele states (usually a deletion)
# lapply(alignments, function(x){sample_subsets[[x]][which(lengths(alignments_states[[x]])>2)]})

# alignment 407 has 2 alternative alleles for site 105. The primary has G, Mets 1-3 have C, will use C as ALT allele
# alignment 408 has 2 alternative alleles for site 114. Met1 has A, Met3-4 have C, will use C as ALT allele

for(alignment in names(mafs)){
  mafs[[alignment]][, Sample_ID := alignment]
  mafs[[alignment]][, Reference_Allele := Normal]
  mafs[[alignment]][, Normal := 'REF']
  colnames(mafs[[alignment]]) = sub('Position','Start_Position',colnames(mafs[[alignment]]))
}

# Create alternative allele sequence
for(alignment in 1:length(mafs)){
  ref_seq = mafs[[alignment]][, Reference_Allele]
  alignment_states = alignments_states[[alignment]]
  for(site in 1:length(ref_seq)){
    # exceptions identified in comments above where there is more than one alternative allele
    if((alignment == 1 & site == 105) | (alignment == 2 & site == 114)) {
      mafs[[alignment]][site, Tumor_Seq_Allele2 := 'C']
    } else {
      # take the allele that is not equivalent to the reference allele or missing
      mafs[[alignment]][site, Tumor_Seq_Allele2 := alignment_states[[site]][ 
        !(alignment_states[[site]] %in% c(ref_seq[site],'-')) ] ]
    }
  }
}

# Replace actual alleles with REF, ALT, or missing
for(alignment in 1:length(mafs)){
  cancer_cols = which(colnames(mafs[[alignment]]) %in% c("Prim",paste0('Met',0:20)))
  #mafs[[alignment]][, lapply(.SD, function(cancer_allele){print(cancer_allele)}), .SDcols = cancer_cols]

  new_cancer_subset = mafs[[alignment]][, lapply(.SD, function(cancer_allele){
                                      fifelse(cancer_allele==Tumor_Seq_Allele2,'ALT',
                                              fifelse(cancer_allele==Reference_Allele,'REF',
                                                      fifelse(cancer_allele=='-','missing',"NA")))
                                    }), .SDcols = cancer_cols]
  mafs[[alignment]][, colnames(mafs[[alignment]])[cancer_cols] := NULL]
  mafs[[alignment]] = cbind(mafs[[alignment]], new_cancer_subset)
}

mafs[[1]][105, Prim := 'ALT']
mafs[[2]][114, Met1 := 'ALT']

## to load into cancereffectsizeR, just take every site and make table with it and the reference allele and alt allele; deal with reversions later

for(i in 1:length(alignments)){
  fwrite(mafs[[i]], paste0('MAFs/',alignments[i],'_maf.maf'),sep = '\t')
}

###
###

# maf=fread('luad_patient_435.csv')
# 
# #adding sample id column
# maf$Sample_ID = '435'
# colnames(maf) = sub('Position','Start_Position',colnames(maf))
# #converting normal sequence into reference sequence
# maf$Reference_Allele=maf$Normal
# maf$Normal='REF'

# cancer_subset = maf[,which(colnames(maf)=='Prim'):which(colnames(maf)=='Met7')]
# states = apply(cancer_subset,1,unique)
# 
# alt_seq = rep(NA,nrow(maf))
# for(i in 1:length(states)){
#   alt_seq[i]=(states[[i]][states[[i]] != maf$Reference_Allele[i] & states[[i]] != '-'])
# }
# 
# maf$Tumor_Seq_Allele2 = alt_seq
# 
# maf_backup = maf
# 
# maf[,Prim:=fifelse(Prim==Tumor_Seq_Allele2,'ALT',fifelse(Prim=='-','missing','REF'))]
# maf[,Met0:=fifelse(Met0==Tumor_Seq_Allele2,'ALT',fifelse(Met0=='-','missing','REF'))]
# maf[,Met1:=fifelse(Met1==Tumor_Seq_Allele2,'ALT',fifelse(Met1=='-','missing','REF'))]
# maf[,Met3:=fifelse(Met3==Tumor_Seq_Allele2,'ALT',fifelse(Met3=='-','missing','REF'))]
# maf[,Met4:=fifelse(Met4==Tumor_Seq_Allele2,'ALT',fifelse(Met4=='-','missing','REF'))]
# maf[,Met5:=fifelse(Met5==Tumor_Seq_Allele2,'ALT',fifelse(Met5=='-','missing','REF'))]
# maf[,Met6:=fifelse(Met6==Tumor_Seq_Allele2,'ALT',fifelse(Met6=='-','missing','REF'))]
# maf[,Met7:=fifelse(Met7==Tumor_Seq_Allele2,'ALT',fifelse(Met7=='-','missing','REF'))]

# #checking if transformation worked as intended
# #checked '-',Reference Allele, and Alt Allele
# tmp1 = which(cancer_subset==maf$Tumor_Seq_Allele2,arr.ind = T)
# #new_cancer_subset = maf[,which(colnames(maf)=='Prim'):which(colnames(maf)=='Met7')]
# tmp2 = which(new_cancer_subset=='ALT',arr.ind = T)
# all(tmp1==tmp2)
# 
# fwrite(maf, '435_maf.maf',sep = '\t')