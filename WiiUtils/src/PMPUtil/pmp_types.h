#ifndef PMP_TYPES_H
#define PMP_TYPES_H

#include"types.h"
#include"matrix.h"

typedef struct object {
  u16 group_id; // Object group ID
  u16 id; // Object ID
  u32 stuff_1; // Unknown data
  matrix pos; // Positon
  matrix scale; // Scale Vector
  matrix trans_v_1; // Transformation Matrix Column 1
  matrix trans_v_2; // Transformation Matrix Column 2
  matrix trans_v_3; // Transformation Matrix Column 3
  u32 stuff_2; // Unknown data
  u8 params[16]; // Object parameters, varies in size
} object;

typedef struct route {
  u16 p_count; // Point count
  u32 stuff_1; // Unknown data
  u16 group_id; // Group ID
  char route_name[18]; // Name of route
  u16 rp_index; // index of first point from point data
  u32 stuff_2; // Unknown data
} route;

typedef struct point {
  matrix pos;
  u8 params[8];
} point;

#endif // PMP_TYPES_H
