# Epigenetic Factor of Pediatric Cancer Types using different types of Clustering and Neural Networks

By: Ria Ghosh, Briana Nguyen, Julie Reyes, Sarala Sharma, Jane Zhao

Based on the following paper: [Pan-cancer landscape of epigenetic factor expression predicts tumor outcome](https://www.nature.com/articles/s42003-023-05459-w#data-availability)

### Overview
The research provides a pan-cancer analysis of epigenetic factors across 24 adult cancer types, using TCGA to explore their impact on tumor heterogeneity and patient outcomes. 
It uncovers distinct clusters of tumors based on epigenetic factor expressions, which correlate with prognostic implications, suggesting potential as biomarkers and therapeutic targets. 
The study helps with understanding the epigenetic landscape’s role in cancer.

### Abstract
This study explores the mechanisms governing pediatric cancers, with a focus on understanding the role of epigenetic factors in disease initiation, progression, and therapeutic response. A comprehensive analysis is conducted using k-means and neural networks on 5 types of pediatric cancer: osteosarcoma (OS), neuroblastoma (NBL), acute myeloid leukemia (AML), Wilms Tumor (WT), and acute lymphoblastic leukemia (ALL), which involve distinct epigenetic mechanisms in cancer progression. 

Data collection involved obtaining raw RNA counts for the mentioned cancer types from TARGET,  which is in The Cancer Genome Atlas (TCGA), resulting in nearly 1000 samples. Samples that excluded the lower 25% of gene expressions were filtered out, focusing on significantly expressed genes for each cancer type. K-means clustering and neural networks were applied to analyze the gene expression data, identifying the specific patterns associated with each cancer type. 

Overall, this research contributes significantly to our understanding of pediatric cancer and paves the way for innovative strategies aimed at improving clinical outcomes and patient care. Clustering and neural networks can be used as potential biomarkers for early detection and targeted therapy, tailoring to each individual’s patient's conditions with high accuracy.


### Methodology
#### Data Collection
* Raw RNA counts were obtained for five types of pediatric cancer: osteosarcoma (OS), neuroblastoma (NBL), acute myeloid leukemia (AML), Wilms Tumor (WT), and acute lymphoblastic leukemia (ALL) from the TARGET dataset within TCGA.
#### Filtering
* The dataset includes nearly 1000 samples, with a preprocessing step to filter out samples in the lower 25% of gene expressions, focusing on significantly expressed genes.
#### K-Means Clustering
* Applied to categorize the gene expression data into distinct clusters for each cancer type.
#### Neural Networks
* Used to analyze patterns in gene expression data, providing a nuanced understanding of epigenetic factors in cancer progression.

### Key Findings
* The study identified specific patterns associated with each pediatric cancer type, with clustering accuracy ranging from 82.5% to 100%.
* Neural networks outperformed k-means clustering, achieving an average accuracy of 99.49% in predicting cancer types based on gene expression models.
* These high accuracy rates underscore the potential of using clustering and neural network analyses as biomarkers for early detection and targeted therapy.

### How to Use This Repository
* Data: The data used for this study can be found within each folder
* Code: Code for data collection, filtering, k-means clustering, and neural network models along with analysis for both is available within each folder in either.R or .ipynb files
