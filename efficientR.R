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


## Improving a code using matrix
# Load the microbenchmark package
library(microbenchmark)

# The previous data frame solution is defined
# d() Simulates 6 dices rolls
d <- function() {
  data.frame(
    d1 = sample(1:6, 3, replace = TRUE),
    d2 = sample(1:6, 3, replace = TRUE)
  )
}

# Complete the matrix solution
m <- function() {
  matrix(sample(1:6, 3, replace = TRUE), 6, ncol = 2)
}

# Use microbenchmark to time m() and d()
microbenchmark(
 data.frame_solution = d(),
 matrix_solution     = m()
)

Unit: microseconds
                expr     min       lq     mean   median       uq      max neval
 data.frame_solution 169.977 175.0820 206.6752 176.8025 178.6145 2653.062   100
     matrix_solution   5.720   6.4595  24.7953   7.1850  10.2215 1659.910   100


## another optimization
# Example data
rolls
> rolls
     [,1] [,2]
[1,]    6    6
[2,]    6    6
[3,]    4    5

# Define the previous solution 
app <- function(x) {
    apply(x, 1, sum)
}

# Define the new solution
r_sum <- function(x) {
    rowSums(x)
}

# Compare the methods
microbenchmark(
    app_sol = app(rolls),
    r_sum_sol = r_sum(rolls)
)

Unit: microseconds
      expr    min     lq     mean  median      uq      max neval
   app_sol 38.187 40.496 69.88488 41.2390 42.1975 2756.885   100
 r_sum_sol  8.613  9.987 30.37558 11.3725 12.0330 1930.036   100

## Using && instead of &
# && will not evaluate second logical value if first is FALSE
# Example data
is_double

# Define the previous solution
move <- function(is_double) {
    if (is_double[1] & is_double[2] & is_double[3]) {
        current <- 11 # Go To Jail
    }
}

# Define the improved solution
improved_move <- function(is_double) {
    if (is_double[1] && is_double[2] && is_double[3]) {
        current <- 11 # Go To Jail
    }
}

## microbenchmark both solutions
microbenchmark(improved_move(is_double), move(is_double), times = 1e5)

Unit: nanoseconds
                     expr min  lq      mean median     uq     max neval
 improved_move(is_double) 330 362  675.9331    401  924.0 2991804 1e+05
          move(is_double) 612 671 1246.6100    818 1533.5 6326187 1e+05


## Parallel computing

# Load the parallel package
library(parallel)

# Store the number of cores in the object no_of_cores
no_of_cores <- detectCores()

# Print no_of_cores
no_of_cores

# computation can run parallel if loops can run backwards
# in some cases parallel computation may be slower due to communication between cores processes
# Determine the number of available cores
detectCores()

# Create a cluster via makeCluster
cl <- makeCluster(2)

# Parallelize this code
parApply(cl, dd, 2, median)

# Stop the cluster
stopCluster(cl)

# Create a cluster via makeCluster (2 cores)
cl <- makeCluster(2)

# Export the play() function to the cluster
clusterExport(cl, "play")

# Parallelize this code
res <- parSapply(cl, 1:100, function(i) play())

# Stop the cluster
stopCluster(cl)

# Set the number of games to play
no_of_games <- 1e5

## Time serial version
system.time(serial <- sapply(1:no_of_games, function(i) play()))
   user  system elapsed 
  9.584   0.024   9.690
                             
## Set up cluster
cl <- makeCluster(4)
clusterExport(cl, "play")

## Time parallel version
system.time(par <- parSapply(cl, 1:no_of_games, function(i) play()))
   user  system elapsed 
  0.076   0.008   3.923
                             
## Stop cluster
stopCluster(cl)
