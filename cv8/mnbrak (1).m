function [ax,bx,cx,fa,fb,fc] = mnbrak(fun, ax,bx)
%
% Ohraniceni minima funkce.
% Podle rutiny MNBRAK z Numerical Recipes in C.
%    
% Pri zadanych AX, BX rutina hleda oblast minima funkce FUNC tim ze se
%   pohybuje z kopce dolu dokud nenarazi na protisvah.
% Pouziva parabolickou inter(extra)polaci k odhadu polohy minima.
% Na vystupu lezi BX mezi AX a CX a hodnota FUNC(BX) je nejmensi z danych
%   3 hodnot, ktere jsou casti vystupu. 
% Zvetseni intervalu se provadi nasobkem zlateho rezu.
%
% Pokud je na vstupu FUN inline funkce, predpokladame skalarni funkci     
% Pokud je na vstupu FUN = {FUNCND,PT0,DIR)}, provadime 1D minimalizaci 
%       na primce  PT0 + x*DIR
%


    %% prevadi fun na skalarni funkci
    function f = func(fun,x)
    % 
    % Pokud jsme v 1D, funguje klasicky: 
    %       FUNC(x) = FUN(x)
    % Pokud jsme ve vice dim, prevadi problem na 1D minimalizaci na primce:
    %       FUNC(x) = FUNCND( PT0 + x*DIR )
    %    
        if (iscell(fun))
            % funkce vektoru, pocatecni bod a smer
            funcnd = fun{1};
            pt0    = fun{2};
            dir    = fun{3};
            f = funcnd(pt0+dir*x);
        else
            % napriklad: fun=inline('sin(x)-0.5');
            f = fun(x);
        end;
        return;
    end

    
    %% Definice konstant
    % 1+zlaty rez    
    GOLD   = 1.618034;  
    % maximalni povolene zvetseni intervalu pri 1 kroku parabolicke extrpolace
    GLIMIT = 100.0;     
    % minimalni hodnota jmenovatele pri parabolicke i(e).
    TINY   = 1.0e-20;

    fa = func(fun,ax);
    fb = func(fun,bx);
    if (fb > fa) 
        dum = ax;  ax = bx;  bx = dum;
        dum = fb;  fb = fa;  fa = dum;
    end    
    cx = bx + GOLD*(bx-ax);
    fc = func(fun,cx);
    
    while (fb >= fc) % OLD: while (fb > fc) 
        r = (bx-ax)*(fb-fc);
        q = (bx-cx)*(fb-fa);
        u = bx - ((bx-cx)*q-(bx-ax)*r) / (2.0*max(abs(q-r),TINY)*sign(q-r));
        ulim = bx + GLIMIT*(cx-bx);
        if ( (bx-u)*(u-cx) > 0.0 ) 
            fu = func(fun,u);
            if (fu < fc) 
                ax = bx;
                bx = u;
                fa = fb;
                fb = fu;
                return;
            elseif (fu > fb) 
                cx = u;
                fc = fu;
                return;
            end
            u  = cx + GOLD*(cx-bx);
            fu = func(fun,u);
        elseif ( (cx-u)*(u-ulim) > 0.0 ) 
            fu = func(fun,u);
            if (fu < fc) 
                bx = cx;  cx = u;   u  = cx + GOLD*(cx-bx);
                fb = fc;  fc = fu;  fu = func(fun,u);
            end	
	elseif ( (u-ulim)*(ulim-cx) >= 0.0 ) 
            u  = ulim;
            fu = func(fun,u);
        else 
            u  = cx + GOLD*(cx-bx);
            fu = func(fun,u);
        end 
      ax = bx;  bx = cx;  cx = u;
      fa = fb;  fb = fc;  fc = fu;
    end % end of "while (fb > fc)"

end

    
