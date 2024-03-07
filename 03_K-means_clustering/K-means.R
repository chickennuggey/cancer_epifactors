library("tidyverse")
library("pheatmap")
cancer_counts=read.csv("pediatric_cancers_filtered_count.csv", header=TRUE)
cancer_counts_full=cancer_counts
cancer_counts=cancer_counts[-526,]

#Add prior count, log 2 transform, and scale the data
cancer_counts[, 2:987]=(apply(cancer_counts[, 2:987], 2, as.numeric))
cancer_counts[, 2:987]=cancer_counts[, 2:987]+0.5
cancer_counts[,2:987]=log2(cancer_counts[,2:987])
cancer_counts[,2:987]=scale(cancer_counts[,2:987])
cancer_counts=rbind(cancer_counts, cancer_counts_full[526,])

#Transpose and label the columns
cancer_counts_t=setNames(data.frame(t(cancer_counts[,-1])), cancer_counts[,1]) 

#Perform k-means and arrange by cluster
set.seed(43)
clusters=kmeans(cancer_counts_t[,1:525],centers=5)
cancer_counts_t=cbind(cancer_counts_t, clusters$cluster)
cancer_counts_t=arrange(cancer_counts_t, clusters$cluster)
cancer_counts_t[, 1:525]=(apply(cancer_counts_t[, 1:525], 2, as.numeric))

#Perform t-SNE and plot using ggplot2
library(Rtsne)
library(ggplot2)
set.seed(66)
Rtsne_out=Rtsne(cancer_counts_t[,1:525])
plotdf=data.frame(x = Rtsne_out$Y[,1], y = Rtsne_out$Y[,2], cluster = cancer_counts_t$`clusters$cluster`)
plotdf$cluster= as.character(plotdf$cluster)
plot=ggplot(plotdf) + geom_point(aes(x=x, y=y, color=cluster,)) +
  scale_color_manual(values=c("red", "orange", "green", "blue", "violet"),
                     labels=c("WT", "AML", "ALL", "NBL", "OS"))+
  labs(title="t-SNE Visualization", x="Dim 1", y="Dim 2")

#Create a df with cancer type and cluster it was assigned to
cluster_type=cancer_counts_t[,526:527]
colnames(cluster_type)=c("Cancer_Type", "Cluster")

#Create a column with counts
cluster_counts=group_by(cluster_type, Cancer_Type, Cluster)
cluster_counts=summarize(cluster_counts, count=n())
cluster_counts=ungroup(cluster_counts)

#Create a df that shows which cluster each cancer type most coincides with
maximum=group_by(cluster_counts, Cancer_Type)
maximum=slice(maximum, which.max(count))
maximum=ungroup(maximum)

#Total number of patients with each cancer type
count_total=group_by(cluster_type, Cancer_Type)
count_total=summarize(count_total, total_count = n())
count_total=ungroup(count_total)

#Merge data frames, add percentage properly clustered to the data frame
results=merge(maximum, count_total, by = "Cancer_Type")
results=mutate(results, Percentage = count / total_count * 100)

#Plot results using ggplot2
plot2=ggplot(results, aes(x = Cancer_Type, y = Percentage, color=Cancer_Type)) +
  geom_bar(stat = "identity") + 
  labs(x = "Cancer Type", y = "Percentage Correctly Clustered")
