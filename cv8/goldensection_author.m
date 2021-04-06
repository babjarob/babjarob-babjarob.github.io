%minimisation in one dimension
close all; clear all;

%the function to be otimised
% f= @(x) -sin(x);
global funct

funct = @(x) (abs(x-log(2))).^3;

%first, we chose the interval within we search the minimum
a0 = 0;
b0 = pi;

% required accuracy
epsilon = 1e-4;

global nf;

%% no bookkepping
n=1;
nf = 0;
a = a0; b = b0;
w = (3 - sqrt(5))/2;
x = a + w*(b-a);
while ( (b-a) > epsilon )
    
    if ( x < (a+b)/2 )
        x1 = x;
        x2 = b - w*(b-a);
    else
        x1 = a + w*(b-a);
        x2 = x;
    end
    
    if ( f(x1) <= f(x2) )
        b = x2;
        x = x1;
    else
        a = x1;
        x = x2;
    end

    disp(['iteration: ' num2str(n) ', the interval is [' num2str(a) ', ' num2str(b) '].'])
    n = n+1;
    
end

fprintf('\n');
disp(['number of evaluations:' num2str(nf)])
fprintf('\n');

%% bookkepping
n=1;
nf = 0;
a = a0; b = b0;
w = (3 - sqrt(5))/2;
x = a + w*(b-a); fx = f(x);
while ( (b-a) > epsilon )
    
    if ( x < (a+b)/2 )
        x1 = x; fx1 = fx;
        x2 = b - w*(b-a); fx2 = f(x2);
    else
        x1 = a + w*(b-a); fx1 = f(x1);
        x2 = x; fx2 = fx;
    end
    
    if ( fx1 <= fx2 )
        b = x2;
        x = x1; fx = fx1;
    else
        a = x1;
        x = x2; fx = fx2;
    end

    disp(['iteration: ' num2str(n) ', the interval is [' num2str(a) ', ' num2str(b) '].'])
    n = n+1;
    
end

fprintf('\n');
disp(['number of evaluations:' num2str(nf)])

%% functions
function res = f(x)
    global nf funct
    nf = nf + 1;
    res = funct(x);
end

