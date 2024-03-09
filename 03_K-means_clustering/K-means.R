library("tidyverse")
library("pheatmap")
cancer_counts=read.csv("pediatric_cancers_filtered_count.csv", header=TRUE)
cancer_counts_full=cancer_counts
cancer_counts=cancer_counts[-526,]

#Choose number of clustering centers between 5 or 7  
centers_amount = 0
while (centers_amount != 5 && centers_amount != 7)
  centers_amount = readline(prompt = "Five or seven clusters? Enter 5 or 7 only: ");
  centers_amount = as.integer(centers_amount)

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
clusters=kmeans(cancer_counts_t[,1:525],centers=centers_amount) # centers increased to 7 to increase likelihood of all cancer types dominating a cluster
centers_amount
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

if (centers_amount==5){
  plot=ggplot(plotdf) + geom_point(aes(x=x, y=y, color=cluster,)) +
  scale_color_manual(values=c("red", "orange", "green", "blue", "violet") # color palette for 7 5 cluster
                     )+
  labs(title="t-SNE Visualization", x="Dim 1", y="Dim 2")
  } else if (centers_amount==7){
    plot=ggplot(plotdf) + geom_point(aes(x=x, y=y, color=cluster,)) +
    scale_color_manual(values=c("red", "orange", "green", "blue", "violet", "pink", "yellow") #increase color palette for 7 cluster
    )+
    labs(title="t-SNE Visualization", x="Dim 1", y="Dim 2")
  }

plot

#Create a df with cancer type and cluster it was assigned to
cluster_type=cancer_counts_t[,526:527]
colnames(cluster_type)=c("Cancer_Type", "Cluster")

#Create a column with counts
cluster_counts=group_by(cluster_type, Cancer_Type, Cluster) # partition all patients with different clusters and cancer types
cluster_counts=summarize(cluster_counts, count=n())
cluster_counts=ungroup(cluster_counts)


#Create a df that shows which cluster each cancer type most coincides with
maximum=group_by(cluster_counts, Cluster) # partition cluster and cancer intersections by cluster 
maximum=slice(maximum, which.max(count)) # identify maximum cancer-type in cluster
maximum=ungroup(maximum)

#Number of patients with largest cancer type in each cluster
count_total=group_by(cluster_type, Cluster) # Group all patients by cluster type
count_total=summarize(count_total, total_count = n()) # total_count the total patients in each cluster
count_total=ungroup(count_total)

#Merge data frames, calcualate percentage of cluster dominated by cancer type
results=merge(maximum, count_total, by = "Cluster")
results=mutate(results, Percentage = count / total_count * 100)

#Plot results using ggplot2
plot2=ggplot(results, aes(x = Cluster, y = Percentage, color=Cancer_Type)) +
  geom_bar(stat = "identity") + 
  labs(x = "Cluster", y = "Percentage of Cluster Dominated by Cancer")

plot2
