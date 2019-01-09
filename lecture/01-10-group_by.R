## ## Questions?

## # Group By

## ## References
## -[The Split-Apply-Combine Strategy for Data Analysis](https://www.jstatsoft.org/article/view/v040i01) Wickham
## -[Large complex data: divide and recombine (D&R) with RHIPE](http://ml.stat.purdue.edu/docs/dr.rhipe.stat.2012.pdf) Guha, et. al.

## The 'group by' pattern of computation means to split the data into groups, and then compute some statistic `f(group)` for every group.
## This pattern has various different names, such as split-apply-combine, or divide and recombine.
## Most data analysis software offers some way to do it, and there are a bunch of packages with specialized implementations.
## I'm calling it the group by pattern because `GROUP BY` is the syntax in the well known SQL language.
## For example, a query to see how much each customer purchased might look like:

## ```
## SELECT customer, sum(price)
## FROM orders
## GROUP BY customer
## ```

## This pattern comes up all the time in data analysis.
## It's especially helpful for large data sets with many groups because we can compute `f(group)` in parallel, thus potentially saving a large amount of time.
## We can do this if each function `f(group)` can be computed independently.

## __Question__: What are examples of functions f that __cannot__ be computed independently?




## Intro to data

## I downloaded the big zip file from the website to this path
zip_file_path = "~/data/awards.zip"

## Look at the help like this:
?unzip

## Carefully reading the documentation shows that we can list the files in this archive.
files = unzip(zip_file_path, list = TRUE)

## Let's pick a random file name to experiment with
fname = "123.csv"

## Now we can start poking around at this data frame.
## Always be touching your data- getting familiar with it, exploring it.
## This interactiveness is a strength of R.

## Ask class- how do you do this?

## The kind of object this is.
## The other functions dispatch based on this value.
## This is called object-oriented programming, and we'll learn more about it later in the quarter.
class(grp)

# Extract the file
unzip(zip_file_path, files = fname)

# Load it into R
d = read.csv(fname)


## We can extract _only_ this file from the archive if we like:
f = unz(zip_file_path, file_name)

## Then read it into a data frame
grp = read.csv(f)

