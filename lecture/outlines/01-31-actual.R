### Homework help
#
#Compressed sparse row
#
#These are a little hard to read because they're 0 based indices, vs 1 based as in R.
#
#```{r}
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


















#Announcements:
#
#- office hours today
#

# Questions:
# It seems like there is one word unaccounted for?

# Ans: comes from the header
# Two ways to get around it:

w = read.csv("~/data/award_words/words.csv", header = FALSE)

w = read.table("~/data/award_words/words.csv")

## Homework help


library(methods)
library(Matrix)

# Column oriented by default
mc = sparseMatrix(i = c(7, 8), j = c(3, 3), x = c(10, 20))

# general dense matrix
m = as(mc, "dgeMatrix")

# Compressed sparse row
# row oriented
mr = as(mc, "dgRMatrix")
# Doesn't work

mr = as(as(m, "matrix"), "dgRMatrix")

# Keep in mind this uses 0 based indexing
str(mr)

# How many integers are there?
.Machine
