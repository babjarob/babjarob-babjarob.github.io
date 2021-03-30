% (c) Jan Vábek; vabekjan@fjfi.cvut.cz (CTU; ELI-Beamlines; The University of Bordeaux)
% Template for implementation of various methods for finding roots of
% single-variable functions.
clear all; close all;
set(0,'defaulttextInterpreter','latex')

%% Initial values
% the function to solve f(x)=0
f = @(x) sin(x)-0.5;

% method
method = 'bisection';

% Number of iterations
N_it = 20;

% initial interval where we expect the solution
x1=0; x2=1;


[x, r] = nonlin_root(f,x1,x2,method,N_it); % see the function at the end of the file


% approximation of the final solution
root = x(end)

% estimation of the error
error = r(end)

%% plot the solutions
xgrid = linspace(0,1,100);

figure
plot(xgrid,f(xgrid));
hold on;
ax = gca;
ax.XAxisLocation = 'origin';
for i = 1:length(x)
    scatter(x(i),0)
    text(x(i),0,num2str(i))
    pause
end



%% the study of the error evolution

figure
% plot the sequence of the root approximations
subplot(2,2,[1 2]);
plot(x,1:N_it,'-x');
title('The solution');
ylabel('$i$');
xlabel('$x_i$');
ax = gca; ax.YDir = 'reverse';

% plot the convergence criterion (c.f. Cauchy-Bolzano convergence criterion)
subplot(2,2,3);
plot(1:N_it,r);
title('Convergence');
xlabel('$i$');
ylabel('$r_i = |x_i-x_{i-1}|$');

% plot the evolution of the error
subplot(2,2,4);
log_ri=log10(r(1:end-1));
log_rip1=log10(r(2:end));
plot(log_ri,log_rip1);
hold on
title('$\log r_{i+1}$ vs. $\log r_i$');
xlabel('$\log r_{i}$');
ylabel('$\log r_{i+1}$');

%linear fit
p = polyfit(log_ri,log_rip1,1);
plot(log_ri,p(1)*log_ri + p(2),'--');

%the slope (and thus the order)
disp(['The order of the method is ' num2str(p(1)) '.']);


%% function for the root finding
function [x, r]=nonlin_root(f,x1,x2,method,N_it)
    switch method
        case 'bisection'
            for i=1:N_it
                dum=(x1+x2)/2;
                r(i)=x2-x1;
                x(i)=dum;
                if f(x1)*f(dum)<0
                    x2 = dum;
                else
                    x1 = dum;
                end
            end
        otherwise
        error('wrongly specified method')
    end
end
