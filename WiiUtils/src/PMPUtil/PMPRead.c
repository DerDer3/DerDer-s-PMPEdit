#include<stdio.h>

#include"PMPUtil/PMPRead.h"
#include"types.h"
#include"pmp_types.h"
#include"FileUtil/FileRead.h"


int get_count(FILE* file, u16 offset, u16* count)
{

  fseek(file, offset, SEEK_SET);
  if(read_u16(file, count))
  {
    printf("Could not read object count\n");
    return 1;
  }

  return 0;
}

//--------------------Object Data Read------------
int pmp_object_read(FILE* file, u16 obj_count, object* obj)
{
  fseek(file, 0x40, SEEK_SET);
  u32 obj_offset;

  if(read_u32(file, &obj_offset))
  {
    printf("Could not read object offset\n");
    return 1;
  }

  if(obj_count != 0)
  {
    fseek(file, obj_offset, SEEK_SET);

    for(int i = 0; i < obj_count; i++)
    {
      if(
      read_u16(file, &obj[i].group_id) ||
      read_u16(file, &obj[i].id) ||
      read_u32(file, &obj[i].stuff_1) ||
      read_matrix(file, &obj[i].pos) ||
      read_matrix(file, &obj[i].scale) ||
      read_matrix(file, &obj[i].trans_v_1) ||
      read_matrix(file, &obj[i].trans_v_2) ||
      read_matrix(file, &obj[i].trans_v_3) ||
      read_u32(file, &obj[i].stuff_2) ||
      read_u8s(file, obj[i].params, 16))
        return 1;
    }
  }

  return 0;
  
}

//--------------Route Data Read-----------------
int pmp_route_read(FILE* file, u16 rt_count, route* rt)
{
  fseek(file, 0x44, SEEK_SET);
  u32 rt_offset;

  if(read_u32(file, &rt_offset))
  {
    printf("Could not read route offset\n");
    return 1;
  }

  if(rt_count != 0)
  {
    fseek(file, rt_offset, SEEK_SET);

    for(int i = 0; i < rt_count; i++)
    {
      if(
      read_u16(file, &rt[i].p_count) ||
      read_u32(file, &rt[i].stuff_1) ||
      read_u16(file, &rt[i].group_id) ||
      read_string(file, rt[i].route_name, 18) ||
      read_u16(file, &rt[i].rp_index) ||
      read_u32(file, &rt[i].stuff_2))
        return 1;
    }
  }

  return 0;
  
}

//-----------------Read Point Data----------------
int pmp_point_read(FILE* file, u16 pt_count, point* pt)
{
  fseek(file, 0x48, SEEK_SET);
  u32 pt_offset;

  if(read_u32(file, &pt_offset))
  {
    printf("Could not read point offset\n");
    return 1;
  }

  if(pt_count != 0)
  {
    fseek(file, pt_offset, SEEK_SET);

    for(int i = 0; i < pt_count; i++)
    {
      if(
      read_matrix(file, &pt[i].pos) ||
      read_u8s(file, pt[i].params, 8))
        return 1;
    }
  }

  return 0;
  
}
