#include<stdio.h>

#include"types.h"
#include"matrix.h"
#include"endian.h"
#include"FileUtil/FileRead.h"

int read_f32(FILE* file, f32* f)
{
  if(fread(f, 1, 4, file) == 4)
  {
    *f = eswap_f32(*f);
    return 0;
  }
  else
    return 1;
}

int read_matrix(FILE* file, matrix *n)
{
  if(read_f32(file, &n->x) ||
     read_f32(file, &n->y) ||
     read_f32(file, &n->z))
    return 1;
  else 
    return 0;
}

int read_u8s(FILE* file, u8* b, int size)
{
  if(fread(b, 1, size, file) == size)
    return 0;
  else
    return 1;
}

int read_u16(FILE* file, u16* x)
{
  if(fread(x, 1, 2, file) == 2)
  {
    *x = eswap_16(*x);
    return 0;
  }
  else
    return 1;
}

int read_u32(FILE* file, u32* x)
{
  if(fread(x, 1, 4, file) == 4)
  {
    *x = eswap_32(*x);
    return 0;
  }
  else
    return 1;
}

int read_string(FILE *file, char* str, int size)
{
  if(fread(str, 1, size, file) == size)
    return 0;
  else
    return 1;
}
