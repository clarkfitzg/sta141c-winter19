# STA 141C Big Data & High Performance Statistical Computing

Catalog Description:

> High­performance computing in high­level data analysis languages; different computational approaches and paradigms for efficient analysis of big data; interfaces to compiled languages; R and Python programming languages; high­level parallel computing; MapReduce; parallel algorithms and reasoning.


### Learning Outcomes

> Students learn to reason about computational efficiency in high­level languages. 
> They will be able to use different approaches, technologies and languages to deal with large volumes of data and computationally intensive methods.

This is an experiential course.
Students will learn how to work with big data by actually working with big data.
We'll explore the foundational concepts that will 

These are the goals of the course:

1. Develop skills and confidence to analyze data larger than memory
1. Identify when and where programs are slow, and what options are available to speed them up
2. Critically evaluate new data technologies, and understand them in the context of existing technologies

We'll introduce and use the following concepts at a high level:

2. Remote and cluster computers
1. Parallel programming
3. Software engineering, such as unit testing and version control

We won't do the following in class:

2. Go in depth into the latest and greatest packages for manipulating data.
   Feel free to use them on assignments, unless otherwise stated.
1. Comprehensive overview of machine learning, predictive analytics, or any particular sub field of statistics.
3. Learn low level concepts that distributed applications build on, such as network sockets, MPI, etc.

These are all worth learning, but out of scope for this class.


## Syllabus

Category    | Grade Percentage 
--------    | ----------------
Assignments   | 75
Group Project | 20
Participation | 5

- If there is any cheating, then we will have an in class exam.
- We may curve the class, depending on the distribution at the end.
- There will be around 6 assignments (TODO: check)
- Rubrics will be posted for each individual assignment.
- The safest way to get full points for participation is to use Piazza on a weekly basis.

### Asking Questions

Questions about the material or logistics belong on Piazza so that everyone can see and respond.
For private or sensitive questions ask the TA or instructor.

Asking good technical questions is an important skill.
Stack Overflow offers some [sound advice on how to ask questions](https://stackoverflow.com/help/how-to-ask).
Summarizing,

1. Check that your question hasn't been asked.
2. Make the question specific, self contained, and reproducible.

### Assignments

Start early!
Programming takes a long time, and you may also have to wait a long time for your job submission to complete on the cluster.

I encourage you to talk about assignments, but you need to do your own work, and keep your work private.

__OK__

- Talking about general approaches.
- Using short snippets of code (5 lines or so) from lecture, Piazza, or other sources. Acknowledge where it came from in a comment or in the assignment.

__NOT OK__

- Using other people's code without acknowledging it. 
- Copying large blocks of code.
- Storing your code in a publicly available repository.
- Offering to pay someone else to do your assignment.


## Schedule

Topic | Description
----- | -----------
class and technology overview | syllabus, historical context of programming languages, modern usage, strengths and weaknesses, open source, job opportunities
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

The first assignment should be something with local data.
Then students can decide if they want to drop the class or not.
After enrollment stabilizes, I'll give them access to the cluster.
The first assignment shouldn't use bash, because the Windows users won't have bash installed.
Instead, the first one should be something that they can handle in memory- perhaps of the group by flavor.

Duncan tends to give open ended assignments.
For undergraduates I think the assignments should be more well defined- i.e. use the cluster to do X, Y, Z.
The project can be open ended.

I want the assignments to focus on these things:

- importance of data structures
- how to make an R package
- `stdin` stream processing in bash / other languages
- 2X data processing on cluster _usaspending benfords_
- interface to compiled code (Julia or C) _traffic model_
- metaprogramming _tree biomass_

usaspending is a huge, rich database.
I think it would be more valuable to spend more time exploring data from this one source rather than having cursory exposure to 10 different data sets.
After all, this is how work often is- think of my industry experiences.
Then I'll let them come up with a question on this data set, or give them a handful of prompts to get started.
They can also propose their own project.


__Historical background__
Write a 1 page summary of one programming language. How was it used in the past? How is it used today?
This could be useful to introduce git.

__Theoretical limits__
Derive Gustafson, Amdahl's laws.

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

__Algorithms vs hardware__
Choosing appropriate data structures and algorithms is usually better than blindly adding compute power.


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
