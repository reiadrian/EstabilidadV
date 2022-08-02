%  GID_result: genera el archivo de salida de Resultados para GiD 
%             (Desplazamientos,deformaciones y tensiones)
 function GID_result2(prob_name,uTotal,conec,coord,esfuerzos_n)
 
%**************************************************
%* RUTINA PARA GENERAR LOS ARCHIVOS DE RESULTADOS *
%* PARA SER POSTPROCESADOS CON GID                *
%* Archivo: NAME.flavia.res                       *
%**************************************************
global nelem nnodo npoin nload ndime ndofn nfixe numat nstre ngauss nqdist
% ndofn = e_VG.ndofn;  
% nnodo = e_VG.nnodo;
% ngauss = e_VG.ngauss;

fileCompleto = prob_name;
filename_res = [fileCompleto,'.flavia.res'];
fid_res = fopen(filename_res,'wt');
fprintf(fid_res,'GiD Post Results File 1.0 \n');

if nnodo==3 % Triangulo de tres nodos (CST)
    c_elem_type = 'Triangle';
NPG_ele = 1 ;
m_xgElem = [1/3 ; 1/3]; % 1; !!PARA PROBAR SI FUNCIONAR�A
elseif nnodo==4 % Cuadrilatero bilineal
    c_elem_type = 'Quadrilateral';
NPG_ele = 4 ;
m_xgElem = [-1/(sqrt(3)) -1/(sqrt(3)) ;
              1/(sqrt(3)) -1/(sqrt(3)) ;
             -1/(sqrt(3))  1/(sqrt(3)) ;
              1/(sqrt(3))  1/(sqrt(3))]; 
elseif nnodo==8 % Cuadrilatero bicuadratico
    if ngauss==1
        c_elem_type = 'Quadrilateral';
        NPG_ele = 1 ;
        m_xgElem = [0 ; 0]; 
    elseif ngauss ==2
        c_elem_type = 'Quadrilateral';
        NPG_ele = 4 ;
        m_xgElem = [-1/(sqrt(3)) -1/(sqrt(3)) ;
            1/(sqrt(3)) -1/(sqrt(3)) ;
            -1/(sqrt(3))  1/(sqrt(3)) ;
            1/(sqrt(3))  1/(sqrt(3))]; 
    elseif ngauss == 3
        c_elem_type = 'Quadrilateral';
        NPG_ele = 9 ;
        m_xgElem = [-0.774596669241483 -0.774596669241483 ;
                     0.000000000000000 -0.774596669241483 ;
                     0.774596669241483 -0.774596669241483 ;
                    -0.774596669241483  0.000000000000000 ;
                     0.000000000000000  0.000000000000000 ;
                     0.774596669241483  0.000000000000000 ;
                    -0.774596669241483  0.774596669241483 ;
                     0.000000000000000  0.774596669241483 ;
                     0.774596669241483  0.774596669241483];
    end

end

iSet=1; % NECESARIO PARA IMPONER UN LOAD ANALYSIS EN GiD
fprintf(fid_res,['# Datos de puntos de gauss del Set_',num2str(iSet),'\n']);

% Definici�n de punto de Gauss
fprintf(fid_res,['GaussPoints "GP_Set_',num2str(iSet),'" Elemtype ',...
         c_elem_type,' "Set_',num2str(iSet),'"\n']);

fprintf(fid_res,['Number of Gauss Points: ',num2str(NPG_ele),'\n']);
fprintf(fid_res,'Nodes not included\n');
%Se utiliza Given en lugar de Internal porque es m�s general para distintos puntos de gauss
%que se defina, aunque igualmente la cantidad de puntos tiene que ser compatible con lo que
%permite el GiD para cada elemento y el sistema de coordenadas usada en el mismo.
fprintf(fid_res,'Natural Coordinates: Given\n');
fprintf(fid_res,'%f %f\n',m_xgElem');
fprintf(fid_res,'End GaussPoints\n');

% Recupera variables
in = (1:size(coord,1))'; % Lista de numero de nodos
m_NumElem = (1:size(conec,1)); % Lista de numero de elementos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Resultados en los nodos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESPLAZMIENTOS
iStep = 1;
% des=zeros(size(uTotal));
% des(3:ndofn:end)=uTotal(1:ndofn:end);
uTotal = reshape(uTotal,ndofn,[]);
fprintf(fid_res,'Result "Displacements" "Load Analysis" %d Vector OnNodes\n',iStep); %!!!!VER
fprintf(fid_res,'ComponentNames "X-DISPL" "Y-DISPL" "Z-DISPL"\n'); %!!!!CAMBIAR NOMBRE
fprintf(fid_res,'Values\n');
format = ['%d',repmat(' %.15g',1,ndofn),'\n'];
fprintf(fid_res,format,[in';uTotal]);
fprintf(fid_res,'End Values\n');
% TENSIONES EN NODOS
%
moment = esfuerzos_n(:,1:3);
iStep = 1;
fprintf(fid_res,'Result "Stress" "Load Analysis" %d Vector OnNodes\n',iStep);
fprintf(fid_res,'ComponentNames "SigmaXX" "SigmaYY" "SigmaXY"\n');
fprintf(fid_res,'Values\n');
format = ['%d',repmat(' %.15g',1,nstre),'\n'];
fprintf(fid_res,format,[in';moment']);
fprintf(fid_res,'End Values\n');
%TENSIONES PRINCIPALES EN NODOS
corte1 = esfuerzos_n(:,4:5);
corte = [corte1 zeros(size(in))];
iStep = 1;
fprintf(fid_res,'Result "Shear" "Load Analysis" %d Vector OnNodes\n',iStep);
fprintf(fid_res,'ComponentNames "Sigma1" "Sigma2" "Zeros"\n');
fprintf(fid_res,'Values\n');
format = ['%d',repmat(' %.15g',1,nstre),'\n'];
fprintf(fid_res,format,[in';corte']);
fprintf(fid_res,'End Values\n');

fclose(fid_res);

