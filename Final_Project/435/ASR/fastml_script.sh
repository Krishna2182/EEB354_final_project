#!/bin/bash

cd ~/Desktop/Phylogenetics/Final_Project/estimated_rates
mkdir ASR
cd ASR
/Applications/FastML/programs/fastml/fastml -s ../../435_aln.fasta -t ../435_mcc.newick -mg -g 8 -qf

cd ~/Desktop/Phylogenetics/Final_Project/fixed_rates
mkdir ASR
cd ASR
/Applications/FastML/programs/fastml/fastml -s ../../435_aln.fasta -t ../435_mcc.newick -mg -g 8 -qf