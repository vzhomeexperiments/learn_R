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


## Avoiding growing a vector in for loop
# example
n <- 30000
# Slow code
growing <- function(n) {
    x <- NULL
    for(i in 1:n)
        x <- c(x, rnorm(1))
    x
}

# to measure:
# Use `<-` with system.time() to store the result as res_grow
system.time(res_grow <- growing(30000))

# result
   user  system elapsed 
  2.048   0.040   2.096

## fast code
n <- 30000
# Fast code
pre_allocate <- function(n) {
    x <- numeric(n) # Pre-allocate
    for(i in 1:n) 
        x[i] <- rnorm(1)
    x
}

# Use `<-` with system.time() to store the result as res_allocate
n <- 30000
system.time(res_allocate <- pre_allocate(30000))
# result   
   user  system elapsed 
  0.056   0.000   0.058

## Should use vectorised solutions whereever possible!!!

# example: this code is not vectorised
x <- rnorm(10)
x2 <- numeric(length(x))
for(i in 1:10)
    x2[i] <- x[i] * x[i]

# this runs much faster
# Store your answer as x2_imp
x2_imp <- x*x

## Vectorized code
# x is a vector of probabilities
total <- 0
for(i in seq_along(x)) 
    total <- total + log(x[i])

# Initial code
n <- 100
total <- 0
x <- runif(n)
for(i in 1:n) 
    total <- total + log(x[i])

# Rewrite in a single line. Store the result in log_sum
log_sum <- sum(log(x))

## Use matrices whenever possible - to optimize code
# Which is faster, mat[, 1] or df[, 1]? 
microbenchmark(mat[ ,1], df[, 1])

> microbenchmark(mat[ ,1], df[, 1])
Unit: microseconds
     expr    min      lq     mean  median     uq     max neval
 mat[, 1]  3.173  3.5600  6.47358  3.9935  4.418 234.400   100
  df[, 1] 18.251 19.7735 21.41484 20.6165 21.491  87.283   100

# Which is faster, mat[1, ] or df[1, ]? 
microbenchmark(mat[1, ], df[1, ])

> microbenchmark(mat[1, ], df[1, ])
Unit: microseconds
     expr      min        lq       mean    median       uq       max neval
 mat[1, ]    4.615    5.5895   11.29247   10.1515   14.300    37.959   100
  df[1, ] 5613.701 6053.9650 7003.47098 6349.7760 7470.361 13831.791   100

## profiling of your code with profvis library
# Load the data set
data(movies, package = "ggplot2movies") 

# Load the profvis package
library(profvis)

# Profile the following code with the profvis function
profvis({
  # Load and select data
  movies <- movies[movies$Comedy == 1, ]

  # Plot data of interest
  plot(movies$year, movies$rating)

  # Loess regression line
  model <- loess(rating ~ year, data = movies)
  j <- order(movies$year)

  # Add a fitted line to the plot
  lines(movies$year[j], model$fitted[j], col = "red")
})     ## Remember the closing brackets!  
