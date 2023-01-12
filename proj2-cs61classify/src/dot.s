.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 123.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 124.
# =======================================================
dot:
    blt x0, a2, good_length
    addi a1, x0, 123 # if a2 <= 0: a1 = 123
    jal x0, except
good_length:
    slti t0, a3, 1 # t0 = (a3 < 1)
    slti t1, a4, 1 # t1 = (a4 < 1)
    or t0, t0, t1 # t0 = t0 | t1
    beq t0, x0, good_stride
    addi a1, x0, 124
    jal x0, except
good_stride:
    # Prologue

    slli a3, a3, 2 # a3 *= 4 so that a3 is the stride by byte
    slli a4, a4, 2 # a4 *= 4 so that a4 is the stride by byte
    add t0, x0, x0 # t0 = 0; t0 is a counter
    add t1, x0, x0 # t1 = 0; t1 is the sum of products    
loop_start:
    bge t0, a2, loop_end # if t0 >= a2: break
    lw t2, 0(a0) # t2 = *a0
    lw t3, 0(a1) # t3 = *a1
    mul t2, t2, t3 # t2 *= t3
    add t1, t1, t2 # t1 += t3
    add a0, a0, a3 # a0 += a3
    add a1, a1, a4 # a1 += a4
    addi t0, t0, 1
    jal x0, loop_start
loop_end:
    add a0, x0, t1 # a0 = t1

    # Epilogue

    
    ret

except:
    addi sp, sp, -4
    sw ra, 0(sp)
    jal ra, exit2