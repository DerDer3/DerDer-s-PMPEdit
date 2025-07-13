#include<stdio.h>

#include"types.h"
#include"matrix.h"
#include"endian.h"
#include"PMPUtil/pmp_types.h"
#include"PMPUtil/PMPWrite.h"

int write_pmp_header(FILE* file, u16 o_count, u16 r_count, u16 p_count, u32 o_offset, u32 r_offset, u32 p_offset)
{
  char File_Magic[16] = "PMPF";

  fwrite(File_Magic, sizeof(File_Magic), 1, file);

  fwrite(&o_count, 1, 2, file);
  fwrite(&r_count, 1, 2, file);
  fwrite(&p_count, 1, 2, file);

  fseek(file, 0x40, SEEK_SET);

  o_offset = eswap_32(o_offset);
  r_offset = eswap_32(r_offset);
  p_offset = eswap_32(p_offset);

  fwrite(&o_offset, 1, 4, file);
  fwrite(&r_offset, 1, 4, file);
  fwrite(&p_offset, 1, 4, file);

  return 0;
}

int write_pmp_obj(FILE* file, object o)
{
  fwrite(&o.group_id, 1, 2, file);
  fwrite(&o.id, 1, 2, file);
  fwrite(&o.stuff_1, 1, 4, file);
  fwrite(&o.pos.x, 1, 4, file);
  fwrite(&o.pos.y, 1, 4, file);
  fwrite(&o.pos.z, 1, 4, file);
  fwrite(&o.scale.x, 1, 4, file);
  fwrite(&o.scale.y, 1, 4, file);
  fwrite(&o.scale.z, 1, 4, file);
  fwrite(&o.trans_v_1.x, 1, 4, file);
  fwrite(&o.trans_v_1.y, 1, 4, file);
  fwrite(&o.trans_v_1.z, 1, 4, file);
  fwrite(&o.trans_v_2.x, 1, 4, file);
  fwrite(&o.trans_v_2.y, 1, 4, file);
  fwrite(&o.trans_v_2.z, 1, 4, file);
  fwrite(&o.trans_v_3.x, 1, 4, file);
  fwrite(&o.trans_v_3.y, 1, 4, file);
  fwrite(&o.trans_v_3.z, 1, 4, file);
  fwrite(&o.stuff_2, 1, 4, file);
  for(int i = 0; i < 16; i++)
    fwrite(&o.params[i], 1, 1, file);

  return 0;
}

int write_pmp_route(FILE* file, route r)
{
  fwrite(&r.p_count, 1, 2, file);
  fwrite(&r.stuff_1, 1, 4, file);
  fwrite(&r.group_id, 1, 2, file);
  fwrite(&r.route_name, 18, 1, file);
  fwrite(&r.rp_index, 1, 2, file);
  fwrite(&r.stuff_2, 1, 4, file);

  return 0;
}
int write_pmp_point(FILE* file, point p)
{
  fwrite(&p.pos.x, 1, 4, file);
  fwrite(&p.pos.y, 1, 4, file);
  fwrite(&p.pos.z, 1, 4, file);
  for(int i = 0; i < 8; i++)
    fwrite(&p.params[i], 1, 1, file);

  return 0;
}
