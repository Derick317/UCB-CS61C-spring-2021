.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 121.
    # - If malloc fails, this function terminates the program with exit code 116 (though we will also accept exit code 122).
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    addi t0, x0, 5
    beq a0, t0, good_argc
    addi a1, x0, 121
    jal x0, exit2
good_argc:

    addi sp, sp, -52
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw ra, 16(sp)
    sw s4, 36(sp)
    sw s5, 48(sp)

    lw s0, 4(a1) # M0_PATH
    lw s1, 8(a1) # M1_PATH
    lw s2, 12(a1) # INPUT_PATH
    lw s3, 16(a1) # OUTPUT_PATH
    mv s4, a2 # print_classification, if this is zero

	# =====================================
    # LOAD MATRICES
    # =====================================






    # Load pretrained m0
    mv a0, s0
    addi a1, sp, 20 # point to number of rows in matrix 0 
    addi a2, sp, 24 # point to number of columns in matrix 0 
    jal ra, read_matrix
    mv s0, a0
    
    # Load pretrained m1
    mv a0, s1
    addi a1, sp, 28 # point to number of rows in matrix 1
    addi a2, sp, 32 # point to number of columns in matrix 1
    jal ra, read_matrix
    mv s1, a0

    # Load input matrix
    mv a0, s2
    addi a1, sp, 40 # point to number of rows of input matrix
    addi a2, sp, 44 # point to the number of columns of input matrix
    jal ra, read_matrix
    mv s2, a0

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    # Allocate space for m0 * input
    lw t0, 20(sp)
    lw t1, 44(sp)
    mul a0, t0, t1
    slli a0, a0, 2
    jal ra, malloc
    beq a0, x0, malloc_fails
    mv s5, a0 # s5 points to m0 * input

    mv a0, s0
    lw a1, 20(sp)
    lw a2, 24(sp)
    mv a3, s2
    lw a4, 40(sp)
    lw a5, 44(sp)
    mv a6, s5
    jal ra, matmul
    
    # Relu
    mv a0, s5
    lw t0, 20(sp)
    lw t1, 44(sp)
    mul a1, t0, t1
    jal ra, relu

    # Free m0 and input
    mv a0, s0
    jal ra, free
    mv a0, s2
    jal ra, free

    # Allocate space for m1 * ReLU(m0 * input)
    lw t0, 28(sp)
    lw t1, 44(sp)
    mul a0, t0, t1
    slli a0, a0, 2
    jal ra, malloc
    beq a0, x0, malloc_fails
    mv s0, a0 # Now, s0 points to m1 * ReLU(m0 * input)

    # Multiply m1 and ReLU(m0 * input)
    mv a0, s1
    lw a1, 28(sp)
    lw a2, 32(sp)
    mv a3, s5
    lw a4, 20(sp)
    lw a5, 44(sp)
    mv a6, s0
    jal ra, matmul

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    mv a0, s3
    mv a1, s0
    lw a2, 28(sp)
    lw a3, 44(sp)
    jal ra, write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, s0
    lw t0, 28(sp)
    lw t1, 44(sp)
    mul a1, t0, t1
    jal ra, argmax
    mv s2, a0 # Now, s2 is the predicted label

    # Print classification
    bne s4, x0, finish_print
    mv a1, s2
    jal ra, print_int
    # Print newline afterwards for clarity
    addi a1, x0, 10 # 10 in decimal is '\n'
    jal ra, print_char
finish_print:
    mv a0, s2

    # Free memory
    mv a0, s1 # free matrix 1
    jal ra, free
    mv a0, s5 # free ReLU(m0 * input)
    jal ra, free
    mv a0, s0 # free m1 * ReLU(m0 * input)
    jal ra, free
    
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw ra, 16(sp)
    lw s4, 36(sp)
    lw s5, 48(sp)
    addi sp, sp, 52

    ret

malloc_fails:
    addi sp, sp, -4
    sw ra, 0(sp)
    addi a1, x0, 116
    jal ra, exit2