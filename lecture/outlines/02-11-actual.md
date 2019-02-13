# Questions?

When we submit our scripts we get a bunch of different files.
Do we need another script to get all the output?

No. `wc -L` interactively is fine.

Compare:

`grep "pattern" | sort`
`sort | grep "pattern"`

Hint: How much data is being sorted?


## Rubric

- The code that you turn in should be the best that you can write.
- Some aspects really matter, and others are just cosmetic.
- The graders will be referring to these lecture notes.
- This applies more generally, beyond bash

#### Use variables


What does 5 mean here?

😡

```{bash}
head transaction_small.csv |
    cut -d , -f 5
```

😀

```{bash}
FISCAL_YEAR=5
head transaction_small.csv |
    cut -d , -f ${FISCAL_YEAR}
```

😀

```{bash}
YEAR=5
head transaction_small.csv |
    cut -d , -f ${YEAR}
```

Less conventional, but still fine:
😀

```{bash}
year=5
head transaction_small.csv |
    cut -d , -f ${year}
```


Bad variable name
😡
```{bash}
COLUMN=5
head transaction_small.csv |
    cut -d , -f ${COLUMN}
```

😐
```{bash}
head transaction_small.csv |
    cut -d , -f 5   # Select the fiscal_year 
```

Why is this way better?f
- You can change the value of YEAR and it will be propagated through the program
- Put global variables near the top.


```{bash}
YEAR=5
head transaction_small.csv |
    cut -d , -f ${YEAR}
```

__I value clarity over correctness__

The 'good' solution uses this variable.
What would be even better?
To infer it.
This is what R and Python do.

Are there any numbers where the 'magic number' anti pattern does not apply?
0, 1


#### DRY

Do not repeat yourself.

😀

```{bash}
DATAFILE="transaction_small.csv"
head ${DATAFILE} |
    wc -l

cat ${DATAFILE} |
    grep "National" |
    wc -l

YEAR=5
head ${DATAFILE} |
    cut -d , -f ${YEAR}
```

😡

```{bash}
head transaction_small.csv |
    wc -l

cat transaction_small.csv |
    grep "National" |
    wc -l

YEAR=5
head transaction_small.csv |
    cut -d , -f ${YEAR}
```

## Write out parameter names

Which is more clear?
😀
```{bash}
YEAR=5
cat transaction_small.csv |
    sort --key=${YEAR} --field-separator=, --numeric-sort
```
😡
```{bash}
YEAR=5
cat transaction_small.csv |
    sort -k ${YEAR} -t , -n
```

What if I unzip the whole data first?
It may be faster, depending on the IO of the physical disk.
It may be slower too.

#### Use a consistent style

😡
```{bash}
YEAR=5
cat transaction_small.csv | grep --no-filename "National" | sort --key=${YEAR} --field-separator=, | cat > result.txt
```


😀
```{bash}
YEAR=5
cat transaction_small.csv |
    grep --no-filename "National" |
    sort --key=${YEAR} --field-separator=, |
    cat > result.txt
```

😀
```{bash}
YEAR=5
cat transaction_small.csv |
grep --no-filename "National" |
sort --key=${YEAR} --field-separator=, |
cat > result.txt
```


