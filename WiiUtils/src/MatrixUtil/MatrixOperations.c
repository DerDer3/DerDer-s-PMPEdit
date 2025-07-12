#include"matrix.h"
#include"types.h"

f32 dot_product(matrix a, matrix b)
{
  return (a.x * b.x) + (a.y * b.y) + (a.z * b.z);
}

matrix cross_product(matrix a, matrix b)
{
  matrix c;
  c.x = a.y * b.z - a.z * b.y;
  c.y = a.z * b.x - a.x * b.z;
  c.z = a.x * b.y - a.y * b.x;
  return c;
}

matrix matrix_scalar(matrix a, f32 m)
{
  matrix b;
  b.x = a.x * m;
  b.y = a.y * m;
  b.z = a.z * m;
  return b;
}

matrix matrix_addition(matrix a, matrix b)
{
  matrix c;
  c.x = a.x + b.x;
  c.y = a.y + b.y;
  c.z = a.z + b.z;

  return c;
}
