#include<stdio.h>
#include<stdlib.h>

#include"types.h"
#include"PMPUtil/pmp_types.h"
#include"PMPUtil/PMPRead.h"
#include"PMPUtil/PMPJson.h"

int PMPDecode(FILE* pmp_file, FILE* pmp_json)
{
  //--------------- Read Object Count and Offset-----------

  u16 obj_count;
  u16 rt_count;
  u16 pt_count;

  get_count(pmp_file, 0x10, &obj_count);
  get_count(pmp_file, 0x12, &rt_count);
  get_count(pmp_file, 0x14, &pt_count);

  object* obj = malloc(obj_count * sizeof(object));
  route* rt = malloc(rt_count * sizeof(route));
  point* pt = malloc(pt_count * sizeof(point));

  if(pmp_object_read(pmp_file, obj_count, obj) |
     pmp_route_read(pmp_file, rt_count, rt) |
     pmp_point_read(pmp_file, pt_count, pt))
  {
    printf("Error reading data\n");
    return 1;
  }

  //-------------------Output to JSON-------------------

  if(write_pmp_json(pmp_json, obj, obj_count, rt, rt_count, pt, pt_count))
  {
    printf("Error writing data\n");
    return 1;
  }

  return 0;
}
