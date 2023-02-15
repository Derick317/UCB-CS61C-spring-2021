addi s0, x0, 128
lui a0, 1034567
lui s1, 987654
addi s1, s1, 123
sw a0, 0(s0)
sw s1, 16(s0)
lb t1, 16(s0)
lb t0, 18(s0)
lb t0, 17(s0)
lb t1, 0(s0)
lb t0, 1(s0)
lb t0, 2(s0)
sb a0, 12(s0)
lw t0, 12(s0)
sb a0, 13(s0)
lw t0, 12(s0)
sb s1, 14(s0)
lw t0, 12(s0)
