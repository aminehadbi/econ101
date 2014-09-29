## dynamic programming

# constants
alpha <- 0.6
discount <- 0.95
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

## initial guess at value function
v0 <- approxfun(k.grid, v.grid,rule=2, method="linear")
library(parallel)
v.change <- 100
tol <- 1e-4
iterations <- 0
v.app <- list()
v.app[[1]] <- v0
while(v.change > tol || iterations<100) {
    bellman <- mcmapply(function(k) {
        optimize(function(c) {
            utility(c) + discount*v0(transition(c,k)) },
                 interval=c(0.01, production(k) + (1-depreciation)*k -
                     0.01),
                 maximum=TRUE,
                 tol=tol*1e-3
                 )
    }, k.grid)
    
    v.g.new <- unlist(bellman["objective",])
    
    v.change <- max(abs(v.g.new-v.grid))
    iterations <- iterations+1
    v.grid <- v.g.new
    v0 <- approxfun(k.grid,v.grid,rule=2,method="linear")
    v.app[[iterations+1]] <- v0
    print(sprintf("After %d iterations v.change=%.2g\n",iterations,v.change))
}

df <- data.frame(k=k.grid, v1=v.app[[1]](k.grid), v2=v.app[[2]](k.grid),
                 v10=v.app[[10]](k.grid), v100=v.app[[100]](k.grid),
                 v=v0(k.grid),
                 c=unlist(bellman["maximum",]),
                 k.new=transition(unlist(bellman["maximum",]),k.grid))
library(ggplot2)
value <- ggplot(df,aes(x=k)) +
    geom_line(aes(y=v1,colour="1")) +
    geom_line(aes(y=v2,colour="2"))+
    geom_line(aes(y=v10,colour="10")) +
    geom_line(aes(y=v100,colour="100")) +
    geom_line(aes(y=v,colour="converged")) +
    theme_minimal() +
    scale_colour_discrete(name="iteration")


policy <- ggplot(df,aes(x=k))+
    geom_line(aes(y=c,colour="consumption"))  +
    geom_line(aes(y=k.new,colour="next capital")) +
    geom_line(aes(y=k),colour="gray") + 
    theme_minimal() +
    scale_colour_discrete(name="") +
    scale_y_continuous("consumption or capital") +
    scale_x_continuous("current capital")

pdf("value.pdf",width=7,height=5)
value
dev.off()

pdf("policy.pdf",width=7,height=5)
policy
dev.off()
