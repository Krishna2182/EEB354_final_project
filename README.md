# Phylogenetic Biology - Final Project

## Guidelines - you can delete this section before submission

This is a stub for your final project. Edit/ delete the text in this readme as needed.

There are two ways you can use this document:  
- You can download this file to a folder on your computer, edit this document and add other files (data, code, etc), and then zip up and submit the folder on canvas.
- You can for the [repository](finalproject) containing this document on gitub. Then commit and push your canges to the repository, and submit a link to the repository on canvas.

Github is a great way to work on projects, but also has a steep initial learning curve.


Some guidelines and tips:

- Use the stubs below to write up your final project. Alternatively, if you would like the writeup to be an executable document (with [knitr](http://yihui.name/knitr/), [jupytr](http://jupyter.org/), or other tools), you can create it as a separate file and put a link to it here in the readme.

- For information on formatting text files with markdown, see https://guides.github.com/features/mastering-markdown/ . You can use markdown to include images in this document by linking to files in the repository, eg `![GitHub Logo](/images/logo.png)`.

- The project must be entirely reproducible. In addition to the results, the repository must include all the data (or links to data) and code needed to reproduce the results.

- If you are working with unpublished data that you would prefer not to publicly share at this time, please contact me to discuss options. In most cases, the data can be anonymized in a way that putting them in a public repo does not compromise your other goals.

- Paste references (including urls) into the reference section, and cite them with the general format (Smith at al. 2003).

OK, here we go.

# Mutation-associated Increases in the Evolutionary Rates of Non-small Cell Lung Cancer
## Introduction and Goals

Human cancers are an example of repeated evolution from a similar ancestor. By tracking this repetitive evolution, we can uncover patterns concerning mutations that tend to be highly recurrent across cancers and establish whether their recurrence is due to a high mutation rate, high selective pressures, or both (Cannataro et al. 2018). Information on selection in useful for guiding the development of targeted therapeutics that will effectively target cancer’s dependencies.

To study selection along the evolutionary trajectories of lung adenocarcinoma (a type of cancer), I have been using a Markov-chain based model of progression through possible mutation states of cancer instead of phylogenetics, for which little sufficient data is available. However, I came across the following problem: selection for mutations appeared to be artificially inflated after the mutation of particular genes, especially the “guardian of the genome” *TP53*. This led me to suspect that certain mutations were increasing the effective mutation rate of cancer cells, creating the artificial selection inflation, but I had no way to measure the increase in mutation rate caused by mutations themselves.

The goal of this project will be to assess how mutation rates vary along the branches of tumor phylogenies and how those correlate to the driver mutations occurring on the respective branches. Given the paucity of multi-sample data sufficient for phylogenetic inference, it will likely not be possible to pin increases in mutation rate to specific drivers but rather only to recurrent groups of mutations. Nevertheless, this will be a helpful first step in understanding how mutations can themselves alter the evolutionary rate of cancer.

The methodology of the project will be split into three portions. First, Bayesian phylogenetic inference will be performed to construct small ultrametric trees from multi-region sample data of several patients. Standard model parameters for tumor phylogenetics will be used (Miura et al. 2022), but an essential aspect is that the rate parameters will be allowed to vary stochastically between sites and branches, according to a relaxed clock model (Drummond et al. 2006). This will allow me to calculate branch-specific posterior distributions of mutation rates across several cases of repeated evolution. Second, for each constructed phylogeny, I will also infer a phylogeny given the same parameters but constant mutation rates between branches to assess whether the difference in likelihood is significant according to a metric that penalizes the increased complexity of the relaxed clock model (AIC, BIC, etc.).

Hypothesis tests can be performed to see if branch-specific mutation rates differ significantly from their parent branch. A permutation-based hypothesis test can be performed to determine the significance of the association between significant branches and the branch mutations. This would allow me to determine which mutations/groups of mutations tend to cause increased mutation rates. Though the small size of each tree may produce large distributions of branch-specific mutation rates that impair my ability to assess whether mutations are significantly increasing the mutation rate, I can leverage the repeated evolution aspect of cancer to combine information about several independent rate distributions and their corresponding branch mutations. This should allow me to establish tighter rate distributions.

The data I will use to construct phylogenies will come from the 2017 TracerX lung cancer study (Jamal-Hanjani et al. 2017), which performed multi-region sampling (2-8 samples per tumor) of 100 non-small cell lung cancer patients, who had not previously received systemic treatment. This data is valuable to my analysis because 1) it is one of the few cases of publicly available multi-region tumor sample data, 2) the samples are from the same tumor rather than metastatic lineages, allowing for the assumption that the mutational processes affecting each lineage should be approximately equal—an essential assumption because mutational processes have a significant influence on mutation rates (Alexandrov et al. 2020), and 3) the patients had not yet received treatment, because treatment would have altered cancer evolution and mutation rates (Fisk et al. 2022). As part of my analysis, I will need to determine whether phylogenetic inference can accurately and informatively be performed on the 39 patients who only had 2 samples taken.


## Methods

The tools I used were... See analysis files at (links to analysis files).

## Results

The tree in Figure 1...

## Discussion

These results indicate...

The biggest difficulty in implementing these analyses was...

If I did these analyses again, I would...

## References

- Alexandrov, L. B., Kim, J., Haradhvala, N. J., Huang, M. N., Tian Ng, A. W., Wu, Y., Boot, A., Covington, K. R., Gordenin, D. A., Bergstrom, E. N., Islam, S. M. A., Lopez-Bigas, N., Klimczak, L. J., McPherson, J. R., Morganella, S., Sabarinathan, R., Wheeler, D. A., Mustonen, V., PCAWG Mutational Signatures Working Group, … PCAWG Consortium. (2020). The repertoire of mutational signatures in human cancer. Nature, 578(7793), 94–101.
Cannataro, V. L., Gaffney, S. G., & Townsend, J. P. (2018). Effect Sizes of Somatic Mutations in Cancer. Journal of the National Cancer Institute, 110(11), 1171–1177.

- Drummond, A. J., Ho, S. Y. W., Phillips, M. J., & Rambaut, A. (2006). Relaxed Phylogenetics and Dating with Confidence. In PLoS Biology (Vol. 4, Issue 5, p. e88). https://doi.org/10.1371/journal.pbio.0040088

- Fisk, J. N., Mahal, A. R., Dornburg, A., Gaffney, S. G., Aneja, S., Contessa, J. N., Rimm, D., Yu, J. B., & Townsend, J. P. (2022). Premetastatic shifts of endogenous and exogenous mutational processes support consolidative therapy in EGFR-driven lung adenocarcinoma. Cancer Letters, 526, 346–351.

- Jamal-Hanjani, M., Wilson, G. A., McGranahan, N., Birkbak, N. J., Watkins, T. B. K., Veeriah, S., Shafi, S., Johnson, D. H., Mitter, R., Rosenthal, R., Salm, M., Horswell, S., Escudero, M., Matthews, N., Rowan, A., Chambers, T., Moore, D. A., Turajlic, S., Xu, H., … TRACERx Consortium. (2017). Tracking the Evolution of Non-Small-Cell Lung Cancer. The New England Journal of Medicine, 376(22), 2109–2121.

- Miura, S., Vu, T., Choi, J., Townsend, J. P., Karim, S., & Kumar, S. (2022). A phylogenetic approach to study the evolution of somatic mutational processes in cancer. In Communications Biology (Vol. 5, Issue 1). https://doi.org/10.1038/s42003-022-03560-0
