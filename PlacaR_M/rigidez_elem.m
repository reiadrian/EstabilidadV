% rigidez_elem: Calcula la matriz de rigidez de cada elemento CST
function kelem = rigidez_elem(ielem,conec,coord,D,t)

%!! Crea un vector con las conectividades del elemento actual
nodos=[conec(ielem,1) conec(ielem,2) conec(ielem,3)];

%!! Calculo de la matriz de las derivadas de las funciones de forma
[B,area] = Bmat(nodos,coord);

%!! Calcula la matriz de rigidez local
kelem=area*B'*D*B*t;

return