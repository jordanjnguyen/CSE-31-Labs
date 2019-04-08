	.text
main:
	la	$a0,n1
	la	$a1,n2
	jal	swap
	li	$v0,1	# print n1 and n2; should be 27 and 14
	lw	$a0,n1
	syscall
	li	$v0,11
	li	$a0,' '
	syscall
	li	$v0,1
	lw	$a0,n2
	syscall
	li	$v0,11
	li	$a0,'\n'
	syscall
	li	$v0,10	# exit
	syscall

swap:	
	lw $t1, 0($sp) #address of the top of the stack
	lw $t0,0($a0) #addr of a0 into t0
	sw $t0,0($t1) #value of t1(addr of top of stack) put into t0
	
	lw $t0,0($a1) #load addr of a1 to t0
	sw $t0,0($a0) #store val of t0 to a1
	lw $t0,0($sp) #swap addr
	sw $t0,0($a1)
	jr $ra
	
	.data
n1:	.word	14
n2:	.word	27
