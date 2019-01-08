## Introduction

Welcome to STA 141C, Big Data and High Performance Computing.

I'm Richard Clark Fitzgerald.
You can call me Clark.
I'm a 5th year PhD student studying under Duncan Temple Lang.
The Statistics Department asked me to teach this because it's related to my research.


## Class Overview

In this class I'll mainly demonstrate (base) R, bash and cluster computing with SLURM.
R is a programming language for analyzing data.
bash is 'the command line'
SLURM is the job submission software for the 10 or so compute clusters on campus, which is why I chose it.

My philosophy is to teach in more depth a couple standard, proven technologies that are appropriate for this class, rather than briefly covering 10 different ones.
The focus is on concepts, not getting lost in setup details and syntax.
We will also dabble in other languages- Python, Julia, C.

What is 'big data'?
It's an ambiguous term - kind of like 'data science'.
One definition that's sometimes useful is data that's larger than memory, because this requires different techniques from the usual in-memory R and Python.

(Blackboard)
What are some other 'big data' or high performance technologies you've heard of?

- Big Data: SQL, noSQL, Cloud computing, Hadoop MapReduce, Spark, Hive, Impala, Pig, dask, Arrow, Parquet
- High Performance: MPI, GPU, CUDA, Tensorflow

If you're super excited to learn and use some other technology on your own then go for it, especially on the final project.
I get excited about new technologies too.
But don't get sucked into the "language wars"- religious debates on which technology is "better".

Regarding prerequisites, I expect that you are already comfortable handling data with R or Python.
If you're not, that's ok- the TA and I will do our best to get you up to speed.
The homeworks will just take more time.
I actually don't satisfy any of the prerequisites, yet here I am teaching the class.
All the other technologies and statistics we'll learn together.


## About you

What do you want to get out of this class?

- love to learn?
- get a job?
- solve a research problem?

Who wants to get a job in data science?
It's a pretty good time for it.
https://www.indeed.com/salaries/Data-Scientist-Salaries,-California
I worked in the field and came back to get my PhD when I saw the kinds of opportunities available to those who knew both the statistics and had the technical computing skills.
Most organizations need people who can do this.
Much of what we'll do in class is motivated by my work experience.


## Upcoming Events

1. Google Data Scientist panel Friday afternoon https://www.eventbrite.com/e/google-data-scientist-career-panel-tickets-53978556315
1. Stats seminar Larry Wasserman "Assumption Free Predictive Inference" Thursday 4pm, MSB 1147 https://statistics.ucdavis.edu/events/seminar-011019-wasserman


## Syllabus

Quick walk through.

https://github.com/clarkfitzg/sta141c-winter19


## Data

usaspending


## Homework 1

```{r}

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

# Always be touching your data

# first few lines
head(d)

# Dimensions, number of rows and columns
dim(d)

# summarize object
summary(d)
```
