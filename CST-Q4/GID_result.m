%  GID_result: genera el archivo de salida de Resultados para GiD 
%             (Desplazamientos,deformaciones y tensiones)
 function GID_result(prob_name,uTotal,conec,coord,StraiG,StresG)
 
%**************************************************
%* RUTINA PARA GENERAR LOS ARCHIVOS DE RESULTADOS *
%* PARA SER POSTPROCESADOS CON GID                *
%* Archivo: NAME.flavia.res                       *
%**************************************************

global ndofn nstre nnodo ngauss

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
    if ngauss ==2
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
if ndofn==1
    iStep = 1;
    fprintf(fid_res,'Result "Potencial" "Load Analysis" %d Scalar OnNodes\n',iStep);
    %         fprintf(fid_res,'Result "Potencial" Scalar OnNodes\n');
    fprintf(fid_res,'ComponentNames "PHI"\n');
    fprintf(fid_res,'Values\n');
    format = ['%d',repmat(' %.15g',1,ndofn),'\n'];
    fprintf(fid_res,format,[in';reshape(uTotal,ndofn,[])]);   %[in,u(1:ndime:end),u(2:ndime:end)]'
    fprintf(fid_res,'End Values\n');
    % VELOCIDAD (FLUJO)
    nomGaussSet = ['GP_Set_',num2str(iSet)];
    tipoDatAlmac = 'Vector';
    nomComponente = '"QX" "QY" "QZ"';
    fprintf(fid_res,['Result "Vector//On Gauss Points" "Load Analysis" %d %s ',...
        'OnGaussPoints "',nomGaussSet,'"\n'],iStep,tipoDatAlmac);
    fprintf(fid_res,'ComponentNames %s\n',nomComponente);
    fprintf(fid_res,'Values\n');
    format = ['%d',repmat([repmat(' %.15g',1,nstre),'\n'],1,NPG_ele)];
    if nnodo==3
        add=zeros(size(StresG,1),1);
        StresG=[StresG add];
        fprintf(fid_res,format,[m_NumElem;StresG']);
    elseif nnodo==4 || nnodo==8
        fprintf(fid_res,format,[m_NumElem;StresG]);
    end
    fprintf(fid_res,'End Values\n');
elseif ndofn==2
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % DESPLAZMIENTOS
    uTotal = reshape(uTotal,ndofn,[]);
    iStep = 1;
    fprintf(fid_res,'Result "Displacements" "Load Analysis" %d Vector OnNodes\n',iStep);
    fprintf(fid_res,'ComponentNames "X-DISPL" "Y-DISPL"\n');
    fprintf(fid_res,'Values\n');
    format = ['%d',repmat(' %.15g',1,ndofn),'\n'];
    fprintf(fid_res,format,[in';uTotal]);
    fprintf(fid_res,'End Values\n');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %!! TENSIONES Y DEFORMACIONES
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % TENSIONES (EPD/EPT)
    nomGaussSet = ['GP_Set_',num2str(iSet)];
    tipoDatAlmac = 'PlainDeformationMatrix';
    nomComponente = '"Stress XX" "Stress YY" "Stress XY" "Stress ZZ"';
    fprintf(fid_res,['Result "Stresses//On Gauss Points" "Load Analysis" %d %s ',...
        'OnGaussPoints "',nomGaussSet,'"\n'],iStep,tipoDatAlmac);
    fprintf(fid_res,'ComponentNames %s\n',nomComponente);
    fprintf(fid_res,'Values\n');
    format = ['%d',repmat([repmat(' %.15g',1,nstre),'\n'],1,NPG_ele)];
    if nnodo==3
        fprintf(fid_res,format,[m_NumElem;StresG']);
    elseif nnodo==4 || nnodo==8
        fprintf(fid_res,format,[m_NumElem;StresG]);
    end
    fprintf(fid_res,'End Values\n');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % DEFORMACIONES
    tipoDatAlmac = 'PlainDeformationMatrix';
    nomComponente = '"Strain XX" "Strain YY" "Strain XY" "Strain ZZ"';
    fprintf(fid_res,['Result "Strain//On Gauss Points" ',...
        '"Load Analysis" %d %s OnGaussPoints "',nomGaussSet,'"\n'],iStep,tipoDatAlmac);
    fprintf(fid_res,'ComponentNames %s\n',nomComponente);
    fprintf(fid_res,'Values\n');
    format = ['%d',repmat([repmat(' %.15g',1,nstre),'\n'],1,NPG_ele)];
    if nnodo==3
        fprintf(fid_res,format,[m_NumElem;StraiG']);
    elseif nnodo==4 || nnodo==8
        fprintf(fid_res,format,[m_NumElem;StraiG]);
    end
    fprintf(fid_res,'End Values\n');
end
fclose(fid_res);

