	.data

msg:	.asciiz "Hello World!"

	.text
	
main:
	li $v0, 4 	# Systemcall code print_str
	la $a0, msg
	syscall
	
	li $v0, 10	# Systemcall code exit
	syscall
