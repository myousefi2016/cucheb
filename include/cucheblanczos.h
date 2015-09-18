#include <cuchebdependencies.h>

/* header file for cucheblanczos data type */
#ifndef __cucheblanczos_h__ 
#define __cucheblanczos_h__

/* convergence tolerance */
#ifdef DOUBLE_TOL
#undef DOUBLE_TOL
#define DOUBLE_TOL (double)pow(2.0,-52)
#else
#define DOUBLE_TOL (double)pow(2.0,-52)
#endif

/* maximum number of computed eigenvalues */
#ifdef MAX_NUM_EIGS    
#undef MAX_NUM_EIGS    
#define MAX_NUM_EIGS 100
#else
#define MAX_NUM_EIGS 100
#endif

/* maximum number of restarts */
#ifdef MAX_BLOCK_SIZE
#undef MAX_BLOCK_SIZE
#define MAX_BLOCK_SIZE 3
#else
#define MAX_BLOCK_SIZE 3
#endif

/* maximum number of restarts */
#ifdef MAX_RESTARTS
#undef MAX_RESTARTS
#define MAX_RESTARTS 20
#else
#define MAX_RESTARTS 20
#endif

/* maximum step size */
#ifdef MAX_STEP_SIZE
#undef MAX_STEP_SIZE
#define MAX_STEP_SIZE 30
#else
#define MAX_STEP_SIZE 30
#endif

/* maximum number of arnoldi vectors */
#ifdef MAX_NUM_BLOCKS
#undef MAX_NUM_BLOCKS
#define MAX_NUM_BLOCKS (MAX_RESTARTS)*(MAX_STEP_SIZE)
#else
#define MAX_NUM_BLOCKS (MAX_RESTARTS)*(MAX_STEP_SIZE)
#endif

/* maximum number of arnoldi vectors */
#ifdef MAX_ORTH_DEPTH
#undef MAX_ORTH_DEPTH
#define MAX_ORTH_DEPTH (MAX_NUM_BLOCKS)
#else
#define MAX_ORTH_DEPTH (MAX_NUM_BLOCKS)
#endif

/* cucheblanczos data type */
typedef struct {

  int n;
  int bsize;
  int nblocks;
  int stop;
  int nconv;
  int* index;
  double* evals;
  double* res;
  double* bands;
  double* vecs;
  double* schurvecs;

  double* dtemp;
  double* dvecs;
  double* dschurvecs;
 
} cucheblanczos;

#endif /* __cucheblanczos_h__ */
