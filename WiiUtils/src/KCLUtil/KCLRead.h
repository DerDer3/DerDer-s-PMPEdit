#ifndef KCLREAD_H
#define KCLREAD_H

#include<stdio.h>
#include"types.h"
#include"matrix.h"
#include"KCLUtil/kcl_types.h"

int get_section_matrices(FILE* file, u32 size, u32 offset, matrix* m);
int get_tri_data(FILE* file, u32 offset, u32 size, triangle* t);
int read_triangle(FILE* file, triangle* t);

#endif // KCLREAD_H
