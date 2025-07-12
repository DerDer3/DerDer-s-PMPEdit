#include<stdio.h>
#include<stdlib.h>

#include"types.h"
#include"KCLUtil/kcl_types.h"
#include"matrix.h"
#include"KCLUtil/KCLSections.h"
#include"KCLUtil/KCLJson.h"
#include"KCLUtil/KCLCalculateTris.h"
#include"KCLUtil/KCLRead.h"

int KCLDecode(FILE* kcl_file, FILE* kcl_json)
{
  section vertex, normal, tris, octree, end;

  if(get_offsets(kcl_file, &vertex, &normal, &tris, &octree, &end))
  {
    printf("Failed getting offsets\n");
    return 1;
  }
  if(get_size(&vertex, &normal, &tris, &octree, &end))
  {
    printf("Failed getting sizes\n");
    return 1;
  }

  //---------------- Fetching of Vertex Positions ----------
  int vertex_count = vertex.size / sizeof(matrix);
  matrix* vertices = malloc(vertex_count * sizeof(matrix));

  if(get_section_matrices(kcl_file, vertex.size, vertex.offset, vertices))
  {
    printf("Failed getting vertices\n");
    return 1;
  }

  //---------------- Fetching of Normal Data ----------
  int normal_count = normal.size / sizeof(matrix);
  matrix* normals = malloc(normal_count * sizeof(matrix));

  if(get_section_matrices(kcl_file, normal.size, normal.offset, normals))
  {
    printf("Failed getting vertices\n");
    return 1;
  }

  //-------------Fetching Triangle Data---------
  int tri_count = tris.size / sizeof(triangle);
  triangle* triangles = malloc(tri_count * sizeof(triangle));

  if(get_tri_data(kcl_file, tris.offset, tris.size, triangles))
  {
    printf("Failed getting triangle data\n");
    return 1;
  }


  //---------------Calculate Faces----------
  faces* face_data = malloc(tri_count * sizeof(faces));

  if(calc_tris(vertices, normals, triangles, face_data, tri_count))
  {
    printf("Failed calculate tris\n");
    return 1;
  }

  //-------------Export to Json----------------

  if(write_kcl_json(kcl_json, face_data, tri_count))
  {
    printf("Failed writing JSON\n");
    return 1;
  }

  return 0;
}

