#ifndef PMPJSON_H
#define PMPJSON_H

#include"types.h"
#include"pmp_types.h"
#include<stdio.h>

int write_pmp_json(FILE* file, object* obj, u16 obj_count, route* rt, u16 rt_count, point* pt, u16 pt_count);
int obj_write(FILE* file, object obj);
int rt_write(FILE* file, route rt);
int pt_write(FILE* file, point pt);

#endif // PMPJSON_H
