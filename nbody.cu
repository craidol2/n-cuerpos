/*
  Purpose:
    Predicts the individual motions of a group of objects interacting with each other gravitationally, moving through 3 dimensional space
  Licensing:
    This code is distributed under the GNU LGPL license.
  Modified:
    Unknow
  Author:
    Unknow
  Cuda Modification:
  24 Fenruary 2021 by Diego Villamizar, Universidad Industrial de Santander diego.villamizar7@correouis.edu.co                   
  This Cuda Modification makes a parallelization of the original Code...  
*/



#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include "./lib/timer.h"


#include <iostream>
#include <fstream>
#include <string>



#define BLOCK_SIZE 256
#define SOFTENING 1e-9f

using namespace std;

typedef struct { float4 *pos, *vel; } BodySystem;


void readData(float *datos) {
  int cont=0;
  string line;
  ifstream myfile ("./archivoEntrada/datos_entrada_100000_cuerpos.txt");
  if (myfile.is_open())
  {
    while ( getline (myfile,line) )
    {
        datos[cont]=std::stof(line);
        cont=cont+1;
    }
    myfile.close();
  }
}

__global__
void bodyForce(float4 *p, float4 *v, float dt, int n) {
  int i = blockDim.x * blockIdx.x + threadIdx.x;
  if (i < n) {
    float Fx = 0.0f; float Fy = 0.0f; float Fz = 0.0f;

    for (int tile = 0; tile < gridDim.x; tile++) {
      __shared__ float3 spos[BLOCK_SIZE];
      float4 tpos = p[tile * blockDim.x + threadIdx.x];
      spos[threadIdx.x] = make_float3(tpos.x, tpos.y, tpos.z);
      __syncthreads();

      for (int j = 0; j < BLOCK_SIZE; j++) {
        float dx = spos[j].x - p[i].x;
        float dy = spos[j].y - p[i].y;
        float dz = spos[j].z - p[i].z;
        float distSqr = dx*dx + dy*dy + dz*dz + SOFTENING;
        float invDist = rsqrtf(distSqr);
        float invDist3 = invDist * invDist * invDist;

        Fx += dx * invDist3; Fy += dy * invDist3; Fz += dz * invDist3;
      }
      __syncthreads();
    }

    v[i].x += dt*Fx; v[i].y += dt*Fy; v[i].z += dt*Fz;
  }
}

int main(const int argc, const char** argv) {
  
  int nBodies = 10000; //DEBE SER IGUAL A LA CANTIDAD DE CUERPOS EN EL ARCHIVO .txt
  int nIters = 10;

  const float dt = 0.01f; // time step
  
  int bytes = 2*nBodies*sizeof(float4);
  float *buf = (float*)malloc(bytes);
  BodySystem p = { (float4*)buf, ((float4*)buf) + nBodies };

  readData(buf); //LEO LOS DATOS DEL ARCHIVO DE TEXTO

  float *d_buf;
  cudaMalloc(&d_buf, bytes);
  BodySystem d_p = { (float4*)d_buf, ((float4*)d_buf) + nBodies };

  int nBlocks = (nBodies + BLOCK_SIZE - 1) / BLOCK_SIZE;
  double totalTime = 0.0; 


  ofstream myfile ("position_nbodies.txt");

  for (int iter = 1; iter <= nIters; iter++) {
    StartTimer();

    cudaMemcpy(d_buf, buf, bytes, cudaMemcpyHostToDevice);
    bodyForce<<<nBlocks, BLOCK_SIZE>>>(d_p.pos, d_p.vel, dt, nBodies);
    cudaMemcpy(buf, d_buf, bytes, cudaMemcpyDeviceToHost);


    
    
    for (int i = 0 ; i < nBodies; i++) { // integrate position
      p.pos[i].x += p.vel[i].x*dt;
      p.pos[i].y += p.vel[i].y*dt;
      p.pos[i].z += p.vel[i].z*dt;
          //cout<<p.pos[i].x<<"\t"<<p.pos[i].y<<"\t"<<p.pos[i].z<<"\n";

      if (myfile.is_open() && iter==1)
      {
        myfile<<p.pos[i].x<<"\t"<<p.pos[i].y<<"\t"<<p.pos[i].z<<"\n";
      }
    }

    const double tElapsed = GetTimer() / 1000.0;
    if (iter > 1) { // First iter is warm up
      totalTime += tElapsed; 
    }

    printf("Iteration %d: %.3f seconds\n", iter, tElapsed);

  }
  myfile.close();
  
  double avgTime = totalTime / (double)(nIters-1); 


  printf("%d Bodies: average %0.3f Billion Interactions / second\n", nBodies, 1e-9 * nBodies * nBodies / avgTime);
  free(buf);
  cudaFree(d_buf);
  return 0;
}
