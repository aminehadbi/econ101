%% Paul Schrimpf 2011/09/12 
% creates figures for 526 lecture 2
% plots sets of solutions for small underdetermined systems of linear
% equations 
clear;
close all;

figure;
% -2x + y =  1
ezplot(@(x) 1 - 2*x);
xlabel('x');
ylabel('y');
title('');
print('-depsc2','fig1.eps');

figure;
% x - y - z = 0
% -2x + y + 3z =  1
% -> 
% x - y - z = 0
%   -y + z = 1  
ezplot3(@(z) -1 + 2*z, @(z) -1 + z, @(z) z)
title('');
xlabel('x');
ylabel('y');
zlabel('z');
print('-depsc2','fig2.eps');

% -2 x - y + z = 2
figure;
ezsurf(@(x, y) 2 + 2*x + y);
title('');
xlabel('x');
ylabel('y');
zlabel('z');
print('-depsc2','fig3.eps');

