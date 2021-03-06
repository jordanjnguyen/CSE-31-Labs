	.data
	# This shows you can use a .word and directly encode the value in hex
	# if you so choose
num1:	.word 0x78000000
num2:	.float 1.0
num3:	.word 0xF8000000
result:	.word 0
string: .asciiz "\n"

	.text
main:
	la $t0, num1
	lwc1 $f2, 0($t0)
	lwc1 $f4, 4($t0)
	lwc1 $f6, 8($t0)
	# Print out the values of the summands

	li $v0, 2
	mov.s $f12, $f2
	syscall

	li $v0, 4
	la $a0, string
	syscall

	li $v0, 2
	mov.s $f12, $f4
	syscall

	li $v0, 4
	la $a0, string
	syscall
	
	li $v0, 2	# new
	mov.s $f12, $f6
	syscall

	li $v0, 4
	la $a0, string
	syscall
	
	li $v0, 4
	la $a0, string
	syscall

	# Do the actual addition

	add.s $f12, $f2, $f4
	add.s $f12, $f12, $f6

	# Transfer the value from the floating point reg to the integer reg

	swc1 $f12, 12($t0)
	lw $s0, 12($t0)

	
	# At this point, $f12 holds the sum, and $s0 holds the sum which can
	# be read in hexadecimal

	li $v0, 2
	syscall
	li $v0, 4
	la $a0, string
	syscall
	
	# add again
	add.s $f12, $f6, $f2
	add.s $f12, $f4, $f12
	
	# transfer again
	swc1 $f12, 16($t0)
	lw $s0, 16($t0)
	
	# print
	li $v0, 2
	syscall
	li $v0, 4
	la $a0, string
	syscall

	# This jr crashes MARS
	# jr $ra
