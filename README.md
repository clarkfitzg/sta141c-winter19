# STA 141C Big Data & High Performance Statistical Computing

Catalog Description:

> High­performance computing in high­level data analysis languages; different computational approaches and paradigms for efficient analysis of big data; interfaces to compiled languages; R and Python programming languages; high­level parallel computing; MapReduce; parallel algorithms and reasoning.

Looking over the syllabus, proposed emphasis is as follows:

- 0.1 profiling / efficiency
- 0.1 bash
- 0.2 compiled code
- 0.4 Python
- 0.2 Parallel / distributed

James and Nick are doing all of 141B in Python.
If I teach Python I have to do it for all those in 141A who never saw it, and this will be boring for those that already took 141B.
Instead I can just let them use Python (or any other language) if they're more comfortable with it.
The concepts will be the same in both languages.
Julia, as an up and comer, that's now at 1.0, might be good to demonstrate the compiled languages.
I'd prefer that over Rcpp.
I like that C really forces you to understand data types, memory, etc.

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
