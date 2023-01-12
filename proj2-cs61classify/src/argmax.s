.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 120.
# =================================================================
argmax:
    bge x0, a1, except # make sure a1 != 0, i.e. a1 >= 1
    # Prologue

    addi t0, x0, 1 # t0 = 1, t0 is a counter
    add t1, x0, x0 # t1 = 0, t1 is the index of the maximum number so far
    lw t2, 0(a0) # t2 = *a0, t2 is the maximum number so far
    addi a0, a0, 4
loop_start:
    beq t0, a1, loop_end # if t0 == a0: break
    lw t3, 0(a0) 
    bge t2, t3, loop_continue # if t2 >= t3: continue
    add t1, t0, x0 # t1 = t0
    add t2, t3, x0
loop_continue:
    addi t0, t0, 1
    addi a0, a0, 4
    jal x0, loop_start
loop_end:
    add a0, t1, x0

    # Epilogue


    ret

except:
    addi sp, sp, -4
    sw ra, 0(sp)
    addi a1, x0, 120
    jal ra, exit2