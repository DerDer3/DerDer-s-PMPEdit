#include<stdio.h>

#include"types.h"
#include"pmp_types.h"
#include"PMPUtil/PMPJson.h"

int write_pmp_json(FILE* file, object* obj, u16 obj_count, route* rt, u16 rt_count, point* pt, u16 pt_count)
{
  fprintf(file, "{\n");

  // Objects
  fprintf(file, "\t\"objects\": [\n");
  for(int i = 0; i < obj_count; i++)
  {
    fprintf(file, "\t\t{\n");
    if(obj_write(file, obj[i]))
    {
      printf("Error writing object data\n");
      return 1;
    }
    if(i == obj_count - 1)
      fprintf(file, "\t\t}\n");
    else
      fprintf(file, "\t\t},\n");
  }
  fprintf(file, "\t],\n");

  // Routes
  fprintf(file, "\t\"routes\": [\n");
  for(int i = 0; i < rt_count; i++)
  {
    fprintf(file, "\t\t{\n");
    if(rt_write(file, rt[i]))
    {
      printf("Error writing route data\n");
      return 1;
    }
    if(i == rt_count - 1)
      fprintf(file, "\t\t}\n");
    else
      fprintf(file, "\t\t},\n");
  }
  fprintf(file, "\t],\n");

  // Points
  fprintf(file, "\t\"points\": [\n");
  for(int i = 0; i < pt_count; i++)
  {
    fprintf(file, "\t\t{\n");
    if(pt_write(file, pt[i]))
    {
      printf("Error writing point data\n");
      return 1;
    }
    if(i == pt_count - 1)
      fprintf(file, "\t\t}\n");
    else
      fprintf(file, "\t\t},\n");
  }
  fprintf(file, "\t]\n");

  fprintf(file, "}");

  return 0;
}

int obj_write(FILE* file, object obj)
{
  fprintf(file, "\t\t\t\"group\": %d,\n", obj.group_id);
  fprintf(file, "\t\t\t\"id\": %d,\n", obj.id);
  fprintf(file, "\t\t\t\"unknown_1\": %d,\n", obj.stuff_1);
  fprintf(file, "\t\t\t\"position\": [%f, %f, %f],\n", obj.pos.x, obj.pos.y, obj.pos.z);
  fprintf(file, "\t\t\t\"scale\": [%f, %f, %f],\n", obj.scale.x, obj.scale.y, obj.scale.z);
  fprintf(file, "\t\t\t\"transformation_matrix_1\": [%f, %f, %f],\n", obj.trans_v_1.x, obj.trans_v_1.y, obj.trans_v_1.z);
  fprintf(file, "\t\t\t\"transformation_matrix_2\": [%f, %f, %f],\n", obj.trans_v_2.x, obj.trans_v_2.y, obj.trans_v_2.z);
  fprintf(file, "\t\t\t\"transformation_matrix_3\": [%f, %f, %f],\n", obj.trans_v_3.x, obj.trans_v_3.y, obj.trans_v_3.z);
  fprintf(file, "\t\t\t\"unknown_2\": %d,\n", obj.stuff_2);
  fprintf(file, "\t\t\t\"params\": [");
  for(int j = 0; j < 16; j++)
  {
    if(j < 15)
      fprintf(file, "%d, ", obj.params[j]);
    else
      fprintf(file, "%d", obj.params[j]);
  }
  fprintf(file, "]\n");

  return 0;
}

int rt_write(FILE* file, route rt)
{
  fprintf(file, "\t\t\t\"point_count\": %d,\n", rt.p_count);
  fprintf(file, "\t\t\t\"unknown_1\": %d,\n", rt.stuff_1);
  fprintf(file, "\t\t\t\"group\": %d,\n", rt.group_id);
  fprintf(file, "\t\t\t\"name\": \"%s\",\n", rt.route_name);
  fprintf(file, "\t\t\t\"index\": %d,\n", rt.rp_index);
  fprintf(file, "\t\t\t\"unknown_2\": %d\n", rt.stuff_2);

  return 0;
}

int pt_write(FILE* file, point pt)
{
  fprintf(file, "\t\t\t\"position\": [%f, %f, %f],\n", pt.pos.x, pt.pos.y, pt.pos.z);
  fprintf(file, "\t\t\t\"params\": [");
  for(int j = 0; j < 8; j++)
  {
    if(j < 7)
      fprintf(file, "%d, ", pt.params[j]);
    else
      fprintf(file, "%d", pt.params[j]);
  }
  fprintf(file, "]\n");

  return 0;
}
