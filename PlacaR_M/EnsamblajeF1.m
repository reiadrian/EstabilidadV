% EnsamblajeF1: crea y ensambla el vector de cargas nodales GLOBALES
function FGlob = EnsamblajeF1(e_DatMat,e_DatElem,e_DatCB,e_VG)

npoin = e_VG.npoin;
nload_p = e_VG.nload_p; 
nload_d = e_VG.nload_d; 
ndofn = e_VG.ndofn;
nelem = e_VG.nelem;
nnodo = e_VG.nnodo;
nstre = e_VG.nstre_f;
ngauss = e_VG.ngauss_f;

denss = e_DatMat.denss;
espesor = e_DatElem.espesor;
elem = e_DatElem.elem; %Matriz de conectividades
coord = e_DatElem.coord; %Matriz de coordenadas nodales
carg_punt = e_DatCB.carg_punt; %Matriz de cargas puntuales
carg_dist = e_DatCB.carg_dist; %Matriz de cargas distribuidas
%Inicializa vector de fuerzas globales 
FGlob = zeros(ndofn*npoin,1); 
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%!! Cargas Puntuales
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
if nload_p ~= 0
    npos = ndofn*(carg_punt(:,1)-1)+carg_punt(:,2);
    FGlob(npos)=carg_punt(:,3); % Inserta Fz
end
%Opcion alternativa
% for innl = 1:nload_p
%     npos = ndofn*(carg_punt(innl,1)-1)+carg_punt(innl,2);
%     FGlob(npos)=carg_punt(innl,3); % Inserta Fz
% end
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%!! Fuerzas de Masa
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%Recupera las posiciones de los puntos de Gauss y sus pesos
% Fs = zeros(ndofn*nnodo,1);
% Fm = zeros(ndofn*nnodo,1);
if ~isempty(carg_dist)
    G = 9.81; %Aceleracion de la gravedad
    carg_dist = full(carg_dist);
    [gausp,weigp] = gauss_points(ngauss); 
    difAT = 0;
    difVT = 0;
    for iel=1:nelem %Bucle en elementos    
        Fs = zeros(ndofn*nnodo,1);
        Fm = zeros(ndofn*nnodo,1);
        cd_el = carg_dist(iel);
        coord_el = coord(elem(iel,1:1:nnodo),:);
        for igaus=1:ngauss % Bucle en dieccion xi o psi
            xi=gausp(igaus);
            for jgaus=1:ngauss % Bucle en dieccion eta
                eta=gausp(jgaus);
                [funfor,derivFF] = Fforma_DFf(xi,eta,nnodo); %Calcula las funciones de forma y sus derivadas en 
                                                       %el PG correspondiente
                [detJB,MatrB] = MatB_Cuad(coord_el',derivFF',funfor,nnodo,ndofn,nstre); %Calcula e determinante y la matriz B en 
                                                               %el PG correspondiente
                difA = detJB*weigp(igaus)*weigp(jgaus); %Calculo del area
                difV = difA*espesor;
                Fs(1:ndofn:end) = Fs(1:ndofn:end) + funfor'*cd_el*difA; 
                Fm(1:ndofn:end) = Fm(1:ndofn:end) + funfor'*denss*G*difV;
                difAT = difAT + difA;
                difVT = difVT + difV;
            end
        end
        for inodo=1:nnodo % Bucle en nodos
            nodoi=elem(iel,inodo); % Deternima el nodo del elemento considerado
            for igl=1:ndofn % Bucle en gdl
                filag=(nodoi-1)*ndofn+igl; % Determina la fila GLOBAL de KGlob donde se INTRODUCIRA el valor TOMADO de Kelem
                filae=(inodo-1)*ndofn+igl; % Determina la fila del ELEMENTO/LOCAL donde se TOMARA el valor de Kelem a INTRODUCIRSE EN KGlob
                FGlob(filag,1)=FGlob(filag,1)+Fs(filae,1)+Fm(filae,1);
            end %for(igl) 
        end %for(inodo) 
    end
end