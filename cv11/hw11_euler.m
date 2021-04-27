% The Kepler problem in Cartesian coordinates
set(0,'defaulttextInterpreter','latex')
%%  the set of equations to solve: u'=f(t,u)
f = @(u) [u(3), u(4), -u(1)/(u(1)^2 + u(2)^2)^(3/2), -u(2)/(u(1)^2 + u(2)^2)^(3/2)];

%% Initial conditions
T = 10 ;  % the solution u will be solved for t from [0, T]

u = [0.5 1 -0.3 0.3 ]; 

dt = 0.0001;

N = round(T/dt);

results = [u];
t = [0];

%leap-frog potrebuje na naštartovanie okrem počiatočnej podmienky aj druhý
%bod, odhadnite ho eulerovou metódou
%results(2,:) = ; 
%t(2) = ;

for i = 1:N
   results(i+1,:) = results(i,:) + dt*f(results(i,:)); 
   t(end+1) = t(end)+ dt;
end

figure
plot(results(:,1),results(:,2));
xlabel('$x$');
ylabel('$y$');
title('Trajectory');

%% plot energy
% initial energy      
Ekin0 = 0.5*(u(3)^2+u(4)^2);
Epot0 = -1/sqrt(u(1)^2+u(2)^2);
E0 = Ekin0 + Epot0;

% energy evolution
Ekin = 0.5.*(results(:,3).^2+results(:,4).^2);
Epot = -1./sqrt(results(:,1).^2+results(:,2).^2);
E = Ekin + Epot;

figure
plot(t,Ekin,'g.');hold on;
plot(t,Epot,'b.'); hold on;
plot(t,E,'r.'); hold on;
legend('Kinetic','Potential','Total');
xlabel('$t$');
ylabel('$Energy$');

figure 
plot(t,abs(E-E0))
xlabel('$t$');
ylabel('$|E-E0|$');

%eh1= ;
%eh2= ;
%h1=0.0025;
%h2=0.0005;

%k = (log(eh1/eh2))/(log(h1/h2))