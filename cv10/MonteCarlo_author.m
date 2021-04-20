clear all; close all;
%% function to integrate
f = @(x,y) x^2 + y^2;
f = @(x,y) exp(-(x^2 + y^2));
Ndim = 2;

ComputeVariance = true;

% boundaries are specified at the end of file
a = 1;

% boundary for the integration (square)
a_int = 1;

% Number of points
N_int = 1e7;

dum = 0; dum2 = 0;
for i = 1:N_int
    r = a_int*(2*rand(1,Ndim)-1);
    if InSetBoundaries(r(1),r(2),a)
        dum = dum + f(r(1),r(2));
        if ComputeVariance
            dum2 = dum2 + f(r(1),r(2))^2;
        end
    end
end

if ComputeVariance
    dum2 = dum2/(N_int-1);
    variance = (2*a_int)^2 * sqrt((dum2 - (dum/N_int)^2)/N_int);
end

integral = (2*a_int)^2 * dum/N_int;
disp(['The integral is:            ' num2str(integral)]);
disp(['Estimated error (variance): ' num2str(variance)]);


exact_square = @(a) pi*erf(a)^2;
exact_disk = @(a) pi*(1-exp(-a^2));

disp(['Exact result, square:        ' num2str(exact_square(a))]);
disp(['Exact result, disk:          ' num2str(exact_disk(a))]);


function res = InSetBoundaries(x,y,a)
    % square
    res = (abs(x)<= a ) && (abs(y)<= a );
    % circle
    res = ( (x^2 + y^2) <= a^2 );
end