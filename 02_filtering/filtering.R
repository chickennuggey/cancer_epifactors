# importing raw counts for all cancer types
all_cancer <- read.csv("pediatric_cancers_raw_count.csv")
# save cancer types 
cancer_types <- all_cancer[701, ]

# turn raw counts data to matrix format
all_cancer_matrix <- as.matrix(all_cancer[-701, ])
rownames(all_cancer_matrix) <- all_cancer_matrix[,1] # transform first column to rownames
all_cancer_matrix <- all_cancer_matrix[,-1, drop = FALSE]
all_cancer_matrix <- apply(all_cancer_matrix, c(1,2), as.numeric) #turn raw counts from char to numeric

# calculate the mean expression level for each gene
all_cancer_mean_expression <- rowMeans(all_cancer_matrix)

# Find the 25th percentile threshold for each cancer type and all cancer matrix
all_cancer_threshold <- quantile(all_cancer_mean_expression, 0.25)

# Filter genes
all_cancer_filtered_data <- all_cancer_matrix[all_cancer_mean_expression > all_cancer_threshold, ]
all_cancer_filtered_df <- as.data.frame(all_cancer_filtered_data)

# add cancer type back in
all_cancer_filtered_df <- rbind(all_cancer_filtered_df, cancer_types[-1])
rownames(all_cancer_filtered_df)[nrow(all_cancer_filtered_df)] <- "cancer_type"

# Save filtered data
# write.csv(all_cancer_filtered_df, file.path("/Users...","all_cancer_filtered_count.csv"))
          

