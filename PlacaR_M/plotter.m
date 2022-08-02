% plotter: Gráfica la estrucutura del problema con la malla utilizada (en
% condición indeformada y deformada)
function plotter(coord,conec,format)

global nelem nnodo

k=1;
for ielem=1:nelem          % Bucle en los elementos
  for inod=1:nnodo          % Bucle en los nodos de cada elemento
    xini(ielem)=coord(conec(ielem,k),1); % Coord x del nodo k(local) de ielem
    yini(ielem)=coord(conec(ielem,k),2) ; % Coord y del nodo k(local) de ielem
    k=k+1; 
    if k>nnodo
      k=1;
    end %if(k)
    xfin(ielem)=coord(conec(ielem,k),1);
    yfin(ielem)=coord(conec(ielem,k),2);
    plot([xini;xfin],[yini;yfin],format)% Traza línea azul de nodo inicial a final
    hold on  % Establece la propiedad para el siguiente ploteo de los ejes 
             % actuales en condicion "agregar".
  end %for(inod)
end %for(ielem)