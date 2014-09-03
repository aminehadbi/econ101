rm(list=ls())

# Parameter settings
discountFactor <- 0.9
returnsToScale <- 1.0
TFP <- 1.0
depreciation <- 1.0

## Settings for value function approximation
## We approximate V(k) by linearly interpolating between on k.grid
k.grid <- seq(from=0.01,to=10,length.out=100)
iterations <- 50 ## number of bellmanOperator iterations

## model primitives
productionFunction <- function(k) {
    return(k^returnsToScale)
}
utilityFunction <- function(c,k) {
    return(TFP*k - c - c^2/(2*k))
}
transitionFunction <- function(c,k) {
    return(c + (1-depreciation)*productionFunction(k))
}

## bellman operator
bellmanOperator <- function(V) {
    v.grid <- NA*k.grid
    p.grid <- v.grid
    ## Compute value for each point in grid
    for (i in 1:length(k.grid)) {
        k.old <- k.grid[i]
        obj <- function(c) {
            utilityFunction(c,k.old) + discountFactor*V(transitionFunction(c,k.old))
        }
        ## maximize utility plus next value
        res <- optimize(f=obj, interval=c(-100,100),
                        maximum=TRUE)
        v.grid[i] <- res$objective
        p.grid[i] <- res$maximum
    }
    return(list(value=approxfun(x=k.grid, y=v.grid,rule=2),
                policy=approxfun(x=k.grid, y=p.grid,rule=2)))
}

v0 <- function(k) { return(TFP*k) }
v <- list()
v.old <- v0
df <- data.frame(k=k.grid,v=v0(k.grid),c=0,iteration=0)
for (t in 1:iterations) {
    v[[t]] <- bellmanOperator(v.old)
    v.old <- v[[t]]$value
    cat("Completed ",t," of ",iterations," iterations.\n")
    if (t %% (floor(iterations/10))==0)
    df <- rbind(df,data.frame(k=k.grid,v=v[[t]]$value(k.grid),c=v[[t]]$policy(k.grid),iteration=t))
}

## plot results
library(ggplot2)
c <- (1+discountFactor*depreciation) +
      sqrt((1+discountFactor*depreciation)^2 -
           discountFactor^2*(4*TFP)) / discountFactor^2
ggplot(df,aes(x=k,y=v,colour=iteration,group=iteration)) +
    geom_line() 



