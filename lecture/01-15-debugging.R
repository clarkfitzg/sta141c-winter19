- If you aren't on Piazza, please let me know
- Post with your name, not 'anonymous'.
  No need to be shy, no one will judge you here.
  Is there some kind of default to anonymous?
- Demo Pull request
- Clarify "memory leak"

Better examples of group by operations:

1. Thousands's of highway traffic sensors collect data every second.
    Summarize the traffic flow patterns at each sensor.
    At which points is traffic flow similar?
2. Millions of customers place orders for years.
    Analyze each customer's buying patterns.
    How many customers are purchasing more or less over time?
3. Simulations estimate temperature on the surface of the earth.
    Compute the standard deviation at each (latitude, longitude) coordinate.
    Is temperature generally more variable?

Content:

- Stack frames, computational model
- setting global `options(stringsAsFactors = FALSE)`
- Debugging `debug, undebug, debugonce, browser, options(error = recover), options(error = dump.frames)`
- Types of errors: syntax / parsing error vs. runtime error
- Checking what's going on- `message`, logging 
- Ignoring or elevating messages / errors

2015 overview of state of the art for R [Statistical Methods and Computing for Big Data](https://arxiv.org/abs/1502.07989)



Background Reading:

Debugging chapters in R books

Debugging example- putting the arguments in the wrong order.

Learning to debug is an excellent investment of your time.
It takes a little while to learn and get comfortable with it, but it will strengthen your mental model of the language.
This goes for any language.
Learning debugging is also somewhat like learning to program, because once you learn one debugger it's easier to pick up the next one.

Duncan Temple Lang likes to say, "Debugging should be the first thing you learn in a new language."

You don't have to learn the ins and outs of all the tools that I'm going to show you here.
It's better to start off by getting comfortable with one or two, and then go from there.
I didn't personally get comfortable with debugging until I worked on a software development project rather than data analysis.
In hindsight, I should have learned it earlier!

pro
