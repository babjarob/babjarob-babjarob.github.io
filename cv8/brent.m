function [xmin, fmin] = brent(fun, ax,bx,cx,tol)
%
% Brentova metoda pro hledani minima funkce.
% Podle rutiny BRENT z Numerical Recipes in C.
%    
% Hleda Brentovou metodou minimum zadane funkce FUNC, ktere je jiz
%   dopredu ohraniceno hodnotami AX,BX,CX, kde BX lezi mezi AX a CX 
%   a funkce je v BX minimalni z dane trojice. 
% TOL zadava relativni presnost hledani minima,
% Vystup:
%   XMIN je nalezena poloha minima,
%   FMIN je hodnota funkce v tomto bodu.
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
    %  
    ITMAX  = 100;
    % 1-zlaty rez    
    CGOLD  = 0.3819660;  
    % 
    ZEPS   = 1.0e-10;

    
    if (ax < cx) 
        a = ax;
    else 
        a = cx;
    end;
    if (ax > cx)
        b = ax;
    else 
        b = cx;
    end;
    v = bx;
    w = bx;
    x = bx;
    e  = 0.0;
    d  = 0.0;
    fx = func(fun,x);
    fv = fx;
    fw = fx;

    for iter=1:ITMAX
        xm   = 0.5*(a+b);
        tol1 = tol*abs(x) + ZEPS;
        tol2 = 2.0*tol1;
        if ( abs(x-xm) <= (tol2-0.5*(b-a)) ) 
            xmin = x;
            fmin = fx;
            return;
        end;
        if (abs(e) > tol1) 
            r = (x-w)*(fx-fv);
            q = (x-v)*(fx-fw);
            p = (x-v)*q-(x-w)*r;
            q = 2.0*(q-r);
            if (q > 0.0)
                p = -p;
            end;
            q = abs(q);
            etemp = e;
            e = d;
            if ( (abs(p)>=abs(0.5*q*etemp))||(p<=q*(a-x))||(p >= q*(b-x)))
                if (x>=xm) 
                    e = a-x;
                else
                    e = b-x;
                end;
                d = CGOLD*e;
            else 
                d = p/q;
                u = x+d;
                if ( (u-a<tol2) || (b-u<tol2) )
                    d = abs(tol1)*sign(xm-x);
                end
            end
        else 
            if (x>=xm) 
                e = a-x;
            else
                e = b-x;
            end;
            d = CGOLD*e;
        end;
        if (abs(d)>=tol1)
            u = x+d;
        else
            u = x + abs(tol1)*sign(d);
        end;
        fu = func(fun,u);
        if (fu <= fx) 
            if (u >= x) 
                a=x; 
            else 
                b=x;
            end;
            v = w;    w = x;    x = u;
            fv = fw;  fw = fx;  fx = fu;
        else 
            if (u < x) 
                a=u; 
            else 
                b=u;
            end;
            if ( (fu<=fw) || (w==x) ) 
                v  = w;
                w  = u;
                fv = fw;
                fw = fu;
            elseif ( (fu<=fv) || (v==x) || (v==w) )
                v  = u;
                fv = fu;
            end;
        end;
    end
    disp(['Too many iterations in BRENT']);
    xmin = x;
    fmin = fx;
    return;

    
end


    
    
