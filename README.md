# n-cuerpos
## Enunciado

An n-body simulator predicts the individual motions of a group of objects interacting with each other gravitationally, moving through 3 dimensional space.

In its current CPU-only form, this application takes about 5 seconds to run on 4096 particles, and 20 minutes to run on 65536 particles. Your task is to GPU accelerate the program, retaining the correctness of the simulation.

## Analisis seguido para la solucion planteada



## Instrucciones de compilacion y ejecucion







#CREACION DE LOS ARCHIVOS QUE CONTIENEN LOS DATOS DE ENTRADA 
g++ data.cpp -std=c++11 -o datosEntrada  && ./datosEntrada



#cargar modulos
module load devtools/cuda/8.0

#compilar y ejecutar
nvcc -std=c++11 -o nbody nbody.cu && ./nbody