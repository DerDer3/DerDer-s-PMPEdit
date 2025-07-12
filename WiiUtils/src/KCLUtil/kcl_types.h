#ifndef KCL_TYPES_H
#define KCL_TYPES_H

#include"types.h"
#include"matrix.h"

typedef struct triangle {
  f32 length; // Length (Not entirely sure what this does)
  u16 v_index; // Vertex index
  u16 d_index; // Face normal direction
  u16 na_index; // Normal A index
  u16 nb_index; // Normal B index
  u16 nc_index; // Normal C index
  u16 col_flag; // Collison flag
} triangle;

typedef struct faces {
  matrix a, b, c;
  u16 col_flag;
  matrix normal;
} faces;

#endif // KCL_TYPES_H
