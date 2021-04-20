clear all;
kapek=0;    % pocet kapek
vkruhu=0;   % pocet kapek v kruhu
V = 0;      % odhad "objemu"
steps=1e4;  % pocet krokov
plotNum=zeros(steps,1);
plotV=zeros(steps,1);
n_dim = 2;

x1_in = [];
x2_in = [];
x1_out = [];
x2_out = [];

for i=1:steps
        kapek=kapek+1; 
        x=rand(1,2).*2 - 1;   %1
        if (x(1)^2+x(2)^2<=1) %2
             vkruhu=vkruhu+1;   
             x1_in(end+1) = x(1);
             x2_in(end+1) = x(2);
        else %3
             x1_out(end+1) = x(1);
             x2_out(end+1) = x(2);        
        end;
  
    V=(2^n_dim)*vkruhu/kapek; %4
    plotNum(i)=kapek;
    plotV(i)=V;
end;

disp(['Calculated volume of a n-ball in ' ,num2str(n_dim),' dimensions is ',num2str(V),' after ',num2str(steps),' steps'])
 
figure
plot(plotNum,abs(plotV-pi));
set(gca, 'YScale', 'log')

figure
scatter(x1_in,x2_in,'b')
hold on
scatter(x1_out,x2_out,'r')

