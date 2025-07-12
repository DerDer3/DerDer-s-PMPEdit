#include<stdio.h>
#include<stdlib.h>

#include"types.h"
#include"endian.h"
#include"FileUtil/FileRead.h"
#include"KCLUtil/KCLSections.h"
#include"KCLUtil/kcl_types.h"

int compare(const void* a, const void* b)
{
  return ((section*)a)->offset - ((section*)b)->offset;
}

int get_offsets(FILE* file, section* v, section* n, section* t, section* o, section* end)
{
  fseek(file, 0, SEEK_END);
  end->offset = ftell(file) + 1;
  fseek(file, 0, SEEK_SET);
  if(read_u32(file, &v->offset) ||
     read_u32(file, &n->offset) ||
     read_u32(file, &t->offset) ||
     read_u32(file, &o->offset))
     return 1;

  t->offset += 0x10; // Weird Nintendo thing

  return 0;
}

// There has to be a better way to do this
int get_size(section* v, section* n, section* t, section* o, section* end)
{
  section s[5] = {*v, *n, *t, *o, *end};

  qsort(s, 5, sizeof(section), compare); // Sort sections

  for(int i = 0; i < 4; i++)
    s[i].size = s[i + 1].offset - s[i].offset;

  for(int i = 0; i < 4; i++)
  {
    if(s[i].offset == v->offset)
      v->size = s[i].size;
    else if(s[i].offset == n->offset)
      n->size = s[i].size;
    else if(s[i].offset == t->offset)
      t->size = s[i].size;
    else if(s[i].offset == o->offset)
      o->size = s[i].size;
  }

  return 0;
}
