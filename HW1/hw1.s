.globl __start

.rodata
    division_by_zero: .string "division by zero"

.text
__start:
    # Read first operand
    li a0, 5
    ecall
    mv s0, a0
    # Read operation
    li a0, 5
    ecall
    mv s1, a0
    # Read second operand
    li a0, 5
    ecall
    mv s2, a0

###################################
#  TODO: Develop your calculator  #
#                                 #
###################################

# Switch the operations
    beq s1, x0, addition
    li t0, 1
    beq s1, t0, subtraction
    li t0, 2
    beq s1, t0, multiplication
    li t0, 3
    beq s1, t0, division
    li t0, 4
    beq s1, t0, minimum
    li t0, 5
    beq s1, t0, power
    li t0, 6
    beq s1, t0, factorial


addition:
    add s3, s0, s2
    jal zero, output
  
subtraction:
    sub s3, s0, s2
    jal zero, output
    
multiplication:
    mul s3, s0, s2
    jal zero, output

division:
    beq s2, x0, division_by_zero_except
    div s3, s0, s2
    jal zero, output

minimum:
    mv s3, s0
    ble s0, s2, output  
    mv s3, s2
    jal zero, output
  
power:
    li s3 1
    loop_pow:
        ble s2, x0, output
        addi s2, s2, -1
        mul s3, s3, s0
        jal zero, loop_pow
    jal zero, output

factorial:
    li s3 1
    loop_fac:
        ble s0, x0, output
        mul s3, s3, s0
        addi s0, s0, -1
        jal zero, loop_fac
    jal zero, output

output:
    # Output the result
    li a0, 1
    mv a1, s3 # output s3
    ecall

exit:
    # Exit program(necessary)
    li a0, 10
    ecall

division_by_zero_except:
    li a0, 4
    la a1, division_by_zero
    ecall
    jal zero, exit
