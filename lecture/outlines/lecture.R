# Announcements:
# 
# - 
# - My office hours Thursday will be in the Data Science Initiatve, Shields 360, right after class.
# 
# ## Notes on first HW
# 
# - Grades for HW1 are available.
#   Ask Siteng in OH if you have questions / clarifications.
# - Difference between formatting numbers for humans and for machines.
#   What's this number? 3414992319 is 3.4 billion
#   Communication- a report is for communicating with humans.
#   So put them on a table in units that make it easy for humans to read.
# - Submit homework in a format that Canvas can preview- pdf, html, docx.
#   We're using the online system to grade- make it easy on the graders.
# 
# 
# on board
# 
# - review independent workers model for parallelism
# - pictures of replicate, lapply (sapply), tapply, apply, Map, mapply, rapply
# - What the load balancing cluster apply does with chunking.
# 
#  
# 
# ## Vectorization
# 
# Use `microbenchmark` for small timing experiments.
# 
# Vectorized functions operate on entire vectors at once.
# 
# ```{r}
# library(microbenchmark)
# 
# n = 1e4
# x = rnorm(n)
# 
# # Fast- Vectorized
# microbenchmark(y <- exp(x))
# 
# # This is not how exp is designed to be used.
# exp_apply = function(x) sapply(x, exp)
# 
# # Slow
# microbenchmark(y_apply <- exp_apply(x))
# 
# exp_loop_preallocated = function(x)
# {
#     # Preallocation means we create a place for the answers to go.
#     result = numeric(length(x))
#     for(i in seq_along(x)){
#         result[i] = exp(x[i])
#     }
#     result
# }
# 
# # Turn off the byte code compiler
# enableJIT(0)
# 
# # Slow
# microbenchmark(y_loop_preallocated <- exp_loop_preallocated(y), times = 10L)
# 
# 
# exp_loop_growing = function(x)
# {
#     # Dynamically grow the result by appending to the end.
#     result = c()
#     for(i in seq_along(x)){
#         result = c(result, exp(x[i]))
#     }
#     result
# }
# 
# # Disaster
# microbenchmark(y_loop_growing <- exp_loop_growing(y), times = 10L)
# 
# ```
# 
# Moral of the story?
# 
# - Prefer vectorization whenever possible.
#   String functions such as `tolower, gsub`, etc. are all vectorized.
# - Apply functions are clean, easier to parallelize, and they always preallocate correctly.
# - Avoid dynamically growing objects
# 
# 
# 
# ## Data types
# 
# The goal today is to learn a little about how to reason about how large something is.
# Number crunching is fast because of contiguous blocks of homogeneously typed memory.
# 
# Question: What are the possible low level types for R in memory?
# - 
# 
# ```{r}
# typeof(TRUE)
# typeof(1L)
# typeof(1)
# typeof(1+0i)
# typeof(raw(10L))
# ```
# 
# Characters and factors are a little different.
# 
# ```{r}
# typeof("words and more words")
# 
# f = as.factor(c("female", "male", "female"))
# 
# typeof(f)
# 
# f
# ```
# 
# Factors are actually stored as integers.
# How does R know what value to print?
# 
# It has an internal lookup table matching the integers to character strings.
# 
# ```{r}
# levels(f)
# ```
# 
# How do we calculate how large an array is?
# 
# ```{r}
# n = 1000
# p = 500
# x = matrix(rnorm(n * p), nrow = n)
# 
# typeof(x)
# 
# # Expert knowledge!
# bytes_per_double = 8
# 
# expected_size = n * p * bytes_per_double
# ```
# 
# Is the object the expected size?
# 
# ```{r}
# object.size(x)
# ```
# 
# Not exactly.
# Question: Why not?
# Because R has some memory overhead per object, a few bytes of metadata hanging out for every object.
# 
# Question: How large will it be if we store this in a general container, like a list?
# 
# ```{r}
# xl = lapply(x, identity)
# object.size(xl)
# 
# as.numeric(object.size(xl) / object.size(x))
# ```
# 
# The list is 8 times bigger than the efficient matrix form. :(
# 
# Which one is faster?
# 
# ```{r}
# library(microbenchmark)
# sum(x)
# microbenchmark(sum(x))
# microbenchmark(do.call(sum, xl))
# ```
# 
# The matrix is 2 orders of magnitude faster.
# 
# For efficiency we like small objects, and fast code.
# 
# 
# ## Matrix
# 
# Use the right data structure to increase speed and reduce memory usage.
# 
# ```{r}
# library(Matrix)
# 
# m = Matrix(1:10, nrow = 2)
# 
# class(m)
# ```
# 
# So what's a dgeMatrix?
# We need to look up the help page for the class.
# 
# ```{r}
# ?dgeMatrix # Nope
# 
# class?dgeMatrix
# ```



















library(microbenchmark)

n = 1e4
x = rnorm(n)

# 100 microseconds
microbenchmark(y <- exp(x))

# 3 milliseconds
microbenchmark(y2 <- sapply(x, exp))

all(y == y2)

exp_loop_preallocate = function(x)
{
    # Here's the preallocation:
    # Make space for our result
    result = numeric(length(x))
    for(i in seq_along(x)){
        result[i] = exp(x[i])
    }
}

library(compiler)
enableJIT(0)

# Without byte code compiler:
# Around 8 ms
microbenchmark(y3 <- exp_loop_preallocate(x))

# What if we turn on the byte code compiler?
enableJIT(0)

# Now it's 900 microseconds
microbenchmark(y3 <- exp_loop_preallocate(x))

# What happens when we do not preallocate?
exp_loop_bad = function(x)
{
    # Dynamically build the result
    result = c()
    for(i in seq_along(x)){
        result = c(result, exp(x[i]))
    }
}

# Around 160 milliseconds
microbenchmark(y4 <- exp_loop_bad(x), times = 10L)

# vectorized: 100 microseconds
# sapply: 4 ms
# with preallocation: 8 ms
# without preallocation: 160 ms

# Takeaways:
# - Always use vectorization if you can.
# Why do we like apply?
# - easier code to write and read
# - it's easy to make it parallel
# - not possible to make "growing vector" error


# Data types

# What are the possible data types in R?

# How it acts
class(1)

# How it is stored / represented in memory
typeof(1)

typeof(TRUE)

typeof(1L)

typeof(1)

r = as.raw(1:4)

typeof(r)

d = as.Date("2018-10-10")
typeof(d)
class(d)

f = as.factor(c("male", "female", "female"))

class(f)

typeof(f)

as.integer(f)

levels(f)



typeof("abc")


