# STA 141C Big Data & High Performance Statistical Computing

Catalog Description:

> High­performance computing in high­level data analysis languages; different computational approaches and paradigms for efficient analysis of big data; interfaces to compiled languages; R and Python programming languages; high­level parallel computing; MapReduce; parallel algorithms and reasoning.

![Summit supercomputer](summit.jpg)

_The fastest machine in the world as of January, 2019 is the [Oak Ridge Summit Supercomputer](https://www.olcf.ornl.gov/olcf-resources/compute-systems/summit/)._


### Learning Outcomes

This is an experiential course.
Students will learn how to work with big data by actually working with big data.
We'll cover the foundational concepts that are useful for data scientists and data engineers.

These are the goals of the course:

1. Develop skills and confidence to analyze data larger than memory
1. Identify when and where programs are slow, and what options are available to speed them up
2. Critically evaluate new data technologies, and understand them in the context of existing technologies

The class will cover the following topics.
In class we'll mostly use the R programming language, but these concepts apply more or less to any language.

- 'group by' computation
- debugging
- profiling
- memory efficiency
- high level parallel programming
- interfacing to faster languages
- object oriented programming
- shell (bash)
- cluster computing (SLURM)

Optional topics:

- creating reusable software
- Databases, Hive, Postgres
- Other languages: Python, Julia, C
- test driven development
- metaprogramming
- GPUs (graphical processing units)
- Hadoop MapReduce

We won't do the following in class:

1. Go in depth into the latest and greatest packages for manipulating data.
   Feel free to use them on assignments, unless otherwise directed.
1. Comprehensive overview of machine learning, predictive analytics, deep neural networks, algorithm design, or any particular sub field of statistics.
3. Learn low level concepts that distributed applications build on, such as network sockets, MPI, etc.

These are all worth learning, but out of scope for this class.


### Data

We'll use the raw data behind [usaspending.gov](https://www.usaspending.gov/#/) as the primary example dataset for this class.
These are comprehensive records of how the US government spends taxpayer money.
From their website:

> USA Spending tracks federal spending to ensure taxpayers can see how their money is being used in communities across America.

How did I get this data?
I downloaded the [raw Postgres database](https://files.usaspending.gov/database_download/).
Nehad Ismail, our excellent department systems administrator, helped me set it up.
It's about 1 Terabyte when built.
The largest tables are around 200 GB and have 100's of millions of rows.


### Reference Books

You may find these books useful, but they aren't necessary for the course.
I'll post other references along with the lecture notes.

- The Art of R Programming, by Norm Matloff
- [Advanced R](http://adv-r.had.co.nz/), by Hadley Wickham
- Linux Pocket Guide, by Daniel Barrett


### Grading

Category    | Grade Percentage 
--------    | ----------------
Assignments   | 75
Group Project | 20
Participation | 5

- If there is any cheating, then we will have an in class exam.
- There will be around 6-8 assignments
- Rubrics will be posted for each individual assignment.
- The safest way to get full points for participation is to use Piazza on a weekly basis.


### Asking Questions

I expect you to ask lots of questions as you learn this material.
Here is where you can do this:

1. In class or at office hours
2. Online with Piazza.
   Make sure your posts don't give away solutions to the assignment.
   Including a handful of lines of code is usually fine.

For private or sensitive questions it's OK to email the instructor or TA.

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
- Using short snippets of code (5 lines or so) from lecture, Piazza, or other sources.
  Acknowledge where it came from in a comment or in the assignment.

__NOT OK__

- Any violations of the UC Davis code of student conduct.
- Using other people's code without acknowledging it. 
- Copying large blocks of code.
- Storing your code in a publicly available repository.
