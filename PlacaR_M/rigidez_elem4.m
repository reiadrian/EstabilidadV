% rigidez_elem4: Calcula la matriz de rigidez de cada elemento cuadrilatero
% bilineal
function kelem = rigidez_elem4(ielem,conec,coord,Df,Dc,e_VG)


nnodo = e_VG.nnodo;
ndofn = e_VG.ndofn;
ngauss_c = e_VG.ngauss_c;
ngauss_f = e_VG.ngauss_f;
nstre_c = e_VG.nstre_c; 
nstre_f = e_VG.nstre_f; 

% kelem = zeros(nnodo*ndofn,nnodo*ndofn);
kelem_f = zeros(nnodo*ndofn,nnodo*ndofn);
kelem_c = zeros(nnodo*ndofn,nnodo*ndofn);
coord_el = coord(conec(ielem,1:1:nnodo),:);

[gausp,weigp] = gauss_points(ngauss_f); 
difATf = 0;
for igaus=1:ngauss_f % Bucle en dieccion xi o psi
    xi=gausp(igaus);
    for jgaus=1:ngauss_f % Bucle en dieccion eta
        eta=gausp(jgaus);
        [funfor,derivFF] = Fforma_DFf(xi,eta,nnodo);
        [detJB,MatrB] = MatB_Cuad(coord_el',derivFF',funfor,nnodo,ndofn,nstre_f);
        difA = detJB*weigp(igaus)*weigp(jgaus);     
        kelem_f = kelem_f + MatrB'*Df*MatrB*difA; 
        difATf = difATf + difA;
    end
end

[gausp,weigp] = gauss_points(ngauss_c); 
difATc= 0;
for igaus=1:ngauss_c % Bucle en dieccion xi o psi
    xi=gausp(igaus);
    for jgaus=1:ngauss_c % Bucle en dieccion eta
        eta=gausp(jgaus);
        [funfor,derivFF] = Fforma_DFf(xi,eta,nnodo);
        [detJB,MatrB] = MatB_Cuad(coord_el',derivFF',funfor,nnodo,ndofn,nstre_c);
        difA = detJB*weigp(igaus)*weigp(jgaus);     
        kelem_c = kelem_c + MatrB'*Dc*MatrB*difA; 
        difATc = difATc + difA;
    end
end

kelem = kelem_f + kelem_c;

