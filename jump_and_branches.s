# ---------------------------------------------------------------------------
# PURPOSE
#
# Small MIPS assembly tutorial demonstrating unconditional and conditional
# jumps.
#
#   - An unconditional jump always occurs. There is no conditions to check.
#
#   - A conditional jump is called a branch in MIPS.
#
# The tutorial introduces the following MIPS instructions.
#
#   Instruction   Meaning
#   ----------------------------------------------
#   j             Unconditional jump
#   blt           Branch if Less Than
#   bge           Branch if Greater or Equal
#
#
# In this tutorial the following control structures will be implemented
# using conditional jumps.
#
#   - if-then-else
#   - infinite loop
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

yes:	.asciiz "Yes ($t0 < $t1)\n"
no:	.asciiz "No ($t0 >= $t1)\n"


# ---------------------------------------------------------------------------
# MAIN
#
# Text segment (code) for the program.
# ---------------------------------------------------------------------------

 	.text

main:

	# Execution starts at the label main.

	addi $s0, $s0, 0 	# Initialize $s0 = 0.


  	#####
  	##### j - unconditional Jump
  	#####
  	

	# The j (Jump) instruction is used to unconditionally jump to an
	# address (label).

	# Here we use the j instruction to unconditionally jump to the
	# label increment_s1.

	j increment_s1


increment_s0:

	# This code will never be reached.
	addi $s0, $s0, 1

increment_s1:

  	addi $s1, $s1, 1

  	
  	#####
  	##### if-then-else
  	#####

	
	##### Example 1
	
	li $t0, 1 	# A
	li $t1, 9	# B

	# Pseudo code: IF A < B PRINT "Yes" ELSE PRINT "No"


	# Now, lets's translate the above pseudo code directy to assembly.

	# First we need to test if $t0 < $t1 and make a decision based on the result.
	# For this purpose we can use the blt (Branch if Less Than) instruction.

	# If $t0 < $1 jump to the label less_than, othewise continue with the next
	# instruction.

	blt $t0, $t1, less_than_1

not_less_than_1:

	# Here we know that $t0 >= $t1.

	# NOTE: As a result of using blt the else case follows directly after the test.

	la $a0, no	# Load the address of string to print.
	j print_1	# Unconditionally jump to the label print.

less_than_1:

	# Here we know that $t0 < $t1.

	la $a0, yes	# Load the addres of sting to print.

print_1:

	li $v0, 4	# System call code 4 (print_string).
	syscall		# Print string loaded in $a0.


	##### Example 2
	
	# An alternative is to use the bge (Branch if Greater or Equal) instruction.

	# If $t0 >= $t1 jump to label greater_or_equal, otherwise continute with the
	# next instruction.

	bge $t0, $t1, not_less_than_2

less_than_2:

	# Here we know that $t0 < $t1.

	# NOTE: As a result of using bge the then case follows directly after the test.

	la $a0, yes	# Load address of string to print.

	j print_2	# Unconditionally jump to the label print_2.

not_less_than_2:

  	# Here we know that $t0 >= $t1.
	la $a0, no

print_2:

	li $v0, 4	# System call code 4 (print_string).
	syscall


  	#####
  	##### Infinte loop
  	#####

	# Here we use the j instruction to construct an infinite loop.

loop_forever:

	addi $s0, $s0, 1	# Increment counter by 1.

	# When you single step, observe the highlighted instruction in the text
	# segement. Also observe that the register $s0 is highlighted in the
	# registers pane as the value of $s0 is incremented.

	j loop_forever

	# This code will never be reached.
