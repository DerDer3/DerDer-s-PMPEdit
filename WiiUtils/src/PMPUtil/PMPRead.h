#ifndef PMPREAD_H
#define PMPREAD_H

#include<stdio.h>
#include"types.h"
#include"pmp_types.h"

int pmp_object_read(FILE* file, u16 obj_count, object* obj);
int pmp_route_read(FILE* file, u16 rt_count, route* rt);
int pmp_point_read(FILE* file, u16 pt_count, point* pt);
int get_count(FILE* file, u16 offset, u16* count);

#endif // PMPREAD_H
