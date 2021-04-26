function Kepler()
% The Kepler problem in Cartesian coordinates

%%  the set of equations to solve: u'=f(t,u)
f = @(u) [u(3), u(4), -u(1)/(u(1)^2 + u(2)^2)^(3/2), -u(2)/(u(1)^2 + u(2)^2)^(3/2)];

%% Initial conditions
T = 10 ;  % the solution u will be solved for t from [0, T]
method = 'RK4'; % 'RK4' or 'Euler'

% initial vector u(t=0),  u = [x  dx/dt   y  dy/dt ]
%u = [1  0   0 1   ]; 
u = [1 0 -0.3 0.3 ]; 
% u = [1 0 -1 .1 ];
% u = [0.982797594226261  -0.497880943950698   0.789987900125162  -0.098087304638185];

% !!! step size is defined  in the body of the function

E0 = 0.5*(u(3)^2+u(4)^2) - 1/sqrt(u(1)^2+u(2)^2); %initial energy
E = E0;

%% initialise figure

figure;
subplot(1,2,1)
axis([-0.5 1.8  -1 1]);
axis square
hold on;
plot([-0.5 1.5],[0 0],'k--');
plot([0 0],[-1 1],'k--');
xlabel('X');
ylabel('Y');
hold off;

subplot(1,2,2)
axis([0 T  -25 25]);
hold on;
plot([0 T],[0 0],'k--');
% plot([0 0],[-1 1],'k--');
xlabel('X');
ylabel('Y');
hold off;

%% Main loop

t = 0;
i = 0;
while(t<T)

    %%  control of the adaptive step (if applied)
    r = (u(1)^2+u(2)^2)^(1/2);
    % At this point, we use further knowledge of the problem and we define
    % step-size dependent on the distance from the origin. "A true adaptive
    % method" would choose its steps automatically and it would be much more
    % complicated. 

    %%  step-size
%     h = 1e-2;      %  fixed 1
%     h = 5e-3;      %  fixed 2
%     h = 1e-3;      %  fixed 3
    h = 1e-1*r^2;  %  "adaptive"
   
   disp(['krok ' num2str(i) ': t=' num2str(t) ', r=' num2str(r) ', h=' num2str(h) ', E=' num2str(E) ', E0=' num2str(E0) ]);
   % print some characteristics on the screen
   
   %% the next point in time 
   i = i+1;
   t = t+h;
   pause(0.00001);
   
   %% show actual position
   subplot(1,2,1)
   hold on;
   plot(u(1),u(2),'r.'); 
   hold off;
 
   %% plot energy
   % store points       
   Ekin = 0.5*(u(3)^2+u(4)^2);
   Epot = -1/sqrt(u(1)^2+u(2)^2);
   E = Ekin + Epot;
   subplot(1,2,2)
   hold on;
   plot(t,Ekin,'g.');
   plot(t,Epot,'b.'); 
   plot(t,E,'r.'); 
   hold off;   
   
   %% The solver
   
   switch method
       case 'RK4'
           k1 = f(u);
           k2 = f(u+h/2*k1);
           k3 = f(u+h/2*k2);
           k4 = f(u+h*k3);
           u = u + h/6 * ( k1 + 2*k2 + 2*k3 + k4);
       case 'Euler'
           u = u + h * f(u);
   end
   

   
end

end