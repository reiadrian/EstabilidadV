%gauss_points: Permite obtener los puntos de Gauss y los pesos
%correpondientes para la integracion numerica
function [gausp,weigp] = gauss_points(ngauss)
if ngauss==1
    gausp(1)=0.0;
    weigp(1)=2.0;
elseif ngauss==2
    gausp(1)= -1/(sqrt(3)); %-0.577350269189626
    gausp(2)=  1/(sqrt(3)); %0.577350269189626
    weigp(1)=1.0;
    weigp(2)=1.0;
elseif ngauss==3
    gausp(1)= -sqrt(15)/5;
    gausp(2)=  0.0;
    gausp(3)=  sqrt(15)/5; 
    weigp(1)=  5/9;
    weigp(2)=  8/9;
    weigp(3)=  5/9;
end