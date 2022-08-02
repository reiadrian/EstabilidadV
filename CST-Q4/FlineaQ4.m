function FGlob = FlineaQ4(conec,coord,qdist,t,FGlob)
FGlob = FGlob';
global ngauss nqdist
[gausp,weigp] = gauss_points;
nl = nqdist-1; %Numero de lados con carga uniforme distribuida 
               %Equivale a numero de elementos que poseen la carga
eta = 1; %Es indiferente que linea se utilice del elemento Q4. En todos los caso el resultado
         %deberia ser el mismo q*l_elem/2
for inl=1:nl
    nodo1 = qdist(inl,1);
    nodo2 = qdist(inl+1,1);
    coord_el = zeros(2,4);
    coord_el(1,3:4) = [coord(nodo1,1) coord(nodo2,1)];
    coord_el(2,3:4) = [coord(nodo1,2) coord(nodo2,2)];
    q = qdist(find(qdist(:,1) == nodo1),2);
    Fl = zeros(4,1);
    for igaus=1:ngauss % Bucle en dieccion en una sola direccion (integral de linea)
        xi=gausp(igaus); %Integra en dos puntos de Gauss
        [funfor,derivFF] = Fforma_DFf(xi,eta);
        detJ = detJ_linea(coord_el,derivFF(1,:));
        dl = detJ*weigp(igaus)*1;
%         dli = dli + detJ*weigp(igaus);
        Fl = Fl + funfor'*q*dl;
    end %ngauss
    nodos = [nodo1 nodo2];
    dy = (coord_el(2,4)-coord_el(2,3))^2;
    dx = (coord_el(1,4)-coord_el(1,3))^2;
    if dy==0
        %Corresponde a la direccion y en cada nodo
        FGlob(nodos*2) = FGlob(nodos*2) + Fl(3:4);
    elseif dx == 0
        FGlob(nodos*2-1) = FGlob(nodos*2-1) + Fl(3:4);
    else
        alfa = atan(dy/dx); 
        Flx = Fl*sin(alfa);
        Fly = Fl*cos(alfa);
        FGlob(nodos*2-1) = FGlob(nodos*2-1) + Flx(3:4);
        FGlob(nodos*2) = FGlob(nodos*2) + Fly(3:4); 
    end
end %nl
FGlob = FGlob';
end

function detJ = detJ_linea(coord_el,dN)
%Determinante del Jacobiano de una linea
J11 = coord_el(1,:)*dN';
J12 = coord_el(2,:)*dN';
detJ = sqrt(J11^2+J12^2);
end