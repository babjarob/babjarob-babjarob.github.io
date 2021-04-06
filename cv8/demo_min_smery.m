function fd = demo_min_smery(metoda);
%
% Ukazka minimalizace funkce vice promennych.    
%
% metoda=1: minimalizace v souradnych smerech   
%    Ukazuje ze minimalizace provadena ve stale sade smeru muze vest 
%    k extremne pomale konvergenci
% metoda=2: Powellova metoda konjugovanych smeru
%    Konverguje rychle, zde extremne rychle nebot se hleda minimum
%    kvadraticke formy
%
% Na vstupu ocekavame pocatecni odhad - bod [X Y] pozadovanou presnost
%
    
    %% Mame dve promenne: x a y
    ndim=2;

    %% Funkce N promennych
    %funcnd = inline('x(1)*(101*x(1)-198*x(2)+4) + x(2)*(101*x(2)+4) + 5','x');
    funcnd = inline('101*(x(1)-x(2))^2 + 4*(x(1)+1)*(x(2)+1) + 1','x');

    
    %% Vybrana metoda minimalizace  
    disp(' ');
    if (metoda==1)
        disp('DEMO: Minimalizace v souradnych smerech')
    elseif (metoda==2)
        disp('DEMO: Powellova metoda konjugovanych smeru')
    else
        disp(['Metoda ' num2str(metoda) ' neni implementovana'])
        return;
    end
        
    
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
        if (metoda==1)
            [pnew,fnew,iter] = souradsmery(funcnd,pnew,xdirset,ftol);
        elseif (metoda==2)
            [pnew,fnew,iter] = powell(funcnd,pnew,xdirset,ftol);
        end
        %% vypis vysledek
        disp(['Provedl jsem ', num2str(iter) ' iteraci']);
        format long;
        disp(['Nalezene minimum: f(',num2str(pnew),') = ',num2str(fnew)]);
    end

    disp(['--- Koncim. ---']);

end
   

%%% Vlastni rutiny pro minimalizaci

function [p,fret,iter] = souradsmery(funcnd,p,xdirset,ftol)
%
% Hleda minimum funkce FUNCND(X) N promennych (X je vektor dimenze N).
%
% Vstup
%   P[1..N] je pocatecni bod,
%   XDIRSET[1..N,1..N] je matice pocatecnich smeru, obvykle N jednotk. vektoru,
%   FTOL je pomerna tolerance funkcni hodnoty minima. 
%     Neschpnost zmensit hodnotu funkce o vice nez tuto hodnotu znamena hotovo.
% Vystup
%   P je nejlepsi nalezeny bod,
%   XDIRSET je soucasna sada smeru, 
%   FRET    je hodnota funkce je bode P,
%   ITER    je pocet provedenych iteraci. 
%
% Procedura pouziva LINMIN pro hledani minima ve smeru.
%
    %% zjisti pocet promennych
    [buf,ndim] = size(p);
    
    fret = funcnd(p);
    pt   = p;
    iter = 0;

    while 1
        iter = iter+1;
        disp(['probiha iterace  ' num2str(iter)]);
        fp   = fret;
        ibig = 0;
        del  = 0.0;
        for i=1:ndim
            xdir = xdirset(:,i)';
            fptt = fret;
            [p,fret] = linmin(funcnd, p,xdir);
            disp(['  min ve smeru ',int2str(i),': (x y)= (',num2str(p),...
                  '),  f= ',num2str(fret)]);
            if (abs(fptt-fret)>del)
                del  = abs(fptt-fret);
                ibig = i;
            end;
        end;
        %pause;
        if ( 2.0*abs(fp-fret) <= ftol*(abs(fp)+abs(fret)) )
            break;
        end;
    end;
end
 
%%%

function [p,fret,iter] = powell(funcnd,p,xdirset,ftol)
%
% Hleda minimum funkce FUNCND(X) N promennych (X je vektor dimenze N).
%
% Vstup
%   P[1..N] je pocatecni bod,
%   XDIRSET[1..N,1..N] je matice pocatecnich smeru, obvykle N jednotk. vektoru,
%   FTOL je pomerna tolerance funkcni hodnoty minima. 
%     Neschpnost zmensit hodnotu funkce o vice nez tuto hodnotu znamena hotovo.
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
    
    fret = funcnd(p);
    %% uschovej pocatecni bod
    pt   = p;
    iter = 0;

    while 1
        iter = iter+1;
        disp(['probiha iterace  ' num2str(iter)]);
        fp   = fret;
        ibig = 0;
        del  = 0.0;
        %% iterace pres jednotlive smery
        for i=1:ndim
            xdir = xdirset(:,i)';
            fptt = fret;
            disp(['   minimalizuji ve smeru (',num2str(xdir),')']);
            %% 1D minimalizace ve smeru xdir
            [p,fret] = linmin(funcnd, p,xdir);
            disp(['      -> min je : (x y)= (',num2str(p),...
                  '),  f= ',num2str(fret)]);
            %% najdi smer s nejvetsim poklesem funkce
            if (abs(fptt-fret)>del)
                del  = abs(fptt-fret);
                ibig = i;
            end;
        end;
        %pause;
        if ( 2.0*abs(fp-fret) <= ftol*(abs(fp)+abs(fret)) )
            break;
        end;
        %% Toto je navic oproti rutine soursmery
        if (iter==itmax) 
            disp('Rutina POWELL selhala: prilis mnoho iteraci');
            break;
        end
        %% extrapolovany bod a prumerny smer
        ptt  = 2.0*p - pt;
        xdir = p - pt;
        pt   = p;
        fptt = funcnd(ptt);
        if (fptt<fp)
            t = 2.0 * (fp-2.0*fret+fptt) * (fp-fret-del)^2 - del*(fp-fptt)^2;
            if (t<0.0)
                disp(['   minimalizuji v novem smeru (',num2str(xdir),')']);
                %% presun se do minima v novem smeru
                [p,fret] = linmin(funcnd, p,xdir);
                disp(['      -> min je : (x y)= (',num2str(p),...
                  '),  f= ',num2str(fret)]);
                %% uloz novy smer misto smeru s nejvetsim poklesem
                xdirset(:,ibig) = xdir';
            end;
        end;
    end;
end
 
%%%  
