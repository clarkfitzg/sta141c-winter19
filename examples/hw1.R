# This is a partial solution to the homework.
# The speed comes from using efficient packages.

library(fasttime)
library(data.table)

DATADIR = "~/data/awards/"

csv_files = list.files(DATADIR, full.names = TRUE)

process_one = function(csv_file_name)
{
    d = fread(csv_file_name, 
              select = c("total_obligation", "period_of_performance_start_date")
              )
    date = fastPOSIXct(d$period_of_performance_start_date)
    year = format(date, "%Y")
    totals = tapply(d$total_obligation, year, sum)
    median(totals)
}

# Takes 45 seconds
system.time(m <- sapply(csv_files, process_one))

# A simple way to tell visually if there is a gap is by plotting the sorted values.
m = sort(m, decreasing = TRUE)

plot(head(m, 100), log = "y"
     , xlab = "agency"
     , ylab = "median annual spending in dollars"
     )
