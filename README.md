# STA 141C Big Data & High Performance Statistical Computing

Catalog Description:

> High­performance computing in high­level data analysis languages; different computational approaches and paradigms for efficient analysis of big data; interfaces to compiled languages; R and Python programming languages; high­level parallel computing; MapReduce; parallel algorithms and reasoning.


### Learning Outcomes

This is an experiential course.
Students will learn how to work with big data by actually working with big data.
These are the goals of the course:

1. Develop skills and confidence to analyze data larger than memory
2. Use remote compute resources
1. Identify when and where programs are slow, and what options are available to speed them up
2. Critically evaluate new data technologies, and understand them in the context of existing technologies
3. Understand basic software engineering concepts

We won't do the following in class:

1. Comprehensive overview of statistics, machine learning, or 
2. Go in depth into the latest and greatest packages for manipulating data.

These are all worth learning, but it's not the goal of this class.


## Schedule

Topic | Description
-----
technology overview     | historical context of programming languages, modern usage, strengths and weaknesses, open source
bash 1                  | intro to command line, working and absolute directories, man page, executing programs, passing arguments, inspecting data, stdin and pipes
bash 2                  | intro to Gauss, cluster architecture 
test driven development |
speed profiling         | `Rprof`, microbenchmark
memory profiling        | when are objects copied? Why does it matter?
interfacing to faster languages | JuliaCall, intro to Julia
metaprogramming         | data as code, supports tree assignment

I like the idea of doing bash first, because it helps support everything else afterwards.

Looking over the syllabus, proposed emphasis is as follows:

- 0.1 profiling / efficiency
- 0.1 bash
- 0.2 compiled code
- 0.4 Python
- 0.2 Parallel / distributed

## Concepts

### Writing

__Technical Reports__
What are the bottlenecks in a program?
What are the options to fix it?

__Paper Summaries__
Read original papers on Hadoop, Hive, etc.

__Learning Narrative__
Idea: separate the report on the data vs. what you learned / used to solve it, problems you ran up against.

### Software Engineering

__Errors__
How to read a stack trace?

__Debugging__
Debuggers are better than print statements

__Profiling__
Never assume you know what's going on.
Measure your program.
Profiling is different than a microbenchmark
"Premature optimization is the root of all evil."
When are copies made? `tracemem` in R.

__Logging__
Save the results to look at them later.
Even just a stack trace is better than nothing.

__Software Reuse__
Use standard, existing tools where possible.
Good example- R's Matrix package.
Use the _minimium_ tool that gets the job done- if you can do it on a server in 2 minutes and you don't anticipate this growing, then why bother with Hadoop?

__Unit Testing__
Test driven development, write a test and documentation first.

__Automation__
`GNU make` works well, and we can use this to test everyone's code all at once.

__Code Review__
How to talk about others code.


### Data

__Physical Data Types__
What is an array of doubles?
Leads nicely into C programming.

__Vectorization__
Intermediate copies, R's memory model.

__Data Representation__
Sparse data structures can save on both space and runtime.

__Low Rank Matrix Decompositions__
Approximately represent large data more efficiently, see notes from Udell's talk.

__stdin stdout__
UNIX pipes- standard interfaces for data transfer between processes.
Can show pipeline parallelism here.
Fun example might be to pipe from text file to Python to Julia to R to a database.
Some of these low level tools can be quite efficient: `sort, split, cut`

__Chunking__
Data too big?
Cut it up into pieces that you can work with.
This can be parallel too.

__IID__
`SELECT * FROM data LIMIT 5;` is _not_ IID.

__Map side join__
One big table larger than memory, one small table that fits in memory, do something that requires joining the two.


### Project / HW ideas

__Historical background__
Write a 1 page summary of one programming language. How was it used in the past? How is it used today?

__Animal movements__
Given GPS tracking data of where the monkeys have moved, describe how they behave.

__Compiled Code__

__Julia on GPU__
Can compile and run Julia code directly?

__Summing up Random Variables__
How many times do we need to add up Cauchy variable before the sum is infinite?
Or any other RV where expectation is not defined.
Could also introduce some numerical methods.

__Metaprogramming__
Given a table of equations, look up the right equation and apply it.

__Streaming__
Count min sketch for streaming data.

### Data sets

I would like to do something with open source software data.
Log file processing certainly motivates big data...

Big list: https://github.com/awesomedata/awesome-public-datasets


__Maybe__

USAspending.gov database. 44.8 GB PostgresSQL archive https://files.usaspending.gov/database_download/
Can ask some interesting questions- how does the federal government spend the taxpayer money?
Digital Accountability and Transparency Act of 2014- analyzing this data is one way for citizens to hold government accountable.
Do the numbers add up?
We could do some text processing to see what the government cares about.
Detect outlying expenses. How similar are two gov organizations?

Raw Travis build logs: https://travistorrent.testroots.org/buildlogs/20-12-2016/ 
nice table: https://travistorrent.testroots.org/page_dataformat/
3.7 million rows and 62 columns, 1.7 GB in memory.

Zenodo software library dependendency information: https://zenodo.org/record/1196312#.W-274ZNKjOQ
7 CSV tables, good for relational concepts.

__No__

2019 JSM Data Challenge. Data too small, only 9 MB. Could mention it though. Abstract submission due Feb 4th.
