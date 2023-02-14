#include "transpose.h"

/* The naive transpose function as a reference. */
void transpose_naive(int n, int blocksize, int *dst, int *src) {
    for (int x = 0; x < n; x++) {
        for (int y = 0; y < n; y++) {
            dst[y + x * n] = src[x + y * n];
        }
    }
}

/* Transpose block of source matrix started at (row, col). */
void transpose_one_block(int n, int rowsize, int row, int colsize, int col, int *dst, int *src)
{
    for (int i = row; i < row + rowsize; i++)
        for (int j = col; j < col + colsize; j++)
            dst[j + i * n] = src[i + j * n];
}     

/* Implement cache blocking below. You should NOT assume that n is a
 * multiple of the block size. */
void transpose_blocking(int n, int blocksize, int *dst, int *src) {
    // YOUR CODE HERE
    for (int i = 0; i < n; i += blocksize)
    {
        int rowsize = (i + blocksize) < n ? blocksize : (n - i);
        for (int j = 0; j < n; j += blocksize)
        {
            int colsize = (j + blocksize) < n ? blocksize : (n - j);
            transpose_one_block(n, rowsize, i, colsize, j, dst, src);
        }
    }
}
