%% Demo: Direct multiple shooting method
 
%% parameters of the problem
    h   = 0.01;
    params.c = 0.5; % crs = c * rho * s
    params.m   = 1.0;
    params.g   = 1.0;
    
    imax = 14; % Number of iterations

    % Target position is (x0, 0)
    x0  = 2;

 %% initial conditions
    % Min and max elevation angles
    angA = 45;
    angB = 85;
    
    u0(1) = 0;
    u0(2) = 0;
    u0(3) = 4; % initial velocity
    
    estimates   = zeros(imax,1);
    
    % initialise figure
    figure
    hold on
    xl=xlim(gca);
% 	plot(xl,[0.0 0.0],'k--');
    set(gca, 'XAxisLocation', 'origin')
	plot([x0 x0],[0 0],'rx','Markersize',5,'Linewidth',3)
            
    % two probe shots
    angA = angA * (2*pi/360); angB = angB * (2*pi/360);
    
    [x, y, ~, ~] = findtrajectory(angA,u0,params,h);
    plot(x,y); xA = x(end);
    
    [x, y, ~, ~] = findtrajectory(angB,u0,params,h);
    plot(x,y); xB = x(end);
    
    for i=1:imax
        
        % correction (bisection)
        ang = 0.5*(angA+angB);
            
        % Solve the initial problem
        [x, y, v, ang_impact] = findtrajectory(ang,u0,params,h);
        
        % bisection step
        if( x(end) > x0 ) 
            angB = ang; xB = x(end); % too far, decrease initial angle
        else
            angA = ang; xA = x(end); % too close, increase initial angle
        end        
        % Print info
        disp(['i= ' num2str(i), ', theta (0)= ' num2str(ang * (360/(2*pi))), ' deg' ...
              ', (x,y)= (', num2str(x(end)) ',' num2str(y(end)) ')' ...
              ', v=' num2str(v) ', theta_impact=' num2str(ang_impact * (360/(2*pi))) ' deg']);

        % Plot the trajectory
        plot(x,y);
        pause
    
    end;
    hold off;
    
    
    
    return;
    
    
%%%%%%%%%%%%
function du = f(u,params)
% Right-hand side f(w)
% (Vector of derivatives w.r.t. time)
    
    du = zeros(4,1);
    du(1) = u(3)*cos(u(4));
    du(2) = u(3)*sin(u(4));
    du(3) = -params.c*u(3)/params.m - params.g*sin(u(4))/params.m; %the resistance model is specidied here
    du(3) = -params.c*u(3)^2/params.m - params.g*sin(u(4))/params.m;
    du(4) = -params.g*cos(u(4)) / (params.m*u(3));
    
end
    
%%%%%%%%%%%%

function u = rk4step(u,params,h)
% One step by RK4 method
    
    fi  = f(u,params);
    k1  = h*fi(:);

    buf = u(:)+k1(:)/2;
    fi  = f(buf,params);
    k2  = h*fi(:);

    buf = u(:)+k2(:)/2;
    fi  = f(buf,params);
    k3  = h*fi(:);

    buf = u(:)+k3(:)/2;
    fi  = f(buf,params);
    k4  = h*fi(:);

    u = u(:) + ( k1(:) + 2.0*k2(:) + 2.0*k3(:) + k4(:) ) / 6.0;
end

%%%%%%%%%%%%

function [x, y, v, ang_impact] = findtrajectory(ang,u0,params,h)
    x = 0; y =0;
    u = u0;
    u(4) = ang;
    i = 2;
    while (u(2) >= 0)
        u = rk4step(u,params,h);
        x(i)=u(1); y(i)=u(2);
        i = i+1;
    end
    v = u(3); ang_impact = u(4);
end   
