% CondBorde: impone las condiciones de borde del problema
% Agrega al vector de fuerzas, aquellas provocadas por un desplazamiento
% prescripto distinto de cero
function [KGcon,FGcon,e_DatCB] = CondBorde(KGlob,FGlob,e_DatCB,e_VG)

npoin = e_VG.npoin;
nfixe = e_VG.nfixe;
ndofn = e_VG.ndofn;
nod_rest = e_DatCB.nod_rest; %Matriz con nodos restringidos
%Arma matriz con condiciones de borde
ifixe=zeros(ndofn*npoin,2); % Arma matriz con condiciones de borde
%Recupera los grados de libertad global con condiciones de borde
npos=(nod_rest(:,1)-1)*ndofn+nod_rest(:,2);
%Completa la matriz con condiciones de borde impuestas
ifixe(npos,:)=[ones(nfixe,1) nod_rest(:,3)];  
%!! Matriz de RIGIDEZ CON CONDICIONES DE BORDE (Kcb) - Elimina filas y
%!! columnas
%!! Crea matriz de rigidez que contiene solamente los valores para los gdl
%!! libres (impone las restricciones a Kcb)
nfix = find(ifixe(:,1)==0);
KGcon = KGlob(nfix,nfix);
fix = find(ifixe(:,1)==1);

%!! Determina fuerzas generadas por desplazamientos prescriptos distintos a
%!! cero Fuerza por desplazamientos prescriptos = KGlob(:,j)*ifixe(j,2)
%!! Bucle para armar matriz que contiene las restricciones del problema
for i=1:length(fix)
    j=fix(i);
    FGlob = FGlob - KGlob(:,j)*ifixe(j,2);
end %for(i)
%!! Crea el vector de fuerzas nodales que contiene solamente los valores 
%!! para los gdl restringidos (impone las restricciones a FGlob)
FGcon = FGlob(nfix);
%Guardo la matriz ifixe en la estrucutura con los datos de condiciones de
%borde 
e_DatCB.ifixe = ifixe;

