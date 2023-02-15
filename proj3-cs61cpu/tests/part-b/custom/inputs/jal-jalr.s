    addi s1, x0, 10
    lui a0, 123456
    addi a0, x0, -444
    jal ra, square
    xor s2, a1, a0
    jal x0, exit

square:
    mulh a1, a0, a0
    mul a0, a0, a0
    jalr x0, ra, 0
    
exit:
    sub t0, a1, s0
