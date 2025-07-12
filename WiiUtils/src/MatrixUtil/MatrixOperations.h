#ifndef MATRIXOPERATIONS_H
#define MATRIXOPERATIONS_H

#include"matrix.h"
#include"types.h"

f32 dot_product(matrix a, matrix b);
matrix cross_product(matrix a, matrix b);
matrix matrix_scalar(matrix a, f32 m);
matrix matrix_addition(matrix a, matrix b);

#endif // MATRIXOPERATIONS_H
