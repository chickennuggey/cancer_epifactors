# rm(list = ls())
# setwd("/Users/...")

# installation
#if (!requireNamespace("BiocManager", quietly=TRUE))
 # install.packages("BiocManager")
#BiocManager::install("TCGAbiolinks")

# load libraries
library(TCGAbiolinks)
library(dplyr)
library(DT)
library(readxl) 
library(SummarizedExperiment)
library(biomaRt)

count_data.frame <- function(cancer_type){
  
  # query, download and prepare data
  query <- GDCquery(project = cancer_type,
                    data.category = "Transcriptome Profiling",
                    data.type = "Gene Expression Quantification",
                    workflow.type = "STAR - Counts")
  
  cancer_barcodes <- getResults(query, rows = 1:300, cols = "cases")
  
  query <- GDCquery(project = cancer_type,
                    data.category = "Transcriptome Profiling",
                    data.type = "Gene Expression Quantification",
                    workflow.type = "STAR - Counts",
                    barcode = cancer_barcodes)
  
  GDCdownload(query)
  data <- GDCprepare(query)
  
  # filter out epifactor genes of interest 
  epifactor_excel <- read_excel("epifactor.xlsx")
  epifactor_genes <- epifactor_excel$gene_symbol
  genes <- rowData(data)$gene_name %in% epifactor_genes
  count_data <- assays(data[genes])$unstranded
  
  count_df <- as.data.frame(count_data)
  
  # convert gene ID to gene symbols
  gene_id <- rownames(count_df)
  
  gene_id_clean <- vapply(gene_id, function(x) {
    x <- substring(x, 1, 15)
  }, character(1))
  
  ensembl <- useEnsembl(biomart = "genes")
  
  ensembl.con <- useMart("ensembl", dataset = "hsapiens_gene_ensembl")
  
  gene_name <- getBM(attributes = c("ensembl_gene_id", "external_gene_name"),
                     filters = "ensembl_gene_id",
                     values = gene_id_clean,
                     mart = ensembl.con)
  
  rownames(count_df) <- gene_name$external_gene_name
  
  count_df
}

add.outcome <- function(data, string) {
  # add outcome variable
  cancer <- rep(string, ncol(data))
  data <- rbind(data, cancer)
  rownames(data)[nrow(data)] <- "cancer_type"
  data
}

# create dataframe for each cancer type and all cancers
OS_raw_count <- count_data.frame("TARGET-OS")
OS_raw_count2 <- add.outcome(OS_raw_count, "OS")

NBL_raw_count <- count_data.frame("TARGET-NBL")
NBL_raw_count2 <- add.outcome(NBL_raw_count, "NBL")

AML_raw_count <- count_data.frame("TARGET-AML")
AML_raw_count2 <- add.outcome(AML_raw_count, "AML")

WT_raw_count <- count_data.frame("TARGET-WT")
WT_raw_count2 <- add.outcome(WT_raw_count, "WT")

ALL_raw_count <- count_data.frame("TARGET-ALL-P2")
ALL_raw_count2 <- add.outcome(ALL_raw_count, "ALL")

pediatric_cancers_raw_count <- cbind(OS_raw_count2, NBL_raw_count2, AML_raw_count2, WT_raw_count2, ALL_raw_count2)

# write.csv(cancers_raw_count, file.path("/Users/...", "pediatric_cancers_raw_count.csv"))


