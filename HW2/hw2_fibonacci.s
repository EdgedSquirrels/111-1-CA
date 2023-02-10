.globl __start

.text
__start:
    # Read first operand
    li a0, 5
    ecall

    # Call func
    jal ra, func

    # Output
    li a0, 1
    ecall

    # Exit program(necessary)
    li a0, 10
    ecall


# func(a0(now), a1(n), arr)
func:
    addi sp, sp, -24
    sw ra, 16(sp)
    sw a0, 8(sp)
    sw t0, 0(sp)

    li t0, 1
    ble a0, t0, retr

    addi a0, a0, -1
    jal ra, func
    mv t0, a1

    addi a0, a0, -1
    jal ra, func
    add t0, t0, a1

    mv a1, t0

    lw t0, 0(sp)
    lw a0, 8(sp)
    lw ra, 16(sp)
    addi sp, sp, 24
    jalr x0, 0(ra)

retr:
    slt a1, x0, a0
    addi sp, sp, 24
    jalr x0, 0(ra)
