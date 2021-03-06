# Cucheb - CUDA accelerated large sparse eigensolvers #
Jared L. Aurentz, Vassilis Kalantzis and Yousef Saad, 2017

## GitHub ##
This README file is written in mark down. For the best experience please view this
file, along with the rest of the Cucheb library on
[GitHub](https://github.com/jaurentz/cucheb).

## Introduction ##
Cucheb is a collection of C++ subroutines for accurately and efficiently
solving large sparse matrix eigenvalue problems using NVIDIA brand GPUs. These
methods are well suited for computing eigenvalues and eigenvectors of matrices
arising in quantum physics, structural engineering and network analysis.

### Current features ###
__cucheb-v0.1.2__ has the following features:
 - double precision eigensolvers for real symmetric matrices
 
### Dependencies ###
Cucheb depends on the 
[__NVIDIA CUDA Toolkit__](https://developer.nvidia.com/cuda-toolkit) 
(v7.0 or greater). 

## User-level programs ##
There are many files in the Cucheb library but only a few will be necessary for
most users. The first set of files are the objects used to store computed
quantities, such as eigenvalues and eigenvectors. Below we give a brief
description of each file and a link for further information:
 - [cuchebmatrix](include/cuchebmatrix.h) - object for storing sparse matrices
 - [cucheblanczos](include/cucheblanczos.h) - object for storing computed
   eigenvalues and eigenvectors
 
The next set of files are programs used to initialize and delete objects and
compute eigenvalues and eigenvectors:
- [cuchebmatrix_init](src/cuchebmatrix/cuchebmatrix_init.cu) - initializes a
  cuchebmatrix object using a sparse matrix stored in [Matrix Market
Format](http://math.nist.gov/MatrixMarket/)
- [cuchebmatrix_destroy](src/cuchebmatrix/cuchebmatrix_destroy.cu) - frees all
  memory associated with an instance of a cuchebmatrix object
- [cuchebmatrix_print](src/cuchebmatrix/cuchebmatrix_print.cu) - prints basic
  propertied of an instance of a cuchebmatrix object
- [cuchebmatrix_lanczos](src/cuchebmatrix/cuchebmatrix_lanczos.cu) - computes
  all eigenvalues and eigenvectors in a user-defined interval using the Lanczos
method and stores the output in a cucheblanczos object
- [cuchebmatrix_filteredlanczos](src/cuchebmatrix/cuchebmatrix_filteredlanczos.cu)
  - computes all eigenvalues and eigenvectors in a user-defined interval using
    the filtered Lanczos procedure and stores the output in a cucheblanczos
object
- [cucheblanczos_init](src/cucheblanczos/cucheblanczos_init.cu) - initializes a
  cucheblanczos object
- [cucheblanczos_destroy](src/cucheblanczos/cucheblanczos_destroy.cu) - frees
  all memory associated with an instance of a cucheblanczos object
- [cucheblanczos_print](src/cucheblanczos/cucheblanczos_print.cu) - prints
  basic propertied of an instance of a cucheblanczos object

## Installation ##
Cucheb is built on top of the [NVIDIA CUDA
Toolkit](https://developer.nvidia.com/cuda-toolkit) and a small number of C++
standard libraries. You must have the toolkit installed before the library can
be built.

### Linux ###
To install on a Linux machine simply move into the Cucheb root directory,
edit the file __make.inc__ to suit your system and type:
```
make install
```
This creates a shared object library __libcucheb.so._version___ and copies it
into the user specified installation directory. The installation does not
create any symbolic links or export any library paths. To add __cucheb__ to
the library path type:
```
export LD_LIBRARY_PATH=/path/to/cucheb/lib:$LD_LIBRARY_PATH
```

## Tests ##
You can find several examples for using Cucheb in the [tests](tests)
subdirectory. Once Cucheb has been installed the tests can be compiled
by typing:
```
make tests
```
The test matrices are included as part of Cucheb but more can be found at the 
[Sparse Matrix Collection](https://www.cise.ufl.edu/research/sparse/matrices/).

### First example ###
When using Cucheb for the first time we suggest that you start with 
[testparsec.cu](tests/parsec/testparsec.cu). This tests computes a subset of the 
ground states of a molecular Hamiltonian, which we consider a standard problem for 
Cucheb. To execute __testparsec.cu__ once compiled type:
```
./tests/parsec/testparsec
```
CAUTION: When working on a cluster the relative path to the __matrices__ in the 
test __source files__ may not be exported properly. To fix this modify the 
specific test source file to use the __absolute path__ to the matrix.

## Removing Cucheb ##
If the source directory has not been removed simply move into the Cucheb
root directory and type:
```
make uninstall
```
If the source directory has been removed the install directory will have to be
removed explicitly by the user.

## Questions and issues ##
If you have any questions or encounter any issues while using Cucheb please
file an issue on the [Cucheb issues](https://github.com/jaurentz/cucheb/issues) 
page of Github.
