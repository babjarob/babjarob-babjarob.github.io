%% Example of 2D - integration
% Jan Vabek (c), based on a tutorial by Jiri Vyskocil


clear all;
%% the function to be integrated + exact solution
% exact solution is only to estimate the errors

% f_handle = @(x,y) x+y;
% f_inline = inline('x+y','x','y');
% exact = 1

f_handle = @(x,y) abs(sin(pi^2.*((x-0.5).^2+(y-0.5).^2)));
f_inline = inline('abs(sin(pi^2.*((x-0.5).^2+(y-0.5).^2)))','x','y');
exact = 0.6551724745288948; % Mathematica

%% Integration area
% Unit square:
xmin = 0.0;
xmax = 1.0;
ymin = 0.0;
ymax = 1.0;

%% dicsretisation
% the same in both variables:
% h = 5.0e-2;
% h = 1.0e-2;
% h = 5.0e-3;
% h = 1.0e-3;
h = 5.0e-4;
% h = 1.0e-4;

TestInline = false; % inline calculation is too slow in some cases, possibility to turn it off
TestHandle = false;
Slowest = false;
Fastest = true;

%% The tests of various procedures
% see the fuction Compute2DIntegral for further details
if TestInline
    
%% Rectangle + inline
disp('Rectangle rule; loop; naive implementation; access by grids; inline');
[integral,time] = Compute2DIntegral(f_inline,[xmin, xmax],[ymin, ymax],h,'1D_x+y_rectangle_loop1'); precision = abs(integral-exact)/abs(exact);
disp(['Computation time: ' num2str(time) '; precision:   ' num2str(precision) '; value:  ' num2str(integral) ]);
fprintf('\n');

disp('Rectangle rule; loop; naive implementation; access by indices; inline');
[integral,time] = Compute2DIntegral(f_inline,[xmin, xmax],[ymin, ymax],h,'1D_x+y_rectangle_loop2'); precision = abs(integral-exact)/abs(exact);
disp(['Computation time: ' num2str(time) '; precision:   ' num2str(precision) '; value:  ' num2str(integral) ]);
fprintf('\n');

disp('Rectangle rule; loop; shorter summation; access by indices; inline');
[integral,time] = Compute2DIntegral(f_inline,[xmin, xmax],[ymin, ymax],h,'1D_x+y_rectangle_loop3'); precision = abs(integral-exact)/abs(exact);
disp(['Computation time: ' num2str(time) '; precision:   ' num2str(precision) '; value:  ' num2str(integral) ]);
fprintf('\n');

disp('Rectangle rule; matrix+loop; shorter summation; access by grids; inline');
[integral,time] = Compute2DIntegral(f_inline,[xmin, xmax],[ymin, ymax],h,'1D_x+y_rectangle_matrix1'); precision = abs(integral-exact)/abs(exact);
disp(['Computation time: ' num2str(time) '; precision:   ' num2str(precision) '; value:  ' num2str(integral) ]);
fprintf('\n');


disp('Rectangle rule; full matrix; inline; + allocation time');
[integral,time] = Compute2DIntegral(f_inline,[xmin, xmax],[ymin, ymax],h,'1D_x+y_rectangle_matrix3'); precision = abs(integral-exact)/abs(exact);
disp(['Computation time: ' num2str(time) '; precision:   ' num2str(precision) '; value:  ' num2str(integral) ]);
fprintf('\n');

disp('Rectangle rule; full matrix; inline;');
[integral,time] = Compute2DIntegral(f_inline,[xmin, xmax],[ymin, ymax],h,'1D_x+y_rectangle_matrix2'); precision = abs(integral-exact)/abs(exact);
disp(['Computation time: ' num2str(time) '; precision:   ' num2str(precision) '; value:  ' num2str(integral) ]);
fprintf('\n');

disp('Rectangle rule; full matrix; inline; + second run');
[integral,time] = Compute2DIntegral(f_inline,[xmin, xmax],[ymin, ymax],h,'1D_x+y_rectangle_matrix2'); precision = abs(integral-exact)/abs(exact);
disp(['Computation time: ' num2str(time) '; precision:   ' num2str(precision) '; value:  ' num2str(integral) ]);
fprintf('\n');

%% Midpoint + inline
disp('Midpoint rule; loop; access by grids; inline;');
[integral,time] = Compute2DIntegral(f_inline,[xmin, xmax],[ymin, ymax],h,'2D_midpoint_loop1'); precision = abs(integral-exact)/abs(exact);
disp(['Computation time: ' num2str(time) '; precision:   ' num2str(precision) '; value:  ' num2str(integral) ]);
fprintf('\n');

disp('Midpoint rule; loop; access by indices; inline;');
[integral,time] = Compute2DIntegral(f_inline,[xmin, xmax],[ymin, ymax],h,'2D_midpoint_loop2'); precision = abs(integral-exact)/abs(exact);
disp(['Computation time: ' num2str(time) '; precision:   ' num2str(precision) '; value:  ' num2str(integral) ]);
fprintf('\n');

disp('Midpoint rule; matrix+loop; inline;');
[integral,time] = Compute2DIntegral(f_inline,[xmin, xmax],[ymin, ymax],h,'2D_midpoint_matrix1'); precision = abs(integral-exact)/abs(exact);
disp(['Computation time: ' num2str(time) '; precision:   ' num2str(precision) '; value:  ' num2str(integral) ]);
fprintf('\n');

disp('Midpoint rule; full matrix; inline;');
[integral,time] = Compute2DIntegral(f_inline,[xmin, xmax],[ymin, ymax],h,'2D_midpoint_matrix2'); precision = abs(integral-exact)/abs(exact);
disp(['Computation time: ' num2str(time) '; precision:   ' num2str(precision) '; value:  ' num2str(integral) ]);
fprintf('\n');
end
if TestHandle
%% Rectangle + handle
disp('Rectangle rule; loop; naive implementation; access by grids; handle');
[integral,time] = Compute2DIntegral(f_handle,[xmin, xmax],[ymin, ymax],h,'1D_x+y_rectangle_loop1'); precision = abs(integral-exact)/abs(exact);
disp(['Computation time: ' num2str(time) '; precision:   ' num2str(precision) '; value:  ' num2str(integral) ]);
fprintf('\n');

disp('Rectangle rule; loop; naive implementation; access by indices; handle');
[integral,time] = Compute2DIntegral(f_handle,[xmin, xmax],[ymin, ymax],h,'1D_x+y_rectangle_loop2'); precision = abs(integral-exact)/abs(exact);
disp(['Computation time: ' num2str(time) '; precision:   ' num2str(precision) '; value:  ' num2str(integral) ]);
fprintf('\n');

disp('Rectangle rule; loop; shorter summation; access by indices; handle');
[integral,time] = Compute2DIntegral(f_handle,[xmin, xmax],[ymin, ymax],h,'1D_x+y_rectangle_loop3'); precision = abs(integral-exact)/abs(exact);
disp(['Computation time: ' num2str(time) '; precision:   ' num2str(precision) '; value:  ' num2str(integral) ]);
fprintf('\n');

disp('Rectangle rule; matrix+loop; shorter summation; access by grids; handle');
[integral,time] = Compute2DIntegral(f_handle,[xmin, xmax],[ymin, ymax],h,'1D_x+y_rectangle_matrix1'); precision = abs(integral-exact)/abs(exact);
disp(['Computation time: ' num2str(time) '; precision:   ' num2str(precision) '; value:  ' num2str(integral) ]);
fprintf('\n');


disp('Rectangle rule; full matrix; handle; + allocation time');
[integral,time] = Compute2DIntegral(f_handle,[xmin, xmax],[ymin, ymax],h,'1D_x+y_rectangle_matrix3'); precision = abs(integral-exact)/abs(exact);
disp(['Computation time: ' num2str(time) '; precision:   ' num2str(precision) '; value:  ' num2str(integral) ]);
fprintf('\n');

disp('Rectangle rule; full matrix; handle;');
[integral,time] = Compute2DIntegral(f_handle,[xmin, xmax],[ymin, ymax],h,'1D_x+y_rectangle_matrix2'); precision = abs(integral-exact)/abs(exact);
disp(['Computation time: ' num2str(time) '; precision:   ' num2str(precision) '; value:  ' num2str(integral) ]);
fprintf('\n');

disp('Rectangle rule; full matrix; handle; + second run');
[integral,time] = Compute2DIntegral(f_handle,[xmin, xmax],[ymin, ymax],h,'1D_x+y_rectangle_matrix2'); precision = abs(integral-exact)/abs(exact);
disp(['Computation time: ' num2str(time) '; precision:   ' num2str(precision) '; value:  ' num2str(integral) ]);
fprintf('\n');

%% Midpoint + handle
disp('Midpoint rule; loop; access by grids; handle;');
[integral,time] = Compute2DIntegral(f_handle,[xmin, xmax],[ymin, ymax],h,'2D_midpoint_loop1'); precision = abs(integral-exact)/abs(exact);
disp(['Computation time: ' num2str(time) '; precision:   ' num2str(precision) '; value:  ' num2str(integral) ]);
fprintf('\n');

disp('Midpoint rule; loop; access by indices; handle;');
[integral,time] = Compute2DIntegral(f_handle,[xmin, xmax],[ymin, ymax],h,'2D_midpoint_loop2'); precision = abs(integral-exact)/abs(exact);
disp(['Computation time: ' num2str(time) '; precision:   ' num2str(precision) '; value:  ' num2str(integral) ]);
fprintf('\n');

disp('Midpoint rule; matrix+loop; handle;');
[integral,time] = Compute2DIntegral(f_handle,[xmin, xmax],[ymin, ymax],h,'2D_midpoint_matrix1'); precision = abs(integral-exact)/abs(exact);
disp(['Computation time: ' num2str(time) '; precision:   ' num2str(precision) '; value:  ' num2str(integral) ]);
fprintf('\n');

disp('Midpoint rule; full matrix; handle;');
[integral,time] = Compute2DIntegral(f_handle,[xmin, xmax],[ymin, ymax],h,'2D_midpoint_matrix2'); precision = abs(integral-exact)/abs(exact);
disp(['Computation time: ' num2str(time) '; precision:   ' num2str(precision) '; value:  ' num2str(integral) ]);
fprintf('\n');
end

if Slowest
    [integral,time] = Compute2DIntegral(f_handle,[xmin, xmax],[ymin, ymax],h,'1D_x+y_rectangle_loop3');
end
if Fastest
    [integral,time] = Compute2DIntegral(f_handle,[xmin, xmax],[ymin, ymax],h,'2D_midpoint_matrix2');
end






%% functions

function [integral, time] = Compute2DIntegral(f,xlim,ylim,h,method)
    xmin = xlim(1); xmax = xlim(2); 
    ymin = ylim(1); ymax = ylim(2); 
    switch method
        %% 2D - midpoint  
        % We sum cuboids defined by the grid points and the function value
        % in the middle of the cells. (All the middles all sometimes called
        % reciprocal grid).
        case '2D_midpoint_matrix1'
            
            xgrid = (xmin+h/2:h:xmax-h/2);
            ygrid = (ymin+h/2:h:ymax-h/2);

            tic % start timing
            Npoints = length(xgrid);
            % preallocate array for all function values, this may be large,
            % it is easy to change it to one row only and compute it
            % consequitively (without 'sum').
            fval = zeros(Npoints,Npoints);
            for i=1:Npoints       
                fval(:,i) = f(xgrid(i),ygrid(:));
            end
            integral = sum(fval(:))*h^2; % sum all the elements of matrix at once
            time = toc; % stop timing
            
        case '2D_midpoint_matrix2'
            % The heaviest implementation for memory, we allocate 3
            % matrices of the size Nx*Ny=N^2. The code is shortest, only  3
            % lines, no explicit loops.
            [xgrid, ygrid] = meshgrid( (xmin+h/2:h:xmax-h/2), (ymin+h/2:h:ymax-h/2));
            
            tic % start timing
            fvals = f(xgrid,ygrid);
            integral = sum(fvals(:))*h^2;
            time = toc;

        case '2D_midpoint_loop1'
            % Implementation with loops. There are pre-allocated grids. If
            % you remove it (xi = x0 + h). You can do the calculation
            % almost with no memory.
            xgrid = (xmin+h/2:h:xmax-h/2);
            ygrid = (ymin+h/2:h:ymax-h/2);

            tic; % start timing
            integral=0;            
            for xi = xgrid       % x - coordinate loop
                for yi = ygrid   % y - coordinate subloop, sums all y's for every x              
                    integral = integral + f(xi,yi); 
                end
            end
            integral = integral*h^2;
            time = toc;

        case '2D_midpoint_loop2'
            % The same as previous, but accessing grids by explicit indices.
            
            xgrid = (xmin+h/2:h:xmax-h/2);
            ygrid = (ymin+h/2:h:ymax-h/2);

            tic; % start timing
            integral=0;            
            for k1 = 1:length(xgrid)       
                for k2 = 1:length(ygrid)                    
                    integral = integral + f(xgrid(k1),ygrid(k2)); 
                end
            end
            integral = integral*h^2;
            time = toc;

            
        %% 1D - rectangle
        % The inspiration comes from the Fubini's theorem and integrating
        % by 1-D rectangle rulesin every direction. See tutorials for
        % further explanation about equivalent formulations.
        case '1D_x+y_rectangle_loop1'
            % A naïve implementation with the formula for computing the
            % rectangle area. Accessing the grids directly.
            xgrid = xmin:h:xmax;
            ygrid = ymin:h:ymax;

            tic; % start timing
            integral = 0;
            % There are only (N-1) summands. We start the sum in the second
            % iteration.
            firstrun = true; 
            for xi = xgrid                
                integral_y2 = 0;
                for yi = ygrid(1:end-1) % 1-D rectangle integration over y.                 
                    integral_y2 = integral_y2 + 0.5*(f(xi,yi)+f(xi,yi+h)); 
                end                
                if ~firstrun, integral = integral + 0.5*(integral_y1+integral_y2); end % Integrate over x, when the points ara available
                integral_y1 = integral_y2;                
                firstrun = false;
            end
            integral = integral*h^2;
            time = toc;

        case '1D_x+y_rectangle_loop2'
            % The same as above, but accessing the grids by indices.
            
            xgrid = xmin:h:xmax;
            ygrid = ymin:h:ymax;
            
            tic; % start timing
            integral = 0;
            firstrun = true;
            for k1 = 1:length(xgrid)                
                integral_y2 = 0;
                for k2 = 1:(length(ygrid)-1)         
                    integral_y2 = integral_y2 + 0.5*(f(xgrid(k1),ygrid(k2))+f(xgrid(k1),ygrid(k2+1)));
                end                
                if ~firstrun, integral = integral + 0.5*(integral_y1+integral_y2); end
                integral_y1 = integral_y2;                
                firstrun = false;
            end
            integral = integral*h^2;
            time = toc;
            
            
        case '1D_x+y_rectangle_loop3'
            % All the points in the middle of the grids are computed and
            % added two times = redundant operations. We use them only once.
            xgrid = xmin:h:xmax;
            ygrid = ymin:h:ymax;
            
            tic; % start timing
            integral = 0;
            firstrun = true;
            for k1 = 1:length(xgrid)                
                integral_y2 = 0.5*f(xgrid(k1),ygrid(1));
                for k2 = 2:(length(ygrid)-1)
                    integral_y2 = integral_y2 + f(xgrid(k1),ygrid(k2));
                end 
                integral_y2 = integral_y2 + 0.5*f(xgrid(k1),ygrid(end));
                if ~firstrun, integral = integral + 0.5*(integral_y1+integral_y2); end
                integral_y1 = integral_y2;                
                firstrun = false;
            end
            integral = integral*h^2;
            time = toc;
            
        case '1D_x+y_rectangle_matrix1'
            % The inner summation is done explicitely, we keep the
            % rectangle rule for the outer loop.
            xgrid = xmin:h:xmax;
            ygrid = ymin:h:ymax;
            
            tic; % start timing
            integral = 0;
            firstrun = true;
            for k1 = 1:length(xgrid)                
                integral_y2 = 0.5*f(xgrid(k1),ygrid(1)) + sum(f(xgrid(k1),ygrid(2:end-1))) + 0.5*f(xgrid(k1),ygrid(end));
                if ~firstrun, integral = integral + 0.5*(integral_y1+integral_y2); end
                integral_y1 = integral_y2;                
                firstrun = false;
            end
            integral = integral*h^2;
            time = toc;

        case '1D_x+y_rectangle_matrix2'
            % We remove all the explicit loops. See tutorials fol details.
            % The heaviest memory consumption.
            [xgrid, ygrid] = meshgrid( xmin:h:xmax , ymin:h:ymax );
            
            tic % start timing
            fvals = f(xgrid(2:end-1,2:end-1),ygrid(2:end-1,2:end-1)); % central term (without the edges)
            
            integral = h^2*(sum(fvals(:)) +... % sum the central terms
                            0.5*(... % add the edges
                                sum(f(xgrid(1,2:end-1),ygrid(1,2:end-1))) + ...
                                sum(f(xgrid(end,2:end-1),ygrid(end,2:end-1))) + ...
                                sum(f(xgrid(2:end-1,1),ygrid(2:end-1,1))) + ...
                                sum(f(xgrid(2:end-1,end),ygrid(2:end-1,end))))+...
                            0.25*(... % add the vertices
                                f(xgrid(1,1),ygrid(1,1))+...
                                f(xgrid(end,1),ygrid(end,1))+...
                                f(xgrid(1,end),ygrid(1,end))+...
                                f(xgrid(end,end),ygrid(end,end))));

            time = toc;

        case '1D_x+y_rectangle_matrix3'
            % the same as above, but grid allocation is included in the
            % timing.
            tic % start timing
            
            [xgrid, ygrid] = meshgrid( xmin:h:xmax , ymin:h:ymax );
            
            
            fvals = f(xgrid(2:end-1,2:end-1),ygrid(2:end-1,2:end-1)); % central term            
            integral = h^2*(sum(fvals(:)) +...
                            0.5*(...
                                sum(f(xgrid(1,2:end-1),ygrid(1,2:end-1))) + ...
                                sum(f(xgrid(end,2:end-1),ygrid(end,2:end-1))) + ...
                                sum(f(xgrid(2:end-1,1),ygrid(2:end-1,1))) + ...
                                sum(f(xgrid(2:end-1,end),ygrid(2:end-1,end))))+...
                            0.25*(...
                                f(xgrid(1,1),ygrid(1,1))+...
                                f(xgrid(end,1),ygrid(end,1))+...
                                f(xgrid(1,end),ygrid(1,end))+...
                                f(xgrid(end,end),ygrid(end,end))));

            time = toc;
            
        otherwise
            error('wrongly specified method');
    end
end
