.data

k: .word 7
A: .word 15, 42, -22, 49, 83, 51, 59 # A [1x7] vector
B: .word 19,-73,62,30,-55,-21,31, -70,44,15,-56,73,-61,4, -93,-6,21,-80,65,-84,70, 66,-64,73,-28,49,-87,7, 8,58,15,30,62,-53,-91, 45,-66,61,46,-83,-87,-62, 18,31,66,6,96,36,77
C: .word 34, -52, 77, -51, -48, -88, -89 

msg1:     .string "C = "
spc:      .string "  "
newln:    .string "\n"


# .text means the rest of the stuff is a program or instructions to the computer
.text
.globl main                         # make main available to all project files

main:                               # There should be one main

la x2, A 
la x3, B 
la x4, C 
lw x5, k      # x5 contains the dimension of your vector/matrix


# Step 1. call the function mvmult
jal x1, mvmult

#  Step 2. call the function printResult
jal x1, printResult



# Exit the program gracefully. Don't modify anything below this.  
   la a1, newln
    li a0, 4
    ecall

exit:
    addi a0, zero, 10 
    ecall


#YOUR CODE GOES HERE 
mvmult:
add x6, zero, x5 # x5 = k, x6 = loop counter
li x7, 0         # x7 column indexing

out_loop:
bge x7, x6, stop # if j >= k stop
li x8, 0
li x9, 0

in_loop:
bge x9, x6, store_c

#A[i]
slli x10, x9, 2 # x10 = i x 4
add x11, x2, x10 #A[i]
lw x12, 0(x11)

#B[i, j]
mul x13, x9, x6 # i x k
add x13, x13, x7 # ik + j
slli x13, x13, 2 
add x14, x3, x13
lw x15, 0(x14)

mul x16, x12, x15
add x8, x8, x16
addi x9, x9, 1
j in_loop

store_c:
slli x17, x7, 2 # j x 4
add x18, x4, x17 # C[j]
sw x8, 0(x18)
addi x7, x7, 1
j out_loop

stop:
ret

#END of your CODE

# Don't Touch this (BEGIN)

printResult:
# Code to print "C = "
    la a1, msg1
    li a0, 4
    ecall 

     la x4, C 
     lw x5, k      # x5 contains the dimension of your vector/matrix
      li x6, 0     # forloop index variable
forloop: 
      slli x7, x6, 2         # x7 has the offset
      add  x8, x4, x7       # x8 points to C[i]
      lw a1, 0(x8)          # a1 has element C[i]
      li a0, 1
      ecall                 #print C[i]

      la a1, spc           # print space
      li a0, 4
      ecall 

      addi x6, x6, 1   
      beq  x6, x5, L
      j forloop
L:  jalr x0, 0(x1)

