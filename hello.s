.section .text.start_
.global _start
.global main
_start:

    # load address
    lui t0, 0x10000

    # H
    andi t1, t1, 0
    addi t1, t1, 72
    sw t1, 0(t0)

    # E
    andi t1, t1, 0
    addi t1, t1, 101
    sw t1, 0(t0)

    # L
    andi t1, t1, 0
    addi t1, t1, 108
    sw t1, 0(t0)

    # L
    andi t1, t1, 0
    addi t1, t1, 108
    sw t1, 0(t0)

    # O
    andi t1, t1, 0
    addi t1, t1, 111
    sw t1, 0(t0)
    
    # \n
    andi t1, t1, 0
    addi t1, t1, 10
    sw t1, 0(t0)


loop: j loop
.end _start

finish:
    beq t1, t1, finish
