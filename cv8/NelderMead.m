close all; clear all;

% Rosenbrock
f = @(x) 0;
for k1 = 1:2
    f = @(x) f(x) + 100*(x(2*k1-1)^2 - x(2*k1-1))^2 + (x(2*k1-1) - 1)^2;
end


x{1} = [0.9 1 1 1];
x{2} = [0 5 4 9];
x{3} = [1 15 8 5];
x{4} = [-4 -8 6 0];
x{5} = [7 9 -8 25];

alpha=1; gamma=2; rho=0.5; sigma=0.5;
Nmax = 200;
eps1 = 0.001; eps2 = 0.001;


%% program
N_points = length(x);
terminated = false; k1 = 0;

while ~terminated
    % 1 order
    x = bubble_sort(f,x);
    terminated = isfinished(f,x,eps1,eps2,k1,Nmax);
    k1 = k1 + 1;
    
    % 2 centroid
    for k2 = 1:(N_points-1)
        x_in{k2} = x{k2};
    end
    x0 = centroid(x_in);
    
    % 3 reflection
    xr = x0 + alpha*(x0 - x{N_points});
    if ( ( f(x{1}) < f(xr) ) && ( f(xr) < f(x{N_points-1}) ) )
        x{N_points} = xr;
        continue;
    end
    
    % 4 expansion
    if ( f(xr) <= f(x{1}) ) 
        xe = x0 + gamma*(xr-x0);
        if ( f(xe) < f(xr) )
            x{N_points} = xe;
        else
            x{N_points} = xr;
        end
        continue;
    end 
    
    % 5 contraction
    xc = x0 + rho*(x{N_points} - x0);
    if ( f(xc) < f(x{N_points}) ) 
        x{N_points} = xc;
        continue;
    end
    
    % shrink
    for k2 = 2:N_points
        x{k2} = x{1} + sigma*(x{k2}-x{1});
    end
    
    
 
    
end

x = bubble_sort(f,x);

x
f(x{1})


%% functions
function x_new = bubble_sort(f,x)
    N_points = length(x);
    indices = 1:N_points;
    for k1 = 1:N_points
        swap = false;
        for k2 = 1:(N_points-k1)
            if ( f(x{indices(k2)}) > f(x{indices(k2+1)}) )
                dum = indices(k2); indices(k2) = indices(k2+1); indices(k2+1)=dum; %swap
                swap = true;
            end
        end
        if ~swap, break; end
    end
    
    % we ordered the indices, we reorder the points
    x_new{N_points}={};
    for k1 = 1:N_points
        x_new{k1} = x{indices(k1)};
    end
end


function x_c = centroid(x)
    N_points = length(x);
    x_c = x{1};
    for k1 = 2:N_points
        x_c = x_c + x{k1};
    end
    x_c = (1/N_points)*x_c;
end


function terminated = isfinished(f,x,eps1,eps2,k,N)
    N_points = length(x);
    average = 0;
    for k1 = 1:N_points
        average = average + f(x{k1});
    end
    average = average/(N_points+1);
    variance = 0;
    for k1 = 1:N_points
        variance = variance + abs(f(x{k1}) - average)^2;
    end   
    variance = sqrt(variance/N_points);
    
    size = 0;
    x = bubble_sort(f,x);
    for k1 = 1:N_points
        size = size + norm(x{k1} - x{1},1);
    end   
    
    if ( (variance < eps1) && (size < eps2) )
        terminated = true;
    elseif (k>=N)
        warning('too many iterations, result probably unconverged')
        terminated = true;
    else
        terminated = false;
    end
end
