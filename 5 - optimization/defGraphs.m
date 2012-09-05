clear;
close all;
figure;
ezmesh(@(x,y) (x.^2 + y.^2))
title('')
print('-depsc','pd.eps');
figure;
ezmesh(@(x,y) (-x.^2-y.^2))
title('')
print('-depsc','nd.eps');
figure;
ezmesh(@(x,y) (x.^2))
title('')
print('-depsc','psd.eps');
figure;
ezmesh(@(x,y) (-y.^2))
title('')
print('-depsc','nsd.eps');
figure;
ezmesh(@(x,y) (x.^2-y.^2))
title('')
print('-depsc','id.eps');
figure;
ezmesh(@(x,y) (x.^2+y.^3))
title('')
print('-depsc','id2.eps');