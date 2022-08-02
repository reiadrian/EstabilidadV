%MatB_Cuad: Calcula la matriz B y el Jacobiano
function [detJ,B] = MatB_Cuad(coord_el,dN,N,nnodo,ndofn,nstre)

ndofpe = ndofn*nnodo;
% Matriz Jacobiana
J11 = coord_el(1,:)*dN(:,1);
J12 = coord_el(2,:)*dN(:,1);
J21 = coord_el(1,:)*dN(:,2);
J22 = coord_el(2,:)*dN(:,2);
J = [J11 J12 ; J21 J22];
detJ = det(J);

% Matriz B
dN_xy = J\(dN'); % Matriz de derivadas cartesianas
if nstre==2
    B = zeros(nstre,ndofn*nnodo);
    B(2,1:ndofn:ndofpe) = -dN_xy(1,:);
    B(1,3:ndofn:ndofpe) = N(1,:);
    B(1,1:ndofn:ndofpe) = -dN_xy(2,:);
    B(2,2:ndofn:ndofpe) = N(1,:);
elseif nstre==3
    B = zeros(nstre,ndofn*nnodo);
    B(1,2:ndofn:ndofpe) = dN_xy(1,:);
    B(2,3:ndofn:ndofpe) = dN_xy(2,:);
    B(3,2:ndofn:ndofpe) = dN_xy(2,:);
    B(3,3:ndofn:ndofpe) = dN_xy(1,:);
end