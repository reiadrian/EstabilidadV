% EnsamblajeF1: crea y ensambla el vector de cargas nodales GLOBALES
function FGlob = EnsamblajeF1(loads,coord,conec,matpr,qdist)

global nelem npoin nload ndofn nnodo ngauss nqdist

FGlob = zeros(1,ndofn*npoin); % Inicializa vector de fuerzas globales 

%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%!! Cargas Puntuales
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
if ndofn==1
    for ifix=1:nload     % Bucle en nodos con carga
        npos1=(loads(:,1)-1)*ndofn+1; % Posicion primer grado de libertad del nodo cargado
        FGlob(npos1)=loads(:,2); % Inserta valor de la componente de flujo
    end %for(ifix)
elseif ndofn==2
    for ifix=1:nload     % Bucle en nodos con carga
        inodo=loads(ifix,1);  % Numero del nodo con carga
        npos=(inodo-1)*ndofn+1; % Posicion primer grado de libertad del nodo cargado
        FGlob(npos)=loads(ifix,2); % Inserta valor de la componente x
        npos=npos+1; % Posicion segundo grado de libertad del nodo cargado
        FGlob(npos)=loads(ifix,3); %Inserta valor de la componente y
    end %for(ifix)
end
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%!! Cargas Puntuales - Opcion alternativa
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% npos1=(loads(:,1)-1)*ndofn+1; % Posicion primer grado de libertad del nodo cargado
% FGlob(npos1)=loads(:,2); % Inserta valor de la componente x 
% npos2=npos1+1; % Posicion segundo grado de libertad del nodo cargado
% FGlob(npos2)=loads(:,3); %Inserta valor de la componente y

%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%!! Fuerzas de Masa
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
if nnodo==3
    for ielem=1:nelem
        nodos=[conec(ielem,1) conec(ielem,2) conec(ielem,3)];
        b(1) = coord(nodos(2),2) - coord(nodos(3),2); %b1=y2-y3
        b(2) = coord(nodos(3),2) - coord(nodos(1),2); %b2=y3-y1
        b(3) = coord(nodos(1),2) - coord(nodos(2),2); %b3=y1-y2
        c(1) = coord(nodos(3),1) - coord(nodos(2),1); %c1=x3-x2
        c(2) = coord(nodos(1),1) - coord(nodos(3),1); %c2=x1-x3
        c(3) = coord(nodos(2),1) - coord(nodos(1),1); %c3=x2-x1
%         area=0.5*(c(3)*b(2)-c(2)*b(3));
%         p=-matpr(ielem,4)*matpr(ielem,3)*area/3;
            p=0;
        FGlob(ndofn.*nodos(:))=FGlob(ndofn.*nodos(:))+p;
    end %for(ielem) %Me parece que se puden sumar todas en un solo bucle
elseif nnodo == 4
        difVK = zeros(nelem,1);
        for ielem=1:nelem
            coord_el = coord(conec(ielem,1:1:nnodo),:);% Coordenadas del elemento
            nodos = ndofn*conec(ielem,1:1:nnodo); % GDL en Y para las conectivadas del elemento
            t = matpr(ielem,3); % Espesor
            pes_esp = matpr(ielem,4)*9.81; % Peso especifico en N/m3???
            [gausp,weigp] = gauss_points;
            for igaus=1:ngauss % Bucle en dieccion xi o psi
                psi=gausp(igaus);
                for jgaus=1:ngauss % Bucle en dieccion eta
                    eta=gausp(jgaus);
                    [N,derivFF] = Fforma_DFf(psi,eta);
                    [detJB,~] = MatB_Cuad(coord_el',derivFF');
                    difV = detJB*weigp(igaus)*weigp(jgaus)*t;
                    difVK(ielem,1) = difVK(ielem,1) + difV;
%                     p = -pes_esp*difV*t*N; % Peso
                    p = 0; % Peso
                    FGlob(nodos)=FGlob(nodos)+p; % Agrega el peso para la direccion vertical
                end %jgaus
            end %igaus
        end %ielem
end %nnodo

%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%!! Cargas Distribuidas - (FALTA PROGRAMAR)
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
if nnodo==3
    FGlob = FlineaCST(conec,coord,qdist,matpr(ielem,3),FGlob);
elseif nnodo == 4
    FGlob = FlineaQ4(conec,coord,qdist,matpr(ielem,3),FGlob);
end %if
FGlob=FGlob'; % Transpone para formar vector columna
