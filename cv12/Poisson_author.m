close all; clear all;

f = @(x) cos(x);
xmin = 0;
xmax = 2*pi;
a = 3;
b = 0;

N=150;
x = linspace(xmin,xmax,N+2);
h=x(2)-x(1);
A = zeros(N,N); c = zeros(N,1);
for i=1:(N-1)
    A(i,i)=-2;
    A(i,i+1)=1;
    A(i+1,i)=1;
    c(i) = h^2 * f(x(i+1));
end

c(1)=h^2*f(x(2))-a;
A(N,N)=-2; c(N)=h^2*f(x(N+1))-b;

y = A\c;
y = [a; y; b];

plot(x,y)


