addu $t1, $t3, $t4
sltu $t2, $t1, $t3 # if t1 < t3, t2 = 1


finish:
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall	