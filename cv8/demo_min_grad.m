function fd = demo_min_grad(metoda);
%
% Ukazka minimalizace funkce vice promennych gradientnimi metodami.    
%
% metoda=1: prime pouziti gradientu (metoda nejprudsiho spadu)  
%    Extremne pomale
% metoda=2: konjugovane gradienty, pouz. 1D Brentovou metodu bez derivaci
%    Kvadraticka forma - prakticky konverguje na 2 kroky
% metoda=3: konjugovane gradienty, pouz. 1D Brentovou metodu s derivacemi
%    Kvadraticka forma - prakticky konverguje na 2 kroky
%
% Na vstupu ocekavame pocatecni odhad - bod [X Y] pozadovanou presnost
%
    
    %% Mame dve promenne: x a y
    ndim=2;

    %% Funkce N promennych a jeji gradient
    %funcnd = inline('x(1)*(101*x(1)-198*x(2)+4) + x(2)*(101*x(2)+4) + 5','x');
    funcnd   = inline('101*(x(1)-x(2))^2 + 4*(x(1)+1)*(x(2)+1) + 1','x');
    grfuncnd = inline('[202*x(1)-198*x(2)+4 202*x(2)-198*x(1)+4]','x');

   
    %% Vybrana metoda minimalizace  
    disp(' ');
    if (metoda==1)
        disp('DEMO: Metoda nejprudsiho spadu')
    elseif (metoda==2)
        disp('DEMO: Konjugovane gradienty, pouz. 1D Brenta bez derivaci')
    elseif (metoda==3)
        disp('DEMO: Konjugovane gradienty, pouz. 1D Brenta s derivacemi')
    else
        disp(['Metoda ' num2str(metoda) ' neni implementovana'])
        return;
    end

    %% Pokud konjugovane gradienty, 1=Fletcher-Reeves, 2=Polak-Ribiere
    frpr = 2;
    
    while 1
        %% precti pocatecni odhad a toleranci
        pold = input(['\nZadej pocatecni bod ve formatu [x y] '...
                      'nebo ENTER pro ukonceni : ']);
        if (isempty(pold)) , break, end;
        ftol = input('Zadej vyzadovany min. pokles (default 1e-4) : ');
        if (isempty(ftol)||(ftol<=0))
            ftol = 1e-4;
            disp(['   -> zadne nebo nespravne zadani. Pouzijeme ', num2str(ftol) ])
        end;
        pnew = pold;
        fold = funcnd(pold);
        disp(['Pocatecni odhad : f(',num2str(pold),') = ',num2str(fold)]);
        %% sada smeru - zde jednotkove souradne vektory
        xdirset = zeros(ndim,ndim);
        for i=1:ndim
            xdirset(i,i) = 1.0;
        end
        %% zavolej minimalizaci
        [pnew,fnew,iter] = gradmin(funcnd,grfuncnd,...
                                   pnew,xdirset,metoda,frpr,ftol);
        %% vypis vysledek
        disp(['Provedl jsem ', num2str(iter) ' iteraci']);
        format long;
        disp(['Nalezene minimum: f(',num2str(pnew),') = ',num2str(fnew)]);
    end

    disp(['--- Koncim. ---']);

end
   

%%% Vlastni rutina pro minimalizaci

function [p,fret,iter] = gradmin(funcnd,grfuncnd,p,xdirset,method,frpr,ftol)
%
%
% Hleda minimum funkce FUNCND(X) N promennych (X je vektor dimenze N).
%
% Vstup
%   P[1..N] je pocatecni bod,
%   XDIRSET[1..N,1..N] je matice pocatecnich smeru, obvykle N jednotk. vektoru,
%   FTOL je pomerna tolerance funkcni hodnoty minima. 
%     Neschpnost zmensit hodnotu funkce o vice nez tuto hodnotu znamena hotovo.
%   METHOD: nejprudsi spad / konj.gred. bez nebo s derivacemi
% Vystup
%   P je nejlepsi nalezeny bod,
%   XDIRSET je soucasna sada smeru, 
%   FRET    je hodnota funkce je bode P,
%   ITER    je pocet provedenych iteraci. 
%
% Procedura pouziva LINMIN pro hledani minima ve smeru.
%
    itmax = 500;
    
    %% zjisti pocet promennych
    [buf,ndim] = size(p);
    
    %% funkcni hodnota a gradient v pocatecnim bodu
    fp   = funcnd(p);
    xdir = grfuncnd(p);

    g    = -xdir;
    %disp(['  iter ',num2str(0) ,':  g = (',num2str(g),')']);
    disp(['Pocatecni neg. gradient : g = (',num2str(g),')']);

    if ((method==2)||(method==3))
        h    = g;
        xdir = h;
        %disp(['  iter ',num2str(0) ,':  h = (',num2str(h),')']);
    end

    for iter = 1:itmax

        disp(['probiha iterace  ' num2str(iter)]);
        disp(['   minimalizuji ve smeru (',num2str(g),')']);
        %% 1D minimalizace ve smeru xdir
        if(method==1)
            %% nejprudsi spad: ve smeru g, Brent bez derivaci
            [p,fret] = linmin(funcnd, p,g);
        elseif(method==2)
            %% ConGrad: ve smeru h(=xdir), Brent bez derivaci
            [p,fret] = linmin(funcnd, p,xdir); 
        else
            %% ConGrad: ve smeru h(=xdir), Brent s derivacemi
            [p,fret] = dlinmin(funcnd,grfuncnd, p,xdir); 
        end
        %writeln('vysl iter',iter,'x y f',p(1),'  ',p(2),'  ',fp);
        disp(['      -> min je : (x y)= (',num2str(p),...
                  '),  f= ',num2str(fp)]);
        if ( 2.0*abs(fret-fp) <= ftol*(abs(fret)+abs(fp)+eps) ) 
           return; 
        end
        fp = funcnd(p);
        xdir = grfuncnd(p);

        if(method==1)
            %% metoda nejprudsiho spadu

            g  = -xdir;
            disp(['   iter ',num2str(iter) ,':  g = (',num2str(g),')']);
            %pause
            gg = sum(g(:).^2); 
            if (gg <= 0), return, end;

        else
            %% metoda konjugovanych gradientu 
            
            gg  = sum(g(:).^2); 
            if (gg <= 0), return, end;

            if (frpr==1) 
                %% Fletcher-Reeves
                dgg = sum( xdir(:).^2 );
            else
                %% Polak-Ribiere
                dgg = sum((xdir(:)+g(:)).*xdir(:));
            end
            gam = dgg/gg;

            g     = -xdir;
            h     = g + gam*h;

            disp(['   iter ',num2str(iter) ,':  g = (',num2str(g),')']);
            disp(['   iter ',num2str(iter) ,':  h = (',num2str(h),')']);
            disp(['   iter ',num2str(iter) ,':  gamma = ',num2str(gam)]);

            xdir  = h;
            sxdir = sum(xdir(:).^2);
            if (sxdir<=0.0), return, end;
      
        end;
      
    end;
    disp('Rutina GRADMIN selhala: prilis mnoho iteraci');
    pause
end
    

 
%%%  
