## ### Notes

## - TA, Si Teng Hao, will have office hours tomorrow, tentatively 2-4 pm.
##   I'll have office hours on Monday.
## - No late homework.
##   If you can't quite finish it's better to turn it what you have.
##   Don't worry about it, you can drop one.
## - Seminar today Stats seminar today: Larry Wasserman "Assumption Free Predictive Inference" Thursday 4pm, MSB 1147 https://statistics.ucdavis.edu/events/seminar-011019-wasserman

## ### Questions?

## Homework takes 90 minutes. too long? Xiaoxi
## Why did my machine fall over when I tried to load all the data?
## That was the idea.
##
## Can I use Python?
## Sure! Use whatever.
## data.table::fread

## Each file in the zip archive should contain exactly one agency, that doesn't appear anywhere else.

## What does qualitatively describe distribution mean?
## Basic, general description.
## Feel free to get fancy.

x = rnorm(100)

# How to time?
system.time(hist(x))
# From command line:
# $ time Rscript scratch.R

x[100] = 1000

## No need to use all the functions in the hints.

## # Review

## Last class we loaded the data in by choosing one file that we wanted and unzipping that one into our current directory.

# Original data
zip_file_path = "~/data/awards.zip"
files = unzip(zip_file_path, list = TRUE)

# Picking a random file name to play with
fname = "123.csv"

unzip(zip_file_path, files = fname)

grp = read.csv(fname)

# Delete the file as I go
unlink(fname)

## Another way is through temporary files / directories, which the OS will clean up later.
scratch = tempdir()


## ## There are a variety of ways to get in these files.

## I could unzip everything beforehand.
## Do it with the point and click.

## __Question__: When should you use / not use the point and click method?

## - Data is small enough.
## - If I only had the command line interface then I can't use GUI.
## - Repeatable
## - Automation- write a script!
## - Compose commands
## - Lazy - command line will stay the same.

## We can do it from R:
unzip(zip_file_path, exdir = "~/data/awards")

## We could do it from the command line: `unzip ~/data/awards.zip -d ~/data/awards`

## If you carefully read R's `unzip` help page you'll see a link to the function `unz()`.

f = unz(zip_file_path, fname)

d = read.csv(f)

# Connection

## Q: Difference between unz, and unzip

## What is data in a file really?

## Read from connection


## pipe
## The command `unzip -p ~/data/awards.zip 123.csv` will extract the contents of the file 123.csv to stdout.


fp = pipe("unzip -p ~/data/awards.zip 123.csv")

fp

# Read from pipe
d = read.csv(fp)

# What's the size?
object.size(d)

## # Group By

## ## References

## -[The Split-Apply-Combine Strategy for Data Analysis](https://www.jstatsoft.org/article/view/v040i01) Wickham
## -[Large complex data: divide and recombine (D&R) with RHIPE](http://ml.stat.purdue.edu/docs/dr.rhipe.stat.2012.pdf) Guha, et. al.

## The 'group by' pattern of computation means to split the data into groups, and then compute some statistic `f(group)` for every group.
## This pattern has various different names, such as split-apply-combine, or divide and recombine.
## Most data analysis software offers some way to do it, and there are a bunch of packages with specialized implementations.
## Notable packages in R are data.table and dplyr.
## I'm calling it the group by pattern because `GROUP BY` is the syntax in the well known SQL language.

## SQL example
## How much has each customer purchased?

## ```
## SELECT customer, sum(price)
## FROM orders
## GROUP BY customer;
## ```

## This pattern comes up all the time in data analysis.
## It's especially helpful for large data sets with many groups because we can compute `f(group)` in parallel, thus potentially saving a large amount of time.
## We can do this if each function `f(group)` can be computed independently, as in the example above with `f = sum`.

## __Question__: What are examples of functions `f` that __cannot__ be computed independently?

count = 0L
f = function() count <<- count + 1L

## Demo: tapply, as.Date, format

bikes = read.csv("../data/awards_bicycles.csv")

## Let's focus on a couple columns to see what we're doing.

bikes = bikes[, c("total_obligation", "period_of_performance_start_date")]

head(bikes)

colnames(bikes) = c("price", "date")

str(bikes)

## Conversion to date 

bikes$date = as.Date(bikes$date)

## Did it work?
str(bikes)


## Make data print better
bikes$period_of_performance_start_date = NULL

## Extract the month

bikes$month = format(bikes$date, "%m")

## tapply lets us ask questions such as:
## What was the max the VA spent on a bike in any given month?

tapply(bikes$price, bikes$month, max)

## Suppose we want to get the actual date along with the max price.

grp = bikes[bikes$month == "01", ]

# Want: data frame with max price, month, and date the max price happened

## Let's start by making it work for just one month.

# Nice one Janet!

data.frame(price = max(grp$price)
           , month = grp[1L, "month"]
           , date = grp[which.max(grp$price), "date"]
           )

## Here's what I want to end up with for each month.

## __Technique__: To process a bunch of different groups in the same way, write a function that processes a single group.

max_month = function(grp)
{
    data.frame(price = max(grp$price)
               , month = grp[1L, "month"]
               , date = grp[which.max(grp$price), "date"]
               )
}

max_month(grp)


## Now all we have to do is apply it to every group in the data.
## We can use a specialized package, or we can use base R.

months = split(bikes, bikes$month)

## Question: What do you expect is the length?
length(months)

## Now we apply the function we wrote to each group.

m = lapply(months, max_month)

## Will data.frame do it for us?


## rbind is the function we're looking for here.
## The parameters are `...`.
## That means we can pass in as many arguments as we like.

rbind(m[[1]], m[[2]])

## Ewww!
rbind(m[[1]], m[[2]], m[[3]], m[[4]], m[[5]], m[[6]], m[[6]], m[[7]], m[[8]], m[[9]], m[[10]], m[[11]], m[[12]])

# What's wrong?
# DRY- Do not repeat yourself
# - Hardcoding!
# - Ugly!
# - Error prone!


do.call(rbind, m)

# What are the advantages of the function / apply pattern?
# - Can repeat on other data
# - Faster? Yes, can tune it.
# - Ease of development

# Next:
aggregate(bikes, by = list(bikes$month), FUN = max_month) 

## `aggregate` gives us something nicer than `tapply`.
## Thanks Rishi!
aggregate(price ~ month, bikes, FUN = max)
