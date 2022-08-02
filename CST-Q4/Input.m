% Input: Lee los ficheros de entrada y genera las variables de comando
function [conec,coord,fixed,loads,matpr,qdist,var_EP] = Input(problem)

global nelem nnodo npoin nload ndime ndofn nfixe numat nstre ngauss nqdist

prtip = load([problem '.dat']);  % Carga numero que identifica si el problema es de EPD/EPT y el tipo de elemento (P/el caso solo triangular)
conec = load([problem '-1' '.dat']);  % Carga la Matriz de conectividades y las almacena
coord = load([problem '-2' '.dat']) ;  % Carga las Coordenadas nodales y las almacena
fixed = load([problem '-3' '.dat']) ;  % Carga las Restricciones/Desplazamientos prescriptos y las almacena
loads = load([problem '-4' '.dat']) ;  % Carga las Cargas Nodales en coord globales y las almacena
matpr = load([problem '-5' '.dat']) ;  % Carga las Propiedades Materiales y las almacena
qdist  = load([problem '-6' '.dat']) ;  % Matriz carga uniforme distribuida que ingresa con datos en nodos
% Asignacion de variables
nelem = size(conec,1);    % Numero de elementos
nnodo = size(conec,2);    % Numero de nudos por elemento
ndime = size(coord,2);    % Dimension del problema (2D)
npoin = size(coord,1);    % Numero de nudos del problema
if prtip(1)==0||prtip(1)==1
    ndofn = ndime;            % Grados de libertad por nodo (OJO ACA!: no siempre coinciden. Para problemas de deform. en solidos) 
    nstre = 3;                % Numero de deformaciones y tensiones por elemento (3 p/CST)
elseif prtip(1)==2
    ndofn = 1; 
    nstre = 3;                % Numero de velocidades por elemento (3 p/CST)
end
nfixe = size(fixed,1);    % Numero de grados de libertad prescriptos
nload = size(loads,1);    % Numero de cargas externas

numat = size(matpr,1);    % Numero de materiales distintos
var_EP = prtip(1);        % Estable tipo de problema de Estado Plano
                          % var_EP = 0  p/EPT
                          % var_EP = 1  p/EPD
ngauss = 2;
nqdist = size(qdist,1);



