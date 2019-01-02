# STA 141C Big Data & High Performance Statistical Computing

Catalog Description:

> High­performance computing in high­level data analysis languages; different computational approaches and paradigms for efficient analysis of big data; interfaces to compiled languages; R and Python programming languages; high­level parallel computing; MapReduce; parallel algorithms and reasoning.

![Summit supercomputer](summit.jpg)

_The fastest machine in the world as of January, 2019 is the [Oak Ridge Summit Supercomputer](https://www.olcf.ornl.gov/olcf-resources/compute-systems/summit/)._

### Learning Outcomes

From syllabus:

> Students learn to reason about computational efficiency in high­level languages. 
> They will be able to use different approaches, technologies and languages to deal with large volumes of data and computationally intensive methods.

This is an experiential course.
Students will learn how to work with big data by actually working with big data.
We'll cover broadly applicable foundational concepts.

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
   Feel free to use them on assignments, unless otherwise directed.
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

I expect you to ask lots of questions as you learn this material.
Here is where you can do this:

1. In class or at office hours
2. Online with Piazza.
   Make sure your posts don't give away solutions to the assignment.
   Including a handful of lines of code is usually fine.

For private or sensitive questions ask the instructor or TA.

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

Subject to change

Topic | Description
----- | -----------
class and technology overview | syllabus, historical context of programming languages, modern usage, strengths and weaknesses, open source, job opportunities
group by computation    | chunking, capabilities of a local machine, relation to SQL, Hadoop
bash 1                  | intro to command line, working and absolute directories, man page, executing programs, passing arguments, inspecting data, stdin and pipes
cluster                 | intro to Gauss, cluster architecture 
test driven development |
speed profiling         | `Rprof`, microbenchmark
memory profiling        | when are objects copied? Why does it matter?
interfacing to faster languages | JuliaCall, intro to Julia
metaprogramming         | data as code, supports tree assignment

<!--
I like the idea of doing bash early, because it helps support everything else afterwards.
-->
