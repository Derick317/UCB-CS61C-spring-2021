addi s0, x0, 10
addi s1, x0, 9
bge s1, s0, label1
addi t0, x0, 1221
label1:
xori t0, s0, -332
bge s0, s1, label2
addi t0, x0, 12
label2:
xori t0, s0, 232
addi s1, s1, -100
addi s0, s0, -200
bge s0, s1, label3
addi t0, x0, 121
label3:
xori t0, s0, 352
add s0, x0, s1
bge s0, s1, label4
addi t0, x0, 125
label4:
xori t0, s0, 278
