#include <stddef.h>
#include <stdint.h>

typedef struct ShuffMap {
    int planes[4];
    ptrdiff_t offsets[4];
} ShuffMap;

void shuff_pack(ShuffMap *mapping,
                uint8_t *in_buf[4], int in_planes, ptrdiff_t in_strides[4],
                uint8_t *out_buf[4], ptrdiff_t out_strides[4],
                unsigned int width, unsigned int height, ptrdiff_t step)
{
    ptrdiff_t stepsizes[4] = { 0 };
    unsigned int i, j;
    ptrdiff_t k;
    int p;

    for (p = 0; p < in_planes; p++)
        stepsizes[mapping->planes[p]] += step;

    for (p = 0; p < in_planes; p++) {
        uint8_t *in  = in_buf[p];
        uint8_t *out = out_buf[mapping->planes[p]] + (mapping->offsets[p] * step);

        for (i = 0; i < height; i++) {
            ptrdiff_t inpos  = 0;
            ptrdiff_t outpos = 0;

            for (j = 0; j < width; j++) {
                for (k = 0; k < step; k++)
                    out[outpos + k] = in[inpos + k];

                inpos  += step;
                outpos += stepsizes[mapping->planes[p]];
            }

            in  += in_strides[p];
            out += out_strides[mapping->planes[p]];
        }
    }
}


void shuff_unpack(ShuffMap *mapping,
                  uint8_t *in_buf[4], ptrdiff_t in_strides[4],
                  uint8_t *out_buf[4], int out_planes, ptrdiff_t out_strides[4],
                  unsigned int width, unsigned int height, ptrdiff_t step)
{
    ptrdiff_t stepsizes[4] = { 0 };
    unsigned int i, j;
    ptrdiff_t k;
    int p;

    for (p = 0; p < out_planes; p++)
        stepsizes[mapping->planes[p]] += step;

    for (p = 0; p < out_planes; p++) {
        uint8_t *in  = in_buf[mapping->planes[p]] + (mapping->offsets[p] * step);
        uint8_t *out = out_buf[p];

        for (i = 0; i < height; i++) {
            ptrdiff_t inpos  = 0;
            ptrdiff_t outpos = 0;

            for (j = 0; j < width; j++) {
                for (k = 0; k < step; k++)
                    out[outpos + k] = in[inpos + k];

                inpos  += stepsizes[mapping->planes[p]];
                outpos += step;
            }

            in  += in_strides[mapping->planes[p]];
            out += out_strides[p];
        }
    }
}
