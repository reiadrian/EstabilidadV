function [deform_n,deform_el,esfuerzos_n,esfuerzos_el] = f_esfuerzos(e_DatMat,e_DatElem,e_DatCB,e_VG,despG)

nelem =e_VG.nelem;
nnodo = e_VG.nnodo;
ndime = e_VG.ndime;
npoin = e_VG.npoin;
ndofn = e_VG.ndofn;
nstre_c = e_VG.nstre_c; 
nstre_f = e_VG.nstre_f; 

conec = e_DatElem.elem;
coord = e_DatElem.coord;
%!! Calculo de la matriz constitutiva del elemento   
[Df,Dc] = MatrizD(e_DatMat,e_DatElem); % Llama a la funcion donde obtiene la matriz constitutiva del elemento
ngauss = e_VG.ngauss ;
[gausp,weigp] = gauss_points(ngauss); 
gdl_nodos = reshape(f_DofElem(reshape(conec',1,[]),ndofn),nnodo*ndofn,[]);
desp_nelem = (reshape(despG(gdl_nodos),[],nelem));
for ielem=1:nelem  % Bucle en elemento
    coord_el = coord(conec(ielem,1:1:nnodo),:);    
    desp_ielem = desp_nelem(:,ielem);
    for igaus=1:ngauss % Bucle en dieccion xi o psi
        xi=gausp(igaus);
        for jgaus=1:ngauss % Bucle en dieccion eta
            eta=gausp(jgaus);
            [funfor,derivFF] = Fforma_DFf(xi,eta,nnodo);
            [detJB_f,MatrB_f] = MatB_Cuad(coord_el',derivFF',funfor,nnodo,ndofn,nstre_f);
            [detJB_c,MatrB_c] = MatB_Cuad(coord_el',derivFF',funfor,nnodo,ndofn,nstre_c);   
            def_f = MatrB_f*desp_ielem;
            momento = Df*def_f;
            def_c = MatrB_c*desp_ielem;
            corte = Dc*def_c;
        end
    end
    deform_el(ielem,:) = [def_f ; def_c];  
    esfuerzos_el(ielem,:) = [momento ; corte]; 
end
% % for ielem=1:nelem  % Bucle en elemento
% %     coord_el = coord(conec(ielem,1:1:nnodo),:);    
% %     desp_ielem = desp_nelem(:,ielem);
% %     desp_ielem2 = zeros(24,1);
% %     desp_ielem2(1:3:end) = desp_ielem(1:3:end);
% %     desp_ielem2(2:3:end) = desp_ielem(3:3:end);
% %     desp_ielem2(3:3:end) = desp_ielem(2:3:end);
% %     for igaus=1:ngauss % Bucle en dieccion xi o psi
% %         xi=gausp(igaus);
% %         for jgaus=1:ngauss % Bucle en dieccion eta
% %             eta=gausp(jgaus);
% %             [funfor,derivFF] = Fforma_DFf(xi,eta,nnodo);
% %             [detJB_f,MatrB_f] = MatB_Cuad(coord_el',derivFF',funfor,nnodo,ndofn,nstre_f);
% %             def_f = MatrB_f*desp_ielem2;
% %             momento = Df*def_f;
% %         end
% %     end
% %     for igaus=1:ngauss % Bucle en dieccion xi o psi
% %         xi=gausp(igaus);
% %         for jgaus=1:ngauss % Bucle en dieccion eta
% %             eta=gausp(jgaus);
% %             [funfor,derivFF] = Fforma_DFf(xi,eta,4);
% %             [detJB_c,MatrB_c] = MatB_Cuad(coord_el(1:4,:)',derivFF',funfor,4,ndofn,nstre_c);
% %             def_c = MatrB_c*desp_ielem2(1:12);
% %             corte = Dc*def_c;
% %         end
% %     end
% %     deform_el(ielem,:) = [def_f ; def_c];  
% %     esfuerzos_el(ielem,:) = [momento ; corte]; 
% % end
[deform_n,esfuerzos_n] = f_fuerza_a_nudo(deform_el,esfuerzos_el,e_VG,conec);

end
function m_GdLNod = f_DofElem(m_ListNod,nGdLNod)

   %m_ListNod es un vector fila conteniendo los nodos de los cuáles se quiere obtener los grados de
   %libertad.
   %Devuelve un vector que contiene todos los grados de libertad de cada nodo ordenados en forma
   %contigua.
   m_GdLNod = reshape(bsxfun(@plus,nGdLNod*m_ListNod,(-nGdLNod+1:0)'),[],1);
    
end
function[deform,esfuerzos]=f_fuerza_a_nudo(deform_el,esfuerzos_el,e_VG,conec)
%
% This function averages the stresses at the nodes
%
nelem =e_VG.nelem;
nnodo = e_VG.nnodo;
% ndime = e_VG.ndime;
npoin = e_VG.npoin;
% ndofn = e_VG.ndofn;
%
for k = 1:npoin
    mx = 0.0;
    my = 0.0;
    mxy = 0.0;
    qx = 0.0;
    qy = 0.0;
    
    epsx = 0.0;
    epsy = 0.0;
    epsxy = 0.0;
    gammax = 0.0;
    gammay = 0.0;
    ne = 0;
    for iel = 1:nelem
        for jel=1:nnodo
            if conec(iel,jel) == k
                ne=ne+1;
                mx = mx + esfuerzos_el(iel,1);
                my = my + esfuerzos_el(iel,2);
                mxy = mxy + esfuerzos_el(iel,3);
                qx = qx + esfuerzos_el(iel,4);
                qy = qy + esfuerzos_el(iel,5);
                
                epsx = epsx + deform_el(iel,1);
                epsy = epsy + deform_el(iel,2);
                epsxy = epsxy + deform_el(iel,3);
                gammax = gammax + deform_el(iel,4);
                gammay = gammay + deform_el(iel,5);
            end
        end
    end
    MX(k,1) = mx/ne;
    MY(k,1) = my/ne;
    MXY(k,1) = mxy/ne;
    QX(k,1) = qx/ne;
    QY(k,1) = qy/ne;
    
    EPSX(k,1) = epsx/ne;
    EPSY(k,1) = epsy/ne;
    EPSXY(k,1) = epsxy/ne;
    GAMMAX(k,1) = gammax/ne;
    GAMMAY(k,1) = gammay/ne;
end
deform = [EPSX EPSY EPSXY GAMMAX GAMMAY];
esfuerzos =[MX MY MXY QX QY];
end
