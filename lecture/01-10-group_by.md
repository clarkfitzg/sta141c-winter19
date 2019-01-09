
## Extracting

We can extract _only_ this file from the archive if we like:
```r
f = unz(zip_file_path, file_name)
```

Then read it into a data frame
```r
grp = read.csv(f)
```
