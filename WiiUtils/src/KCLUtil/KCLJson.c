#include<stdio.h>
#include<math.h>

#include"KCLUtil/kcl_types.h"

int is_nan(float f)
{
  if(isnan(f) || isinf(f))
  {
    return 1;
  }
  return 0;
}

int write_kcl_json(FILE* file, faces* f, int count)
{
  fprintf(file, "{\n");
  fprintf(file, "\t\"triangles\": [\n");
  for(int i = 0; i < count; i++)
  {
    if(is_nan(f[i].a.x) || is_nan(f[i].a.y) || is_nan(f[i].a.z) ||
       is_nan(f[i].b.x) || is_nan(f[i].b.y) || is_nan(f[i].b.z) ||
       is_nan(f[i].c.x) || is_nan(f[i].c.y) || is_nan(f[i].c.z))
       continue;
    fprintf(file, "\t\t{\n");
    fprintf(file, "\t\t\t\"vertices\": [\n");
    fprintf(file, "\t\t\t\t[%f, %f, %f],\n", f[i].a.x, f[i].a.y, f[i].a.z);
    fprintf(file, "\t\t\t\t[%f, %f, %f],\n", f[i].b.x, f[i].b.y, f[i].b.z);
    fprintf(file, "\t\t\t\t[%f, %f, %f]\n", f[i].c.x, f[i].c.y, f[i].c.z);
    fprintf(file, "\t\t\t],\n");
    fprintf(file, "\t\t\t\"surface\": \"0x%X\",\n", f[i].col_flag);
    fprintf(file, "\t\t\t\"normal\": [%f, %f, %f]\n", f[i].normal.x, f[i].normal.y, f[i].normal.z);
    if(i == count - 1)
      fprintf(file, "\t\t}\n");
    else
      fprintf(file, "\t\t},\n");
  }
  fprintf(file, "\t]\n");
  fprintf(file, "}");

  return 0;
}
