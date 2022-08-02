% rigidez_elem4: Calcula la matriz de rigidez de cada elemento cuadrilatero
% bilineal
function kelem = rigidez_elem8(ielem,conec,coord,D,t)

global nnodo ngauss ndofn nstre

kelem = zeros(nnodo*ndofn,nnodo*ndofn);

coord_el = coord(conec(ielem,1:1:nnodo),:);

[gausp,weigp] = gauss_points;
for igaus=1:ngauss % Bucle en dieccion xi o psi
    psi=gausp(igaus);
    for jgaus=1:ngauss % Bucle en dieccion eta
        eta=gausp(jgaus);
        [funfor,derivFF] = Fforma_DFf(psi,eta);
        [detJB,MatrB] = MatB_Cuad(coord_el',derivFF');
        difV = detJB*weigp(igaus)*weigp(jgaus)*t;     
%         MatrB = MatrizB(ndime,nnodo,nstre,coord_el,shap8,DerCa);
        kelem = kelem + MatrB'*D*MatrB*difV; 
    end
end
end
