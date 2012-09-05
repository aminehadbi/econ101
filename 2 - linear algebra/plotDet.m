clear;
close all;
A = [1.1 1/2; 0.3 1.3];

corners = [0 0; 
	   1 0;
	   1 1;
	   0 1; 
	   0 0];
tc = corners*A;
figure;
plot(corners(:,1),corners(:,2),'-', ...
     tc(:,1),tc(:,2),'-');
text(A(1,1),A(1,2),'(a,c)');
text(A(2,1),A(2,2),'(b,d)');
text(sum(A(:,1)),sum(A(:,2)),'(a+b,c+d)');
%xlim([0,2]);
%ylim([0,2]);
grid on;
axis square;
print('-depsc','det2.eps');

A = [1.1 .4 .9; ...
     0.2 1.5 .2; ...
     0.5 1.1 0.8];
corners = [0 0 0;
	   1 0 0;
	   1 1 0;
	   1 1 1;
	   1 0 1;
	   0 0 1;
	   0 1 1;
	   0 1 0;
	   0 0 0;
	   0 1 0;
	   1 1 0;
	   0 0 0; 
	   0 0 1
	   0 1 1
	   1 1 1
	   1 1 0 
	   1 0 0
	   1 0 1];
tc = corners*A;
figure;
plot3(corners(:,1),corners(:,2),corners(:,3),'-', ...
      tc(:,1),tc(:,2),tc(:,3),'-');
%xlim([0,2]);
%ylim([0,2]);
grid on;
axis square;
print('-depsc','det3.eps');