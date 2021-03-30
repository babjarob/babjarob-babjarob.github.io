% (c) Jan Vábek, vabekjan@fjfi.cvut.cz
% Template for implementation of various methods for finding roots of
% single-variable functions.
clear all; close all;
set(0,'defaulttextInterpreter','latex')

%% Initial values
% the function to solve f(x)=0
% f = @(x) sin(x)-0.5;
f = @(x) exp(x)-6; 
% f = @(x) atan(x) + sin(x); % secant or Newton may fail for some choices of x1 , x2
% f = @(x) x./(1+x.^2); % secant or Newton may fail for some choices of x1 , x2



% method
method = 'regula-falsi'; % 'bisection', 'secant', 'Newton', 'regula-falsi',

% Precision and number of iterations
eps=1e-6; N_it=100;

% initial interval where we expect the solution
% x1=0; x2=1;
x_in = [-1 2];

[x, r] = nonlin_root(f,x_in,method,eps,N_it); % see the function at the end of the file

N_it = length(x);

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
%     pause
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
plot(1:length(r),r);
title('Convergence'); 
xlabel('$i$');
ylabel('$r_i = |x_i-x_{i-1}|$');

% plot the evolution of the error
subplot(2,2,4);
log_ri = log10(r(1:end-2));
log_rip1 = log10(r(2:end-1));
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
function [x, r]=nonlin_root(f,x_in,method,eps,N_it) % x_in is a vector with a proper number of initial points
    rr = 2*eps;
    switch method
        case 'bisection'
            x1 = x_in(1); x2 = x_in(2);
            i = 1;
            while ( abs(rr) > eps )
                dum=(x1+x2)/2;
                r(i)=x2-x1;
                x(i)=(x1+x2)/2;
                if f(x1)*f(dum)<0
                    x2=dum;
                else
                    x1=dum;
                end
                rr = r(i);
                i = i+1;
            end            
        case 'secant'
            x1 = x_in(1); x2 = x_in(2);
            i = 1;
            while ( abs(rr) > eps )
                dum=(x1*f(x2)-f(x1)*x2)/(f(x2)-f(x1));
                x1=x2;
                x2=dum;
                x(i)=dum;
                if ( i>1 ), r(i-1)=abs(x(i)-x(i-1)); rr = r(i-1); end
                if (i==N_it)
                    disp('maxit reached'); break;
                end                
                i = i+1;
            end
        case 'regula-falsi'
            x1 = x_in(1); x2 = x_in(2);
            i = 1;
            while ( abs(rr) > eps )
                dum=(x1*f(x2)-f(x1)*x2)/(f(x2)-f(x1));
                if (f(dum)*f(x1) < 0)
                    x2 = dum;
                else
                    x1 = dum;
                end
                x(i)=dum;                
                if (i==N_it)
                    disp('maxit reached'); break;
                end
                if ( i>1 ), r(i-1)=abs(x(i)-x(i-1)); rr = r(i-1); end  
                i = i+1;
            end
        case 'Newton'
            syms z; df = f(z); df = diff(df); df = matlabFunction(df);
            x1 = x_in(1);
            i = 1;
            while ( abs(rr) > eps )
                x1 = x1 - f(x1)/df(x1);                
                x(i)=x1;
                if ( i>1 ), r(i-1)=abs(x(i)-x(i-1)); rr = r(i-1); end
                if ( i == N_it )
                    disp('maximum of iterations reached'); break;
                end
                i = i+1;
            end
        otherwise
        error('wrongly specified method')
    end
end
