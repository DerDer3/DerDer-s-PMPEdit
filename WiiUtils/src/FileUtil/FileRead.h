#ifndef FILEREAD_H
#define FILEREAD_H

#include<stdio.h>
#include"types.h"
#include"matrix.h"

int read_f32(FILE* file, f32* f);
int read_matrix(FILE* file, matrix *n);
int read_u8s(FILE* file, u8* b, int size);
int read_u16(FILE* file, u16*);
int read_u32(FILE* file, u32*);
int read_string(FILE* file, char* str, int size);

#endif // FILEREAD_H
