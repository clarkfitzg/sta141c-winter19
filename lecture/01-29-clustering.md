Possible Topics:

- floating point representation, `.Machine`
- memory profiling, when do objects actually get copied?
- "data mining" contrast with parametric statistics
- Clustering, cluster package
- agglomerative clustering, "cutting the tree", interpreting the results
- ways to think about machine learning models- generate data that does and does not satisfies the assumptions.
- interpreting clustering plots
- Extending objects by adding methods - but this is more useful if they're actually writing their own package.

On board:

- Compressed sparse row
- Clustering: kmeans, PAM, agnes

## Review

Last class we saw order of magnitude improvements by using an appropriate data representation / data structure.
Improvements:

- Faster speed
- Lower memory usage

R's `Matrix` package contains classes and methods for matrices implemented using R's S4 class system.
An S4 object is basically a name with slots.
The slots in the S4 object *must* be of a certain class.

```{r}
m = matrix(1:6, nrow = 2)

library(methods)
library(Matrix)

mm = as(m, "dgeMatrix")

str(mm)
```

Question: How do we know when object sizes are too big and are causing a problem?

We could try to reason it all out ahead of time.
This is sometimes useful.
A better way is to profile the code- run the code and check which lines / operations actually cause problems.
Once we identify where the problems are, we try to fix those.

## What is a number?

`.Machine` holds all the low level details.

Double precision numbers are implemented as two parts: the significand, and the exponent.

```{r}
.Machine$double.digits

.Machine$double.exponent
```

The details aren't particularly important for this class, but it's important to be aware of some problems.
For example, checking for exact quality is a problem.
```{r}
0.1 + 0.2 == 0.3
```
The right way is to check if two numbers are close is to see if they differ by more than epsilon, for some small epsilon.

Source: [THE FLOATING-POINT GUIDE](https://floating-point-gui.de/)

## Clustering

Clustering reference from [Berkeley STA133 class](https://www.stat.berkeley.edu/~s133/Cluster2a.html)

Technique: A good way to understand a machine learning model (or any model), and the software that implements it, is to generate data that satisfies the assumptions of the model and check that the model gives you the results you expect.
Let's do that for clustering.

We'll start by generating 2 dimensional data that has 3 clusters around the points (0, 0), (1, 0), (0, 1).
We use 2 dimensions so that we can actually see the clusters.

```{r}
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

plot(x, y)

# Better
plot(x, y, pch = true_cluster)
```

The goal of clustering is simple if vague: partition the data into groups.

`pam` is an acronym for Partitioning Around Medoids.

The basic idea: find k data points to be the medoids of the clusters, and assign all the other points to the closest medoid.
Do this in a way that minimizes the total distance between points and their assigned medoids.

A medoid is generalization of median- i.e. the data point that lies in the 'center' of the data, according to some measure of distance.

This is more robust to outliers than kmeans.


Let's make sure everyone is on the same page about what a distance calculation is.
We'll take the three two dimensional points that we used for our cluster centroids:

R's `dist` function computes the distance between each pair of points, where each row of data is considered a point.

```{r}
m = matrix(c(0, 1, 0, 0, 0, 1), nrow = 3)
m
```

The Euclidean (L2) distances between these points should be 1, 1, and sqrt(1 + 1).

```{r}
dist(m)
```

The Manhattan (L1) distances between these points should be 1, 1, and 1 + 1.

```{r}
dist(m, method = "manhattan")
```


## Reasoning about the computation:

pam is not computationally efficient for large data sets.
Computing a distance matrix can be expensive.
You have to compute pairwise distances between every pair of n choose 2 points.
For example, if you have 1 million 5 dimensional data points then you need to do at least 2.5 trillion calculations.
Computers can do this, it's not the end of the world.

```{r}
5 * choose(1e6, 2)
```

Question: How many possible cluster assignments are there for PAM with k clusters?
Answer: n choose k, one for each set of k medoids

So for the above cluster, if we're looking for 10 clusters:

```{r}
5 * choose(1e6, 10)
```

We're already up to 10^54 different options.
This is the end of the world pretty much- it's infeasible.

Pam deals with this by being a _greedy_ algorithm- it doesn't explore all possible options to find the very best.
All it tries to do is improve the objective function at every iteration.


## Playing around:

Now we'll play around with some algorithms.
I'm using the `cluster` package that comes as a recommended package with R.

```{r}
library(cluster)

# Modeling functions tend to play better with data frames.
xy = data.frame(x, y)

p1 = pam(xy, k = 3L)
```


Reading the documentation we see that the software saves the cluster assignments into `clustering`.

```{r}
mean(p1$clustering == true_cluster)
```

What, the clustering doesn't match the true clustering!
Question: What's going on?
Clusters only matter up to labeling.

```{r}
points(p1$medoids, bg = "blue", pch = 21)

```

Silhouettes are pretty cool, you can read about them.
The basic idea: each number represents how well each point fits into its cluster.

Reference: Silhouettes: A graphical aid to the interpretation and validation of cluster analysis by Peter J.Rousseeuw

## Agglomerative hierarchical clustering

These clustering algorithms are based on "dissimilarites" between points, and this is what I asked you to work with on the homework.

If you don't pass them a 'distance' matrix, then they compute the distance between the points, where the points are rows in your data frame.

As I keep fitting these models, they keep computing the distance matrix.
No big deal for this small data, but if I spend a long time computing a distance then I would want to save this result.

Setting `trace.lev` gives me a little more information.

```{r}
a1 = agnes(xy, method = "complete")

plot(a1, which.plots = 2L)
```

The dendrogram plot here provides some good evidence that there are three clusters.
We also have to keep in mind that this is essentially as good as it gets.

The y axis shows the distance at which the clusters are formed.
The x axis is arbitrary, all it does is keep clusters near each other.

Interpreting this plot, we see that all the data are grouped into 3 clusters after an average distance of 0.3, and we don't see two come together until the average distance between points is 1.0.

Ideas:

- 1.2 is not random, it comes from taking about half that are 1 unit away, and half that are sqrt(2) units away.
- Draw the dendrogram as I walk through the agnes algorithm on the board.
- Iterative, top down versus bottom up clustering.


```{r}
a2 = agnes(xy, method = "complete")

head(a2$merge)

# This says:
# 78 and 90 were the first points joined
# The first three points joined were:
# 47, 77, 87
# Because the first positive number is 4, paired with 87, and the two joined at step 4 were 47, 77
```


## Explain Homework Data

Homework is due in a week.
Get started, ask questions.
