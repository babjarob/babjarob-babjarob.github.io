close all; clear all;
% There are implemented the following methods to solve ODE's (Euler (forward and backward), Heun's, middlepoint, RK4)

%% The declaration of the problem to solve
% the equation to solve is y' = f(x,y)
    f = @(x,y) (1+cos(x)).*y; y_exact = @(x) exp(x + sin(x)); 
%     f = @(x,y) -15*y; y_exact = @(x) exp(-15.*x);

    
 %% Initial conditions   
    y0 = 1; % y(0) = y0
    x1 = 5; % interval of x is [0, x1]
    h  = 0.1; %step size


%%  Initialise variables for the solution
x = 0:h:x1; N = length(x); % x grid
y = zeros(1,N);
y(1) = y0;


% Euler
for i = 1:(N-1)
%
end
y_Euler = y;

% Heun
for i = 1:(N-1)
%
end
y_Heun = y;

% Midpoint
for i = 1:(N-1)
%
end
y_Midpoint = y;

% RK4
for i = 1:(N-1)
%
end 
y_RK4 = y;


%% Plot
y_exact = y_exact(x);
plot(x,y_exact,'DisplayName','Exact'); hold on;
plot(x,y_Euler,'DisplayName','Euler explicit (forward)'); hold on;
plot(x,y_Heun,'DisplayName','Heun'); hold on;
plot(x,y_Midpoint,'DisplayName','Midlepoint'); hold on;
plot(x,y_RK4,'DisplayName','RK4'); hold on;

%% Euler backward
% The procedure for implicit (backward) Euler scheme is not as universal as
% for the other schemes. It generally leads to non-linear equations, however,
% it can be inverted exactly for a linear ODE: y' = a(x)*y. Our equations are
% of that form.

a = @(x) (1+cos(x));
a = @(x) -15;

% Backward Euler
for i = 1:(N-1)
%
end 
y_Euler2 = y;

plot(x,y_Euler2,'DisplayName','Euler implicit (backward)'); hold on;
legend('Location','best')


%% Error estimation
disp('errors');
disp(['Euler (forward)  :  ' num2str(max(abs(y_Euler - y_exact)))]);
disp(['Heun             :  ' num2str(max(abs(y_Heun - y_exact)))]);
disp(['Midpoint         :  ' num2str(max(abs(y_Midpoint - y_exact)))]);
disp(['RK4              :  ' num2str(max(abs(y_RK4 - y_exact)))]);
disp(['Euler (backward) :  ' num2str(max(abs(y_Euler2 - y_exact)))]);

figure;
semilogy(x,abs(y_Euler-y_exact),'DisplayName','Euler (forward)'); hold on;
semilogy(x,abs(y_Euler2-y_exact),'DisplayName','Euler (backrward)'); hold on;
semilogy(x,abs(y_Heun-y_exact),'DisplayName','Heun'); hold on;
semilogy(x,abs(y_Midpoint-y_exact),'DisplayName','Midpoint'); hold on;
semilogy(x,abs(y_RK4-y_exact),'DisplayName','RK4'); hold on;
legend('Location','best')
