% MatrizD: Calculo de la matriz constitutiva del elemento
function D = MatrizD(matpr,ielem,var_EP)
global ndofn
if ndofn==1
    kx=matpr(ielem,1); % Coeficiente de permeabiliad en la dirección x
    ky=matpr(ielem,2); % Coeficiente de permeabiliad en la dirección y
    %!!Arma la matriz constitutiva (Matriz de permabilidad)
    D=[kx 0 ; 0 ky];
elseif ndofn==2
    E=matpr(ielem,1); % Modulo de Young
    nu=matpr(ielem,2); % Coeficiente de Poisson
    % Pagina 22 "Elementos finitos triangulares para ESTADO PLANO"
    if var_EP==0 %!!Arma la matriz constitutiva p/EPT
        D=E/(1-nu^2)*[1 nu 0 ;
            nu 1 0 ;
            0 0 (1-nu)/2];
    elseif var_EP==1 %!!Arma la matriz constitutiva p/EPD
        E_epd = E/(1-nu^2);
        nu_epd = nu/(1-nu);
        D=E_epd/(1-nu_epd^2)*[1 nu_epd 0 ;
            nu_epd 1 0 ;
            0 0 (1-nu_epd)/2];
    end % Cierra sentencia if
end
