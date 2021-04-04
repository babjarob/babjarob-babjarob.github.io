close all; clear all;

% Note: this implementation is just a show of principle and the methods are
% very bad ones

%% Input parameters

N = 3; %dimension 
f = @(x) x(1)^2 + 2*x(2)^2 + 3*x(3)^2 ;%function

%% Initial guess
x_init = [1 2 3];




epsilon = 1e-4; MaxIt=100;
for i = 1:MaxIt
%% Direction specification
dir = direction(i,N);


%% Reduction to 1D
f1D = @(t) f(x_init + t*dir);

[t_min, fmin]=find1Dminimum(f1D,1);

%% Update the position of the minimum
x_init = x_init + t_min*dir; % new position of the minimum;
error = norm(t_min*dir);
x_approx(i,:) = x_init;
if (error < epsilon), break; end
 
end


%% functions
function dir=direction(i,N) % changes direction in every iteration
    j = mod(i,N);
    dir = zeros(1,N);
    dir(j+1) = 1;
end

function [t, ft]=find1Dminimum(f,method) % golden section in the interval t.. [-10, 10]
a = -10; b = 10;
% required accuracy
epsilon=1e-6;

w = (3-sqrt(5))/2;
x = a + w*(b-a);
    while ( (b-a) > epsilon )     
        if ( x < (a+b)/2 )
            x1 = x;
            x2 = b - w*(b-a);
        else
            x2 = x;
            x1 = a + w*(b-a);
        end
        
        if ( f(x1)<=f(x2) )
            b = x2;
            x = x1;
        else
            a = x1;
            x=x2;
        end
    end
    t=x2;
    ft = f(t);
end