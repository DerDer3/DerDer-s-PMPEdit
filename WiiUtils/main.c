#include<stdio.h>
#include<string.h>

void usage();
int KCLDecode(FILE*, FILE*);
int PMPDecode(FILE*, FILE*);
int PMPEncode(FILE*, FILE*);

int main(int argc, char* argv[])
{
  if(argc != 4)
  {
    usage();
    return 1;
  }

  FILE* infile;
  FILE* outfile;
  
  if(!strncmp(argv[1], "-pe", 3))
  {
    infile = fopen(argv[2], "r");
    outfile = fopen(argv[3], "wb");
  }
  else
  {
    infile = fopen(argv[2], "rb");
    outfile = fopen(argv[3], "w");
  }

  if(infile == NULL ||
     outfile == NULL)
  {
    printf("Could not open files\n");
    return 1;
  }

  if(!strncmp(argv[1], "-kd", 3))
    KCLDecode(infile, outfile);
  else if(!strncmp(argv[1], "-pd", 3))
    PMPDecode(infile, outfile);
  else if(!strncmp(argv[1], "-pe", 3))
    PMPEncode(infile, outfile);
  else
  {
    usage();
    return 1;
  }

 fclose(infile);
 fclose(outfile);

  return 0;
}

void usage()
{
  printf("Usage: WiiUtil -flag input output\n");
  printf("-kd - KCL Decode\n");
  printf("-pd - PMP Decode\n");
  printf("-pe - PMP Encode\n");
}
