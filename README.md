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

# Mutation-associated Increases in the Evolutionary Rates of Cancer
## Introduction and Goals

Human cancers are an example of repeated evolution from a similar ancestor. By tracking this repetitive evolution, we can uncover patterns concerning mutations that tend to be highly recurrent across cancers and establish whether their recurrence is due to a high mutation rate, high selective pressures, or both (Cannataro et al. 2018). Information on selection in useful for guiding the development of targeted therapeutics that will effectively target cancer’s dependencies.

To study selection along the evolutionary trajectories of lung adenocarcinoma (a type of cancer), I have been using a Markov-chain based model of progression through possible mutation states of cancer instead of phylogenetics, for which little sufficient data is available. However, I came across the following problem: selection for mutations appeared to be artificially inflated after the mutation of particular genes, especially the “guardian of the genome” *TP53*. This led me to suspect that certain mutations were increasing the effective mutation rate of cancer cells, creating the artificial selection inflation, but I had no way to measure the increase in mutation rate caused by mutations themselves.

The goal of this project will be to assess how mutation rates vary along the branches of tumor phylogenies and how those correlate to the driver mutations occurring on the respective branches. Given the paucity of multi-sample data sufficient for phylogenetic inference, it will likely not be possible to pin increases in mutation rate to specific drivers but rather only to recurrent groups of mutations. Nevertheless, this will be a helpful first step in understanding how mutations can themselves alter the evolutionary rate of cancer.

The methodology of the project will be split into three portions. First, Bayesian phylogenetic inference will be performed to construct small ultrametric trees from multi-region sample data of several patients. Standard model parameters for tumor phylogenetics will be used (Miura et al. 2022), but an essential aspect is that the rate parameters will be allowed to vary stochastically between sites and branches, according to a relaxed clock model (Drummond et al. 2006). This will allow me to calculate branch-specific posterior distributions of mutation rates across several cases of repeated evolution. Second, for each constructed phylogeny, I will also infer a phylogeny given the same parameters but constant mutation rates between branches to assess whether the difference in likelihood is significant according to a metric that penalizes the increased complexity of the relaxed clock model (AIC, BIC, etc.).

A permutation-based hypothesis test will be performed to determine the significance of the association between significant branches and the branch mutations. This would allow me to determine which mutations/groups of mutations tend to cause increased mutation rates. Though the small size of each tree may produce large distributions of branch-specific mutation rates that impair my ability to assess whether mutations are significantly increasing the mutation rate, I can leverage the repeated evolution aspect of cancer to combine information about several independent rate distributions and their corresponding branch mutations. This should allow me to establish tighter rate distributions.

The data I will use to construct phylogenies will come from a 2016 study of metastatic lineages (Zhao et al., 2016), which performed sequencing on normal tissue, primary tissue, and several metastatic sites for several patients of different cancers. For some patients, the primary tumor was resected and sequenced earlier than the metastatic sites, allowing for time-calibration. It is important to note that many of these patients have been treated with chemotherapy, which induces a strong selective pressure. Additionally metastatic samples reside in different tissues, which may expose them to different mutational processes that independently affect the mutation rate variability. This effect can be controlled for through mutational signature deconvolution, but that is outside of the current scope of this project. Although there are limitations to the data, including the aforementioned confounding variables as well the short alignment lengths, this is one of the only publicly available multi-sample cancer datasets that allows for time-calibration, so it will be necessary to make do with the data.


## Methods

In order to infer mutation rates per unit time, it is necessary to have data to time calibrate the tree. Thus, I only considered sets of samples for which the primary tumor was resected and sequenced before the metastatic tumors, which were sequenced during necropsy. This produced three time-points for each patient: birth, primary tumor resection, and death. Currently, I have produced trees for alignments 435 (lung adenocarcinoma) and 407 (endometrial cancer), though I plan to also attempt further alignments to gain a more comprehensive understanding of rate variability and the contribution of mutations across cancer types.

In setting up the BEAST2 run, these three timepoints were used as the tip dates (normal sample was dated to birth, primary samples to resection time, and metastatic samples to death). A Gamma Site, GTR model was used in which the substitution rate, shape of the gamma distribution, the N --> N rates and equilibrium frequencies were estimated. 8 discrete rates were allowed, and 0 sites were allowed to be considered invariant, since only commonly mutated sites were inluded in the sequencing methodologies.

For the phylogeny estimating branch-wise mutation rates, a relaxed clock log normal clock model was used. The fixed rate comparison phylogeny used a strick clock model (this was the only difference between the two setups). A coalescent exponential population prior was used because cancer growths are close to exponential. Additionally, a topology prior was added to force all cancer samples to be monophyletics. Because it is possible for separate metastatic clades to develop from the primary tumor, a topology prior constraining all the metastatic samples into one clade was not implemented. Additionally, a root prior with a uniform distribution was added so that mutations were distributed across the truncal branch. Though not currently implemented, I will also include a topology constraining prior for the strict clock inference based on the topology inferred from the relaxed clock inference. This is because in the case of alignment 407, the topologies slightly differed between the two, and both topologies had high posterior probabilities. AlteringAll BEAST setups can be found in the XMLs filed in this repository.

All MCMC runs will eventually be of 500 million chain length. Currently, alignment 435 has been run with that length and 407 was run with only 50 million (but will be extended). Additionally, six runs were performed for each alignment. This was done to improve parameter sampling as there is a paucity of data within most of these alignments from which to accurately infer mutation rates and other estimated parameters. The additional runs helped create more reliable traces and better effective sample sizes. Many runs failed because too many posterior corrections were required, so they were programmatically restarted with a different seed when they failed until the run finished. Though this indicates issues with the data, this is a common problem with Bayesian analysis of cancer data and improves dramatically as more sites are sequenced. Alignment 407 is several times longer than alignment 435 and thus had a much lower failure frequency.

Once all runs were completed, the logs and trees were combined with a 20% burn-in, and a maximum clade credibility (MCC) tree was constructed. Model comparison between strict clock and relaxed clock models will be performed using AIC and BIC once all inferrences have been run with 500 million chain length and a consistent set of priors. Ancestral state reconstruction was performed using FastML with a GTR model and 8 gamma rate categories. A script was then used to map mutations from the original mutation matrix to the branches they occurred on according to the ancestral state reconstruction. These mutations will then be identified by the gene the occurred in to offer insight into the mutations occuring on each branch.

## Results

### 435

Six runs of 50 million chain length were completed. After the 20% burn-in, the traces were examined and an MCC tree was constructed, followed by ancestral state reconstruction and mutation mapping.

Though the effective sample size (ESS) for certain parameters was relatively low, many were sufficiently high, including the likelihood. The likelihood trace is shown below:
![Likelihood trace for alignment 435](/Final_Project/Images/435_likelihood_trace.png)

Six runs of 500 million chain length were also completed, and the ESS and trace appeared to significantly improve, as shown below. However, it appears that for a short time, one of the runs entered an extremely different parameter sampling space, resulting in trace plots that are hard to interpret. For example, the likelihood suddenly spiked from negative likelihoods to positive tens of thousands for just a small number of runs. For this reason, the 500 million chain length results are not included here but will modified and posted soon.
![Stats for alignment 435](/Final_Project/Images/435_run_stats.png)

The MCC trees for both the relaxed clock and strict models are shown below, in that order. Posterior probabilities are displayed on the nodes. 95% confidence intervals for rates inferred by the relaxed clock inference are displayed on the branches.

![435 relaxed clock maximum clade credibility tree](/Final_Project/Images/435_mcc_relaxed.tree.png)

![435 strict clock maximum clade credibility tree](/Final_Project/Images/435_mcc_strict.tree.png)

The mean log likelihood for the relaxed model was -545.061, and the mean log likelihood for the strict model was -564.775. Because I have not been able to ascertain the exact degrees of freedom from the BEAST setup, I have not compared the models by AIC/BIC yet.

Once ancestral state reconstruction was performed, the mutations were programmatically mapped onto the tree. A snapshot of the results are shown below. The rest can be found by running the Rmd document in the repository. 

![435 mutations mapped to branches](/Final_Project/Images/435_tree_maf.png)

### 407

Similarly, six runs of 50 million chain length were completed. A 20% burn-in was used, an MCC tree was constructed, and ancestral state reconstruction was performed.

The traces also appeared acceptable for this alignment, though the ESS was still relatively low for certain parameters. Shown below is the likelihood trace.

![407 likelihood trace](/Final_Project/Images/407_likelihood_trace.png)

The MCC trees for the relaxed and strict clock models are shown below, in that order. Again, posterior probabilities are shown on the nodes, and for the relaxed clock model, 95% confidence intervals for the rates are shown on the branches.

![407 relaxed clock maximum clade credibility tree](/Final_Project/Images/407_mcc_relaxed.tree.png)

![407 strict clock maximum clade credibility tree](/Final_Project/Images/407_mcc_strict.tree.png)

The mean log likelihood for the relaxed model was -3015.937, and the mean log likelihood for the strict model was -3041.73. 

Ancestral state reconstruction has not yet been performed but will be soon.

## Discussion

The relaxed clock models tend to have a slightly higher likelihood, as expected given that they have allow for more parameter estimation. A formal model comparison has not been implemented yet but will be used to compare the two clock models once 500 million chain length runs has been completed.

In the relaxed clock models, the rates do appear to vary across branches. With alignment 435, we see some instances where the 95% CI's don't overlap. However, many of the intervals stretch to nearly 0, a symptom of the lack of data for this alignment. The increased chain length may help tighten this distribution. Nevertheless, it may still be more productive to focus on other alignments that sequenced more sites. Support for this is evident in the MCC tree for alignment 407, where the 95% CI's are much tighter, due to the fact that 722 sites were included in the alignment compared to 94 in alignment 435.

Additionally, the majority of mutations seem to occur on the branch leading to the primary tumor and from the primary tumor to the metastatic lineages. This limits the selection of possible rate-shifting sites, but it also suggests that observed variability may be due more so to external factors of the metastatic environment than to internal mutations.

Below is shown the mutations per branch described by the child node that the branch leads to.
![435 mutations per branch](/Final_Project/Images/branch_mutations.png)
![435 ASR tree](/Final_Project/Images/435_ASR.png)

## To-Do

- Constrain topology in priors. Done
- Constrain truncal branch length. Done, kinda?
- Compare Likelihoods and Relaxed Clock and Strict Clock AIC and BIC
- Adjust ASR-MAF script to map mutations to branches. Done.
- Adjust priors for estimated and fixed runs based on BEAST slurm outputs. Done - though maybe this is misleading
- Incorporate info on doubling time to constrain substitution rate distribution prior.
- Determine if it would be possible to do a permutation test for branch mutations and mutation rate.
- Useful plots? how rate variability varies with clade age (does it increase? could decrease bc immune surveillance), some way to compare clade-wide rate variability to see if trends in rate changes remain consistent within clades or are somewhat random?, boxplots of commonly observed mutations and their associated relative rate changes

## References

- Alexandrov, L. B., Kim, J., Haradhvala, N. J., Huang, M. N., Tian Ng, A. W., Wu, Y., Boot, A., Covington, K. R., Gordenin, D. A., Bergstrom, E. N., Islam, S. M. A., Lopez-Bigas, N., Klimczak, L. J., McPherson, J. R., Morganella, S., Sabarinathan, R., Wheeler, D. A., Mustonen, V., PCAWG Mutational Signatures Working Group, … PCAWG Consortium. (2020). The repertoire of mutational signatures in human cancer. Nature, 578(7793), 94–101.
Cannataro, V. L., Gaffney, S. G., & Townsend, J. P. (2018). Effect Sizes of Somatic Mutations in Cancer. Journal of the National Cancer Institute, 110(11), 1171–1177.

- Drummond, A. J., Ho, S. Y. W., Phillips, M. J., & Rambaut, A. (2006). Relaxed Phylogenetics and Dating with Confidence. In PLoS Biology (Vol. 4, Issue 5, p. e88). https://doi.org/10.1371/journal.pbio.0040088

- Fisk, J. N., Mahal, A. R., Dornburg, A., Gaffney, S. G., Aneja, S., Contessa, J. N., Rimm, D., Yu, J. B., & Townsend, J. P. (2022). Premetastatic shifts of endogenous and exogenous mutational processes support consolidative therapy in EGFR-driven lung adenocarcinoma. Cancer Letters, 526, 346–351.

- Miura, S., Vu, T., Choi, J., Townsend, J. P., Karim, S., & Kumar, S. (2022). A phylogenetic approach to study the evolution of somatic mutational processes in cancer. In Communications Biology (Vol. 5, Issue 1). https://doi.org/10.1038/s42003-022-03560-0

- Zhao, Z.-M., Zhao, B., Bai, Y., Iamarino, A., Gaffney, S. G., Schlessinger, J., Lifton, R. P., Rimm, D. L., & Townsend, J. P. (2016). Early and multiple origins of metastatic lineages within primary tumors. Proceedings of the National Academy of Sciences of the United States of America, 113(8), 2140–2145.
