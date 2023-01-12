.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 112.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 113.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 114.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp -28
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw ra, 20(sp)

    mv s0, a0 # the pointer to string representing the filename
    mv s1, a1 # the pointer to the start of the matrix in memory
    mv s2, a2 # the number of rows in the matrix
    mv s3, a3 # the number of columns in the matrix

    # Open file
    mv a1, s0
    addi a2, x0, 1
    jal ra, fopen
    addi t0, x0, -1
    bne a0, t0, good_open
    addi a1, x0, 112
    jal x0, except
good_open:
    mv s4, a0 # s4 is the file descriptor

    # write # of rows
    mv a1, s4
    sw s2, 24(sp)
    addi a2, sp, 24
    addi a3, x0, 1
    addi a4, x0, 4
    jal ra, fwrite
    addi t0, x0, 1
    blt a0, t0, except_113

    # write # of columns
    mv a1, s4
    sw s3, 24(sp)
    addi a2, sp, 24
    addi a3, x0, 1
    addi a4, x0, 4
    jal ra, fwrite
    addi t0, x0, 1
    blt a0, t0, except_113

    # write elements of the matrix
    mv a1, s4
    mv a2, s1
    mul a3, s2, s3
    addi a4, x0, 4
    jal ra, fwrite
    mul t0, s2, s3
    blt a0, t0, except_113

    # Close the file
    mv a1, s4
    jal ra, fclose
    beq a0, x0, good_close
    addi a1, x0, 114
    jal x0, except
good_close:
    
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw ra, 20(sp)
    addi sp, sp, 28
    ret

except:
    addi sp, sp, -4
    sw ra, 0(sp)
    jal ra, exit2

except_113:
    addi a1, x0, 113
    jal x0, except