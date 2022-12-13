# Mutation-associated Increases in the Evolutionary Rates of Cancer
## Introduction and Goals

Human cancers are an example of repeated evolution from a similar ancestor. By tracking this repetitive evolution, we can uncover patterns concerning mutations that tend to be highly recurrent across cancers and establish whether their recurrence is due to a high mutation rate, high selective pressures, or both (Cannataro et al. 2018). Information on selection in useful for guiding the development of targeted therapeutics that will effectively target cancer’s dependencies.

To study selection along the evolutionary trajectories of lung adenocarcinoma (a type of cancer), I have been using a Markov-chain based model of progression through possible mutation states of cancer instead of phylogenetics, for which little sufficient data is available. However, I came across the following problem: selection for mutations appeared to be artificially inflated after the mutation of particular genes, especially the “guardian of the genome” *TP53*. This led me to suspect that certain mutations were increasing the effective mutation rate of cancer cells, creating the artificial selection inflation, but I had no way to measure the increase in mutation rate caused by mutations themselves.

The goal of this project is to assess how mutation rates vary along the branches of tumor phylogenies and how those correlate to the driver mutations occurring on the respective branches. Given the paucity of multi-sample data sufficient for phylogenetic inference, it will likely not be possible to pin increases in mutation rate to specific drivers but rather only to recurrent groups of mutations. Nevertheless, this will be a helpful first step in understanding how mutations can themselves alter the evolutionary rate of cancer.

The methodology of the project is split into three portions. First, Bayesian phylogenetic inference is performed to construct small chronograms from multi-region sample data of several patients. Standard model parameters for tumor phylogenetics will be used (Miura et al. 2022), but an essential aspect is that the rate parameters will be allowed to vary stochastically between sites and branches, according to a relaxed clock model (Drummond et al. 2006). This will allow me to calculate branch-specific posterior distributions of mutation rates across several cases of repeated evolution. Second, for each constructed phylogeny, I also infer a phylogeny given the same parameters but constant mutation rates between branches (strict clock model) to assess whether the difference in likelihood provided by a relaxed clock is significant according to a metric that penalizes the increased complexity of the relaxed clock model (AIC and BIC).

Though not yet implemented, eventually a permutation-based hypothesis test will be performed to determine the significance of the association between significant branches and the branch mutations. This would allow me to determine which mutations/groups of mutations tend to cause increased mutation rates. Though the small size of each tree may produce large distributions of branch-specific mutation rates that impair my ability to assess whether mutations are significantly increasing the mutation rate, I can leverage the repeated evolution aspect of cancer to combine information about several independent rate distributions and their corresponding branch mutations. This will allow me to establish tighter rate distributions.

The data for the phylogenies will come from a 2016 study of metastatic lineages (Zhao et al., 2016), which performed DNA sequencing on normal tissue, primary tissue, and several metastatic sites for several patients of different cancers. For some patients, the primary tumor was resected and sequenced earlier than the metastatic sites, allowing for time-calibration. It is important to note that many of these patients have been treated with chemotherapy, which induces a strong selective pressure. Additionally metastatic samples reside in different tissues, which may expose them to different mutational processes that independently affect the mutation rate variability. This effect can be controlled for through mutational signature deconvolution, but that is outside of the current scope of this project. Although there are limitations to the data, including the aforementioned confounding variables as well the short alignment lengths, this is one of the only publicly available multi-sample cancer datasets that allows for time-calibration, so it will be necessary to make do with the data.


## Methods

In order to infer mutation rates per unit time, it is necessary to have data to time calibrate the tree. Thus, I only considered sets of samples for which the primary tumor was resected and sequenced before the metastatic tumors, which were sequenced during necropsy. This produced three time-points for each patient: birth, primary tumor resection, and death. Based on this criteria, as well as the length of alignments, I chose four cancers for which I would construct phylogenies, described in Table 1.

![Tumor Characteristics](/Final_Project/Images_v2/tumor_characteristics.png)

Table 1. Characteristics of tumor samples used for phylogenetic inference, sourced from Zhao et al., 2016.

BEAST2 was chosen to run Bayesian inference (Bouckaert et al., 2019). In setting up the BEAST2 run, the three timepoints noted above were used as the tip dates (normal sample was dated to birth, primary samples to resection time, and metastatic samples to death). A Gamma Site, HKY model was used in which only the shape of the gamma distribution, the Kappa and equilibrium frequencies were estimated. The HKY model was picked based on the results of IQTree's ModelFinder and because the MCMC was having difficulty converging under a GTR model despite experimentation with the priors. 4 discrete rates were allowed considering the likelihood of rate heterogeneity amongst sites, and 0 sites were allowed to be considered invariant, since only commonly mutated sites were inluded in the sequencing methodologies.

For the phylogeny estimating branch-wise mutation rates, a relaxed clock log normal clock model was used. The fixed rate comparison phylogeny used a strick clock model (this was the only difference between the two setups). A coalescent exponential population prior was used because cancer growths are close to exponential. Additionally, a topology prior was added to force all cancer samples to be monophyletic. Because it is possible for separate metastatic clades to develop from the primary tumor, a topology prior constraining all the metastatic samples into one clade was not implemented. Additionally, a root prior with a uniform distribution was added so that mutations were distributed across the truncal branch. All BEAST setups can be found in the XMLs filed in this repository.

The relaxed clock models were run with a chain length of 100 million. The strict clock models, which generally had better traces, were run with 500 million chain length. Six runs were performed for each phylogeny. This was done to improve parameter sampling as there is a paucity of data within most of these alignments from which to accurately infer mutation rates and other estimated parameters. The additional runs helped create more reliable traces and better effective sample sizes. Many relaxed clock runs failed because too many posterior corrections were required, so they were programmatically restarted with a different seed when they failed until the run finished. Though this indicates issues with the data, this is a common problem with Bayesian analysis of cancer data and improves dramatically as more sites are sequenced. For example, alignment 407 is several times longer than alignment 435 and thus had a much lower failure frequency.

Once all runs were completed, the logs and trees were combined with a 20% burn-in, and a maximum clade credibility (MCC) tree was constructed using mean heights. The relaxed clock and strict clock models were compared using a likelihood ratio test, AIC, and BIC. Ancestral state reconstruction was performed using FastML with a HKY model and 4 gamma rate categories (Ashkenazy et al., 2012). A script was then used to map mutations from the original mutation matrix to the branches they occurred on according to the ancestral state reconstruction. The resultant MAF file was loaded into cancereffectsizeR to annotate the variants and determine the amino acid changes resulting from the mutations (Cannataro et al., 2018).

## Results

### Chronograms

The relaxed clock chronograms for each of the four tumors are shown below. 

![407 Relaxed Clock Chronogram](/Final_Project/Images_v2/mcc_407_estimated.tree.png)

Figure 1. Relaxed clock chronogram for tumor 407. The branches are annotated with 95% HPD intervals for rate.

Note that the rate intervals are often wide and overlap. This remains a consistent trend for the other tumors and is a result of the data limitations that we necessarily deal with in cancer phylogenetics. Interestingly, the cancer also appears to be highly homogenous. From the perspective of treatment, this is valuable because it means that the cancer does not have reservoirs of genetic variation that will allow it to recur after the strong selective pressure induced by treatment.

![408 Relaxed Clock Chronogram](/Final_Project/Images_v2/mcc_408_estimated.tree.png)

Figure 2. Relaxed clock chronogram for tumor 408. The branches are annotated with 95% HPD intervals for rate.

The rate intervals are much more constrained in this chronogram and sometimes do not overlap. However, the primary sample branch has an unusually large upper bound for the mutation rate.

![435 Relaxed Clock Chronogram](/Final_Project/Images_v2/mcc_435_estimated.tree.png)

Figure 3. Relaxed clock chronogram for tumor 435. The branches are annotated with the median rate.

Despite the large number of metastatic sites, they all seemed to diverge within a relatively short time span, suggesting a critical metastasis-inducing event. This could possibly be linked to other clinical occurences within the patient at that time, such as inflammation that may have promoted the epithelial-mesenchymal transition necessary for metastasis (López-Novoa and Angela Nieto 2009).

![458 Relaxed Clock Chronogram](/Final_Project/Images_v2/mcc_458_estimated.tree.png)

Figure 4. Relaxed clock chronogram for tumor 458. The branches are annotated with the median rate.

This chronogram provides the least reliable rate intervals, so its results should be interpreted with caution. We can note, at least, that there appears to be a high degree of homogeneity amongst the metastatic samples (compared to 407, in which all cancer sites were homogeneous).

#### Traces

Though most of the traces for the MCMC runs were satisfactory (including all of the strict clock trees), a couple were not as stable, namely the traces for 435 and 458. Example traces are shown in figure 5. 

![Traces](/Final_Project/Images_v2/traces.png)

Figure 5. Likelihod traces from the MCMC runs.

Note that tumor 435 had the shortest alignment length, which likely contributed to the difficulty of getting satisfactory traces.

### Model Comparison

The results of the model comparison are shown in figure 6.

![Model Comparison](/Final_Project/Images_v2/model_comparison.png)

Figure 6. Comparison of relaxed clock and strict clock models by likelihood ratio test with alpha of 0.01, AIC, and BIC.

The relaxed clock model was found to have a significantly higher likelihood by the likelihood ratio test, and it was considered to be a better model despite the increased number of estimated parameters (as indicated by the lower AIC and BIC). This indicates that the branch rates do tend to vary during cancer evolution, even if our ability to compare rate intervals is limited.

### Rate variation within tumors reveals no significant trend towards increased mutation rate.

To investigate whether mutation rates tend to increase as cancer progresses, I took the ratio of the rate on each branch to the rate on its parent/previous branch, which indicates the relative change in mutation rate at each bifurcation. I plotted those ratios on every branch within each tumor below.

![Relative branch rates](/Final_Project/Images_v2/Tumor_Rel_Rates.png)

Figure 7. Relative changes in mutation rate across the four tumors.

Based on the distribution of relative changes, there does not appear to be strong evidence towards a general increase or decrease in mutation rate during cancer progression. Additionally, it does not seem like there exists a relationship between the relative age of the node and the direction of relative rate change (i.e., the branches leading to the tip do not seem to have unusually more positive rate changes relative to more internal branches.)

There are several possible reasons we might not see a generally increasing mutation rate in cancers. For example, immune surveillance may select against highly mutated cancers, which are more immunogenic. Thus, cancer lineages which obtained excessively destabilizing mutations may die off before we can sample them. Since immune cells have difficulty penetrating tumors, internal cells may be shielded from the immune selective pressure, so multiple-sampling of a single tumor may help us understand if destabilizing mutations are still being gained late in cancer progression. Another reason we might not see more destabilization is that too much genome and cellular instability can directly cause cell death.

Additionally, variation in mutation rate is confounded by the fact that the primary and metastatic tumors are in different tissue types. Each of these tissue types have their own associated mutation rate covariates as well unique sets of mutational processes, so the anatomical location of each node could have a significant influence on its branch rate. This would also affect each of the different cancer types differently.

### Mutations in certain genes are possibly associated with directional shifts in mutation rate

To address the original question, I plotted the relative rate changes for the branches upon which the most commonly observed mutations were found.

![Relative branch rates by gene](/Final_Project/Images_v2/Gene_Rel_Rates.png)

Figure 8. Gene-associated changes in relative mutation rates. CDH23 is a cadherin, cell-cell adhesion protein. Mutations to the same gene in the same tumor are either at different sites, are reversions, or are homoplasies. 

EPHA6 is a biomarker for breast cancer (Zhou et al., 2018). FBXO46 degrades FBXO31, which is a protein key for genomic stability. SAFB2 is involved in the stress response and cell cycle regulation (NCBI). TP53 is the classically known tumor suppressor and "guardian of the genome." And TTN is a very large human gene that we see commonly mutated in human cancers. It is not known to have any carcinogenic function, so its mutation is likely a product of its size and genome instability.

Of the most recurrently mutated genes in this dataset, the majority are strongly associated with directional shifts in mutation rate. Here we see that CDH23, FBXO46, SAFB2, and TP53 mutations are associated with decreases in mutation rate while EPHA6 and TTN mutations are associated with increases in mutation rate. However, it is also important to note that many of the rate intervals between branches overlap, and so we often cannot make conclusions with significance.

Because FBXO46 degrades a genome-stabilizing protein, it makes sense that its mutation might decreases the general mutation rate. However, in the case of TP53, we should expect that the mutation rate should increase following its mutation, given its role as a stabilizing protein. We do not observe that here, though it should be noted that all TP53 mutations were found to occur on the branch leading to the cancer lineage. This branch contains the majority of mutations and is long, so it might be the case that the effect of TP53's mutation on the cancer is being drowned out by other mutations or by external agents. We do expect TP53 to be commonly mutated on this branch given its role in driving carcinogenesis.

Though TTN is associated with an increased mutation rate, there is very little reason to believe that is itself causing the increased mutation rate because it is just a muscle protein. We may see this association because TTN is more commonly mutated when the genome has already become unstable.

## Discussion and Future Work

The results indicate that mutation rates do vary along the branches of cancer phylogenies. However, with our current data, we cannot determine the precise nature of the changes in mutation rate along each branch, since the rate intervals are often too wide and overlap. Additionally, genetic mutations do appear to be associated with directional shifts in mutation rate, with possible causal links in the literature. Nevertheless, the findings so far are 
association-based, as is exemplified by the case of TP53 -- in which we have strong reason to suspect its mutation to increase the mutation rate yet find an association with a decreased mutation rate -- and TTN -- which is consistently associated with a higher mutation rate despite having no known effect on genome or cellular stability. These associations are dependent on changes in mutation rates that may not be significant, which highlights the necessity of having longer reads to perform phylogenetic inference with.

In considering future work, it may be helpful to consider the association of groups of related genes with changes in mutation rate to preserve power. Additionally, given more sequence data, it may be feasible to mask potential rate-shifting sites from the inference algorithm and observe whether the relative changes in mutation rate it infers remains consistent. If a site was truly rate-shifting (stabilizing or destabilizing), the effect of its mutation should be evident in the increased or decreased mutation rate at all other sites, so the inferred mutation rate of the branch which it occured should be robust to its exclusion. This analysis would move one step further towards causal inference.

With the current data, I could check for associations between the age of the node and the trends in relative changes in mutation rate as well as compare variability in mutation rates and relative rate changes as metastases form. Increasing rate variability due to the different cellular environments and adaptive landscapes would be another form of heterogeneity that might make systemic treatment more difficult.

I would also like to consider the influence of other sources of variation in mutation rate. The most significant would be the influence of tissue type and endogenous and exogenous mutational processes, but I may want to additionally consider possible evolutionary pressures for and against increased mutation rates like immune surveillance and resource competition. These would allow me to make more precise conclusions about the true causes for rate variation within a tumor and amongst its metastatic sites.

## Conclusion

In summary, this project has developed an initial framework to study mutation-associated variability in the mutation rates of cancer throughout its progression. Though the lack of data makes it difficult to state conclusions, we broadly do not observe a trend in relative rate changes as cancer progresses and do appear to find associations between mutations and the degree and direction of relative rate changes. Further data will provide more power to make conclusions, enable analyses of causality, and enable the consideration of confounding variables such as endogenous and exogenous mutational processes and evolutionary pressures.

## References

- Alexandrov, L. B., Kim, J., Haradhvala, N. J., Huang, M. N., Tian Ng, A. W., Wu, Y., Boot, A., Covington, K. R., Gordenin, D. A., Bergstrom, E. N., Islam, S. M. A., Lopez-Bigas, N., Klimczak, L. J., McPherson, J. R., Morganella, S., Sabarinathan, R., Wheeler, D. A., Mustonen, V., PCAWG Mutational Signatures Working Group, … PCAWG Consortium. (2020). The repertoire of mutational signatures in human cancer. Nature, 578(7793), 94–101.
Cannataro, V. L., Gaffney, S. G., & Townsend, J. P. (2018). Effect Sizes of Somatic Mutations in Cancer. Journal of the National Cancer Institute, 110(11), 1171–1177.

- Ashkenazy, H., Penn, O., Doron-Faigenboim, A., Cohen, O., Cannarozzi, G., Zomer, O., & Pupko, T. (2012). FastML: a web server for probabilistic reconstruction of ancestral sequences. Nucleic Acids Research.

- Bouckaert, R., Vaughan, T. G., Barido-Sottani, J., Duchêne, S., Fourment, M., Gavryushkina, A., Heled, J., Jones, G., Kühnert, D., De Maio, N., Matschiner, M., Mendes, F. K., Müller, N. F., Ogilvie, H. A., du Plessis, L., Popinga, A., Rambaut, A., Rasmussen, D., Siveroni, I., … Drummond, A. J. (2019). BEAST 2.5: An advanced software platform for Bayesian evolutionary analysis. PLoS Computational Biology, 15(4), e1006650.

- Cannataro, V. L., Gaffney, S. G. & Townsend, J. P. (2018). Effect Sizes of Somatic Mutations in Cancer. J. Natl. Cancer Inst. 110, 1171–1177.

- Choppara, S., Ganga, S., Manne, R., Dutta, P., Singh, S., & Santra, M. K. (2018). The SCF ubiquitin ligase complex mediates degradation of the tumor suppressor FBXO31 and thereby prevents premature cellular senescence. The Journal of Biological Chemistry, 293(42), 16291–16306.

- Drummond, A. J., Ho, S. Y. W., Phillips, M. J., & Rambaut, A. (2006). Relaxed Phylogenetics and Dating with Confidence. In PLoS Biology (Vol. 4, Issue 5, p. e88). https://doi.org/10.1371/journal.pbio.0040088

- Fisk, J. N., Mahal, A. R., Dornburg, A., Gaffney, S. G., Aneja, S., Contessa, J. N., Rimm, D., Yu, J. B., & Townsend, J. P. (2022). Premetastatic shifts of endogenous and exogenous mutational processes support consolidative therapy in EGFR-driven lung adenocarcinoma. Cancer Letters, 526, 346–351.

- López-Novoa, J. M., & Angela Nieto, M. (2009). Inflammation and EMT: an alliance towards organ fibrosis and cancer progression. EMBO Molecular Medicine, 1(6-7), 303.

- Miura, S., Vu, T., Choi, J., Townsend, J. P., Karim, S., & Kumar, S. (2022). A phylogenetic approach to study the evolution of somatic mutational processes in cancer. In Communications Biology (Vol. 5, Issue 1). https://doi.org/10.1038/s42003-022-03560-0

- National Center for Biotechnology Information (NCBI)[Internet]. Bethesda (MD): National Library of Medicine (US), National Center for Biotechnology Information; [1988] – [cited 2022 Dec 08]. Available from: https://www.ncbi.nlm.nih.gov/

- Zhao, Z.-M., Zhao, B., Bai, Y., Iamarino, A., Gaffney, S. G., Schlessinger, J., Lifton, R. P., Rimm, D. L., & Townsend, J. P. (2016). Early and multiple origins of metastatic lineages within primary tumors. Proceedings of the National Academy of Sciences of the United States of America, 113(8), 2140–2145.

- Zhou, D., Ren, K., Wang, J., Ren, H., Yang, W., Wang, W., Li, Q., Liu, X., & Tang, F. (2018). Erythropoietin-producing hepatocellular A6 overexpression is a novel biomarker of poor prognosis in patients with breast cancer. Oncology Letters, 15(4), 5257–5263.
