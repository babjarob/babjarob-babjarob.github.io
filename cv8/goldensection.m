%minimisation in one dimension
close all; clear all;

%the function to be otimised
f= @(x) -sin(x);
% f= @(x) (abs(x-log(2))).^3;

%first, we chose the interval within we search the minimum
a=0;
b=pi;

% required accuracy
epsilon=1e-4;

n=1;
while ( (b-a) > epsilon )
    
    x1 = a + (b-a)/3;
    x2 = b - (b-a)/3;
    
    if ( f(x1)<=f(x2) )
        b = x2; x(n) = x1;
    else
        a = x1; x(n) = x2;
    end

    fprintf('iteration: %i, the interval is [ %g,%g ] \n',n,a,b)
    n = n+1;
    
end

