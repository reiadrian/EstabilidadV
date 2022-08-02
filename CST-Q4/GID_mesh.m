% GID_mesh: genera el archivo de salida de la "Geometría" para GiD 
%           (Desplazamientos,deformaciones y tensiones)
% function GID_mesh(prob_name,e_Matrix,e_Var)
function GID_mesh(prob_name,coord,conec)
%  Generacion archivos de post-proceso con GID 
global ndime nelem nnodo

fileCompleto = prob_name;

if nnodo==3 % Triangulo de tres nodos (CST)
c_elem_type = 'Triangle';
elseif nnodo==4 % Cuadrilatero bilineal
c_elem_type = 'Quadrilateral';
elseif nnodo==8 % Cuadrilatero bicuadratico
c_elem_type = 'Quadrilateral';
end
[~,filename] = fileparts(fileCompleto);
filename_write = [fileCompleto,'.flavia.msh'];
fid = fopen(filename_write,'wt');

% 1.- Encabezado con 6 lineas libres
fprintf(fid,'# ================================================== \n');
fprintf(fid,'# \n');
fprintf(fid,'# PostProceso GiD - Archivo de malla \n');
fprintf(fid,['# Nombre de archivo: ',filename,' \n']);
fprintf(fid,'# ================================================== \n');

% Recupera variables
in = (1:size(coord,1))'; % Lista de numero de nodos
m_NumElem = (1:size(conec,1)); % Lista de numero de elementos
iSet=1;
fprintf(fid,['MESH "Set_',num2str(iSet),'" dimension ',num2str(ndime),' Elemtype ',...
  c_elem_type,' Nnode ',num2str(nnodo),'\n']);

% 2.- Coordenadas
fprintf(fid,'Coordinates \n');
fprintf(fid,'# Número_de_nodo Coordenada_x Coordenada_y Coordenada_z \n');
format = ['%d',repmat(' %.15g',1,ndime),'\n'];
fprintf(fid,format,[in,coord(:,1:ndime)]');
fprintf(fid,'end coordinates \n');

% 3.- Elementos
fprintf(fid,'Elements \n');

format = '';
for iNpe = 1:nnodo
    format = [format,'Nodo_',num2str(iNpe),' '];  %#ok<AGROW>
end
format = ['# Nro_Elemento ',format,' Nro_Set \n'];  % %#ok<AGROW>
fprintf(fid,format);

format = ['%d',repmat(' %d',1,nnodo),' %d\n'];
%La enumeración de los nodos que viene en la conectividad es la local dentro del programa (según el
%orden en que fue indicado el nodo en la matriz de coordenadas), por lo que se cambia para la numeración
%de los nodos indicado por el usuario.
conec(conec~=0) = in(conec(conec~=0));
%       fprintf(fid,format,[e_DatSet(iSet).m_NumElem',m_Conec,repmat(iSet,nElemSet,1)]');
fprintf(fid,format,[m_NumElem',conec,ones(nelem,1)]');
% fprintf(fid,format,[m_NumElem',m_Conec]');
fprintf(fid,'end elements \n');

fclose(fid);
