.globl __start

.rodata
    space: .string " "

.text
__start:
    # Read n
    li a0, 5
    ecall
    mv s1, a0

    # sbrk n
    mv a1, s1
    slli a1, a1, 2
    li a0, 9
    ecall
    mv s0, a0

    # Read n number
    li t0, 0
    loop_read:
        bge t0, s1, loop_read_end
        slli t1, t0, 2
        add t1, t1, s0
        li a0, 5
        ecall
        sw a0, 0(t1)
        addi t0, t0, 1
        jal x0, loop_read
    loop_read_end:


    # Call func
    li a0, 0
    jal ra, func


    # Exit program(necessary)
    li a0, 10
    ecall


# s0:arr s1:n func(a0)
func:
    bge a0, s1, retr

    addi sp, sp, -24
    sw t0, 16(sp)
    sw ra, 8(sp)
    sw a0, 0(sp)

    mv t0, a0 

    slli a0, a0, 1
    addi a0, a0, 1
    # Left
    jal ra, func
    
     
    # Output
    slli t1, t0, 2
    li a0, 1
    add t1, t1, s0
    lw a1, 0(t1)
    ecall # print number
    li a0, 4
    la a1, space
    ecall # print space
    mv a0, t0
    
    
    addi a0, a0, 1
    slli a0, a0, 1
    # Right
    jal ra, func

    lw a0, 0(sp)
    lw ra, 8(sp)
    lw t0, 16(sp)
    addi sp, sp, 24
    jalr x0, 0(ra)

retr:
    jalr x0, 0(ra)
