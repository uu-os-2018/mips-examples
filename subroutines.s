# ---------------------------------------------------------------------------
# PURPOSE
#
# Small tutorial demonstrating how to use subroutines in MIPS assembly.
#
# Concepts introduced:
#
#   - jal (Jump And Link)
#   - jr  (Jump Register)
#   - $ra (Return Address)
#   - register use convention
#
# AUTHOR
#
# Karl Marklund <karl.marklund@it.uu.se>
#
# HISTORY
#
# 2018-01-14
#
# First version.
# ---------------------------------------------------------------------------

	.data

msg:	.asciiz "Hello!\n"

nl: 	.asciiz "\n"
bang: 	.asciiz "!\n"

name_1: .asciiz "Nina"
name_2: .asciiz "Mike"


hi:  	.asciiz "Hi "

	.text
	
main:

	# A subroutine is a sequence of program instructions that perform a 
	# specific task, packaged as a unit. This unit can then be used in 
	# programs wherever that particular task should be performed.
	#
	# https://en.wikipedia.org/wiki/Subroutine
	
	
	# The jal (Jump And Link) instruction jumps to a specified address 
	# (register or label) and sets $ra (Return Address) to the address
	# of the next instruction. 
	

	# Jump to label hello and set $ra to the address of the next 
	# instruction, i.e., the address of the li $0, 0x1234abcd instruction.
	
	jal hello
	
	li $t0, 0x1234abcd
	
	jal hello	
	
	# Register use convention: 
	
	# Registers $a0–$a3 are used to pass the first four arguments to sub routines
        # (remaining arguments are passed on the stack).
                
        # Registers $v0 and $v1 are used to return values from subroutines 
        # (remaining results are pushed on the stack).
        
        # Registers $s0–$s7 are callee-saved registers that hold long-lived
	# values that should be preserved across calls. If a subroutine uses 
	# these registers their values must first be saved (usually by pushing 
	# them to the stack) and restored before returning (usually by popping 
	# from stack. 
        
	# Compute the sum of 1, 2 and 3.
	li $a0, 1
	li $a1, 2
	li $a2, 3
	jal compute
	
	# Result now in $v0. 
	
	# Print result. 
	
	# Copy result to $a0. 
	move $a0, $v0

	li $v0, 1 	# Systemcall code print_int
	syscall         # Print value in $a0.
	
	# Print new line.

	li $v0, 4 	# Systemcall code print_str
	la $a0, nl
	syscall
	
	
	la $a0, name_1
	jal say_hi
	
	la $a0, name_2
	jal say_hi

	li $v0, 10   		# System call code 10 (exit).
 	syscall


# ---------------------------------------------------------------------------
# Subroutine hello
# 
# Prints the string "Hello!\n"
# ---------------------------------------------------------------------------
hello: 
	li $v0, 4 	# Systemcall code print_str
	la $a0, msg
	syscall
	
	# Return from subroutine hello.
	
	# Use jr (Jump Register) to jump to the address saved by jal in $ra.
	jr $ra


# ---------------------------------------------------------------------------
# Subroutine compute
#
# Argument(s): Three numbers in $a0, $a1 and $a2.
#
# Return value in $v0: The sum of $a0, $a1 and $a2.
# ---------------------------------------------------------------------------
compute:
	add $t0, $a0, $a1
	add $v0, $t0, $a2
	jr $ra	


# ---------------------------------------------------------------------------
# Subroutine say_hi
#
# Argument(s): $a - Address to a <name> string.
#
# Side effects: Prints "Hi <name>
# ---------------------------------------------------------------------------	
say_hi:
	move $t0, $a0
	
	li $v0, 4 	# Systemcall code print_str
	la $a0, hi
	syscall
	
	move $a0, $t0
	syscall
	
	la $a0, bang
	syscall
		
	jr $ra

   
