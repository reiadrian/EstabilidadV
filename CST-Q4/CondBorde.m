% CondBorde: impone las condiciones de borde del problema
% Agrega al vector de fuerzas, aquellas provocadas por un desplazamiento
% prescripto distinto de cero
function [KGcon,FGcon,ifixe] = CondBorde(KGlob,FGlob,fixed)

global npoin nfixe ndofn

ifixe=zeros(ndofn*npoin,2); % Arma matriz con condiciones de borde
if ndofn==1
    npos=(fixed(:,1)-1)*ndofn+1;
    ifixe(npos,:)=fixed(:,[2 3]);
elseif ndofn==2
    %!! Bucle para armar matriz que contiene las restricciones del problema
    for i=1:nfixe
        npos=(fixed(i,1)-1)*ndofn+1;
        ifixe(npos,:)=fixed(i,[2 4]);
        ifixe(npos+1,:)=fixed(i,[3 5]);
    end %for(i)
end
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%!! Cond. de borde - Opcion alternativa
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% npos=(fixed(:,1)-1)*ndofn+1;
% ifixe(npos,:)=fixed(:,[2 4]);
% ifixe(npos+1,:)=fixed(:,[3 5]);

%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!        
%!! Matriz de RIGIDEZ CON CONDICIONES DE BORDE (KGcon) - Elimina filas y
%!! columnas
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%!! Crea matriz de rigidez que contiene solamente los valores para los gdl
%!! libres (impone las restricciones a KGlob)
nfix = find(ifixe(:,1)==0);
KGcon = KGlob(nfix,nfix);
fix = find(ifixe(:,1)==1);

%!! Determina fuerzas generadas por desplazamientos prescriptos distintos a
%!! cero Fuerza por desplazamientos prescriptos = KGlob(:,j)*ifixe(j,2)
for i=1:length(fix)
    j=fix(i);
    FGlob = FGlob - KGlob(:,j)*ifixe(j,2);
end %for(i)

%!! Crea el vector de fuerzas nodales que contiene solamente los valores 
%!! para los gdl restringidos (impone las restricciones a FGlob)
FGcon = FGlob(nfix);

