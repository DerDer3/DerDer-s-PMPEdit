#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<stdint.h>
typedef struct matrix {
  float x, y, z;
} matrix;

typedef struct object {
  uint16_t group_id; // Object group ID
  uint16_t id; // Object ID
  uint32_t stuff_1; // Unknown data
  matrix pos; // Positon
  matrix scale; // Scale Vector
  matrix trans_v_1; // Transformation Matrix Column 1
  matrix trans_v_2; // Transformation Matrix Column 2
  matrix trans_v_3; // Transformation Matrix Column 3
  uint32_t stuff_2; // Unknown data
  uint8_t params[16]; // Object parameters, varies in size
} object;

void swap_u8(uint8_t* x, int8_t* y);
uint16_t swap_endian_u16(uint16_t x);
uint32_t swap_endian_u32(uint32_t x);
float swap_endian_f(float f);
int read_u8_line(FILE* infile, FILE* outfile);
int read_u16_line(FILE* infile, FILE* outfile);
int read_u32_line(FILE* infile, FILE* outfile);
int read_matrix(FILE* infile, FILE* outfile);

int main(int argc, char* argv[])
{
  FILE* pmp_infile;
  FILE* pmp_outfile;
  
  pmp_infile = fopen(argv[1], "r");
  pmp_outfile = fopen(argv[2], "wb");

  if(pmp_infile == NULL || pmp_outfile == NULL)
  {
    printf("Could not connect to files\n");
    return 1;
  }

  //----------------File Header-------------

  // File magic
  char File_Magic[16] = "PMPF";

  fwrite(File_Magic, sizeof(File_Magic), 1, pmp_outfile);

  // Counts
  int counts[3]; // Object, Routes, Points
  char buffer[8];
  for(int i = 0; i < 3; i++)
  {
    if(fgets(buffer, sizeof(buffer), pmp_infile) == NULL)
    {
      printf("Could not read counts\n");
      fclose(pmp_infile);
      fclose(pmp_outfile);
      return 1;
    }
    counts[i] = atoi(buffer);
  }

  int obj_count = swap_endian_u16(counts[0]);
  int route_count = swap_endian_u16(counts[1]);
  int pnt_count = swap_endian_u16(counts[2]);

  fwrite(&obj_count, 1, 2, pmp_outfile);
  fwrite(&route_count, 1, 2, pmp_outfile);
  fwrite(&pnt_count, 1, 2, pmp_outfile);

  // Calculate and Write Offsets
  fseek(pmp_outfile, 0x40, SEEK_SET);

  int obj_offset, route_offset, pnt_offset;

  obj_offset = 0x80000000; // Swapped 0x00000080 Little -> Big Endian 
  fwrite(&obj_offset, 1, 4, pmp_outfile);  

  route_offset = swap_endian_u32(0x80 + (0x58 * counts[0]));
  fwrite(&route_offset, 1, 4, pmp_outfile);

  pnt_offset = swap_endian_u32(0x80 + (0x58 * counts[0]) + (0x20 * counts[1]));
  fwrite(&pnt_offset, 1, 4, pmp_outfile);


  //-----------------------Object Data-----------------
  fseek(pmp_outfile, swap_endian_u32(obj_offset), SEEK_SET); 
  for(int i = 0; i < counts[0]; i++)
  {
    if(read_u16_line(pmp_infile, pmp_outfile) || // Group ID
       read_u16_line(pmp_infile, pmp_outfile) || // ID
       read_u32_line(pmp_infile, pmp_outfile) || // Unknown
       read_matrix(pmp_infile, pmp_outfile) || // Position
       read_matrix(pmp_infile, pmp_outfile) || // Scale
       read_matrix(pmp_infile, pmp_outfile) || // Transformation 1
       read_matrix(pmp_infile, pmp_outfile) || // Transformation 2
       read_matrix(pmp_infile, pmp_outfile) || // Transformation 3
       read_u32_line(pmp_infile, pmp_outfile) || // Unknown 2
       read_u8_line(pmp_infile, pmp_outfile) || // Params split
       read_u8_line(pmp_infile, pmp_outfile) ||      
       read_u8_line(pmp_infile, pmp_outfile) ||      
       read_u8_line(pmp_infile, pmp_outfile) ||
       read_u8_line(pmp_infile, pmp_outfile) ||
       read_u8_line(pmp_infile, pmp_outfile) ||
       read_u8_line(pmp_infile, pmp_outfile) ||
       read_u8_line(pmp_infile, pmp_outfile) ||
       read_u8_line(pmp_infile, pmp_outfile) ||
       read_u8_line(pmp_infile, pmp_outfile) ||      
       read_u8_line(pmp_infile, pmp_outfile) ||      
       read_u8_line(pmp_infile, pmp_outfile) ||
       read_u8_line(pmp_infile, pmp_outfile) ||
       read_u8_line(pmp_infile, pmp_outfile) ||
       read_u8_line(pmp_infile, pmp_outfile) ||
       read_u8_line(pmp_infile, pmp_outfile))
    {
      printf("Failed reading data\n");
      fclose(pmp_infile);
      fclose(pmp_outfile);
      return 1;
    }
  }

  //--------------------Route Data------------------
  for(int i = 0; i < counts[1]; i++)
  {
    if(read_u16_line(pmp_infile, pmp_outfile) || // Point Count
       read_u32_line(pmp_infile, pmp_outfile) || // Unknown
       read_u16_line(pmp_infile, pmp_outfile)) // Route group ID
    {
      printf("Failed reading data\n");
      fclose(pmp_infile);
      fclose(pmp_outfile);
      return 1;
    }
    // String Internal Route Name
    char rt_buffer[12];
    if(fgets(rt_buffer, sizeof(rt_buffer), pmp_infile) == NULL)
    {
      printf("Could not read data\n");
      fclose(pmp_infile);
      fclose(pmp_outfile);
      return 1;
    }
    fwrite(rt_buffer, sizeof(rt_buffer), 1, pmp_outfile);  

    if(read_u16_line(pmp_infile, pmp_outfile) || // Route Point Index
       read_u32_line(pmp_infile, pmp_outfile)) // Unknown
    {
      printf("Failed reading data\n");
      fclose(pmp_infile);
      fclose(pmp_outfile);
      return 1;
    }
  }

  //----------------Point Data---------------
  for(int i = 0; i < counts[2]; i++)
  {
    if(read_matrix(pmp_infile, pmp_outfile) ||
       read_u32_line(pmp_infile, pmp_outfile) ||
       read_u16_line(pmp_infile, pmp_outfile) ||
       read_u8_line(pmp_infile, pmp_outfile))
    {
      printf("Failed reading data\n");
      fclose(pmp_infile);
      fclose(pmp_outfile);
      return 1;
    }
  }

  fclose(pmp_infile);
  fclose(pmp_outfile);
  return 0;
}

void swap_u8(uint8_t* x, int8_t* y)
{
  int temp = *x;
  *x = *y;
  *y = temp;
}

uint16_t swap_endian_u16(uint16_t x)
{
  union {
    uint16_t temp;
    uint8_t bytes[2];
  } u;

  u.temp = x;

  return ((u.bytes[0] << 8) | u.bytes[1]);
}

uint32_t swap_endian_u32(uint32_t x)
{
  union {
    uint32_t temp;
    uint8_t bytes[4];
  } u;

  u.temp = x;

  return ((u.bytes[0] << 24) | (u.bytes[1] << 16) | (u.bytes[2] << 8) | u.bytes[3]);
}

float swap_endian_f(float f)
{
  union {
    float temp;
    uint8_t bytes[4];
  } u;

  u.temp = f;

  swap_u8(&u.bytes[3], &u.bytes[0]);
  swap_u8(&u.bytes[1], &u.bytes[2]);

  return u.temp;
}


int read_u16_line(FILE* infile, FILE* outfile)
{
  char obj_buffer[32];

  if(fgets(obj_buffer, sizeof(obj_buffer), infile) == NULL)
  {
    printf("Could not read data\n");
    return 1;
  }

  uint16_t x = swap_endian_u16(atoi(obj_buffer));

  fwrite(&x, 1, 2, outfile);

  return 0;
}

int read_u32_line(FILE* infile, FILE* outfile)
{
  char obj_buffer[32];

  if(fgets(obj_buffer, sizeof(obj_buffer), infile) == NULL)
  {
    printf("Could not read data\n");
    return 1;
  }

  uint32_t x = swap_endian_u32(atol(obj_buffer));

  fwrite(&x, 1, 4, outfile);

  return 0;
}

int read_u8_line(FILE* infile, FILE* outfile)
{
  char obj_buffer[32];

  if(fgets(obj_buffer, sizeof(obj_buffer), infile) == NULL)
  {
    printf("Could not read data\n");
    return 1;
  }

  uint8_t x = atoi(obj_buffer);

  fwrite(&x, 1, 1, outfile);

  return 0;
}


int read_matrix(FILE* infile, FILE* outfile)
{
  for(int i = 0; i < 3; i++)
  {
    char obj_buffer[32];

    if(fgets(obj_buffer, sizeof(obj_buffer), infile) == NULL)
    {
      printf("Could not read data\n");
      return 1;
    }

   float x = swap_endian_f(atof(obj_buffer));

   fwrite(&x, 1, 4, outfile);
  }

   return 0;
}
