# ---------------------------------------------------------------------------
# PURPOSE
#
# Small tutorial demonstrating how to use arrays in MIPS assembly.
#
# Concepts introduced:
#
#   - Array of integers.
#   - Array of strings.
#
#   - Loading an elment of an array to a register.
#   - Looping over all elements in an array.
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

# Store three consequtive 4 byte words in memory.

int_array:  .word 10, 11, 12

# Three stirngs. Each label is an address (pointer) to a null terminated string.

one:	.asciiz "One\n"
two: 	.asciiz "Two\n"
three:	.asciiz "Three\n"

# Here each value in str_array is a label that gets replaced by the label
# address by the assembler. Each such label is a address (pointer) to a
# null terminated string. Hence this is an array of pointer to strings, that is,
# an array of strings.

str_array: .word one, two, three


# ---------------------------------------------------------------------------
# MAIN
#
# Text segment (code) for the program.
# ---------------------------------------------------------------------------

	.text

main:

	# Execution starts at the label main.

  	
  	#####
  	##### Array of integers
  	#####
  	
	la $s0, int_array	# Address of 1st element in array.

	lw $t0, 0($s0)		# Load 1st element of array into $t0 (offset 0).
	lw $t1, 4($s0)		# Load 2nd element of array into $t1 (offset 4).
	lw $t2, 8($s0)		# Load 3rd element of array into $t2 (offset 8).


  	#####
  	##### Array of strings
  	#####
  	
	li $v0, 4		# System call code 4 (print_str).

	la $s1, str_array	# Address of 1st element in array.

	lw $a0, 0($s1)		# Print 1st element (offset 0).
	syscall

	lw $a0, 4($s1)		# Print 2nd element (offset 4).
	syscall

	lw $a0, 8($s1)		# Print 3rd element (offset 8).
	syscall


  	#####
  	##### Loop over all strings in array of strings
  	#####
  	
	la $t0, str_array	# Address of 1st element in array.
	li $v0, 4		# System call code 4 (print_string).
	li $t1, 0		# Initialize array offset.
	li $t2, 8		# Last offset.

loop:

	# Use the address mode label(register).

	lw $a0, str_array($t1)	# Load value at address str_array + $t1 (offset).
	syscall

	addi $t1, $t1, 4	# Next element, i.e., increment offset by 4.

	# Done or loop once more?

	ble $t1, $t2, loop



	li $v0, 10   		# System call code 10 (exit).
 	syscall
