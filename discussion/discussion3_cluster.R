library(Matrix)
library(cluster)
#### we use data 'USArrests' and 'agriculture' for examples this time
#### you can check these data
View(USArrests)
View(agriculture)
## define distance
d1 = dist(agriculture)
d2 = dist(USArrests)
## make cluster with agglomerative hierarchical clustering
## c1 choose single linkage and c2 choose complete linkage
c1 = agnes(d1,method = "single")
c2 = agnes(d2,method = "complete")
## make plot to see the clustering results: banner plot and tree
par(mfrow = c(1,2))
plot(c1)
plot(c2)
## you can check for merge table to see the order of merging
head(c2$merge,10)
## cutree function can be used to separate trees in to k part
c2_sub = cutree(c2,k = 4)
## check the result for subtree partition
plot(c2_sub)
rownames(USArrests)[c2_sub == 1]

#### robust K-means with function "pam"
c3 = pam(d2,k = 4)
## do a
par(mfrow = c(1,1))
plot(c3)
## some ways to see the summary result from a pam obj
c3$clusinfo
## check which part is included in 1st group
rownames(USArrests)[c3$clustering == 1]
