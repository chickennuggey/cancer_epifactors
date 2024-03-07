# rm(list = ls())

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

# create dataframe for each cancer type and all cancers
BRCA_raw_count <- count_data.frame("TCGA-BRCA")
ACC_raw_count <- count_data.frame("TCGA-ACC")
LIHC_raw_count <- count_data.frame("TCGA-LIHC")
LUAD_raw_count <- count_data.frame("TCGA-LUAD")
cancers_raw_count <- cbind(BRCA_raw_count, ACC_raw_count, LIHC_raw_count, LUAD_raw_count)

# write.csv(BRCA_raw_count, file.path("/Users/...", "BRCA_raw_count.csv"))
# write.csv(ACC_raw_count, file.path("/Users/...", "ACC_raw_count.csv"))
# write.csv(LIHC_raw_count, file.path("/Users/...", "LIHC_raw_count.csv"))
# write.csv(LUAD_raw_count, file.path("/Users/...", "LUAD_raw_count.csv"))
# write.csv(cancers_raw_count, file.path("/Users/...", "cancers_raw_count.csv"))




