.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 115.
# ==============================================================================
relu:
    # Prologue
    bge x0, a1, except # if 0 >= a1, i.e. a1 < 1
    add t0, x0, x0 # t0 = 0, t0 is a counter
loop_start:
    beq t0, a1, loop_end
    lw t1, 0(a0) # t1 = *a0
    bge t1, x0, loop_continue
    sw x0, 0(a0) # *a0 = 0
loop_continue:
    addi a0, a0, 4
    addi t0, t0, 1
    jal x0, loop_start
loop_end:


    # Epilogue


	ret

except:
    addi sp, sp, -4
    sw ra, 0(sp)
    addi a1, x0, 115
    jal ra, exit2