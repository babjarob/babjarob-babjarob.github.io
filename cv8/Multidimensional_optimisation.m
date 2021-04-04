close all; clear all;
%% Input parameters

N = 3; %dimension 
f = @(x) x(1)^2 + 2*x(2)^2 + 3*x(3)^2 ;%function

%% Initial guess
x_init = [0 0 0];

%% Direction specification
dir = direction();


%% Reduction to 1D

[t_min, fmin]=find1Dminimum(f1D,1);

%% Update the position of the minimum
x_new = x_init + t_min*dir; % new position of the minimum;

%% functions
function dir=direction(varargin) % the inputs of the function are indetermined at this stage of code
    % suppose that there is a code determining the direction (consult the lectures for possibilities)
    dir = [1 1 0]; % this would have been the output
    dir = dir/norm(dir);
end

function [t, ft]=find1Dminimum(f,method)
    % it finds a minimum of 1D fuction and return the value of the
    % argument, the initial point is t=0;
    t = 1; % at the instant, it just returns 1
    ft = f(t);
end