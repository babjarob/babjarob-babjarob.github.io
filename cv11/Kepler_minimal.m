% The Kepler problem in Cartesian coordinates

%%  the set of equations to solve: u'=f(t,u)
f = @(u) [u(3), u(4), -u(1)/(u(1)^2 + u(2)^2)^(3/2), -u(2)/(u(1)^2 + u(2)^2)^(3/2)];

%% Initial conditions
T = 10 ;  % the solution u will be solved for t from [0, T]


u = [1 0 -0.3 0.3 ]; 

dt = 0.001;


N = round(T/dt);

results = [0, u(1:2)];
for i = 1:N
%    u = u + dt * f(u); 
   k1 = f(u); k2 = f(u+dt*k1);
   u = u + 0.5*dt*(k1+k2); 
   results = [results; [results(end,1)+dt, u(1:2)]];
end

figure
plot(results(:,1),results(:,2));

figure
plot(results(:,1),results(:,3));

figure
plot(results(:,2),results(:,3));