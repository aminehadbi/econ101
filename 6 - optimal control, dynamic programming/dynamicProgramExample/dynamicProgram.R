rm(list=ls())

# Parameter settings
discountFactor <- 0.8
returnsToScale <- 0.6

## Settings for value function approximation
## We approximate V(k) by linearly interpolating between on k.grid
k.grid <- seq(from=0.01,to=10,length.out=100)
iterations <- 50 ## number of bellmanOperator iterations

## model primitives
productionFunction <- function(k) {
    return(k^returnsToScale)
}
utilityFunction <- function(c) {
    return(log(c))
}

## bellman operator
bellmanOperator <- function(V) {
    v.grid <- NA*k.grid
    ## Compute value for each point in grid
    for (i in 1:length(k.grid)) {
        k.old <- k.grid[i]
        obj <- function(k.new) {
            utilityFunction(productionFunction(k.old) - k.new) + discountFactor*V(k.new)
        }
        ## maximize utility plus next value
        res <- optimize(f=obj, interval=c(min(k.grid),
                                   productionFunction(k.old)-0.001),
                        maximum=TRUE)
        v.grid[i] <- res$objective
    }
    return(approxfun(x=k.grid, y=v.grid,rule=2))
}

v0 <- function(k) { return(0) }
v <- list()
v.old <- v0
df <- data.frame(k=k.grid,v=v0(k.grid),iteration=0)
for (t in 1:iterations) {
    v[[t]] <- bellmanOperator(v.old)
    v.old <- v[[t]]
    cat("Completed ",t," of ",iterations," iterations.\n")
    if (t %% (floor(iterations/10))==0)
    df <- rbind(df,data.frame(k=k.grid,v=v[[t]](k.grid),iteration=t))
}

## plot results
library(ggplot2)
ggplot(df,aes(x=k,y=v,colour=iteration,group=iteration)) + geom_line()

