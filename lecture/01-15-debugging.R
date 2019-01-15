## - If you aren't on Piazza, please let me know
## - Post with your name, not 'anonymous'.
##   No need to be shy, no one will judge you here.
##   Is there some kind of default to anonymous?
## - Also, make questions public.
## - usaspending projects
## - Demo Pull request
## - Clarify "memory leak"
## - Discussion tomorrow Siteng will show how to set up private git repositories 
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
     
# Ahh, needed to switch the order.

process_file = function(fname, zipfile = "~/data/awards.zip")
{
    rawcsv = unz(zipfile, fname)
    d = read.csv(rawcsv)
}

out = process_file("123.csv")

## 

## We're going to use the tm package.
## tm for text mining

library(tm)

## Last week we saw the 'bottom up' approach to development:
## Write some exploratory code and wrap it into a function.

## We can also do the 'top down' approach:
## Start with __empty__ functions.
## Write their signatures and a short piece of documentation.
## For example, I want to process the `description` column in this data, so I'm going to write a function to clean it up:

# clean up the strings in preparation for subsequent processing
preprocess_string = function(text)
{
    tm::stemDocument(text) 
}

## Now we verify it works as expected.
preprocess_string("STATISTICS statisticians statistical statistically")

## We can incorporate it into our workflow:

process_file = function(fname, zipfile = "~/data/awards.zip")
{
    rawcsv = unz(zipfile, fname)
    d = read.csv(rawcsv)
    preprocess_string(d[, "description"])
}

## Test it out:

process_file("123.csv")

## It didn't work :(

## Debugging to the rescue!

## Here's the stack trace:
## ```
## Error in UseMethod("stemDocument", x) :
##   no applicable method for 'stemDocument' applied to an object of class "factor"
## 3: tm::stemDocument(text) at #3
## 2: preprocess_string(d[, "description"]) at #5
## 1: process_file("123.csv")
## ```
## With experience you can sometimes stare these down and figure them out.
## But the debugger is faster.

## Draw picture of stack.
## This one has three frames.
## From the interpreter prompt we called the function `proceess_file`, which called `preprocess_string`, which called `tm::stemDocument(text)`.

## ## error options

## We can control what R does when it sees an error by setting the global error option.

## This lets us view the traceback
options(error = traceback)

## My favorite is `recover`, which will drop us directly into the debugger when we hit an error.
## This is how I usually program.
## It's often faster to throw something together, try it, and fix it rather than very rigorously work out how everything ought to behave.
## And real data is always the real test of how robust your program is.
options(error = recover)

## Now when we hit that same error we will enter the browser, so we can walk up and down the stack frames..

process_file("123.csv")

## `Selection:` allows us to choose where we want to go.
## `help` shows possible commands we can enter in the browser.
## That <expr> means we can enter any R expression, which is super helpful.

## `ls()` will list objects in the frame.
## Make a prediction- what do you expect to see?
## By the way- this sort of thing is what really tests how well you know the language.

## ```
## Selection: 1
## Called from: top level
## Browse[1]> help
## n          next
## s          step into
## f          finish
## c or cont  continue
## Q          quit
## where      show stack
## help       show help
## <expr>     evaluate expression
## Browse[1]> ls()
## [1] "d"       "fname"   "rawcsv"  "zipfile"
## ```

## We see the function arguments and the objects that have been defined in the function so far.

head(d)

## Entering into the tm::stemDocument frame we see that `x` is a factor, and this seems to have caused the issue.
## We can find out without even leaving the debugger.


## The problem came from the data frame reading in the strings as factors.
## We can change this by coercing factors to strings, or we can just say that we always want the strings to be factors by setting a global option.


options(stringsAsFactors = FALSE)

## Now our function _should_ work.

out = process_file("123.csv")

## Is it stemming the words?
## No.
## It's up to you to refine the processing steps.

## When we wrap the function calls into lapply the stack looks more confusing.

fnames = c("123.csv", "45678.csv")

lapply(fnames, process_file)

## ```
## 1: lapply(fnames, process_file)
## 2: FUN(X[[i]], ...)
## 3: #4: read.csv(rawcsv)
## 4: read.table(file = file, header = header, sep = sep, quote = quote, dec = de
## 5: open(file, "rt")
## 6: open.connection(file, "rt")
## ```

## The `FUN(X[[i]], ...)` is our actual function `process_file`.


## PS: The error handling is customizable- you can do anything you want.
## I expect to touch on this more later.
options(error = function() message("\n\nHakuna matata!\n\n"))

preprocess_string(as.factor(letters))


## ## Explicit debugging
##
## Sometimes we want to see what's going on even when there are no errors.
## For example, you get some weird final result so you want to make sure that the input data is what you expected.
## Then we can use the debugger.
## Rstudio's debugger provides convenient visuals here.

isdebugged(preprocess_string)

debug(preprocess_string)

out = process_file("123.csv")

## Once we're in the debugger we can step through each line of code and verify our assumptions.

## Other topics: `dump.frames`
