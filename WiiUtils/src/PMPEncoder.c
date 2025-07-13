#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<stdint.h>

#include"endian.h"
#include"types.h"
#include"PMPUtil/pmp_types.h"
#include"PMPUtil/PMPDumpRead.h"
#include"PMPUtil/PMPWrite.h"

int PMPEncode(FILE* pmp_infile, FILE* pmp_outfile)
{
  //----------------File Header-------------

  u16 obj_count, route_count, point_count;
  u32 obj_offset, route_offset, point_offset;

  if(get_dumpcounts(pmp_infile, &obj_count, &route_count, &point_count))
    return 1;

  if(calc_offsets(obj_count, route_count, &obj_offset, &route_offset, &point_offset))
    return 1;

  write_pmp_header(pmp_outfile, obj_count, route_count, point_count, obj_offset, route_offset, point_offset);


//--------------Objects--------------  

  fseek(pmp_outfile, obj_offset, SEEK_SET);
  for(int i = 0; i < eswap_16(obj_count); i++)
  {
    object o;

    if(pmp_objdump_read(pmp_infile, &o))
      return 1;
    write_pmp_obj(pmp_outfile, o);
  }

//---------------Routes-------------

  fseek(pmp_outfile, route_offset, SEEK_SET);
  for(int i = 0; i < eswap_16(route_count); i++)
  {
    route r;

    if(pmp_routedump_read(pmp_infile, &r))
      return 1;
    write_pmp_route(pmp_outfile, r);
  }

//--------------Points-------------

  fseek(pmp_outfile, point_offset, SEEK_SET);
  for(int i = 0; i < eswap_16(point_count); i++)
  {
    point p;

    if(pmp_pointdump_read(pmp_infile, &p))
      return 1;
    write_pmp_point(pmp_outfile, p);
  }

  return 0;

}
