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
N_int = 100;

dum = 0;
for i = 1:N_int
    r = ? % transform rand(1,Ndim) into the required interval
    if InSetBoundaries(r(1),r(2),a)
        dum = dum + f(r(1),r(2));
    end
end

% variance = ?; % optionally compute the variance

integral = (2*a_int)^2 * dum/N_int;
disp(['The integral is:            ' num2str(integral)]);
disp(['Estimated error (variance): ' num2str(variance)]);


exact_square = @(a) pi*erf(a)^2;
exact_disk = @(a) pi*(1-exp(-a^2));

disp(['Exact result, square:        ' num2str(exact_square(a))]);
disp(['Exact result, disk:          ' num2str(exact_disk(a))]);


function res = InSetBoundaries(x,y,a)
    % square
    res = ?;
    % circle
    res = ?;
end