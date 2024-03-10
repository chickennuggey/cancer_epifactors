# Filtering

Using R, the raw counts were converted from character to numeric values. The mean expression level for each gene was calculated across the dataset, followed by a filtering process that excluded the lower 25% of gene expressions, focusing the analysis on genes most heavily expressed across the collective cancer-type dataset.

filtering.R contains code that was used to filter raw counts for gene expression.
