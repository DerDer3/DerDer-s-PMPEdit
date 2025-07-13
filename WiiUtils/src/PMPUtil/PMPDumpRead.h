#ifndef PMPDUMPREAD_H
#define PMPDUMPREAD_H

#include<stdio.h>
#include"matrix.h"
#include"types.h"
#include"PMPUtil/pmp_types.h"

int read_u8_lines(FILE* file, u8* x, int count);
int read_u16_line(FILE* file, u16* x);
int read_u32_line(FILE* file, u32* x);
int read_f32_line(FILE* file, f32* f);
int read_matrix_line(FILE* file, matrix* m);
int read_string(FILE* file, char s[18]);
int get_dumpcounts(FILE* file, u16* o, u16* r, u16* p);
int calc_offsets(u16 o_count, u16 r_count, u32* o, u32* r, u32* p);
int pmp_objdump_read(FILE* file, object* o);
int pmp_routedump_read(FILE* file, route* r);
int pmp_pointdump_read(FILE* file, point* p);

#endif // PMPDUMPREAD_H
