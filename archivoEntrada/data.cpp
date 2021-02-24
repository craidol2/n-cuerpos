#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <fstream>
#include <string>
using namespace std;


void generateRandomData(int n) {
  ofstream myfile ("datos_entrada_100000_cuerpos.txt");
  if (myfile.is_open())
  {
    for (int i = 0; i < n; i++) {
      myfile<< 2.0f * (rand() / (float)RAND_MAX) - 1.0f<<"\n";
    }      
    myfile.close();
  }
}

void readData(float *datos) {
  string line;
  int cont=0;
  ifstream myfile ("datos_entrada_100000_cuerpos.txt");
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

int main() {
    int n=1000000;
    float datos[n];
    generateRandomData(n);
    readData(datos);
    cout<<"primer dato "<<datos[0];
    return 0;
}