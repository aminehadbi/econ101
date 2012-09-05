clear
f = @(x,y) (x.^2 + y.^2).*(x.*y<0) + (x+y).*(x.*y>=0)
ezmeshc(f);
print('-depsc','nondiff.eps');  A graph of this function is shown.
f = @(x,y) (y.^3)./(x.^2 + y.^2); ezmeshc(f)