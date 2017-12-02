## Efficient code writing implies to do benchmarking

# How long does it take to read movies from CSV?
system.time(read.csv("movies.csv"))

# How long does it take to read movies from RDS?
system.time(readRDS("movies.rds"))

## Using microbenchmark package

# Load the microbenchmark package
library(microbenchmark)

# Compare the two functions
compare <- microbenchmark(read.csv("movies.csv"), 
                          readRDS("movies.rds"), 
                          times = 10)

# Print compare
compare

# Result will be
Unit: milliseconds
                   expr       min        lq     mean    median        uq
 read.csv("movies.csv") 698.31273 727.79053 814.2164 793.03521 919.07960
  readRDS("movies.rds")  51.86198  78.55357  88.0741  83.80068  92.46535
      max neval
 954.8817    10
 145.5921    10
 
 ## Benchmarking machines
 # Load the benchmarkme package
library(benchmarkme)

# Assign the variable `ram` to the amount of RAM on this machine
ram <- get_ram()
ram

# Assign the variable `cpu` to the cpu specs
cpu <- get_cpu()
cpu

## Benchmarking current machine by running standardized code
# Load the package
library(benchmarkme)

# Run the io benchmark (read and write file 5MB)
res <- benchmark_io(runs = 1, size = 5)

# Plot the results
plot(res)
