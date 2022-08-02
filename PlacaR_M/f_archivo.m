% Input: Lee los ficheros de entrada y genera las variables de comando
% function [conec,coord,fixed,loads,matpr,mola,var_EP] = Input(problem)
function [e_DatMat,e_DatElem,e_DatCB,e_VG] = f_archivo
Placa3

%!! Asignacion de variables
nelem = size(elem,1);    % Numero de elementos
nnodo = size(elem,2);    % Numero de nudos por elemento
ndime = size(coord,2);   % Dimension del problema (2D)
npoin = size(coord,1);   % Numero de nudos del problema
ndofn = 3;                % Grados de libertad por nodo (OJO ACA!: no siempre coinciden. Para problemas de deform. en solidos) 
nstre_f = 3;                % Numero de deformaciones y tensiones por flexion para cada elemento
nstre_c = 2;                % Numero de deformaciones y tensiones por corte para cada elemento
nfixe = size(nod_rest,1);    % Numero de grados de libertad prescriptos
nload_p = size(carg_punt,1);    % Numero de cargas externas
nload_d = size(carg_dist,1);    % Numero de cargas externas
ngauss_c = 2;
ngauss_f = 3;
ngauss = 1; %Guardo valor de numero de punto de Gauss para impresion de resultados
            %(1 solo punto por elemento)

conec = zeros(size(elem));
conec(:,1:4) = elem(:,1:2:end);
conec(:,5:8) = elem(:,2:2:end);

e_DatMat = struct('young',young,'poiss',poiss,'denss',denss);
e_DatElem = struct('coord',coord,'elem',conec,'espesor',espesor);
e_DatCB = struct('nod_rest',nod_rest,'carg_punt',carg_punt,'carg_dist',carg_dist);
e_VG = struct('nelem',nelem,'nnodo',nnodo,'ndime',ndime,'npoin',npoin,'ndofn',ndofn,'nstre_f',nstre_f,...
    'nstre_c',nstre_c,'nfixe',nfixe,'nload_p',nload_p,'nload_d',nload_d,'ngauss_c',ngauss_c,'ngauss_f',ngauss_f,...
    'ngauss',ngauss);
% conec = load([problem '.dat'])      ;  % Carga la Matriz de conectividades y las almacena
% prtip = load([problem '-1' '.dat']) ;  % Carga numero que identifica si el problema es de EPD/EPT y el tipo de elemento (P/el caso solo triangular)
% coord = load([problem '-2' '.dat']) ;  % Carga las Coordenadas nodales y las almacena
% fixed = load([problem '-3' '.dat']) ;  % Carga las Restricciones/Desplazamientos prescriptos y las almacena
% loads = load([problem '-4' '.dat']) ;  % Carga las Cargas Nodales en coord globales y las almacena
% matpr = load([problem '-5' '.dat']) ;  % Carga las Propiedades Materiales y las almacena
% mola  = load([problem '-6' '.dat']) ;  % Matriz de apoyos elasticos 



