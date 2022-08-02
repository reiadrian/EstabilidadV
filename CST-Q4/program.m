%Programa base para el calculo de solidos 2D con elementos triangulares lineales (CST)
%y elementos cuadrilateros bilineales (Q4)

clc %limpia la pantalla
clear %borra la memoria

disp('MEF 2D - Elementos triangulares lineales (CST)') % Imprime mensaje en "Command Window"
disp('MEF 2D - Elementos cuadrilateros bilineales (Q4)') % Imprime mensaje en "Command Window"

ticIDProb = tic; % Cronometro. P/deteriminar tiempo que dura la ejecucion del programa

global nelem nnodo npoin nload ndime ndofn nfixe numat nstre ngauss nqdist % No aconsejable USAR "global" 
% % % Si se manejan muchas variables usar funcion struct por ejemplo!!

%Direccion para lectura de datos a ser ingresados por MATLAB
root = 'Ejemplo5/PlacaTrac_CST2.gid/'; % Nombre del directorio/carpeta con el problema a ser ejecutado. 
% La carpeta debe encontrarse contenida en la carpeta donde se halla
% "program". Caso contrario se debe colocar la direccion completa para que
% Matlab la encuentre.
% root = 'C:/Estabilidad IV/Ejemplos/voladizo4elem.gid/;

problem='PlacaTrac_CST2'; % Nombre del problema a ser ejecutado. Archivo [.dat]

%LECTURA DE DATOS DE ARCHIVOS DE ENTRADA [.dat]
disp('1) Inicio de lectura de archivo de datos') % Salida en pantalla
[conec,coord,fixed,loads,matpr,qdist,var_EP] = Input([root problem]);  % Lee los ficheros de entrada

%GREAFICO DE MALLA INICIAL
disp('2) Grafica la malla indeformada en color azul') % Salida en pantalla
% plotter(coord,conec,'b-') % Grafica la malla indeformada en color azul

%PROGRAMA PRINCIPAL
%Ensambla el vector de fuerzas nodales globales
disp('3) Ensamblaje del vector de Fuerzas Globales') % Salida en pantalla
FGlob = EnsamblajeF1(loads,coord,conec,matpr,qdist);

%Ensambla la matriz de rigidez global
disp('4) Ensamblaje de la matriz de Rigidez') % Salida en pantalla
KGlob = EnsamblajeK(coord,conec,matpr,var_EP);

%Imposicion de las condiciones de borde
[KGcon,FGcon,ifixe] = CondBorde(KGlob,FGlob,fixed);

%Calculo de los desplazamientos
disp('5) Desplazamiento nodal de los gdl libres') % Salida en pantalla
%Vector desplzamiento de los gdl libres
despl = KGcon\FGcon; % Calcula los desplazaminetos 
% El backslash(Barra invertida) Equivale a resolver despl = KGcon^(-1)*FGcon 
% KGcon^(-1)=inversa de la matriz de rigidez con las condiciones de borde
% impuestas

%Vector desplzamiento de todos gdl (libres y restringidos)
% despG(find(ifixe(:,1)==1)) = ifixe(find(ifixe(:,1)==1),2); 
% despG(find(ifixe(:,1)==0)) = despl; 
despG((ifixe(:,1)==1)) = ifixe((ifixe(:,1)==1),2);% Guarda en despG los valores de desplamientos restringidos/prescriptos
despG((ifixe(:,1)==0)) = despl;% Guarda en despG los valores de desplamientos libres
disp('6) Desplazamiento nodal de todos gdl') % Salida en pantalla
despG=despG';

%Calculo de las reacciones globales
disp('7) Reacciones de apoyo') % Salida en pantalla
reac = KGlob*despG;

%Calculo de las deformaciones y tensiones
disp('8) Calculo de las deformaciones y tensiones') % Salida en pantalla
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% ngauss = 1;
[StraiG,StresG] = Elas_Strain2(despG,conec,coord,matpr,var_EP);
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% Average stresses at nodes
% esfuerzos_n = Stresses_at_nodes_Q4(StresG',conec);
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%Determinacion de las coordenas posterior a la deformacion
disp('9) Determina las coordenadas actuales deformadas') % Salida en pantalla
% corda=actual_coord(coord,despG);

%Grafico de malla final
disp('10) Grafica la malla deformada en color rojo') % Salida en pantalla
% plotter(corda,conec,'r-') % Grafica la malla deformada en color rojo

% hold off % Establece la propiedad para el siguiente ploteo de los ejes 
         % actuales en condicion "reemplazar".
         
%Subrutina que genera el archivo de salida de la "Geometria" para GiD (Desplazamientos,
%deformaciones y tensiones)
disp('11) Genera el archivo de salida de Resultados para GiD') % Salida en pantalla
GID_mesh([root problem],coord,conec); % Geometria para el postproceso del GID 7.2
         
%Subrutina que genera el archivo de salida de Resultados para GiD (Desplazamientos,
%deformaciones y tensiones)
disp('12) Genera el archivo de salida de Resultados para GiD') % Salida en pantalla
GID_result([root problem],despG,conec,coord,StraiG,StresG); %Resultados para GiD [problem='voladizo4elem'];
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% GID_result2([root problem],despG,conec,coord,esfuerzos_n)
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
fprintf('Tiempo ejecucion del programa: %f.\n',toc(ticIDProb)); % Detiene el cronometro en imprime en pantalla el tiempo requerido
disp ('Fin del programa MEF 2D - Elementos triangulares lineales (CST)/MEF 2D - Elementos cuadrilateros bilineales (Q4)') % Salida en pantalla