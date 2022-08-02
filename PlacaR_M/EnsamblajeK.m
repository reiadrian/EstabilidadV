% EnsamblajeK: calcula la matriz de rigidez global
function KGlob = EnsamblajeK(e_DatMat,e_DatElem,e_DatCB,e_VG)

nelem =e_VG.nelem;
nnodo = e_VG.nnodo;
npoin = e_VG.npoin;
ndofn = e_VG.ndofn;

conec = e_DatElem.elem;
coord = e_DatElem.coord;

% Inicializa la matriz de rigidez global
KGlob= zeros(ndofn*npoin,ndofn*npoin); 
%!! Calculo de la matriz constitutiva del elemento   
[Df,Dc] = MatrizD(e_DatMat,e_DatElem); % Llama a la funcion donde obtiene la matriz constitutiva del elemento
 
for ielem=1:nelem  % Bucle en elemento
    %!! Calculo de la matriz de rigidez de cada ELEMENTO. P/Cuadrilatero
    %bilineal
    kelem = rigidez_elem4(ielem,conec,coord,Df,Dc,e_VG);
 
 for inodo=1:nnodo % Bucle en nodos
  nodoi=conec(ielem,inodo); % Deternima el nodo del elemento considerado
  for igl=1:ndofn % Bucle en gdl
   filag=(nodoi-1)*ndofn+igl; % Determina la fila GLOBAL de KGlob donde se INTRODUCIRA el valor TOMADO de Kelem
   filae=(inodo-1)*ndofn+igl; % Determina la fila del ELEMENTO/LOCAL donde se TOMARA el valor de Kelem a INTRODUCIRSE EN KGlob
   for jnodo=1:nnodo
    nodoj=conec(ielem,jnodo);
    for jgl=1:ndofn
     colug=(nodoj-1)*ndofn+jgl; % Determina la columna de KGlob GLOBAL donde se INTRODUCIRA el valor TOMADO de Kelem
     colue=(jnodo-1)*ndofn+jgl; % Determina la columna del ELEMENTO/LOCAL donde se TOMARA el valor de Kelem a INTRODUCIRSE EN KGlob
%!! Ensambla la matriz de rigidez global (Agrega el valor de la matriz
%!! local en la global ensamblada)
     KGlob(filag,colug)=KGlob(filag,colug)+kelem(filae,colue);     
    end %for(jgl)                                                
   end %for(jnodo) 
  end %for(igl) 
 end %for(inodo) 
end %for(ielem) 

% % % 
% % % % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% % % % !! Apoyo elastico
% % % % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% % % %Adiciona el valor de la constante de rigidez elastica del apoyo el�stico
% % % %a KGlob (en la diagonal principal)
% % %   for imola=1:nmola
% % %     km=mola(imola,1); kpos1=km*ndofn-1; kpos2=km*ndofn; 
% % % %     if forcex<0.0;
% % %     kx=mola(imola,2);
% % %     KGlob(kpos1,kpos1)=KGlob(kpos1,kpos1)+kx;
% % %     %     if forcey<0.0;
% % %     ky=mola(imola,3);
% % %     KGlob(kpos2,kpos2)= KGlob(kpos2,kpos2)+ky;
% % %   end


