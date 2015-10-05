rm(list=ls())
library(ggplot2)
# utility function
rra <- 2.5
u.fmla <- expression(c^(1-rra)/(1-rra))
discount <- 0.03
# production fuction
alpha <- 0.5
f.fmla <- expression(k^alpha)
depreciation <- 0.1

## derivatives of utility and production
d2u.fmla <- deriv3(u.fmla,"c","c")
u <- function(c) { eval(u.fmla) }
du <- function(c) { as.vector(attr(d2u.fmla(c),"gradient")) }
d2u <- function(c) { as.vector(attr(d2u.fmla(c),"hessian")) }

df.fmla <- deriv(f.fmla,"k",function(k) {})
f <- function(k) { eval(f.fmla) }
df <- function(k) { as.vector(attr(df.fmla(k),"gradient")) }

# differential equations for k and c
dkdt <- function(k,c) {
  f(k) - depreciation*k-c
}
dcdt <- function(k,c) {
  -du(c)/d2u(c)*(df(k)-depreciation-discount)
}

# steady state
kss <- ((discount+depreciation)/alpha)^(1/(alpha-1))
css <- f(kss) - depreciation*kss

k.grid <- seq(0.01,2*kss,length.out=20)
c.grid <- seq(0.01,2*css,length.out=20)


# find stable path
k.stable <- vector()
c.stable <- vector()
s <- 1
k.stable[s] <- kss
c.stable[s] <- css
dt <- 0.1
k <- kss
c <- css
library(nleqslv)
while (k>(min(k.grid)+1) && c>(min(c.grid)+1)) {
  #obj <- function(c.new) {
  #  dk <- -k/dkdt(k,c.new)
  #  return(c.new + dcdt(k,c.new)*dt - c )
  #}
  #r <- uniroot(obj,c(c-1,c+1))
  obj <- function(x) {
    k.new <- x[1]
    c.new <- x[2]
    c(k.new+dkdt(k.new,c.new)*dt - k,
      c.new+dcdt(k.new,c.new)*dt - c)
  }
  r <- nleqslv(x=c(k-dt,c-dt),fn=obj)
  c <- r$x[2]
  k <- r$x[1]
  k.stable[s] <- k
  c.stable[s] <- c
  s <- s+1
}
k <- kss
c <- css
while (k<(max(k.grid)-1) && c<(max(c.grid)-1)) {
  #obj <- function(c.new) {
  #  dk <- -k/dkdt(k,c.new)
  #  return(c.new + dcdt(k,c.new)*dt - c )
  #}
  #r <- uniroot(obj,c(c-1,c+1))
  obj <- function(x) {
    k.new <- x[1]
    c.new <- x[2]
    c(k.new+dkdt(k.new,c.new)*dt - k,
      c.new+dcdt(k.new,c.new)*dt - c)
  }
  r <- nleqslv(x=c(k+dt,c+dt),fn=obj)
  c <- r$x[2]
  k <- r$x[1]
  k.stable[s] <- k
  c.stable[s] <- c
  s <- s+1
}


## plot phase diagram with stable path
d <- data.frame(c=as.vector(outer(0*k.grid,c.grid,FUN="+")),
                 k=as.vector(outer(k.grid,0*c.grid,FUN="+")))
d$dc <- dcdt(d$k,d$c)
d$dk <- dkdt(d$k,d$c)
d$zerodk <- f(d$k)-depreciation*d$k

stable <- data.frame(k=k.stable,c=c.stable)


library(grid)
phase <- ggplot(data=d) +
  geom_segment(data=d,aes(x=k,y=c,yend=(c+dc),xend=(k+dk)),
               arrow=arrow(length=unit(0.1,"cm")),colour="gray") +
  geom_line(aes(x=k,y=zerodk),colour="red") +
  geom_vline(xintercept=kss,colour="blue") +
  geom_line(data=stable,aes(x=k,y=c),colour="black") +
  xlim(min(k.grid),max(k.grid)) +
  ylim(min(c.grid),max(c.grid)) + theme_minimal()
pdf("phase.pdf")
print(phase)
dev.off()





