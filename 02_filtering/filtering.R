

# importing raw counts for each cancer type and all cancer types
ACC_raw <- read.csv("ACC_raw_count.csv")
BRCA_raw <- read.csv("BRCA_raw_count.csv")
LIHC_raw <- read.csv("LIHC_raw_count.csv")
LUAD_raw <- read.csv("LUAD_raw_count.csv")
all_cancer <- read.csv("cancers_raw_count.csv")

# turn raw counts data to matrix format
ACC_matrix <- as.matrix(ACC_raw)
rownames(ACC_matrix) <- ACC_matrix[,1] # transform first column to rownames
ACC_matrix <- ACC_matrix[,-1, drop = FALSE]
ACC_matrix <- apply(ACC_matrix, c(1,2), as.numeric) #turn raw counts from char to numeric

BRCA_matrix <- as.matrix(BRCA_raw)
rownames(BRCA_matrix) <- BRCA_matrix[,1] # transform first column to rownames
BRCA_matrix <- BRCA_matrix[,-1, drop = FALSE]
BRCA_matrix <- apply(BRCA_matrix, c(1,2), as.numeric) #turn raw counts from char to numeric

LIHC_matrix <- as.matrix(LIHC_raw)
rownames(LIHC_matrix) <- LIHC_matrix[,1] # transform first column to rownames
LIHC_matrix <- LIHC_matrix[,-1, drop = FALSE]
LIHC_matrix <- apply(LIHC_matrix, c(1,2), as.numeric) #turn raw counts from char to numeric

LUAD_matrix <- as.matrix(LUAD_raw)
rownames(LUAD_matrix) <- LUAD_matrix[,1] # transform first column to rownames
LUAD_matrix <- LUAD_matrix[,-1, drop = FALSE]
LUAD_matrix <- apply(LUAD_matrix, c(1,2), as.numeric) #turn raw counts from char to numeric

all_cancer_matrix <- as.matrix(all_cancer)
rownames(all_cancer_matrix) <- all_cancer_matrix[,1] # transform first column to rownames
all_cancer_matrix <- all_cancer_matrix[,-1, drop = FALSE]
all_cancer_matrix <- apply(all_cancer_matrix, c(1,2), as.numeric) #turn raw counts from char to numeric

# calculate the mean expression level for each gene
ACC_mean_expression <- rowMeans(ACC_matrix)
BRCA_mean_expression <- rowMeans(BRCA_matrix)
LIHC_mean_expression <- rowMeans(LIHC_matrix)
LUAD_mean_expression <- rowMeans(LUAD_matrix)
all_cancer_mean_expression <- rowMeans(all_cancer_matrix)

# Find the 25th percentile threshold for each cancer type and all cancer matrix
ACC_threshold <- quantile(ACC_mean_expression, 0.25)
BRCA_threshold <- quantile(BRCA_mean_expression, 0.25)
LIHC_threshold <- quantile(LIHC_mean_expression, 0.25)
LUAD_threshold <- quantile(LUAD_mean_expression, 0.25)
all_cancer_threshold <- quantile(all_cancer_mean_expression, 0.25)

# Filter genes
ACC_filtered_data <- ACC_matrix[ACC_mean_expression > ACC_threshold, ]
BRCA_filtered_data <- BRCA_matrix[BRCA_mean_expression > BRCA_threshold, ]
LIHC_filtered_data <- LIHC_matrix[LIHC_mean_expression > LIHC_threshold, ]
LUAD_filtered_data <- LUAD_matrix[LUAD_mean_expression > LUAD_threshold, ]
all_cancer_filtered_data <- all_cancer_matrix[all_cancer_mean_expression > all_cancer_threshold, ]

# Save filtered data to desktop
# write.csv(ACC_filtered_data, file.path("/Users/...","ACC_filtered_count.csv")
# write.csv(BRCA_filtered_data, file.path("/Users/...","BRCA_filtered_count.csv")
# write.csv(LIHC_filtered_data, file.path("/Users/...","LIHC_filtered_count.csv")
# write.csv(LUAD_filtered_data, file.path("/Users/...","LUAD_filtered_count.csv")
# write.csv(all_cancer_filtered_data, file.path("/Users/...","all_cancer_filtered_count.csv")





