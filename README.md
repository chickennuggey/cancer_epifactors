# Epigenetic Factor of Cancer Types using different types of clustering

Based on the following paper: [Pan-cancer landscape of epigenetic factor expression predicts tumor outcome](https://www.nature.com/articles/s42003-023-05459-w#data-availability)

### Current status of this research
The research provides a pan-cancer analysis of epigenetic factors across 24 adult cancer types, using TCGA to explore their impact on tumor heterogeneity and patient outcomes. 
It uncovers distinct clusters of tumors based on epigenetic factor expressions, which correlate with prognostic implications, suggesting potential as biomarkers and therapeutic targets. 
The study helps with understanding the epigenetic landscape’s role in cancer.

### Abstract
This study explores the mechanisms governing pediatric cancers, with a focus on understanding the role of epigenetic factors in disease initiation, progression, and therapeutic response. A comprehensive analysis is conducted using k-means and neural networks on 5 types of pediatric cancer: osteosarcoma (OS), neuroblastoma (NBL), acute myeloid leukemia (AML), Wilms Tumor (WT), and acute lymphoblastic leukemia (ALL), which involve distinct epigenetic mechanisms in cancer progression. 

Data collection involved obtaining raw RNA counts for the mentioned cancer types from TARGET,  which is in The Cancer Genome Atlas (TCGA), resulting in nearly 1000 samples. Samples that excluded the lower 25% of gene expressions were filtered out, focusing on significantly expressed genes for each cancer type. K-means clustering and neural networks were applied to analyze the gene expression data, identifying the specific patterns associated with each cancer type. The accuracy of the clustering method ranged from 82.5% to 100%, demonstrating its effectiveness in classifying cancer types. Out of the 2 analysis methods, the neural network scored higher than k-means clustering, with an average accuracy of 99.49%. High accuracy rates indicate confidence in predicting cancer types based on gene expression data models.

Overall, this research contributes significantly to our understanding of pediatric cancer and paves the way for innovative strategies aimed at improving clinical outcomes and patient care. Clustering and neural networks can be used as potential biomarkers for early detection and targeted therapy, tailoring to each individual’s patient's conditions with high accuracy.


### Methodology
#### - [Data Collection](https://github.com/rghosh1353/cancer_epifactors/tree/main/01_data_collection)
#### - [Filtering](https://github.com/rghosh1353/cancer_epifactors/tree/main/02_filtering)
#### - [K-Means Clustering](https://github.com/rghosh1353/cancer_epifactors/tree/main/03_K-means_clustering)
#### - [Neural Networks](https://github.com/rghosh1353/cancer_epifactors/tree/main/neural_network)
