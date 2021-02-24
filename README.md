# n-cuerpos
## Enunciado


Dadas las propiedades orbitales (masa, posición instantánea y velocidad) de un grupo de cuerpos astronómicos, determinar las fuerzas interactivas actuantes; y consiguientemente, calcular sus movimientos orbitales para cualquier instante futuro.

Esto para un número mínimo de 100000 cuerpos y preferiblemente llegar a más de un millón.



## Análisis seguido para la solución planteada
1. Teniendo en cuenta el código fuente se observó que la función adecuada para acelerar era la función bodyForce
2. Se calcula el índice para cada hilo para así acelerar el ciclo for más externo de esta función
3. Reservamos espacio en la memoria usando CudaMalloc
4. Se calcula la cantidad de bloques y la cantidad de hilos será de 256 (múltiplo de 32)
5. Se libera el espacio usado en memoria usando cudaFree



## Instrucciones de compilación y ejecución

### Ejecución en local
1. module load devtools/cuda/8.0     //Cargar modulo
2. nvcc -std=c++11 -o nbody nbody.cu      //compilar
3. ./nbody      //ejecutar

### Ejecución en guane
1. module load devtools/cuda/8.0    //cargar modulo
2. nvcc -std=c++11 -o nbody nbody.cu     //compilar
3. sbatch nbodyCU.sbatch  //ejecutar sbatch
4. Abrir el archivo output_nbodyCU.txt    //ver salida  

### BONUS: IMPRESION DE LOS DATOS DE SALIDA EN LOCAL
1. Hacer los mismos pasos de ejecución en local
2. gnuplot    //usar gnuplot desde la termina
3. splot "position_nbodies.txt" u 1:2:3 pt 7 lw 1   //plotear los datos de las masas


## Nota
1. Para hacer el BONUS es necesario entrar manteniendo el modo gráfico usando ssh junto con -X




#CREACION DE LOS ARCHIVOS QUE CONTIENEN LOS DATOS DE ENTRADA 
g++ data.cpp -std=c++11 -o datosEntrada  && ./datosEntrada
