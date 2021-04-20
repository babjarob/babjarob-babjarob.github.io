% Integrals:

%% inputs
% function to integrate
% transform of 1/sqrt(x)
f = @(x) 1/sqrt(x); exact = 2;% open formulas will work

% transform of cos(x)/sqrt(x)
% f = @(x) cos(x)/sqrt(x); exact = sqrt(2*pi)*fresnelc(sqrt(2));% open formulas will work

% transform of atg(x)/(1+x^2)

% transform of sqrt(tan(x))
% f = @(x) sqrt(tan(x)); exact = 2.22144;


% limits
a = 0;
b = 1;

% number of intervals (number of points is N+1) %should be odd for correct Simpson
N = 10; 

%% prepare grid
x=linspace(a,b,N+1);
  
    
%% integration loop

LR  = 0.0; % Left rectangle
RR  = 0.0; % Right rectangle
MP  = 0.0; % Midpoint
trap  = 0.0; % trapezoidal
simp  = 0.0; % composed Simpson

h = x(2)-x(1); %equidistant grid

for i=1:N
    LR = LR + 
    RR = RR + 
    MP = MP + 
    trap = trap + 
    
    simp = simp +
end



%% Results


%% vypis reseni
disp(['  Exact solution:   ' num2str(exact) '.']);
disp(['  Left rectangle:   ' num2str(LR) '.']);
disp(['  Right rectangle:  ' num2str(RR) '.']);
disp(['  Midpoint :        ' num2str(MP) '.']);
disp(['  Trapezoidal:      ' num2str(trap) '.']);
disp(['  Simpson:          ' num2str(simp) '.']);

