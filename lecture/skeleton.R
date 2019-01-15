## - If you aren't on Piazza, please let me know
## - Post with your name, not 'anonymous'.
##   No need to be shy, no one will judge you here.
##   Is there some kind of default to anonymous?
## - Also, make questions public.
## - usaspending projects
## - Demo Pull request
## - Clarification: Using too much memory is NOT a memory leak.
## - Memory usage plot
## - Better examples of group by computations:
##      traffic sensor, customers
## - Google panel

## Questions?






## Debugging is an investment.
## Skills transfer between languages.

# REPL

## This code contains a syntax error:

process_file = function(fname)
{
    rawcsv = unz(fname
}











## This function contains an actual mistake I made.

process_file = function(fname, zipfile = "~/data/awards.zip")
{
    rawcsv = unz(fname, zipfile)
    d = read.csv(rawcsv)
}

## Let's try to use it.

out = process_file("123.csv")












## Let's confirm the zip file is where I think it is.













## Do I have the correct order of the arguments to `unz`?
## Let's read the documentation:

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













# Another approach to development - functions first

library(tm)

# clean up the strings in preparation for subsequent processing
preprocess_string = function(text)
{
}

## Now we verify it works as expected.
preprocess_string("STATISTICS statisticians statistical statistically")











## Let's incorporate it into our process_file function





## Test it out:

process_file("123.csv")











## Debugging to the rescue!








## error options

## We can control what R does when it sees an error by setting the global error option.










## This lets us view the traceback
options(error = traceback)

## What's a "stack"?












options(error = recover)

## Now when we hit that same error we will enter the browser, so we can walk up and down the stack frames..

process_file("123.csv")

## Selection, help 









options(stringsAsFactors = FALSE)

## Now our function _should_ work.

out = process_file("123.csv")

## Is it stemming the words?
## No.
## It's up to you to refine the processing steps.














## Adding lapply in the mix makes the stack trace more difficult to read.












## PS: The error handling is customizable- you can do anything you want.
## I expect to touch on this more later.

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

undebug(preprocess_string)

## Other topics: `dump.frames`
