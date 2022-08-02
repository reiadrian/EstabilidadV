% MatrizD: Calculo de la matriz constitutiva del elemento
function [Df,Dc] = MatrizD(e_DatMat,e_DatElem)
E=e_DatMat.young; %Modulo de Young
nu=e_DatMat.poiss; %Coeficiente de Poisson
h = e_DatElem.espesor; %Espeso

Df=((E*h^3))/(12*(1-nu^2))*[1 nu 0;...
                           nu  1 0;...
                           0 0 (1-nu)/2];
    
kappa=1;%5/6;
Dc=(E*h*kappa/(2*(1+nu)))*[1 0;...
                           0 1];

