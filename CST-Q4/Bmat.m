% Bmat: calculo matriz de las derivadas de las funciones de forma 
% Calculo de la matriz de B
function [B,area] = Bmat(nodos,coord)
global ndofn
%!! Calculo de los coeficienes derivados (dL/dx y dL/dy...En forma de derivadas parciales)
if ndofn==1
    b(1) = coord(nodos(2),2) - coord(nodos(3),2); %b1=y2-y3
    b(2) = coord(nodos(3),2) - coord(nodos(1),2); %b2=y3-y1
    b(3) = coord(nodos(1),2) - coord(nodos(2),2); %b3=y1-y2
    c(1) = coord(nodos(3),1) - coord(nodos(2),1); %c1=x3-x2
    c(2) = coord(nodos(1),1) - coord(nodos(3),1); %c2=x1-x3
    c(3) = coord(nodos(2),1) - coord(nodos(1),1); %c3=x2-x1
    
    %!! Calculo del áre
    area = 0.5*(c(3)*b(2)-c(2)*b(3));
    
    %!! Arma la matriz de las derivadas de las funciones de forma
    B1 = 1/(2*area) * [ b(1) b(2) b(3)];
    B2 = 1/(2*area) * [ c(1) c(2) c(3)];
    
    B=[B1 ; B2];
elseif ndofn==2
    b(1) = coord(nodos(2),2) - coord(nodos(3),2); %b1=y2-y3
    b(2) = coord(nodos(3),2) - coord(nodos(1),2); %b2=y3-y1
    b(3) = coord(nodos(1),2) - coord(nodos(2),2); %b3=y1-y2
    c(1) = coord(nodos(3),1) - coord(nodos(2),1); %c1=x3-x2
    c(2) = coord(nodos(1),1) - coord(nodos(3),1); %c2=x1-x3
    c(3) = coord(nodos(2),1) - coord(nodos(1),1); %c3=x2-x1
    
    %!! Calculo del �rea
    % area = 0.5*[(x2*y3+x3*y1+x1*y2)-(y1*x2+y2*x3+y3*x1)]
    
    area = 0.5*(c(3)*b(2)-c(2)*b(3));
    %area = 0.5 *[ [(x2 -x1) * (y3-y1)]- [(x1 -x3) * (y1-y2)]=0.5*[(x2y2 -x2y1-x1y3+x1y1)-(x1y1-x1y2-x3y1+x3y2)]
    % Pagina 24 "Elementos finitos triangulares para ESTADO PLANO"
    
    %!! Arma la matriz de las derivadas de las funciones de forma
    B1 = 1/(2*area) * [ b(1) 0 ; 0 c(1) ; c(1) b(1)];
    B2 = 1/(2*area) * [ b(2) 0 ; 0 c(2) ; c(2) b(2)];
    B3 = 1/(2*area) * [ b(3) 0 ; 0 c(3) ; c(3) b(3)];
    
    B=[B1 B2 B3];
end
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%!! Opcion alternativa - Pagina 24 "Elementos finitos triangulares para ESTADO PLANO"
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% B_a = 1/(2*area) * [ b(1) 0 b(2) 0  b(3) 0;
%                      0 c(1) 0 c(2) 0 c(3);
%                      c(1) b(1) c(2) b(2) c(3) b(3)];
% a=1;

