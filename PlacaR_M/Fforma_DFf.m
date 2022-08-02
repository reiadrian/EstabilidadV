%Fforma_DFf: calucla las funciones de forma y las derivadas de las mismas
function [N,deriv] = Fforma_DFf(xi,eta,nnodo)


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
    fun(1) = -0.25*xim*etam*(1.+ xi + eta);
    fun(2) = 0.5*(1.- xi^2)*etam;
    fun(3) = -0.25*xip*etam*(1. - xi + eta);
    fun(4) = 0.5*xip*(1. - eta^2);
    fun(5) = -0.25*xip*etap*(1. - xi - eta);
    fun(6) = 0.5*(1. - xi^2)*etap;
    fun(7) = -0.25*xim*etap*(1. + xi - eta);
    fun(8) = 0.5*xim*(1. - eta^2);
    %
    der(1,1)=0.25*etam*(2.*xi + eta); der(1,2)=-1.*etam*xi;
    der(1,3)=0.25*etam*(2.*xi-eta); der(1,4)=0.5*(1-eta^2);
    der(1,5)=0.25*etap*(2.*xi+eta); der(1,6)=-1.*etap*xi;
    der(1,7)=0.25*etap*(2.*xi-eta); der(1,8)=-0.5*(1.-eta^2);   
    %
    der(2,1)=0.25*xim*(2.*eta+xi); der(2,2)=-0.5*(1. - xi^2);
    der(2,3)=-0.25*xip*(xi-2.*eta); der(2,4)=-1.*xip*eta;
    der(2,5)=0.25*xip*(xi+2.*eta); der(2,6)=0.5*(1.-xi^2);
    der(2,7)=-0.25*xim*(xi-2.*eta); der(2,8)=-1.*xim*eta;
       
%     N(1) = 1/4*(1-xi).*(1-eta).*(-xi-eta-1);
%     N(2) = 1/4*(1+xi).*(1-eta).*(xi-eta-1) ;
%     N(3) = 1/4*(1+xi).*(1+eta).*(xi+eta-1) ;
%     N(4) = 1/4*(1-xi).*(1+eta).*(-xi+eta-1);    
%     N(5) = 1/2*(1-xi.^2).*(1-eta)       ;
%     N(6) = 1/2*(1+xi).*(1-eta.^2)       ;
%     N(7) = 1/2*(1-xi.^2).*(1+eta)       ;
%     N(8) = 1/4*(1-xi).*(1-eta.^2)       ;
%  
%     deriv2(1,:) = [-1/4*((1-eta).*(-xi-eta-1)+(1-xi).*(1-eta))  -xi+xi.*eta      ...
%                    1/4*((1-eta).*(xi-eta-1)+(1+xi).*(1-eta))    1/2*(1-eta.^2)  ...
%                    1/4*((1+eta).*(xi+eta-1)+(1+xi).*(1+eta))   -xi-xi.*eta      ...
%                   -1/4*((1+eta).*(-xi+eta-1)+(1-xi).*(1+eta))   -1/2*(1-eta.^2)];
%         
%     deriv2(2,:) = [-1/4*((1-xi).*(-xi-eta-1)+(1-xi).*(1-eta))   -1/2*(1-xi.^2)  ...
%                   -1/4*((1+xi).*(xi-eta-1)+(1+xi).*(1-eta))    -eta-xi.*eta    ...
%                    1/4*((1+xi).*(xi+eta-1)+(1+xi).*(1+eta))     1/2*(1-xi.^2)  ...
%                    1/4*((1-xi).*(-xi+eta-1)+(1-xi).*(1+eta))   -eta+xi.*eta ]  ;

    N = zeros(size(fun));
    N(1:4) = fun(1:2:end);
    N(5:8) = fun(2:2:end);
    deriv = zeros(size(der));
    deriv(:,1:4)=der(:,1:2:end);
    deriv(:,5:8)=der(:,2:2:end);
end
