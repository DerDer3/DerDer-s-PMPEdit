#ifndef PMPWRITE_H
#define PMPWRITE_H

#include<stdio.h>
#include"types.h"
#include"PMPUtil/pmp_types.h"

int write_pmp_header(FILE* file, u16 o_count, u16 r_count, u16 p_count, u32 o_offset, u32 r_offset, u32 p_offset);
int write_pmp_obj(FILE* file, object o);
int write_pmp_route(FILE* file, route r);
int write_pmp_point(FILE* file, point p);

#endif // PMPWRITE_H
