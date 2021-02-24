#!/bin/bash

#SBATCH --partition=normal  # Nombre de la particion - Los nombres se obtienen con el comando sinfo
#SBATCH --job-name=nbody_cu # Nombre de la tarea a ejecutar - puede ser cualquiera
#SBATCH --nodes=1         # Cantidad de nodos a usar
#SBATCH --ntasks=2          # Numero de tareas a ejecutar
#SBATCH --cpus-per-task=2  # Numero de cores asignados a cada tarea
#SBATCH --output=output_nbodyCU.txt # Archivo de salida donde se encuentran los resultados de la ejecucion

module load devtools/cuda/8.0   # Modulo que contiene el software a usar

if [ -n "$SLURM_CPUS_PER_TASK" ]; then
  omp_threads=$SLURM_CPUS_PER_TASK
else
  omp_threads=1
fi

./nbody