#ifndef ENDIAN_H
#define ENDIAN_H

#include<stdint.h>
#include"types.h"

static inline void swap_8(u8* x, u8* y)
{
  u8 temp = *x;
  *x = *y;
  *y = temp;
}

static inline u16 eswap_16(u16 x)
{
  union {
    u16 temp;
    u8 bytes[2];
  } u;

  u.temp = x;

  return ((u.bytes[0] << 8) | u.bytes[1]);
}

static inline u32 eswap_32(u32 x)
{
  union {
    u32 temp;
    u8 bytes[4];
  } u;

  u.temp = x;

  return ((u.bytes[0] << 24) |
          (u.bytes[1] << 16) |
          (u.bytes[2] << 8) |
          (u.bytes[3]));
}

static inline u64 eswap_64(u64 x)
{
  union {
    u64 temp;
    u8 bytes[8];
  } u;

  u.temp = x;

  return (((u64)u.bytes[0] << 56) |
          ((u64)u.bytes[1] << 48) |
          ((u64)u.bytes[2] << 40) |
          ((u64)u.bytes[3] << 32) |
          ((u64)u.bytes[4] << 24) |
          ((u64)u.bytes[5] << 16) |
          ((u64)u.bytes[6] << 8) |
          ((u64)u.bytes[7]));
}

static inline f32 eswap_f32(f32 x)
{
  union {
    f32 temp;
    u8 bytes[4];
  } u;

  u.temp = x;

  swap_8(&u.bytes[3], &u.bytes[0]);
  swap_8(&u.bytes[2], &u.bytes[1]);

  return u.temp;
}

static inline f64 eswap_f64(f64 x)
{
  union {
    f64 temp;
    u8 bytes[8];
  } u;

  u.temp = x;

  swap_8(&u.bytes[7], &u.bytes[0]);
  swap_8(&u.bytes[6], &u.bytes[1]);
  swap_8(&u.bytes[5], &u.bytes[2]);
  swap_8(&u.bytes[4], &u.bytes[3]);

  return u.temp;
}

#endif // ENDIAN_H
