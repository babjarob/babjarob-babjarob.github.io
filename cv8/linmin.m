function [p,fret] = linmin(funcnd, p,xdir)
%
% Hleda minimum funkce N promennych v danem smeru.
% Pouziva Brentovu metodu bez derivaci
%
% Vstup:  
%    N-dim. funkce func    = func(vecP)
%    gradient funkce func 
%    bod P[1..N] 
%    N dimenzionalni smer XDIR[1..N].
% Vystup: 
%    bod P (minimum ve smeru XDIR),
%    FRET = funkcni hodnota v P  
%    
% Pouziva MNBRAK a BRENT, 
%
    %% hodnota relativni presnosti pro BRENT.    
    tol = 1e-4;
    
    ax = 0.0;
    xx = 1.0;
    %% ohranic minimum funkce FUNC na primce  p + lambda * xdir
    [ax,xx,bx,fa,fx,fb] = mnbrak({funcnd;p;xdir}, ax,xx);
    %% najdi minimum fce FUNC na primce p+x*xdir
    %%    Brentovou metodou bez derivaci
    [xmin, fret] = brent({funcnd;p;xdir}, ax,xx,bx,tol);
    %% presun se do minima
    xdir(:) = xmin*xdir(:);
    p(:)    = p(:)+xdir(:);

end
 
