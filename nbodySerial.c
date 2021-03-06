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
  ifstream myfile (".archivoEntrada/datos_entrada_100000_cuerpos.txt");
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


void bodyForce(float4 *p, float4 *v, float dt, int n) {
  for (int i =0; i < n; i++) {
    float Fx = 0.0f; float Fy = 0.0f; float Fz = 0.0f;

    for (int j = 0; j < BLOCK_SIZE; j++) {
        float dx = p[j].x - p[i].x;
        float dy = p[j].y - p[i].y;
        float dz = p[j].z - p[i].z;
        float distSqr = dx*dx + dy*dy + dz*dz + SOFTENING;
        float invDist = rsqrtf(distSqr);
        float invDist3 = invDist * invDist * invDist;

        Fx += dx * invDist3; Fy += dy * invDist3; Fz += dz * invDist3;
      }

    v[i].x += dt*Fx; v[i].y += dt*Fy; v[i].z += dt*Fz;
  }
}

int main(const int argc, const char** argv) {
  
  int nBodies = 100; //DEBE SER IGUAL A LA CANTIDAD DE CUERPOS EN EL ARCHIVO .txt
  int nIters = 10;

  const float dt = 0.01f; // time step
  
  int bytes = 2*nBodies*sizeof(float4);
  float *buf = (float*)malloc(bytes);
  BodySystem p = { (float4*)buf, ((float4*)buf) + nBodies };

  readData(buf); //LEO LOS DATOS DEL ARCHIVO DE TEXTO

  double totalTime = 0.0; 

  for (int iter = 1; iter <= nIters; iter++) {
    StartTimer();
		   
    bodyForce(p.pos, p.vel, dt, nBodies);
    
    for (int i = 0 ; i < nBodies; i++) { // integrate position
      p.pos[i].x += p.vel[i].x*dt;
      p.pos[i].y += p.vel[i].y*dt;
      p.pos[i].z += p.vel[i].z*dt;
    }

    const double tElapsed = GetTimer() / 1000.0;
    if (iter > 1) { // First iter is warm up
      totalTime += tElapsed; 
    }

    printf("Iteration %d: %.3f seconds\n", iter, tElapsed);

  }
  double avgTime = totalTime / (double)(nIters-1); 


  printf("%d Bodies: average %0.3f Billion Interactions / second\n", nBodies, 1e-9 * nBodies * nBodies / avgTime);
  free(buf);
  return 0;
}
