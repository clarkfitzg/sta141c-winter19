## ### Notes

## - No late homework.
##   If you can't quite finish it's better to turn it what you have.
##   Don't worry about it, you can drop one.
## - Seminar today Stats seminar today: Larry Wasserman "Assumption Free Predictive Inference" Thursday 4pm, MSB 1147 https://statistics.ucdavis.edu/events/seminar-011019-wasserman

## ### Questions?

## # Review

## Last class we loaded the data in by choosing one file that we wanted and unzipping that one into our current directory.

# Original data
zip_file_path = "~/data/awards.zip"
files = unzip(zip_file_path, list = TRUE)

# Picking a random file name to play with
fname = "123.csv"

unzip(zip_file_path, files = fname)

grp = read.csv(fname)

## If we do this for every file, then we'll end up unzipping all of them.
## How do we clean up after ourselves as we go?

unlink(fname)

## Another way is through temporary files / directories, which the OS will clean up later.
scratch = tempdir()


## ## There are a variety of ways to get in these files.

## I could unzip everything beforehand.
## Do it with the point and click.

## __Question__: When should you use the point and click method?

## For a one off assignment like this I think it's totally fine.
## Otherwise we like scripted methods because we can automate them, and they rarely change.

## We can do it from R:
unzip(zip_file_path, exdir = "~/data/awards")

## We could do it from the command line: `unzip ~/data/awards.zip -d ~/data/awards`

## If you carefully read R's `unzip` help page you'll see a link to the function `unz()`.
f = unz(zip_file_path, fname)
f
## `f` here is an interesting object, a 'connection', which is a generalization of a file.
## It hasn't given us any data yet.
## We need to ask it for data.

## What is data in a file really?
## It's just a sequence of bytes that we can read or write.
## This comes from the UNIX philosophy, that we'll explore in more detail later.

## We can parse the file output directly into an R data frame without creating an intermediate temporary zip file.
f = unz(zip_file_path, fname)
d = read.csv(f)

## That was specific to `zip` archives.
## The `pipe` command is more general.
## It lets us call arbitrary shell commands.
## For example, the command `unzip -p ~/data/awards.zip 123.csv` will extract the contents of the file 123.csv to stdout.
## Try it.
fp = pipe("unzip -p ~/data/awards.zip 123.csv")
fp

dp = read.csv(fp)


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
## We can do this if each function `f(group)` can be computed independently, as in the example above with `f = sum`.

## __Question__: What are examples of functions `f` that __cannot__ be computed independently?

## Demo: tapply, as.Date, format


## __Technique__: To process a bunch of files in the same way, write a function that processes a single file.

## __Question__: What is good about this technique?
## - Keeps your code clean and logical
## - Easy to develop and test
## - Easy to make parallel (we'll learn soon)

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

