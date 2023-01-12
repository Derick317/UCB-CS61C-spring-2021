.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 125.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 126.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 127.
# =======================================================
matmul:

    # Error checks
    slti t0, a1, 1 # t0 = (a1 < 1)
    slti t1, a2, 1 # t1 = (a2 < 1)
    or t0, t0, t1 # t0 = t0 | t1
    beq t0, x0, good_dim_one
    addi a1, x0, 125
    jal x0, except
good_dim_one:
    slti t0, a4, 1 # t0 = (a1 < 1)
    slti t1, a5, 1 # t1 = (a2 < 1)
    or t0, t0, t1 # t0 = t0 | t1
    beq t0, x0, good_dim_two
    addi a1, x0, 126
    jal x0, except
good_dim_two:
    beq a2, a4, dim_match
    addi a1, x0, 127
    jal x0, except
dim_match:
    # Prologue
    addi sp, sp, -36
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw ra, 32(sp)

    add s0, x0, x0 # i of m0 and the product. Initially, i = 0
    add s2, x0, a0 # a pointer to m0
    add s3, x0, a3 # the starter pointer to m1
    add s4, x0, a1 # the # of rows (height) of m0
    add s5, x0, a5 # the # of column (width) of m1
    add s6, x0, a2 # the # of columns (width) of m0, also the # of rows (height) of m1
    add s7, x0, a6 # a pointer to the product
outer_loop_start:
    bge s0, s4, outer_loop_end
    add s1, x0, x0 # j of m1 and the product. Initially, j = 0
inner_loop_start:
    bge s1, s5, inner_loop_end
    add a0, x0, s2 # (dot) the pointer to the start of v0
    slli t0, s1, 2 # t0 = 4 * s1
    add a1, t0, s3 # (dot) the pointer to the start of v1
    add a2, x0, s6 # (dot) the length of the vectors
    addi a3, x0, 1 # (dot) the stride of v0
    add a4, x0, s5 # (dot) the stride of v1
    jal ra, dot
    sw a0, 0(s7)
    addi s1, s1, 1
    addi s7, s7, 4
    jal x0, inner_loop_start
inner_loop_end:
    slli t0, s6, 2 # t0 = 4 * s6
    add s2, s2, t0
    addi s0, s0, 1
    jal x0, outer_loop_start
outer_loop_end:


    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw ra, 32(sp)
    addi sp, sp, 36
    ret


except:
    addi sp, sp, -4
    sw ra, 0(sp)
    jal ra, exit2