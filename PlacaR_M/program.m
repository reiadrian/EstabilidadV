%!! Programa base para el calculo de solidos 2D con elementos triangulares lineales (CST)
%!! y elementos cuadrilateros bilineales

clc %limpia la pantalla
clear %borra la memoria

disp('MEF Placa Reissner-Mindlin') % Imprime mensaje en "Command Window"
disp('Elementos de interpolacion mixta') % Imprime mensaje en "Command Window"

ticIDProb = tic; % Cronometro. P/deteriminar tiempo que dura la ejecucion del programa

% nelem: Numero de elementos
% nnodo: Numero de nudos por elemento
% ndime: Dimension del problema (2D)
% npoin: Numero de nudos del problema
% ndofn: Numero de grados de libertad del problema
% nfixe: Numero de grados de libertad prescriptos
% nload: Numero de cargas externas
% nstre: Numero de deformaciones y tensiones por elemento (3 p/CST)

% Direccion para lectura de datos a ser ingresados por MATLAB
% root = 'Presa.gid/'; % Nombre del directorio/carpeta con el problema a ser ejecutado. 
% La carpeta debe encontrarse contenida en la carpeta deonde de se halla
% "program". Caso contrario s debe colocar la direccion completa para que
% Matlab la encuentre.
% root = 'C:\Delirio\Estabilidad IV\Beneyto\Funcionan\voladizo4elem.gid/';
% problem='Presa'; % Nombre del problema a ser ejecutado. Archivo [.dat]
% LECTURA DE DATOS DE ARCHIVOS DE ENTRADA [.dat]
disp('1) Inicio de lectura de archivo de datos') % Salida en pantalla
[e_DatMat,e_DatElem,e_DatCB,e_VG]  = f_archivo;%([root problem]);  % Lee los ficheros de entrada

%!! GREAFICO DE MALLA INICIAL
disp('2) Grafica la malla indeformada en color azul') % Salida en pantalla
% plotter(coord,conec,'b-') % Grafica la malla indeformada en color azul

%!! PROGRAMA PRINCIPAL

%!! Ensambla el vector de fuerzas nodales globales
disp('3) Ensamblaje del vector de Fuerzas Globales') % Salida en pantalla
FGlob = EnsamblajeF1(e_DatMat,e_DatElem,e_DatCB,e_VG);

%!! Ensambla la matriz de rigidez global
disp('4) Ensamblaje de la matriz de Rigidez') % Salida en pantalla
KGlob = EnsamblajeK(e_DatMat,e_DatElem,e_DatCB,e_VG);

%!! Imposicion de las condiciones de borde
[KGcon,FGcon,e_DatCB] = CondBorde(KGlob,FGlob,e_DatCB,e_VG);

%!! Calculo de los desplazamientos
disp('5) Desplazamiento nodal de los gdl libres') % Salida en pantalla
% Vector desplzamiento de los gdl libres
despl = KGcon\FGcon; % Calcula los desplazaminetos 
% El backslash(Barra invertida) Equivale a resolver despl = KGcon^(-1)*FGcon 
% KGcon^(-1)=inversa de la matriz de rigidez con las condiciones de borde
% impuestas

%!! Vector desplzamiento de todos gdl (libres y restringidos)
% despG(find(ifixe(:,1)==1)) = ifixe(find(ifixe(:,1)==1),2); 
% despG(find(ifixe(:,1)==0)) = despl; 
ifixe = e_DatCB.ifixe;
disp('6) Desplazamiento nodal de todos gdl') % Salida en pantalla
despG = zeros(e_VG.nnodo*e_VG.ndofn,1);
despG((ifixe(:,1)==1),1) = ifixe((ifixe(:,1)==1),2);% Guarda en despG los valores de desplamientos restringidos/prescriptos
despG((ifixe(:,1)==0),1) = despl;% Guarda en despG los valores de desplamientos libres
% % despG(3:3:end) = despG(3:3:end)*(-1);
% despG=despG';

%!! Calculo de las reacciones globales
% disp('7) Reacciones de apoyo') % Salida en pantalla
% reac = KGlob*despG;

%!! Calculo de las deformaciones y tensiones
disp('8) Calculo de las deformaciones y momentos') % Salida en pantalla
[deform_n,deform_el,esfuerzos_n,esfuerzos_el] = f_esfuerzos(e_DatMat,e_DatElem,e_DatCB,e_VG,despG);
% if ndofn==1
%     [~,StresG] = Elas_Strain2(despG,conec,coord,matpr,var_EP);
% elseif ndofn==2
%     [StraiG,StresG] = Elas_Strain2(despG,conec,coord,matpr,var_EP);
% end

%!! Determinacion de las coordenas posterior a la deformacion
disp('9) Determina las coordenadas actuales deformadas') % Salida en pantalla
% corda=actual_coord(coord,despG);

%!! Grafico de malla final
disp('10) Grafica la malla deformada en color rojo') % Salida en pantalla
% plotter(corda,conec,'r-') % Grafica la malla deformada en color rojo

% hold off % Establece la propiedad para el siguiente ploteo de los ejes 
         % actuales en condicion "reemplazar".
         
%!! Subrutina que genera el archivo de salida de la "Geometr�a" para GiD (Desplazamientos,
%!! deformaciones y tensiones)
disp('11) Genera el archivo de salida de Resultados para GiD') % Salida en pantalla
root = pwd;
problem = '/Ejemplo1/Placa3';
GID_mesh([root problem],e_DatElem.coord,e_DatElem.elem,e_VG); % Geometria para el postproceso del GID 7.2
         
%!! Subrutina que genera el archivo de salida de Resultados para GiD (Desplazamientos,
%!! deformaciones y tensiones)
disp('12) Genera el archivo de salida de Resultados para GiD') % Salida en pantalla
GID_result([root problem],despG,e_DatElem.elem,e_DatElem.coord,deform_n,deform_el,esfuerzos_n,esfuerzos_el,e_VG); %Resultados para GiD [problem='voladizo4elem'];
fprintf('Tiempo ejecucion del programa: %f.\n',toc(ticIDProb)); % Detiene el cronometro en imprime en pantalla el tiempo requerido

disp ('Fin del programa MEF 2D - Elementos triangulares lineales (CST)/MEF 2D - Elementos cuadrilateros bilineales') % Salida en pantalla