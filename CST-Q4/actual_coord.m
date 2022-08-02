% actual_coord: determina las coordenadas posterior a la deformación
function corda=actual_coord(coord,despl)

global npoin

corda=zeros(npoin,2); % Crea vector de coordenas actuales

k=0;

for i=1:npoin
  x1(i)=coord(i,1);
  y1(i)=coord(i,2);
  k=k+1;
  x2(i)=x1(i) + despl(k);
  k=k+1;
  y2(i)=y1(i) + despl(k);
  
end %for(i)

[corda]=[x2' y2'];
return 


