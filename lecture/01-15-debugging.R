## - If you aren't on Piazza, please let me know
## - Post with your name, not 'anonymous'.
##   No need to be shy, no one will judge you here.
##   Is there some kind of default to anonymous?
## - Also, make questions public.
## - usaspending projects
## - Demo Pull request
## - Clarify "memory leak"
## - Google panel
## 
## Better examples of group by operations:
## 
## 1. Thousands's of highway traffic sensors collect data every second.
##     Summarize the traffic flow patterns at each sensor.
##     At which points is traffic flow similar?
## 2. Millions of customers place orders for years.
##     Analyze each customer's buying patterns.
##     How many customers are purchasing more or less over time?
## 3. Simulations estimate temperature on the surface of the earth.
##     Compute the standard deviation at each (latitude, longitude) coordinate.
##     Is temperature generally more variable?
## 
## Content:
## 
## - Types of errors: syntax / parsing error vs. runtime error
## - Stack frames, computational model
## - setting global `options(stringsAsFactors = FALSE)`
## - Debugging `debug, undebug, debugonce, browser, options(error = recover), options(error = dump.frames)`
## - Checking what's going on- `message`, logging 
## - `try, tryCatch` if you don't want to actually stop.
## - Ignoring or elevating messages / errors
## 
## 2015 overview of state of the art for R [Statistical Methods and Computing for Big Data](https://arxiv.org/abs/1502.07989)
## 
## 
## 
## Background Reading:
## 
## Debugging chapters in R books
## 
## Debugging example- putting the arguments in the wrong order.
## 
## Learning to debug is an excellent investment of your time.
## It takes a little while to learn and get comfortable with it, but it will strengthen your mental model of the language.
## This goes for any language.
## Learning debugging is also somewhat like learning to program, because once you learn one debugger it's easier to pick up the next one.
## 
## Duncan Temple Lang likes to say, "Debugging should be the first thing you learn in a new language."
## 
## You don't have to learn the ins and outs of all the tools that I'm going to show you here.
## It's better to start off by getting comfortable with one or two, and then go from there.
## I didn't personally get comfortable with debugging until I worked on a software development project rather than data analysis.
## In hindsight, I should have learned it earlier!
## 

## ## Demos


## REPL - read, eval, print loop

## Codes starts as text.
## Syntax errors come from writing illegal code.
## For example, leave off a parenthesis and you'll see an error message:

process_file = function(fname)
{
    rawcsv = unz(fname
}

## ```
## Error: unexpected '}' in:
## "    rawcsv = unz(fname
## }"
## ```

## `unexpected '}'` means that the syntax mistake occurred _before_ `}`.
## IDE's and even text editors like Vim can help you identify these mistakes before you run your code.
## Look for angry red marks.
## They're the least interesting class of errors, and you need to solve them before you can run anything.

## Here's a function that contains a mistake that I actually made and had to figure out:
## (Cool points if you see the bug.)

process_file = function(fname, zipfile = "~/data/awards.zip")
{
    rawcsv = unz(fname, zipfile)
    d = read.csv(rawcsv)
}

## Let's try to use it.

out = process_file("123.csv")

## ```
## Error in open.connection(file, "rt") : cannot open the connection
## In addition: Warning message:
## In open.connection(file, "rt") : cannot open zip file '123.csv'
## ```

## Now we need to figure out what's wrong.
## Debugging advice from Norm Matloff: 
##  Confirm what you think is true, until you reach something that is not true.

## It says: `cannot open the connection`.
## From experience, I know that usually happens when the file is not there.

## Let's confirm the file is where I think it is.

"awards.zip" %in% list.files("~/data")

## Yes, the file is where I expected.
## I'm confident that I can feed `read.csv` a connection because I did it last lecture.
## One advantage of writing simple functions is that it's easier to reason about where something went wrong.
## Do I have the correct order of the arguments to `unz`?
## Let's read the documentation:

?unz
## Signature is:
## ```
## unz(description, filename, open = "", encoding = getOption("encoding"))
## ```
## > ‘unz’ reads (only) single files within zip files, in binary mode.
## > The description is the full path to the zip file, with ‘.zip’
## >      extension if required.
     

process_file = function(fname, zipfile = "~/data/awards.zip")
{
    rawcsv = unz(fname, zipfile)
    d = read.csv(rawcsv)
}

## Let's try to use it.

out = process_file("123.csv")


## We can control what R does when it sees an error by setting a global option.

options(error = traceback)

## Here's the stack trace:
## ```
## 5: open.connection(file, "rt")
## 4: open(file, "rt")
## 3: read.table(file = file, header = header, sep = sep, quote = quote,
##                      dec = dec, fill = fill, comment.char = comment.char, ...)
## 2: read.csv(rawcsv) at #4
## 1: process_file("123.csv")
## ```

## Draw picture of stack

options(error = recover)
