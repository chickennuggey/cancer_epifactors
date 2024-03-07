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
clusters=kmeans(cancer_counts_t[,1:525],centers=5)
cancer_counts_t=cbind(cancer_counts_t, clusters$cluster)
cancer_counts_t=arrange(cancer_counts_t, clusters$cluster)
cancer_counts_t[, 1:525]=(apply(cancer_counts_t[, 1:525], 2, as.numeric))

library(Rtsne)
set.seed(66)
pca=Rtsne(cancer_counts_t[,1:525])
plotdf=data.frame(x = pca$Y[,1], y = pca$Y[,2], col = cancer_counts_t$`clusters$cluster`)
plotdf$col= as.character(plotdf$col)
plot=ggplot(plotdf) + geom_point(aes(x=x, y=y, color=col))+ scale_color_manual(values=c("red", "orange", "green", "blue", "violet"))

