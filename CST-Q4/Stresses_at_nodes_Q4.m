function esfuerzos=Stresses_at_nodes_Q4(SIGMA,connec)
%
% This function averages the stresses at the nodes
%
%
global npoin nelem nnodo
%
for k = 1:npoin
    sigx = 0.0;
    sigy = 0.; 
    tau = 0.0;
    ne = 0;
    for iel = 1:nelem
        for jel=1:nnodo
            if connec(iel,jel) == k
                ne=ne+1;
                sigx = sigx+SIGMA(iel,1);
                sigy = sigy + SIGMA(iel,2);
                tau = tau + SIGMA(iel,3);
            end
        end
    end
    ZX(k,1) = sigx/ne;
    ZY(k,1) = sigy/ne;
    ZT(k,1)=tau/ne;
    Z1(k,1)= ((sigx+sigy)/2 + sqrt(((sigx+sigy)/2)^2 +tau^2))/ne;
    Z2(k,1)= ((sigx+sigy)/2 - sqrt(((sigx+sigy)/2)^2 +tau^2))/ne;
end
esfuerzos =[ZX ZY ZT Z1 Z2];