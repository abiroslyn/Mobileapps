.data
list: .space 6 #can store 6 characters into a string named "list"
invalid: .asciiz "NaN\n"

.text
.globl main

main:
  li $s4, 0
  li $v0, 8 #reads strings into list string
  la $a0, list
  li $a1, 5 #input no more than 10 characters
  syscall

jal SubA

exit:
  li $v0, 10
  syscall

SubA:

  move $s2, $ra
  jal SubB
  move $ra, $s2
  jr $ra

SubB:

move $s0, $ra #1
begin:
  li $t2, 0 #$i=0;
  li $s5, 6 #exit condition - exit loop if at 10th character

loop:
    lb $t0, ($a0) #loads byte of user input into $t0
    addi $t2, $t2, 1 #add 1 after each iteration, i++;
    beq $s5, $t2, exitB #jump to afterloop after 10th character is reached
    addi $a0, $a0, 1
    jal SubC
    j loop

exitB:
  move $ra, $s0 #2
  jr $ra

SubC:

L1: li $t4, '0'
    li $t5, '9'
    blt $t0, $t4, L2 #test the next condition if this falls through
    bgt $t0, $t5, L2 #move to L2 if this isn't true
    addi $s3, $t0, -48 #subtract 48, place result into $s3
    add $s4, $s4, $s3
    jr $ra

L2: li $t4, 'a'
    li $t5, 's'
    blt $t0, $t4, L3 #test the next condition if this falls through
    bgt $t0, $t5, L3 #move to L3 if this isn't true
    addi $s3, $t0, -87 #subtract 87, place result into $s3
    add $s4, $s4, $s3
    jr $ra

L3: li $t4, 'A'
    li $t5, 'S'
    blt $t0, $t4, L4 #test the next condition if this falls through
    bgt $t0, $t5, L4 #move to ELSE if this isn't true
    addi $s3, $t0, -55 #subtract 55, place result into $s3
    add $s4, $s4, $s3
    jr $ra

L4: li $t4, 's'
    bgt $t0, $t4, EL
    j afterloop

EL: li $v0, 4
    la $a0, invalid
    syscall
    jr $ra

afterloop:
  li $v0, 1
  move $a0, $s4
  syscall

end:
  li $v0, 10
  syscall
