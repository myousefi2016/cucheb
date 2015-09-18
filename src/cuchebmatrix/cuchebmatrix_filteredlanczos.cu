#include <cucheb.h>

/* filtered lanczos routine for point value */
int cuchebmatrix_filteredlanczos(int neig, double shift, int bsize, cuchebmatrix* ccm,
                                 cucheblanczos* ccl){

  // temp variables
  cuchebstats ccstats;

  // call filtered lanczos
  return cuchebmatrix_filteredlanczos(neig,shift,bsize,ccm,ccl,&ccstats);

} 
  

/* filtered lanczos routine for point value */
int cuchebmatrix_filteredlanczos(int neig, double shift, int bsize, cuchebmatrix* ccm,
                                 cucheblanczos* ccl, cuchebstats* ccstats){

  // check neig
  if (neig > MAX_NUM_EIGS) {
    printf("\ncuchebmatrix_filteredlanczos:\n");
    printf(" Number of desired eigenvalues is too large!\n\n");
    exit(1);
  }

  // initialize ccstats
  ccstats->mat_dim = 0;
  ccstats->mat_nnz = 0;
  ccstats->block_size = 0;
  ccstats->num_blocks = 0;
  ccstats->num_iters = 0;
  ccstats->num_innerprods = 0;
  ccstats->max_degree = 0;
  ccstats->num_matvecs = 0;
  ccstats->specint_time = 0.0;
  ccstats->arnoldi_time = 0.0;
  ccstats->num_conv = 0;
  ccstats->max_res = 0.0;

  // collect some matrix statistics
  ccstats->mat_dim = ccm->m;
  ccstats->mat_nnz = ccm->nnz;

  // timing variables
  time_t start, stop;

  // compute spectral interval
  start = time(0);
  cuchebmatrix_specint(ccm);

  // record compute time
  stop = time(0);
  ccstats->specint_time = difftime(stop,start);

  // make sure shift is valid
  double rho;
  if (isnan(shift)) {
    printf("\ncuchebmatrix_filteredlanczos:\n");
    printf(" Shift cannot be NaN!\n\n");
    exit(1);
  }
  else if (shift > ccm->b) { rho = ccm->b; }
  else if (shift < ccm->a) { rho = ccm->a; }
  else { rho = shift; }

  // compute interval
  double lb, ub, scl;
  scl = (ccm->b - ccm->a)/sqrt(1.0*ccm->nnz);
  lb = max(ccm->a,rho-scl);
  ub = min(ccm->b,rho+scl);

  // initialize filter polynomial
  cuchebpoly ccp;
  cuchebpoly_init(&ccp);
    
  // create filter polynomial
  cuchebpoly_stepfilter(ccm->a,ccm->b,lb,ub,50,&ccp);

  // max_degree
  ccstats->max_degree = max(ccstats->max_degree,ccp.degree);
    
  // initialize lanczos object
  cucheblanczos_init(bsize,MAX_NUM_BLOCKS,ccm,ccl);

  // collect some lanczos statistics
  ccstats->block_size = ccl->bsize;

  // set starting vector
  cucheblanczos_startvecs(ccl);

  // start stop watch
  start = time(0);

  // loop through various filters
  for (int jj=0; jj<MAX_RESTARTS; jj++) {

    // filtered arnoldi run
    cucheblanczos_filteredarnoldi(MAX_STEP_SIZE,ccm,&ccp,ccl,ccstats);

    // update ccstats
    // num_iters
    ccstats->num_iters += 1;
    ccstats->num_blocks += MAX_STEP_SIZE;

    // compute ritz values of p(A)
    cucheblanczos_ritz(ccm,ccl);

    // exit if converged
    if (ccl->nconv >= neig) { break; }

  }

  // compute rayleigh quotients
  cucheblanczos_rayleigh(ccm,ccl);

  // num_conv
  ccstats->num_conv = ccl->nconv;

  // max_res
  for(int ii=0; ii < ccl->nconv; ii++){
    ccstats->max_res = max(ccstats->max_res,ccl->res[ccl->index[ii]]);
  }
  ccstats->max_res = (ccstats->max_res)/max(abs(ccm->a),abs(ccm->b));

  // record compute time
  stop = time(0);
  ccstats->arnoldi_time = difftime(stop,start);

  // destroy ccp
  cuchebpoly_destroy(&ccp);

  // return  
  return 0;

}




/* filtered lanczos routine for interval */
int cuchebmatrix_filteredlanczos(double lbnd, double ubnd, int bsize, 
                                 cuchebmatrix* ccm, cucheblanczos* ccl){

  // temp variables
  cuchebstats ccstats;

  // call filtered lanczos
  return cuchebmatrix_filteredlanczos(lbnd,ubnd,bsize,ccm,ccl,&ccstats);

} 

/* filtered lanczos routine for interval with statistics */
int cuchebmatrix_filteredlanczos(double lbnd, double ubnd, int bsize, 
                                 cuchebmatrix* ccm, cucheblanczos* ccl, 
                                 cuchebstats* ccstats){

  // initialize ccstats
  ccstats->mat_dim = 0;
  ccstats->mat_nnz = 0;
  ccstats->block_size = 0;
  ccstats->num_blocks = 0;
  ccstats->num_iters = 0;
  ccstats->num_innerprods = 0;
  ccstats->max_degree = 0;
  ccstats->num_matvecs = 0;
  ccstats->specint_time = 0.0;
  ccstats->arnoldi_time = 0.0;
  ccstats->num_conv = 0;
  ccstats->max_res = 0.0;
/*
  // collect some matrix statistics
  ccstats->mat_dim = ccm->m;
  ccstats->mat_nnz = ccm->nnz;

  // timing variables
  time_t start, stop;

  // compute spectral interval
  start = time(0);
  cuchebmatrix_specint(ccm);

  // record compute time
  stop = time(0);
  ccstats->specint_time = difftime(stop,start);
  cuchebmatrix_print(ccm);

  // make sure lbnd is valid
  if (isnan(lbnd)) {
    printf("lbnd cannot be NaN!\n");
    exit(1);
  }

  // make sure ubnd is valid
  if (isnan(ubnd)) {
    printf("ubnd cannot be NaN!\n");
    exit(1);
  }

  // check c and d
  if ( lbnd >= ubnd ) {
    return 1;
  }

  // compute lower bound 
  double a, b;
  a = ccm->a;
  b = ccm->b;
  double lb;
  if (lbnd <= a) {lb = a;}
  else if (lbnd >= b) {return 1;}
  else {lb = lbnd;}

  // compute upper bound 
  double ub;
  if (ubnd >= b) {ub = b;}
  else if (ubnd <= a) {return 1;}
  else {ub = ubnd;}

  // initialize filter polynomial
  cuchebpoly ccp;
  cuchebpoly_init(&ccp);

  // create filter polynomial
  cuchebpoly_stepfilter(ccm->a,ccm->b,lb,ub,50,&ccp);

  // max_degree
  ccstats->max_degree = max(ccstats->max_degree,ccp.degree);
    
  // initialize number of converged eigenvalues
  int numconv = 0;

  // initialize lanczos object
  cucheblanczos_init(bsize,MAX_NUM_BLOCKS,ccm,ccl);

  // collect some lanczos statistics
  ccstats->block_size = ccl->bsize;

  // set starting vector
  cucheblanczos_startvecs(ccl);

  // start stop watch
  start = time(0);

  // loop through various filters
  for (int jj=0; jj<MAX_RESTARTS+1; jj++) {

    // filtered arnoldi run
    cucheblanczos_filteredarnoldi(50,ccm,&ccp,ccl,ccstats);

    // update ccstats
    // num_iters
    ccstats->num_iters += 1;
    ccstats->num_blocks += 50;

    // compute ritz values
    cucheblanczos_ritz(ccm,ccl);

    // check convergence
    cucheblanczos_checkconvergence(&numconv,lb,ub,ccm,ccl); 

    // exit if converged
    if (numconv > 0) { break; }

  }

  // compute rayleigh quotients
  cucheblanczos_rayleigh(ccm,ccl);

  // num_conv
  ccstats->num_conv = numconv;

  // max_res
  for(int ii=0; ii < numconv; ii++){
    ccstats->max_res = max(ccstats->max_res,ccl->res[ccl->index[ii]]);
  }
  ccstats->max_res = (ccstats->max_res)/max(abs(ccm->a),abs(ccm->b));

  // record compute time
  stop = time(0);
  ccstats->arnoldi_time = difftime(stop,start);

  // destroy ccp
  cuchebpoly_destroy(&ccp);
*/
  // return  
  return 0;

}
