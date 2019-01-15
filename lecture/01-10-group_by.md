### Notes

- TA, Si Teng Hao, will have office hours tomorrow, tentatively 2-4 pm.
  I'll have office hours on Monday.
- No late homework.
  If you can't quite finish it's better to turn it what you have.
  Don't worry about it, you can drop one.
- Seminar today Stats seminar today: Larry Wasserman "Assumption Free Predictive Inference" Thursday 4pm, MSB 1147 https://statistics.ucdavis.edu/events/seminar-011019-wasserman

### Questions?

> Homework takes 90 minutes. Is this too long? -Xiaoxi

Yes, the problem came from trying to load all the data into memory at once.
The idea is to process each group individually.

> Can I use Python?

Sure! Use whatever. `data.table::fread` is usually fast.

Each file in the zip archive should contain exactly one agency (`agency_funding_id`), that doesn't appear anywhere else.

What does qualitatively describe distribution mean?
Basic, general description.
Feel free to get fancy.

```r
x = rnorm(100)

# How to time?
system.time(hist(x))
# From command line:
# $ time Rscript scratch.R

x[100] = 1000
```

No need to use all the functions in the hints.


# Review

Last class we loaded the data in by choosing one file that we wanted and unzipping that one into our current directory.

```r
# Original data
zip_file_path = "~/data/awards.zip"
files = unzip(zip_file_path, list = TRUE)

# Picking a random file name to play with
fname = "123.csv"

unzip(zip_file_path, files = fname)

grp = read.csv(fname)
```

If we do this for every file, then we'll end up unzipping all of them.
How do we clean up after ourselves as we go?

```r
unlink(fname)
```

Another way is through temporary files / directories, which the OS will clean up later.
```r
scratch = tempdir()

```

## There are a variety of ways to get in these files.

I could unzip everything beforehand.
Do it with the point and click.

__Question__: When should you use the point and click method?

- Data is small enough.
- If I only had the command line interface then I can't use GUI.
- Repeatable
- Automation- write a script!
- Compose commands
- Lazy - command line will stay the same.


We can do it from R:
```r
unzip(zip_file_path, exdir = "~/data/awards")
```

We could do it from the command line: `unzip ~/data/awards.zip -d ~/data/awards`

If you carefully read R's `unzip` help page you'll see a link to the function `unz()`.
```r
f = unz(zip_file_path, fname)
```

`f` here is an interesting object, a 'connection', which is a generalization of a file.
It hasn't given us any data yet.
We need to ask it for data.

What is data in a file really?
It's just a sequence of bytes that we can read or write.
This comes from the UNIX philosophy, that we'll explore in more detail later.

We can parse the file output directly into an R data frame without creating an intermediate temporary zip file.
```r
f = unz(zip_file_path, fname)
d = read.csv(f)
```

That was specific to `zip` archives.
The `pipe` command is more general.
It lets us call arbitrary shell commands.
For example, the command `unzip -p ~/data/awards.zip 123.csv` will extract the contents of the file 123.csv to stdout.
Try it.
```r
fp = pipe("unzip -p ~/data/awards.zip 123.csv")
fp

dp = read.csv(fp)

```

# Group By

## References

-[The Split-Apply-Combine Strategy for Data Analysis](https://www.jstatsoft.org/article/view/v040i01) Wickham
-[Large complex data: divide and recombine (D&R) with RHIPE](http://ml.stat.purdue.edu/docs/dr.rhipe.stat.2012.pdf) Guha, et. al.

The 'group by' pattern of computation means to split the data into groups, and then compute some statistic `f(group)` for every group.
This pattern has various different names, such as split-apply-combine, or divide and recombine.
Most data analysis software offers some way to do it, and there are a bunch of packages with specialized implementations.
Notable packages in R are data.table and dplyr.
I'm calling it the group by pattern because `GROUP BY` is the syntax in the well known SQL language.
For example, a query to see how much each customer purchased might look like:

```
SELECT customer, sum(price)
FROM orders
GROUP BY customer
```

This pattern comes up all the time in data analysis.
It's especially helpful for large data sets with many groups because we can compute `f(group)` in parallel, thus potentially saving a large amount of time.
We can do this if each function `f(group)` can be computed independently, as in the example above with `f = sum`.

__Question__: What are examples of functions `f` that __cannot__ be computed independently?

A relevant example is when the function appends data to the same file.
Multiple processes trying to write to the same file is __bad news__.

Demo: tapply, as.Date, format

```r
bikes = read.csv("../data/awards_bicycles.csv")
```

Let's focus on a couple columns to see what we're doing.
```r
bikes = bikes[, c("total_obligation", "period_of_performance_start_date")]
```

Convert the period_of_performance_start_date into a date
```r
bikes$date = as.Date(bikes$period_of_performance_start_date)

head(bikes)
```

The date column prints out the same, but it is a different class.
```r
str(bikes)
```

I'm going to drop the old column because we don't need it anymore, and I want it to print nicely for you.
```r
bikes$period_of_performance_start_date = NULL
```

And make total_obligation a little shorter
```r
colnames(bikes)[2] = "price"

```

Let's extract the month
```r
bikes$month = format(bikes$date, "%m")

bikes$month 
```

tapply lets us ask questions such as:
What was the max the VA spent on a bike in any given month?

```r
tapply(bikes$price, bikes$month, max)
```

tapply works best on vectors.

Suppose we want to get the actual date along with the max price.

In SQL this might look something like:
```
SELECT month, date, max(total_obligation)
FROM bikes
GROUP BY month
;
```

Let's start by making it work for just one month.

```r
grp = bikes[bikes$month == "01", ]

maxprice = max(grp$price)
maxdate = grp$date[which.max(grp$price)]
```

Here's what I want to end up with for each month.
```r
# Janet observed that grp[, "month"] will make the data frame have more rows. Nice one!

data.frame(price = maxprice, date = maxdate, month = grp[1, "month"])
```

__Technique__: To process a bunch of different groups in the same way, write a function that processes a single group.

All I need to do in this case is transform what I already have into a function.


```r
max_price_date = function(grp)
{
    maxprice = max(grp$price)
    maxdate = grp$date[which.max(grp$price)]
    data.frame(price = maxprice, date = maxdate, month = grp[1, "month"])
}
```

Let's test it on the little subset we've been working with.

```r
max_price_date(grp)
```

Works. Sweet.

Now all we have to do is apply it to every group in the data.
We can use a specialized package, or we can use base R.

```r
months = split(bikes, bikes$month)
```

__Question__: What do you expect is the length?
```r
length(months)
```

Now we apply the function we wrote to each group.
```r
ms = lapply(months, max_price_date)
```

lapply means 'list apply'.
It returns a list containing all these individual data frames, so we need to combine them together.

```r
ms
```

Will data.frame do it for us?
Seems plausible.
Let's find out.

```r
ms2 = data.frame(ms)

# No. we expect a result that has 12 rows and 3 columns.
dim(ms2)
```

rbind is the function we're looking for here.
The parameters are `...`.
That means we can pass in as many arguments as we like.

```r
rbind(ms[[1]], ms[[2]])
```

So to bring them all together we just do this then, right?

```r
rbind(ms[[1]], ms[[2]], ms[[3]], ms[[4]], ms[[4]], ms[[5]], ms[[6]], ms[[7]], ms[[8]], ms[[9]], ms[[10]], ms[[11]], ms[[12]])
```

Ewww! No way!
__Question__ What's wrong with this?

- Hardcoding!
- Ugly!
- Error prone!

There must be a better way.
do.call is that better way.
do.call lets you provide arguments in a list, which is just what we had!

```r
ms2 = do.call(rbind, ms)
```

This says, "call the function rbind passing all the elements of ms in as arguments".

Ahh, here's what we wanted.
```r
ms2
```

The `by` function in base R does `split` and `apply` together.

```r
ms3 = by(bikes, bikes$month, max_price_date)

ms3 = do.call(rbind, ms)

ms3
```

Now, compare the SQL and the base R versions side by side:

SQL: 
```
SELECT month, date, max(price)
FROM bikes
GROUP BY month;
```

Elegant R:

`aggregate` gives us something nicer than `tapply`.
Thanks Rishi!
```r
aggregate(price ~ month, bikes, FUN = max)
```

split - apply in R:

```r
max_price_date = function(grp)
{
    maxprice = max(grp$price)
    maxdate = grp$date[which.max(grp$price)]
    data.frame(price = maxprice, date = maxdate, month = grp[1, "month"])
}
months = split(bikes, bikes$month)
ms = lapply(months, max_price_date)
ms2 = do.call(rbind, ms)
```

__Question__: Which is more clear?
Which is more flexible?
It's no wonder that there's a bunch of popular packages that make this sort of thing cleaner!

__Technique__: To process a bunch of files in the same way, write a function that processes a single file.

__Question__: What is good about this technique?
- Keeps your code clean and logical
- Easy to develop and test
- Easy to make parallel (we'll learn soon)
