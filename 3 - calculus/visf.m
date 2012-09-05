clear
close all
% CES 
a = 2; b = 4/5;
f{1} = @(x1,x2) (x1.^(-a) + x2.^(-a)).^(-b/a);
name{1} = 'ces';
% crra
gamma = 2; beta = 0.95;
f{2} = @(c1,c2) c1.^(1-gamma)/(1-gamma) + beta*c2.^(1-gamma)/(1-gamma);
name{2} = 'crra';
% cara
alpha = 1;
f{3} = @(c1,c2) -exp(-alpha*c1) + beta*-exp(-alpha*c2);
name{3} = 'cara';
[x y] = meshgrid(0:.25:5,0:.25:5);
for i=1:numel(f)
  figure;
  contour(x,y,f{i}(x,y));
  xlabel('x_1');
  ylabel('x_2');
  print('-depsc',sprintf("%sc.eps",name{i}));
  figure;
  meshc(x,y,f{i}(x,y));
  xlabel('x_1');
  ylabel('x_2');
  zlabel('y');
  print('-depsc',sprintf("%s3d.eps",name{i}));
end

