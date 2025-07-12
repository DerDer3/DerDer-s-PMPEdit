#ifndef KCLSECTIONS_H
#define KCLSECTIONS_H

typedef struct section {
  u32 offset;
  u32 size;
} section;

int get_offsets(FILE* file, section* v, section* n, section* t, section* o, section* end);
int get_size(section* v, section* n, section* t, section* o, section* end);

#endif // KCLSECTIONS_H
