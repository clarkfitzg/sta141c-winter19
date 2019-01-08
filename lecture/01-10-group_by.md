
## We can extract _only_ this file from the archive if we like:
f = unz(zip_file_path, file_name)

## Then read it into a data frame
grp = read.csv(f)


