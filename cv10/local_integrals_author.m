% Integrals:
clear all; close all;

%% inputs
% function to integrate
% transform of 1/sqrt(x)
% f = @(x) 1/sqrt(x); exact = 2;% open formulas will work
% f = @(x) 2; exact = 2;
% transform of cos(x)/sqrt(x)
% f = @(x) cos(x)/sqrt(x); exact = sqrt(2*pi)*fresnelc(sqrt(2));% open formulas will work
% f = @(x) 2*cos(x^2); exact = sqrt(2*pi)*fresnelc(sqrt(2));
% transform of atg(x)/(1+x^2)
% f = @(x) atan(1/x)/(1+x^2); exact = 3*pi^2/32;
% transform of sqrt(tan(x))
% f = @(x) sqrt(tan(x)); exact = 2.22144;
f = @(x) 2*x*sqrt(tan(0.5*pi-x^2)); exact = 2.22144;

% limits
a = 0;
b = sqrt(pi/2);

% number of intervals (number of points is N+1) %should be odd for correct Simpson
N = 100; 

%% prepare grid
x=linspace(a,b,N+1);
    
%% integration loop

LR  = 0.0; % Left rectangle
RR  = 0.0; % Right rectangle
MP  = 0.0; % Midpoint
trap  = 0.0; % trapezoidal
simp  = 0.0; % composed Simpson

h = x(2)-x(1); %equidistant grid

for i=1:N
    LR = LR + h * f(x(i));
    RR = RR + h * f(x(i+1));
    MP = MP + h * f((x(i)+x(i+1))/2);
    trap = trap + h * ( f(x(i)) + f(x(i+1)) ) / 2;
    if (mod(i,2)==1), coeff = 2/3; else, coeff = 4/3; end
    simp = simp + h * coeff * f(x(i));
end



%% Results


%% write solution
disp(['  Exact solution:   ' num2str(exact) '.']);
disp(['  Left rectangle:   ' num2str(LR) '.']);
disp(['  Right rectangle:  ' num2str(RR) '.']);
disp(['  Midpoint :        ' num2str(MP) '.']);
disp(['  Trapezoidal:      ' num2str(trap) '.']);
disp(['  Simpson:          ' num2str(simp) '.']);


% show integrand
fx = zeros(1,N+1);
for i = 1:(N+1)
    fx(i) = f(x(i));
end
plot(x,fx)
title('integrand'); xlim([a b]); xlabel('x'); ylabel('f(x)')


%% Romberg
% we have already for h, we compute for 2h and 4h
% !!! In real applications, the process would be opposite: start with longer subintervals and shorten them in succesive steps !!!
% if you run the code, make sure N is divisible by 4!

trap2h = 0;
trap4h = 0;
for i=1:2:N
    trap2h = trap2h + 2*h * ( f(x(i)) + f(x(i+2)) ) / 2;
end
for i=1:4:N
    trap4h = trap4h + 4*h * ( f(x(i)) + f(x(i+4)) ) / 2;
end

romb = (64*trap - 20*trap2h + trap4h)/45;

disp(['  Romberg:          ' num2str(romb) '.']);