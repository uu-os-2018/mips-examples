# Comments starts with the symbol '#' and continues to the end of the line.

# ---------------------------------------------------------------------------
# PURPOSE
#
# Small tutorial demonstrating the basics of MIPS assembly. The tutorial
# introduces the following MIPS instructions.
#
#   Instruction		Meaning
#   ----------------------------------------
#   li 			Load Immediate
#   la			Load Address
#   lw			Load Word
#   add			Add
#   addi 	        Add Immediate
#   sw			Store Word
#   move	        Move (copy) register
#
# The tutorial introduces the following SPIM/MARS built in system calls.
#
#   System call		Code
#   ------------------------
#   print_string	4
#   print_int		1
#   print_char		11
#   exit		10
#
# The tutorial introduces the following MIPS assembler directives.
#
#   Directive	Description
#   ----------------------------------------------------------------------
#   .data	Subsequent items are stored in the data segment.
#   .text	Subsequent items are put in the user text seg- ment.
#   .space	Allocate n bytes of space in the current segment.
#   .word n	Store the integer n as 4 byte word in the current segment.
#   .asciiz	Store the string str in memory and null-termi- nate it.
#
#
# AUTHOR
#
# Karl Marklund <karl.marklund@it.uu.se>
#
#
# HISTORY
#
# 2015-12-10
#
# First version.
# ---------------------------------------------------------------------------


# ---------------------------------------------------------------------------
# DATA SEGMENT
#
# Data used by the program is declared in the data segment.
# ---------------------------------------------------------------------------

	.data

# Store value 9 as a 4 byte (a word) size signed integer at label x.

x:	.word 9

# Reserve four bytes (a word) at label y.

y: 	.space 4

# Reserve four bytes (a word) at label z.

z: 	.space 4

# Store a null terminated string at label msg.

msg:	.asciiz "Hello world!\n"

# Store new line as a null terminated string at label nl.

nl: 	.asciiz "\n"


# ---------------------------------------------------------------------------
# MAIN
#
# Text segment (code) for the program.
# ---------------------------------------------------------------------------

	.text

main:

	# Execution starts at the label main.

	#####
	##### li - Load Immediate 
	#####
	
	# To store a value in a register, the li instruction can be used.

	# Here the immediate value 5 i loaded into register $t0.

	li $t0, 5

	# Note that li is a pseudo instruction that gets translated to a addiu
	# (Add Immediate Unsigned) instruction by the assemblator.

	#####
	##### la - Load Address
	#####
	
	# Use the la instruction to store the address of a label in a register.

	# Here the address of label x is stored in regsiter $t1.

	la $t1, x

	# NOTE: la is a pseudo instruction that the assemblator translates to
	# two instructions:
	#
	# One lui (Load Upper Immediate) instruction setting $ta (address translate).
	#
	# One ori (OR Immediate) storing the memory address of the label in register
	# $t1.

	#####
	##### lw - Load Word
	#####
	
	# To load a four byte (word) value from memory, use the lw instruction.

	# The bare machine provides only one memory-addressing mode:
	#
	#    c(rx)
	#
	# , which uses the sum of the immediate c and register rx as the address.

	# Here the value stored at the address 0 + $t1 is loaded into register $t2.

	lw $t2, 0($t1)


	# An alternative addressing mode uses only a label.

	# Here the value stored at label x is loaded into regiser $t3.
	
	lw $t3, x

	# NOTE: when using the above adressing mode (label) the assemblator
	# translates the single lw instruction to two instructions:
	#
	# One lui (Load Upper Immediate) instruction storing the memory address of
	# the label in register $at (address translation register).
	#
	# One lw instruction with  address mode c(rx), which uses the sum of the
	# immediate c and register rx as the address.

	##########################
	##### add - Addition #####
	##########################
	
	# Use the add instruction to store the result of adding two registers.

	# Here the result of adding $t0 and $t1 is stored in register $t2.

	add $t4, $t0, $t2

	# Note that 5 + 9 = 14 = 0x0000000e.


	# Use the addi instruction to add an immediate value to the content of a register.

	# Here 1 is added to $t2 and the result is stored in register $t3.
	
	#####
	##### addi - Add Immediate
	#####
	
	addi $t5, $t4, 1

	# Note that 14 + 1 = 15 = 0x0000000f

	#####
	##### sw - Store Word
	#####
	
	# Use the sw instruction to write the value in a register to memory.

	# The bare machine provides only one memory-addressing mode:
	#
	#    c(rx)
	#
	# , which uses the sum of the immediate c and register rx as the address.

	# Here the value in register $t5 is stored at address 0 + $t1.

	sw $t5, 0($t1)

	# An alternative addressing mode uses only a label.

	sw $t5, z

	# NOTE: when using the above adressing mode (label) the assemblator
	# translates the single lw instruction to two instructions:
	#
	# One lui (Load Upper Immediate) instruction storing the memory address of
	# the label in register $at (address translation register).
	#
	# One lw instruction with  address mode c(rx), which uses the sum of the
	# immediate c and register rx as the address.

	#####
	##### move
	#####

	# To copy the value in one register into another register, use the move
	# instruction.

	# Here the value in $t5 is copied into $t6.

	move $t6, $t5

	#####
	##### print_string (system call(
	#####

	# Set system call code 4 (print_string) in regsiter $v0.

	li $v0, 4

	# Load address of string to print in register $a0.

	la $a0, msg

	# Use the syscall instruction to print the string.

	syscall

	#####
	##### print_int (system call)
	#####
	
	# Set system call code 1 (print_int) in regsiter $v0.

	li $v0, 1

	# Load value to print in register $a0.

	# Can use li to print immediate value.

	li $a0, 127

	# NOTE: system call code already set to 1 (print_int) in $a0.

	# Use the syscall instruction to print the integer.

	syscall

	# Print new line.

	li $v0, 4 	# System call code 4 (print_string).
	la $a0, nl	# Address of string to print.
	syscall


	# Can use move to print value in arbitrary register.

	li $v0, 1	    # System call code 1 (print_int).
	move $a0, $t6	# Print value in $t6.
	syscall

	#####
	##### print_char (system call)
	#####

	li $v0, 11 	# System call code 11 (print_char).

	# Load ASCII value of character to print in $a0.

	li $a0, 0x40	# Print '@' (ASCII 0x40)
	syscall

	#####
	##### exit (system call)
	#####

	# Use system call code 10 to terminate normally.

  	li $v0, 10   	# System call code 10 (exit).
  	syscall
