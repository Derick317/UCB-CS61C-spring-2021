.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4-byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 116.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 117.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 118.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 119.
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -28
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw ra, 24(sp)

    add s0, x0, a0 # s0 is the pointer to string representing the filename
    add s1, x0, a1 # a pointer to an integer, we will set it to the number of rows
    add s2, x0, a2 # a pointer to an integer, we will set it to the number of columns
    
    # open the file
    add a1, x0, s0
    addi a2, x0, 0
    jal ra, fopen
    addi t0, x0, -1
    bne a0, t0, good_open
    addi a1, x0, 117
    jal x0, except
good_open:
    add s3, x0, a0 # s3 is the file descripter

    # read the number of rows
    add a1, x0, s3 # a1 is now the file descriptor
    add a2, x0, s1 # a2 is a pointer to the number of rows
    addi a3, x0, 4 # a3 is the number of bytes to be read.
    jal ra, fread
    addi t0, x0, 4 # t0 = 4
    bne a0, t0, except_118

    # read the number of columns
    add a1, x0, s3 # a1 is now the file descriptor
    add a2, x0, s2 # a2 is a pointer to the number of rows
    addi a3, x0, 4 # a3 is the number of bytes to be read.
    jal ra, fread
    addi t0, x0, 4 # t0 = 4
    bne a0, t0, except_118

    # malloc space
    lw t0, 0(s1)
    lw t1, 0(s2)
    mul t0, t0, t1
    slli s4, t0, 2 # s4 is the number of bytes to be allocated
    add a0, x0, s4
    jal ra, malloc
    bne a0, x0, good_malloc
    addi a1, x0, 116
    jal x0, except
good_malloc:
    add s5, x0, a0 # s5 is the address of matrix

    # read elements of matrix
    add a1, x0, s3 # a1 is now the file descriptor
    add a2, x0, s5 # a2 is a pointer to the matrix
    add a3, x0, s4 # a3 is the number of bytes to be read
    jal ra, fread
    bne a0, s4, except_118

    # close the file
    add a1, x0, s3
    jal ra, fclose
    beq a0, x0, good_close
    addi a1, x0, 119
    jal x0, except
good_close:
    add a0, x0, s5

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw ra, 24(sp)
    addi sp, sp, 28

    ret

except:
    addi sp, sp, -4
    sw ra, 0(sp)
    jal ra, exit2

except_118:
    addi sp, sp, -4
    sw ra, 0(sp)
    addi a1, x0, 118
    jal ra, exit2