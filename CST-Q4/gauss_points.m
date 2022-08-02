%gauss_points: Permite obtener los puntos de Gauss y los pesos
%correpondientes para la integracion numerica
function [gausp,weigp] = gauss_points
global ngauss
if ngauss==1
    gausp(1)=0.0;
    weigp(1)=2.0;
elseif ngauss==2
    gausp(1)= -1/(sqrt(3)); %-0.577350269189626
    gausp(2)=  1/(sqrt(3)); %0.577350269189626
    weigp(1)=1.0;
    weigp(2)=1.0;
elseif ngauss==3
    gausp(1)= -0.774596669241483;
    gausp(2)=  0.0;
    gausp(3)=  0.774596669241483; 
    weigp(1)=  0.555555555555555;
    weigp(2)=  0.888888888888888;
    weigp(3)=  0.555555555555555;
end
end