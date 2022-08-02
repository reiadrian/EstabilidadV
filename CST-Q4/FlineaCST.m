function FGlob = FlineaCST(conec,coord,qdist,t,FGlob)
FGlob = FGlob';
global nqdist
nl = nqdist-1; %Numero de lados con carga uniforme distribuida 
               %Equivale a numero de elementos que poseen la carga
for inl=1:nl
    nodo1 = qdist(inl,1);
    nodo2 = qdist(inl+1,1);
    coord_el = zeros(2,4);
    coord_el(1,3:4) = [coord(nodo1,1) coord(nodo2,1)];
    coord_el(2,3:4) = [coord(nodo1,2) coord(nodo2,2)];
    q = qdist(find(qdist(:,1) == nodo1),2);
    nodos = [nodo1 nodo2];
    dy = (coord_el(2,4)-coord_el(2,3))^2;
    dx = (coord_el(1,4)-coord_el(1,3))^2;
    dl = sqrt(dx^2+dy^2);
    Fl = q*dl/2;
    if dy==0
        FGlob(nodos*2) = FGlob(nodos*2) + Fl;
    elseif dx == 0
        FGlob(nodos*2-1) = FGlob(nodos*2-1) + Fl;
    else
        alfa = atan(dy/dx); 
        Flx = Fl*sin(alfa);
        Fly = Fl*cos(alfa);
        FGlob(nodos*2-1) = FGlob(nodos*2-1) + Flx;
        FGlob(nodos*2) = FGlob(nodos*2) + Fly; 
    end
end %nl
FGlob = FGlob';
end