#include <cucheb.h>

/* driver */
int main(){

  // input file
  //string mtxfile("../matrices/H2O.mtx");
  //string mtxfile("../matrices/Si10H16.mtx");
  //string mtxfile("../matrices/Si34H36.mtx");
  //string mtxfile("../matrices/CO.mtx");
  //string mtxfile("../matrices/Ga41As41H72.mtx");
  //string mtxfile("../matrices/Andrews.mtx");
  //string mtxfile("../matrices/Laplacian.mtx");
  string mtxfile("../matrices/DIMACS/al2010.mtx");

  // cuhebmatrix
  cuchebmatrix ccm;
  cuchebmatrix_init(mtxfile, &ccm);

  // compute spectral interval
  cuchebmatrix_specint(&ccm);
  cuchebmatrix_print(&ccm);

  // destroy CCM
  cuchebmatrix_destroy(&ccm);

  // return 
  return 0;

}
