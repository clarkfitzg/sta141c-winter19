### Clustering
#
#Clustering reference from [Berkeley STA133 class](https://www.stat.berkeley.edu/~s133/Cluster2a.html)
#
#Technique: to understand machine learning and software 
#
#1. Generate data that satisfies the assumptions
#2. Check the results against what you know to be true
#
#```{r}
#n = 100
#
## Makes this reproducible.
#set.seed(489)
#true_cluster = sample(1:3, size = n, replace = TRUE)
#
#x = rep(0, n)
#y = rep(0, n)
#
#x[true_cluster == 2] = 0.5
#y[true_cluster == 3] = 1
#
## Right now the points all overlap, so add some noise
#x = x + rnorm(n, sd = 0.1)
#y = y + rnorm(n, sd = 0.1)
#
#plot(x, y)
#
## Better
#plot(x, y, pch = true_cluster)
#```
#
#Let's play with the clustering models.
#
#```{r}
#m = matrix(c(0, 1, 0, 0, 0, 1), nrow = 3)
#m
#```
#
#The Euclidean (L2) distances between these points should be 1, 1, and sqrt(1 + 1).
#
#```{r}
#dist(m)
#```
#
#The Manhattan (L1) distances between these points should be 1, 1, and 1 + 1.
#
#```{r}
#dist(m, method = "manhattan")
#```
#
#
### Reasoning about the computation:
#
#Computing a distance matrix can be expensive.
#
#```{r}
#n = 1e6 # number of data points
#p = 5   # dimensionality
#5 * choose(n, 2)
#```
#
#The nice thing is you do it once, and can keep reusing it with multiple algorithms.
#
#Question: How many possible cluster assignments are there for PAM with k clusters?
#Answer: n choose k, one for each set of k medoids
#
#```{r}
#k = 10
#5 * choose(n, k)
#```
#
#Pam deals with this by being a _greedy_ algorithm- it doesn't explore all possible options to find the very best.
#It just improves an objective function every time.
#
#Contrast this with kmeans, which is O(n), much faster.
#
#
### Playing around:
#
#```{r}
#library(cluster)
#
## Modeling functions tend to play better with data frames.
#xy = data.frame(x, y)
#
#p1 = pam(xy, k = 3L)
#```
#
#Reading the documentation we see that the software saves the cluster assignments into `clustering`.
#
#```{r}
#mean(p1$clustering == true_cluster)
#```
#
#Question: What's going on?
#Clusters only matter up to labeling.
#
#```{r}
#points(p1$medoids, bg = "blue", pch = 21)
#```
#
### Agglomerative hierarchical clustering
#
#```{r}
#a1 = agnes(xy, method = "complete")
#
#plot(a1, which.plots = 2L)
#```
#
#This is as good as it gets.
#
#
### Explain Homework Data
#
#Homework is due in a week.
#Get started, ask questions.
#
### Review
#
#Appropriate data structures can give order of magnitude improvements:
#
#- Faster speed
#- Lower memory usage
#
#R's `Matrix` package contains classes and methods for matrices implemented using R's S4 class system.
#
#Homework help: Compressed sparse row
#
#
#```{r}
#
#mc = sparseMatrix(i = c(7, 8), j = c(3, 3), x = c(10, 20))
#
#m = as(mc, "dgeMatrix")
#
## Fails because it hasn't been implemented. 
#mr = as(mc, "dgRMatrix")
#
## Sometimes you can go around by coercing to an intermediate object.
#mr = as(as(m, "matrix"), "dgRMatrix")
#
## I'm working with the row oriented version.
## In the homework you will work with the column oriented dgCMatrix, which has much better support in the Matrix package.
#
## They print the same, but they are different inside.
#str(mr)
#```
#
#These are 0 based indices, vs 1 based as in R.
#
#
### Memory copying
#
#Question: How do we know when object sizes are too big and are causing a problem?
#
#Profile!
#
#We can find out when R copies objects using `tracemem`
#
#```{r}
#n = 1e6
#x = 1:n
#
#tracemem(x)
#
## No copy
#y = x + 1
#
## No copy
#z = x
#```
#
#What happens when I change a single element?
#
#```{r}
## Makes a copy
#z[1] = 0L
#
## No copy!
#z[2] = 1L
#```
#
### What is a number?
#
#`.Machine` holds all the low level details.
#
#Double precision numbers are implemented as two parts: the significand, and the exponent.
#
#```{r}
#.Machine$double.digits
#
#.Machine$double.exponent
#```
#
#Checking for exact quality is a common problem.
#
#```{r}
#0.1 + 0.2 == 0.3
#```
#
#The right way is to check if two numbers are close is to see if they differ by more than epsilon, for some small epsilon.
#
#Source: [THE FLOATING-POINT GUIDE](https://floating-point-gui.de/)







# Technique to understand machine learning model

# 1. Generate data that satisfies the assumptions
# 2. Try out the technique

n = 100

# Makes this reproducible.
set.seed(489)
true_cluster = sample(1:3, size = n, replace = TRUE)

x = rep(0, n)
y = rep(0, n)

x[true_cluster == 2] = 0.5
y[true_cluster == 3] = 1

# Right now the points all overlap, so add some noise
x = x + rnorm(n, sd = 0.1)
y = y + rnorm(n, sd = 0.1)

plot(x, y, pch = true_cluster)




# Distance matrix

m = matrix(c(0, 1, 0, 0, 0, 1), nrow = 3)

d = dist(m, method = "manhattan")

# What's really going on in the distance object that's returned?

str(d)

# It's actually just a special numeric vector of length 3.

# Distance calculations can be expensive

n = 1e6     # number of data points
p = 5       # dimension of the space

# How many calculations do we need to fill in a distance matrix?

p*choose(n, 2)

# Nice that it's easily parallelizable

# PAM- partitioning around medoids

# How many solutions are possible for PAM?
k = 10

choose(n, k)

# Too expensive, so PAM is greedy,
# just tries to improve at every iteration.

# keep reusing the same distance matrix.

library(cluster)

xy = data.frame(x, y)

p1 = pam(xy, k = 3L)

# Are they the same?
mean(true_cluster == p1$clustering)

points(x, y, pch = p1$clustering)

# Clusters only matter up to labeling.

a1 = agnes(xy, method = "complete")


a2 = agnes(xy)

# Helpful for homework:

str(a2)

head(a2$merge)

# This says:
# 78 and 90 were the first points joined
# The first three points joined were:
# 47, 77, 87
# Because the first positive number is 4, paired with 87, and the two joined at step 4 were 47, 77
