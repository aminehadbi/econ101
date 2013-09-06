rm(list=ls())
library(rgl) ## for 3d plots
library(matlab) ## for meshgrid()

## coefficient matrix
A <- matrix(c(0, 4, 1,
              1, 2,-1,
              0, -8, -2),
            nrow=3, ncol=3, byrow=TRUE)
## rhs
b <- c(5, 2, -10)

rgl.clear("all")
## set up bounding box limits
xlim <- c(-20,20)
ylim <- c(-20,20)
zlim <- c(-20,20)
mesh <- meshgrid(xlim,ylim,zlim,nargout=3)
open3d(windowRect=c(10,40,800,800))
axes3d(labels=FALSE)
plot3d(x=mesh$x,y=mesh$y,z=mesh$z,alpha=0,xlab="x",ylab="y",zlab="z")
planes3d(a=A[,1],b=A[,2], c=A[,3], d=-b, col=c("red","blue","green"),
           alpha=0.2)
play3d( spin3d(axis=c(0,0,1)))
