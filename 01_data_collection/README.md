# Data Collection

Raw RNA counts for 5 pediatric cancer types (OS, NBL, AML, WT, ALL) were obtained from TARGET using the TCGAbiolinks package on R and filtered by 700 epi-factor genes, resulting in a total of almost 1000 samples. 

epifactor.xlsx <- Excel sheet containing list of 700 epi-factor genes of interest

pediatrics_cancers_raw_count.csv <- Raw count data collected after using data_collection.R

data_collection.R <- Using R Studio, the code was run to collect the raw counts for each of the 5 pediatric cancer types
