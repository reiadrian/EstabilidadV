GiD Post Results File 1.0 
# Datos de puntos de gauss del Set_1
GaussPoints "GP_Set_1" Elemtype Quadrilateral "Set_1"
Number of Gauss Points: 4
Nodes not included
Natural Coordinates: Given
-0.577350 -0.577350
0.577350 -0.577350
-0.577350 0.577350
0.577350 0.577350
End GaussPoints
Result "Displacements" "Load Analysis" 1 Vector OnNodes
ComponentNames "X-DISPL" "Y-DISPL"
Values
1 0 0
2 0 0
3 0 0
4 -4.94295908137286e-05 -0.000114585863634868
5 7.0298691126872e-06 -0.000112753104590922
6 6.76785956457204e-05 -0.000113679792171418
7 -2.77125565693286e-05 -0.000399641924199181
8 3.22006507935795e-05 -0.000400934089626848
9 9.30938142950659e-05 -0.000404464211922433
End Values
Result "Stresses//On Gauss Points" "Load Analysis" 1 PlainDeformationMatrix OnGaussPoints "GP_Set_1"
ComponentNames "Stress XX" "Stress YY" "Stress XY" "Stress ZZ"
Values
1 -0.479217217875657 -0.0598345924934918 0.102812962957254
 -0.335258666018945 -0.0588735169245297 -0.252468637447867
 -0.162010868539367 0.00360667737376625 0.106931761162558
 -0.0663908953867783 -0.00509996279809623 -0.248977496449394
2 -0.203392692535064 -0.0635351054162401 0.000858114028657998
 -0.10420194684357 0.0127923500217516 -0.211623667872489
 -0.0670951928336534 -0.036275605475958 -0.00529541424667285
 0.00387735090011539 0.0344082095704887 -0.216503207233817
3 0.059482431155785 -0.00631046530211982 0.144089866893275
 0.133345316793839 0.0225339581567844 -0.24007580216552
 0.400225349357832 0.0618381183382896 0.142007302272447
 0.422162955429933 0.0802974858840032 -0.241841008025904
4 0.00506479391198505 -0.106793970952709 0.0181564153011568
 0.0541074338762845 -0.0315458166924797 -0.175421439340886
 0.13026877934597 -0.0817531738659119 0.0110279052000245
 0.153389950797434 -0.0116893133082498 -0.181074106245099
End Values
Result "Strain//On Gauss Points" "Load Analysis" 1 PlainDeformationMatrix OnGaussPoints "GP_Set_1"
ComponentNames "Strain XX" "Strain YY" "Strain XY" "Strain ZZ"
Values
1 -1.55750099792319e-05 1.20029503605465e-06 8.22503703658033e-06
 -1.0782798754468e-05 2.72607209308647e-07 -2.01974909958293e-05
 -5.42440680047066e-06 1.20029503605465e-06 8.5545408930046e-06
 -2.17903009423863e-06 2.72607209308647e-07 -1.99181997159515e-05
2 -6.35618904839386e-06 -7.61885563640912e-07 6.86491222926399e-08
 -3.55868056159734e-06 1.12109131301552e-06 -1.69298934297991e-05
 -1.99466905794873e-06 -7.61885563640912e-07 -4.23633139733828e-07
 -1.00143033799411e-07 1.12109131301552e-06 -1.73202565787054e-05
3 2.02481747387363e-06 -6.0689838444256e-07 1.1527189351462e-05
 4.29461750541606e-06 -1.37836840066112e-07 -1.92060641732416e-05
 1.29285908563391e-05 -6.0689838444256e-07 1.13605841817957e-05
 1.35367819417711e-05 -1.37836840066112e-07 -1.93472806420723e-05
4 8.80786270084227e-07 -3.59356432450353e-06 1.45251322409255e-06
 2.01388657382602e-06 -1.41224344892455e-06 -1.40337151472708e-05
 4.88731380397173e-06 -3.59356432450353e-06 8.82232416001963e-07
 5.19092711530281e-06 -1.41224344892455e-06 -1.44859284996079e-05
End Values
