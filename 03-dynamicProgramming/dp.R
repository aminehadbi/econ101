## dynamic programming
library(RSNNS)
library(ggplot2)

# constants
alpha <- 0.6
discount <- 0.8
depreciation <- 1

# symbolic expressions for utility and production functions
u <- expression(log(c))
f <- expression(k^alpha)

# utility function
utility <- deriv(u, "c", function(c) {})
# production function
production <- deriv(expression(k^alpha), "k", function(k) {})
# transition
transition <- deriv(substitute(F + k*(1-depreciation) - c,
                               list(F=f[[1]])), c("k","c"),
                    function(c,k) {})

# steady state capital
kss <- uniroot(f=function(k)
               attr(transition(1,k),"gradient")[1,"k"]-1/discount,
               interval=c(0.01,100))
# steady state utility
uss <- utility(production(kss$root) - kss$root*depreciation)
## value function approximation
k.grid <- seq(0.01,3*kss$root,length.out=200)
# initial guess for v(k.grid)  -- any should work; just affects how
# quickly we converge
#v.grid <- rep(0,length(k.grid))
v.grid <- rep(uss/(1-discount),length(k.grid))
#v.grid <- utility(k.grid*0.5)/(1-discount)
approx.method <- "neural-net"
degree <- 10
approxfn <- function(x,y) {
  if (approx.method=="linear") {
    return(approxfun(x, y,rule=2, method="linear"))
  } else if (approx.method=="spline") {
    return(splinefun(x, y, method="fmm"))
  }
  # least squares
  else if (approx.method=="least-squares") {
    model <- lm(y ~ poly(x, degree=degree))
    f <- function(xnew) {
      predict(model, newdata=data.frame(x=xnew))
    }
    return(f)
  } else if (approx.method=="neural-net") {
    xn <- normalizeData(x)
    npx <- getNormParameters(xn)
    yn <- normalizeData(y)
    npy <- getNormParameters(yn)
    model <- mlp(xn,yn, linOut=TRUE,size=round(sqrt(length(x)/2)),
                 learnFunc="SCG")
    f <- function(xnew) {
      xnn <- (xnew-npx$colMeans[1])/npx$colSds[1]
      xnn <- matrix(xnn,ncol=1)
      yhat <- predict(model, xnn)
      yhat <- denormalizeData(yhat, npy)
      return(yhat)
    }
  } else {
    stop("unrecognized approx.method")
  }
}
## initial guess at value function
v0 <- approxfn(k.grid, v.grid)
library(parallel)
v.change <- 100
tol <- 1e-3
iterations <- 0
v.app <- list()
v.app[[1]] <- v0
while(v.change > tol && iterations<50) {
  bellman <- mcmapply(function(k) {
    optimize(function(c) {
      utility(c) + discount*v0(transition(c,k)) },
             interval=c(0.01, production(k) + (1-depreciation)*k -
                 0.01),
             maximum=TRUE,
             tol=tol*1e-3
             )
  }, k.grid, mc.cores=39L)

  v.g.new <- unlist(bellman["objective",])

  v.change <- max(abs(v.g.new-v.grid))
  iterations <- iterations+1
  v.grid <- v.g.new
  v0 <- approxfn(k.grid,v.grid)
  v.app[[iterations+1]] <- v0
  print(sprintf("After %d iterations v.change=%.2g\n",iterations,v.change))
}

df <- data.frame(k=k.grid, v1=v.app[[1]](k.grid),
                 v2=v.app[[2]](k.grid),
                 v3=v.app[[3]](k.grid),
                 v4=v.app[[4]](k.grid),
                 v5=v.app[[5]](k.grid),
                 v10=v.app[[10]](k.grid),
                 v20=v.app[[20]](k.grid),
                 v=v0(k.grid),
                 c=unlist(bellman["maximum",]),
                 k.new=transition(unlist(bellman["maximum",]),k.grid))

library(ggplot2)
value <- ggplot(df,aes(x=k)) +
  geom_line(aes(y=v1,colour=" 1"), linetype=2) +
  geom_line(aes(y=v2,colour=" 2"), linetype=3) +
  geom_line(aes(y=v3,colour=" 3"), linetype=4) +
  geom_line(aes(y=v4,colour=" 4"), linetype=5) +
  geom_line(aes(y=v5,colour=" 5"), linetype=6) +
  geom_line(aes(y=v10,colour="10"), linetype=7) +
  geom_line(aes(y=v20,colour="20"), linetype=8) +
  geom_line(aes(y=v,colour="final"), linetype=1) +
  theme_minimal()  +
  scale_colour_discrete(name="iteration")


policy <- ggplot(df,aes(x=k))+
    geom_line(aes(y=c,colour="consumption"))  +
    geom_line(aes(y=k.new,colour="next capital")) +
    geom_line(aes(y=k),colour="gray") +
    theme_minimal() +
    scale_colour_discrete(name="") +
    scale_y_continuous("consumption or capital") +
    scale_x_continuous("current capital")

#pdf("value.pdf",width=7,height=5)
value
#dev.off()

#pdf("policy.pdf",width=7,height=5)
policy
#dev.off()
