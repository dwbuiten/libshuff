## libshuff ##

This is a simple library that generically packs or unpacks sets of planes into other sets of planes. The goal is to allow simple interoperability between things that require packed colorspaces (VFW, libavcodec) and things which are designed around planar colorspaces ([VapourSynth](https://github.com/vapoursynth/vapoursynth) and [zimg](https://github.com/sekrit-twc/zimg/)).

It currently contains no special cases or optimizations, and thus will be very slow. Speed is not the point.

**API**

The API consists of two functions, both of which have a linkable and inline version available:

- `shuff_pack()`
- `shuff_unpack()`
- `shuff_pack_inline()`
- `shuff_unpack_inline()`

For the exact parameters, see `shuff.c` or the generated `shuff.h`. They take standard sets of plane and strides, as well as a `ShuffMap` and a step size. Step size here means how many bytes per component per plane. e.g. RGB24 would be 1.

A `ShuffMap` contains info on how to map the planes to one another, by number. The `planes` member maps between plane numbers, and the `offsets` member tells it the packed offset in that plane.

**Example**

The following is an example of planar 8-bit GBR to RGB24 packing:

```C
ptrdiff_t rgb24strides[4], gbrstrides[4];
uint8_t *rgb24bufs[4], *gbrbufs[4]
ShuffMap map;

/* Assuming we have a contiguous buffer set up for both input and output. */

/* Set up each plane. */
gbrbufs[0] = my_gbr_buf;
gbrbufs[1] = my_gbr_buf + width * height;
gbrbufs[2] = gbrbufs[1] + width * height

/* Set up output bufs. */
rgb24bufs[0] = my_rgb24_buf;

/* Set up strides. */
gbrstrides[0]   = gbrstrides[1] = gbrstrides[2] = width;
rgb24strides[0] = width * 3;

ShuffMap map;

/* Map all 3 planes to one packed plane. */
map.planes[0] = 0;
map.planes[1] = 0;
map.planes[2] = 0;

/* Reorder from GBR to RGB. */
map.offsets[0] = 1;
map.offsets[1] = 2;
map.offsets[2] = 0;

/* Planar GBR to RGB24. */
shuff_pack(&map, gbrbufs, 3, gbrstrides, rgb24bufs, rgb24strides, width, height, 1);

/* The same ShuffMap can do the reverse: unpack RGB24 to Planar GBR. */
shuff_unpack(&map, rgb24bufs, rgb24strides, gbrbufs, 3, gbrstrides, width, height, 1);
```
