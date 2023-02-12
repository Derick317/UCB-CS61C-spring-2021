    li t0, 65528
    addi t1, x0, 9
    sw t1, 0(t0)
main:
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    # ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    # ecall # Print newline

    addi a0, x0, 10
    jal ra, all_exit

factorial:
    # YOUR CODE HERE
    addi t0, x0, 1 # t0 stores the result
    add t1, x0, a0 # t1 is the multiplier
loop:
    beq t1, x0, exit
    # Now, t1 != 0, an iteration starts
    mul t0, t0, t1
    addi t1, t1, -1
    jal x0, loop
exit:
    add a0, x0, t0
    jr ra
    
all_exit:
    
