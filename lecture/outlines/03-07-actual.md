## Announcements

- Work on your projects.
    Besides posting on the usaspending website, the statistics department will also post a link on the department website.
    Want to go to graduate school or demonstrate competence to a potential employer?
    This is a great chance to get some visibility.
- Course evaluations open tomorrow.
    The University takes these seriously, especially for lecturers.
    A 4/5 average rating is an important threshold for the instructor.
    People will also read your free form comments.


## Review

Test driven development:

1. Write a failing test
2. Write the minimum amount of code to make it pass

Profiling:

1. Run it and measure it, find out what's slow
2. Make the slow part fast
3. Repeat until it's fast enough

Ways to make things fast:

2. Change data structures
2. Change algorithm
3. Vectorization
1. Parallelism 
4. Buy bigger, faster computer
4. Get faster versions of software
5. Use other people's fast code
6. Interface to compiled language


## Questions

> Can we use multiple language and report in MS Word?

Sure.


## Databases

What is a database? How is it different from a bunch of CSV files in a directory?

- Managed, controlling access, concurrency (multiple users) and storage


## Actual systems

Client / server architecture

SQL is a __declarative__ language, which means you write what you want, and let the system figure out how to compute it.

Two types of databases in large organizations:

__transactional database__  make a bank transaction, buy an airplane ticket, book a hotel, buy life insurance
__data warehouse__ aka enterprise data warehouse, data lake (swamp), 

SQLite is file based.


## SQL

There are tons of databases out there.
- Google BigQuery (cloud based)
- 20 Amazon cloud based DB's
- SQLite
- Oracle
- Postgres
- Hive (Shark?, Impala?) / Hadoop / Spark
- Teradata
- Microsoft SQL Server
- DB2 IBM
- mySQL

All (probably) use SQL with minor variations.

```{bash}

sqlite3 ~/data/usaspending.sqlite

.help

.tables

SELECT toptier_agency_id, name FROM agency LIMIT 5;

.quit

```

`SELECT, FROM` are the essential parts of a query.

`module load bio`


## Integration with `stdout`

```{bash}

sqlite3 -header -csv ~/data/usaspending.sqlite "SELECT toptier_agency_id, name FROM agency LIMIT 20;" | head

cat query.sql \
| sqlite3 -header -csv ~/data/usaspending.sqlite \
| head

```


## Connecting to R

question: why go directly from DB to programming?
It's better!

Answer: Potentially easier to stream
More efficient, uses less memory, probably faster
maintains data types



```{r}

library(DBI)
library(RSQLite)

conn = dbConnect(SQLite(), "~/data/usaspending.sqlite")

# Pull query in
q = readLines("query.sql")
q = paste(q, collapse = " ")

q2 = "SELECT toptier_agency_id, name FROM agency LIMIT 5;"

first5 = dbGetQuery(conn, q2)

# What is a SQL injection attack?

q3 = "DROP TABLE agency;"

dbSendStatement(conn, q3)


dbDisconnect(conn)

```

