% plots distribution of grades in 526 from past 5 years
% data accessed from
% https://www.secure.pair.ubc.ca/reports/gradesdist_runreport.action 
clear 
close all
year = 2010:-1:2006;
instructor = {"Sakata", "Sakata", "Celik", "Inoue", "Inoue"};
N =   [56    65    65    36    54    ];
avg = [93.52 90.97 81.06 81.94 82.15 ];
sd =  [7.91  6.92  9.52  7.23  5.27  ];
binCenter = 5:10:95;
       % 5 15 25 35 45 55 65 75 85 95
count = [0  0  0  0  0  1  0  1  6 48; ...
	 0  0  0  0  0  0  1  4 15 44; ...
	 0  0  0  0  0  0  8 18 28 11; ...
	 0  0  0  0  0  0  3 11 16  5; ...
	 0  0  0  0  0  0  1 18 28  6;];

total = sum(count);
%total = total/sum(total);
sakata = sum(count(1:2,:));
%sakata = sakata/sum(sakata);
ci = sum(count(3:5,:));
%ci = ci/sum(ci);
inc=total>0;
f = figure;
set (f,'papertype', '<custom>')
set (f,'paperunits','inches');
set (f,'papersize',[6 3])
set (f,'paperposition', [0,0,[6 3]])
%set (f,'defaultaxesposition', [0.1, 0.1, 0.9, 0.9])
set (f,'defaultaxesfontsize', 16)
set (f,'paperorientation','landscape')
h = bar(binCenter(inc)',[total(inc)' sakata(inc)' ci(inc)']);
colormap('bone');
ylabel('Count');
xlabel('Grade');
legend('2006-2010', '2009-2010', '2006-2008', ...
       'fontname','Vera', 'location','northwest');
title('Distribution of grades 2006-2010');
set(gca(),'fontname','Vera');
set(gca(),'fontsize',16);
print('-depsc2','526gradeDist.eps');