# n-cuerpos
## Enunciado





#CREACION DE LOS ARCHIVOS QUE CONTIENEN LOS DATOS DE ENTRADA 
g++ data.cpp -std=c++11 -o datosEntrada  && ./datosEntrada



#cargar modulos
module load devtools/cuda/8.0

#compilar
nvcc -std=c++11 -o nbody nbody.cu