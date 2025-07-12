#include<stdio.h>
#include<stdlib.h>

#include"types.h"
#include"matrix.h"
#include"MatrixUtil/MatrixOperations.h"
#include"KCLUtil/kcl_types.h"

int calc_tris(matrix* v, matrix* n, triangle* t, faces* f, int count)
{
  for(int i = 0; i < count; i++)
  {
    matrix crossA = cross_product(n[t[i].na_index], n[t[i].d_index]);
    matrix crossB = cross_product(n[t[i].nb_index], n[t[i].d_index]);

    f[i].a = v[t[i].v_index];
    f[i].b = matrix_addition(f[i].a, matrix_scalar(crossB, (t[i].length / dot_product(crossB, n[t[i].nc_index]))));
    f[i].c = matrix_addition(f[i].a, matrix_scalar(crossA, (t[i].length / dot_product(crossA, n[t[i].nc_index]))));

    f[i].col_flag = t[i].col_flag;
    f[i].normal = n[t[i].d_index];
  }

  return 0;
}
