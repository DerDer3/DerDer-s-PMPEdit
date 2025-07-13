#include<stdio.h>
#include<stdlib.h>

#include"endian.h"
#include"matrix.h"
#include"types.h"
#include"PMPUtil/pmp_types.h"
#include"PMPUtil/PMPDumpRead.h"

int read_u8_lines(FILE* file, u8* x, int count)
{
  for(int i = 0; i < count; i++)
  {
    char buffer[32];

    if(fgets(buffer, sizeof(buffer), file) == NULL)
      return 1;

    x[i] = atoi(buffer);
  }

  return 0;
}

int read_u16_line(FILE* file, u16* x)
{
  char buffer[32];

  if(fgets(buffer, sizeof(buffer), file) == NULL)
    return 1;

  *x = eswap_16(atoi(buffer));

  return 0;
}

int read_u32_line(FILE* file, u32* x)
{
  char buffer[32];

  if(fgets(buffer, sizeof(buffer), file) == NULL)
    return 1;

  *x = eswap_32(atoi(buffer));

  return 0;
}

int read_f32_line(FILE* file, f32* f)
{
  char buffer[32];

  if(fgets(buffer, sizeof(buffer), file) == NULL)
    return 1;

  *f = eswap_f32(atof(buffer));

  return 0;
}

int read_matrix_line(FILE* file, matrix* m)
{
  if(read_f32_line(file, &m->x) ||
     read_f32_line(file, &m->y) ||
     read_f32_line(file, &m->z))
    return 1;

  return 0;
}

int read_string_line(FILE* file, char* s)
{
  if(fgets(s, sizeof(s), file) == NULL)
    return 1;

  return 0;
}

int get_dumpcounts(FILE* file, u16* o, u16* r, u16* p)
{
  if(read_u16_line(file, o) ||
     read_u16_line(file, r) ||
     read_u16_line(file, p))
    return 1;

  return 0;
}

int calc_offsets(u16 o_count, u16 r_count, u32* o, u32* r, u32* p)
{
  *o = 0x00000080;

  *r = *o + (0x58 * eswap_16(o_count)); // Swap endian back for calculation

  *p = *r + (0x20 * eswap_16(r_count));

  return 0;
}

int pmp_objdump_read(FILE* file, object* o)
{
  if(read_u16_line(file, &o->group_id) ||
     read_u16_line(file, &o->id) ||
     read_u32_line(file, &o->stuff_1) ||
     read_matrix_line(file, &o->pos) ||
     read_matrix_line(file, &o->scale) ||
     read_matrix_line(file, &o->trans_v_1) ||
     read_matrix_line(file, &o->trans_v_2) ||
     read_matrix_line(file, &o->trans_v_3) ||
     read_u32_line(file, &o->stuff_2) ||
     read_u8_lines(file, o->params, 16))
    return 1;

 return 0;
}

int pmp_routedump_read(FILE* file, route* r)
{
  if(read_u16_line(file, &r->p_count) ||
     read_u32_line(file, &r->stuff_1) ||
     read_u16_line(file, &r->group_id) ||
     read_string_line(file, r->route_name) ||
     read_u16_line(file, &r->rp_index) ||
     read_u32_line(file, &r->stuff_2))
    return 1;

  return 0;
}

int pmp_pointdump_read(FILE* file, point* p)
{
  if(read_matrix_line(file, &p->pos) ||
     read_u8_lines(file, p->params, 8))
    return 1;

  return 0;
}
