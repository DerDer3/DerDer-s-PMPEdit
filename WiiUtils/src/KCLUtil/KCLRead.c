#include<stdio.h>

#include"types.h"
#include"matrix.h"
#include"FileUtil/FileRead.h"
#include"KCLUtil/KCLRead.h"

int get_section_matrices(FILE* file, u32 size, u32 offset, matrix* m)
{
  fseek(file, offset, SEEK_SET);

  int count = size / sizeof(matrix);

  for(int i = 0; i < count; i++)
  {
    if(read_matrix(file, &m[i]))
        return 1;
  }

  return 0;
}

int get_tri_data(FILE* file, u32 offset, u32 size, triangle* t)
{
  fseek(file, offset, SEEK_SET);

  int count = size / sizeof(triangle);

  for(int i = 0; i < count; i++)
  {
    if(read_triangle(file, &t[i]))
      return 1;
  }

  return 0;
}

int read_triangle(FILE* file, triangle* t)
{
  if(read_f32(file, &t->length) ||
     read_u16(file, &t->v_index) ||
     read_u16(file, &t->d_index) ||
     read_u16(file, &t->na_index) ||
     read_u16(file, &t->nb_index) ||
     read_u16(file, &t->nc_index) ||
     read_u16(file, &t->col_flag))
    return 1;
  else
    return 0;
}
