.data
invalid: .asciiz "Invalid Input!\n"
list: .space 1002 #can store 1000 characters into a string named "list"
.text
.globl main

main:
  li $v0, 8 #reads strings into list string
  la $a0, list
  li $a1, 1001 #input no more than 1001 characters
  syscall

jal conversion

li $v0, 10
syscall

conversion:

li $s1, '0' #character 0
li $s2, '9' #character 9
li $t4, 'a' #character a - lower boundary for base 29
li $t5, 's' #character s - upper boundary for base 29
li $t6, 'A' #character A - lower boundary for base 29
li $t7, 'S' #character S - upper boundary for base 29
li $s3, 0 #result variable
li $s4, 0 #variable which will print the final result
li $t3, -1 #obtains length of string
li $t2, 4 #print invalid input if string length > 4

length:
  lb $t0, ($a0)
  beq $t0, $0, begin
  addi $t3, $t3, 1 #increment length
  addi $a0, $a0, 1
  bgt $t3, $t2, EL
j length

begin:
  move $s0, $t3
  li $s5, 1 #used to square, cube, etc 29
  li $s6, 29 #base
  li $s7, 0 #product of 29 * 1
  la $a0, list

loop:
    lb $t1, ($a0)
    addi $s0, $s0, -1
    beq $s0, $zero, afterloop #jump to afterloop after 10th character is reached
    addi $a0, $a0, 1 #add 1 after each iteration, i++;
    mul $s7, $s6, $s5

L1: blt $t1, $s1, L2 #test the next condition if this falls through
    bgt $t1, $s2, L2 #move to L2 if this isn't true
    addi $s3, $t1, -48 #subtract 48, place result into $s3
    add $s3, $s3, $zero
    mul $s7, $s6, $s5
   mul $s4, $s7, $s3
   add $s4, $s4, $zero
   j FN

L2: blt $t1, $t4, L3 #test the next condition if this falls through
    bgt $t1, $t5, L3 #move to L3 if this isn't true
    addi $s3, $t1, -87 #subtract 87, place result into $s3
    add $s3, $s3, $zero
    mul $s7, $s6, $s5

L3: blt $t1, $t6, EL #test the next condition if this falls through
    bgt $t1, $t7, EL #move to ELSE if this isn't true
    addi $s3, $t1, -55 #subtract 55, place result into $s3
    add $s3, $s3, $zero
    mul $s7, $s6, $s5
 
    mul $s4, $s7, $s3
    add $s4, $s4, $zero
    j FN

EL: li $v0, 4
    la $a0, invalid
    syscall
    j endfunct
FN: j loop

afterloop:
  li $v0, 1
  move $a0, $s4 #print contents of s4 register
  syscall
endfunct:
  jr $ra #exit function, return to caller

