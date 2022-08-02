% Elas_Strain2: calculo de las deformaciones y tensiones
function [StraiG,StresG] = Elas_Strain2(despG,conec,coord,matpr,var_EP) 

global nelem ndofn nnodo ngauss

if ndofn==1
        StraiG = [] ; StresG = [];
for ielem=1:nelem    
%!! Crea un vector con las conectividades del elemento actual    
    nodos=[conec(ielem,1) conec(ielem,2) conec(ielem,3)];
    desp=despG(nodos);
%!! Calculo de la matriz de las derivadas de las funciones de forma
    [B,area] = Bmat(nodos,coord);    
    dphi=B*desp;
    %!! Calculo de la matriz constitutiva del problema 
    D = MatrizD(matpr,ielem,var_EP); 
    q=-D*dphi;
    StraiG = [StraiG ; dphi'] ;
    StresG = [StresG ; q'] ;
end %for(ielem)    
elseif ndofn==2
if nnodo==3
    StraiG = [] ; StresG = [];
for ielem=1:nelem
    
%!! Crea un vector con las conectividades del elemento actual    
    nodos=[conec(ielem,1) conec(ielem,2) conec(ielem,3)];
    
%!! Calculo de la matriz de las derivadas de las funciones de forma
    [B,area] = Bmat(nodos,coord);
    
%!! Deformaciones
% Strain = B * desp
%     Strain(1)= 1/2A*(b1*u1+b2*u2+b3*u3)
    Strain(1)=despG(ndofn*nodos(1)-1)*B(1,1)+despG(ndofn*nodos(2)-1)*B(1,3)+despG(ndofn*nodos(3)-1)*B(1,5);
%     Strain(2)= 1/2A*(c1*v1+c2*v2+c3*v3)
    Strain(2)=despG(ndofn*nodos(1))*B(2,2)+despG(ndofn*nodos(2))*B(2,4)+despG(ndofn*nodos(3))*B(2,6);
%     Strain(3)= 1/2A*[(c1*u1+c2*v2+c3*v3)+(b1*v1+b2*v2+b3*v3)]
    Strain(3)=despG(ndofn*nodos(1)-1)*B(2,2)+despG(ndofn*nodos(2)-1)*B(2,4)+despG(ndofn*nodos(3)-1)*B(2,6)...
        +despG(ndofn*nodos(1))*B(1,1)+despG(ndofn*nodos(2))*B(1,3)+despG(ndofn*nodos(3))*B(1,5);
    
%!! Calculo de la matriz constitutiva del problema 
    D = MatrizD(matpr,ielem,var_EP);  

%!! Tensiones
    Stress = (D*Strain')' ; 

%!! Arma el vector de deformaciones y tensiones
    StraiG = [StraiG ; Strain] ;
    StresG = [StresG ; Stress] ;
    
end %for(ielem)

elseif nnodo==4
    dofelem1 = reshape(f_DofElem(reshape(conec',1,[]),ndofn),nnodo*ndofn,[]);
    dofelem = dofelem1(:);
    uElemT  = reshape(despG(dofelem),[],nelem);
    strain = zeros(3,ngauss);
    stress = zeros(3,ngauss);
    StraiG = zeros(ngauss*ngauss*3,nelem);
    StresG= zeros(ngauss*ngauss*3,nelem);
    
for ielem=1:nelem
%!! C�lculo de la matriz constitutiva del elemento   
D = MatrizD(matpr,ielem,var_EP); % Llama a la funcion donde obtiene la matriz de rigidez del elemento  
uElem = uElemT(:,ielem);
coord_el = coord(conec(ielem,1:1:nnodo),:);
ipg = 0;
[gausp,weigp] = gauss_points;
for igaus=1:ngauss
    psi=gausp(igaus);
    for jgaus=1:ngauss
        ipg = ipg + 1; 
        eta=gausp(jgaus);
        [funfor,derivFF] = Fforma_DFf(psi,eta);
        [detJB,MatrB] = MatB_Cuad(coord_el',derivFF');
        strain(:,ipg) = MatrB*uElem;
        stress(:,ipg)= D*strain(:,ipg);        
    end
end
        StraiG(:,ielem) = strain(:);
        StresG(:,ielem) = stress(:);
end

elseif nnodo==8
    dofelem1 = reshape(f_DofElem(reshape(conec',1,[]),ndofn),nnodo*ndofn,[]);
    dofelem = dofelem1(:);
    uElemT  = reshape(despG(dofelem),[],nelem);
    strain = zeros(3,ngauss);
    stress = zeros(3,ngauss);
    StraiG = zeros(ngauss*ngauss*3,nelem);
    StresG= zeros(ngauss*ngauss*3,nelem);
    
for ielem=1:nelem
%!! Calculo de la matriz constitutiva del elemento   
D = MatrizD(matpr,ielem,var_EP); % Llama a la funcion donde obtiene la matriz de rigidez del elemento  
uElem = uElemT(:,ielem);
coord_el = coord(conec(ielem,1:1:nnodo),:);
ipg = 0;
[gausp,weigp] = gauss_points;
for igaus=1:ngauss
    psi=gausp(igaus);
    for jgaus=1:ngauss
        ipg = ipg + 1; 
        eta=gausp(jgaus);
        [funfor,derivFF] = Fforma_DFf(psi,eta);
        [detJB,MatrB] = MatB_Cuad(coord_el',derivFF');
        strain(:,ipg) = MatrB*uElem;
        stress(:,ipg)= D*strain(:,ipg);        
    end
end
        StraiG(:,ielem) = strain(:);
        StresG(:,ielem) = stress(:);
end

end
end


function m_GdLNod = f_DofElem(m_ListNod,nGdLNod)
   %Devuelve un vector que contiene todos los grados de libertad de cada nodo ordenados en forma
   %contigua.
   m_GdLNod = reshape(bsxfun(@plus,nGdLNod*m_ListNod,(-nGdLNod+1:0)'),[],1);
    




