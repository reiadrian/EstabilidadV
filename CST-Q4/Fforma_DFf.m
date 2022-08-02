%Fforma_DFf: calucla las Nciones de forma y las derivadas de las mismas
function [N,deriv] = Fforma_DFf(xi,eta)
global nnodo

if nnodo==4
    N(1) = 1/4*(1-xi).*(1-eta);
    N(2) = 1/4*(1+xi).*(1-eta);
    N(3) = 1/4*(1+xi).*(1+eta);
    N(4) = 1/4*(1-xi).*(1+eta);   
    
    
    deriv(1,:)  = [(1/4*eta-1/4)  (-1/4*eta+1/4)  (1/4*eta+1/4)  (-1/4*eta-1/4)];
    deriv(2,:) = [(1/4*xi-1/4)  (-1/4*xi-1/4)  (1/4*xi+1/4)  (-1/4*xi+1/4)];
    
elseif nnodo==8
    etam=(1.-eta);
    etap=(1.+eta);
    xim=(1.-xi);    
    xip=(1.+xi);
%
%
    N(1) = -0.25*xim*etam*(1.+ xi + eta);
    N(2) = 0.5*(1.- xi^2)*etam;
    N(3) = -0.25*xip*etam*(1. - xi + eta);
    N(4) = 0.5*xip*(1. - eta^2);
    N(5) = -0.25*xip*etap*(1. - xi - eta);
    N(6) = 0.5*(1. - xi^2)*etap;
    N(7) = -0.25*xim*etap*(1. + xi - eta);
    N(8) = 0.5*xim*(1. - eta^2);
    %
    deriv(1,1)=0.25*etam*(2.*xi + eta); deriv(1,2)=-1.*etam*xi;
    deriv(1,3)=0.25*etam*(2.*xi-eta); deriv(1,4)=0.5*(1-eta^2);
    deriv(1,5)=0.25*etap*(2.*xi+eta); deriv(1,6)=-1.*etap*xi;
    deriv(1,7)=0.25*etap*(2.*xi-eta); deriv(1,8)=-0.5*(1.-eta^2);   
    %
    deriv(2,1)=0.25*xim*(2.*eta+xi); deriv(2,2)=-0.5*(1. - xi^2);
    deriv(2,3)=-0.25*xip*(xi-2.*eta); deriv(2,4)=-1.*xip*eta;
    deriv(2,5)=0.25*xip*(xi+2.*eta); deriv(2,6)=0.5*(1.-xi^2);
    deriv(2,7)=-0.25*xim*(xi-2.*eta); deriv(2,8)=-1.*xim*eta;
end
