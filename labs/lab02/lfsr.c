#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"

void lfsr_calculate(uint16_t *reg) {
    uint16_t left = *reg ^ (*reg >> 2) ^ (*reg >> 3) ^ (*reg >> 5);
    left &= 1;
    *reg >>= 1;
    *reg |= (left << 15);
}

