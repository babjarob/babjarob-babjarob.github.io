function dvp = demo_vypocetpi()
%
% Vypocet hodnoty cisla PI metodou Monte Carlo
%
%
% POZN.: pouziti ctvrtkruhu se stredem v (0,0) a polomerem 1
%        misto celeho kruhu se stredem v (0.5,0.5) a polomerem 0.5 
%        by nam usetrilo spoustu operaci
%

%% Parametry simulace 

nkap      = 20000;  % pocet kapek (vystrelu)
vykresluj = 0;      % vykreslovani kapek v kruhu
nsteps    = 10;     % pocet kroku, pokud vykresluj==1

%% Inicializace promennych

kapek   =  0;   % pocet kapek
vkruhu  =  0;   % pocet kapek v kruhu
npi     =  0.0; % aktualni odhad PI



if (vykresluj==0) 
    %% Jednoducha varianta: jen na konci vykresli vyvoj vypoc. PI
    plotNum = zeros(nkap,1);
    plotPi  = zeros(nkap,1);

    for i=1:nkap
        kapek = kapek+1; 
        x     = rand(1,2);    % dve nahodna cisla - bod (x1,x2)
        % jsou uvnitr kruhu se stredem (0.5,0.5) a polomerem 0.5?
        if ( (x(1)-0.5)^2+(x(2)-0.5)^2 < 0.25 ) 
            vkruhu = vkruhu + 1;    % pricteme je
        end;
        npi       = 4 * vkruhu / kapek; 
        plotPi(i) = npi;
    end;
    
    % nakreslime cely vyvoj PI
    figure
    plot(1:nkap,plotPi, [0 nkap], [pi pi]);
    axis([0 nkap 3.0 3.3]);

    
    
else
    %% Graficka varianta: prubezne (v krocich) kresli kapky a vyvoj PI
    
    np1s = nkap / nsteps;
    plotNum = zeros(nsteps,1);
    plotPi  = zeros(nsteps,1);
    
    figure; axes;
    subplot(1,2,1)
    axis square
    
    box on;
    rectangle('Position',[0,0,1,1],'Curvature',[1,1]);
    hold on;

    for i=1:nsteps
      
        % prepneme na obrazek kapek
        subplot(1,2,1)

        % dalsi krok (varka kapek)
        for j=1:np1s,
            kapek=kapek+1; 
            x=rand(1,2); % dve nahodna cisla - bod (x1,x2)
            % jsou uvnitr kruhu se stredem (0.5,0.5) a polomerem 0.5?
            if ( (x(1)-0.5)^2+(x(2)-0.5)^2 < 0.25 ) 
                vkruhu = vkruhu + 1;    % pricteme je
                plot(x(1),x(2),'o','Color',[1 0 0]); % a nakreslime cervene
            else
                plot(x(1),x(2),'o','Color',[0 0 1]); % nakreslime modre
            end;
        end;
        npi = 4 * vkruhu / kapek; 
        % delete(h);
        plotNum(i) = kapek;
        plotPi(i)  = npi;
        str = sprintf('%u kapek, vypoct. PI je %g',kapek,npi);
        h   = title(str);
        % waitforbuttonpress;
        drawnow; 
    
        % prekreslime vyvoj vypocteneho PI po aktualnim kroku
        subplot(1,2,2)
        plot(plotNum(1:i),plotPi(1:i), [0 nkap], [pi pi]);
        axis([0 nkap 3.05 3.25]);
        
        drawnow; 
    end;
    subplot(1,2,1)
    hold off;

    
end;
    
%% vypiseme vysledek
disp(['Pocet kapek ' num2str(nkap) '. Vypoctene PI je ' num2str(npi)]);


end
