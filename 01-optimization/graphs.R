## Some simple graphs of examples from this lecture
library(ggplot2)
x <- seq(-1,1,length.out=200)
df <- data.frame(x=x,f=x^4)
fig <- ggplot(data=df,aes(x=x,y=f)) + geom_line() + theme_minimal()
pdf(file="ex21.pdf",width=3,height=2)
fig
dev.off()

x <- seq(-20,20,length.out=200)
df <- data.frame(x=x,f=-1/(1+x^2))
fig <- ggplot(data=df,aes(x=x,y=f)) + geom_line() + theme_minimal()
pdf(file="ex12.pdf",width=3,height=2)
fig
dev.off()




