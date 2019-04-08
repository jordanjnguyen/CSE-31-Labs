.data 
str0: .asciiz "Welcome to BobCat Candy, home to the famous BobCat Bars!"
# Declare any necessary data here

greet_string: .asciiz "Welcome to BobCat Candy, home to the famous BobCat Bars!\n"
priceQ_string: .asciiz "Please enter the price of a Bobcat Bar:\n"
wrapNumQ_string: .asciiz "Please enter the number of wrappers needed to exchange for a new bar:\n"
moneyQ_string: .asciiz "How, how much do you have?\n"
good_string: .asciiz "Good! Let me run the number...\n"
bought1_string: .asciiz "You first buy "
bought2_string: .asciiz " bars.\n"
then1_string: .asciiz "Then, you will get another "
then2_string: .asciiz " bars.\n"
with1_string: .asciiz "With $"
with2_string: .asciiz ", you will recieve a maximum of "
with3_string: .asciiz " BobCat Bars!"
.text

main:
	#This is the main program.
	#It first asks user to enter the price of each BobCat Bar.
	#It then asks user to enter the number of bar wrappers needed to exchange for a new bar.
	#It then asks user to enter how much money he/she has.
	#It then calls maxBars function to perform calculation of the maximum BobCat Bars the user will receive based on the information entered. 
	#It then prints out a statement about the maximum BobCat Bars the user will receive.
				
	addi $sp, $sp -4	# Feel free to change the increment if you need for space.
	sw $ra, 0($sp)
	# Implement your main here
	
	li $v0, 4		# 4 is code for print strings
	la $a0, greet_string 	# print greet_string
	syscall
	
	li $v0, 4		# 4 is code for print strings
	la $a0, priceQ_string 	# print priceQ_string
	syscall
	
	addi $v0, $zero, 5	# user input (5 is code for integer user input)
	syscall
	
	# Print number (syscall 0) to test user input is working
	add $s0, $zero, $v0  # Get number read from previous syscall and put it in $s0, argument for next syscall
	
	
	li $v0, 4		# ask for number of wrappers
	la $a0, wrapNumQ_string 	
	syscall
	
	addi $v0, $zero, 5	# user input
	syscall
	
	add $s1, $zero, $v0	# save to $s1

	li $v0, 4		# ask for number of bars
	la $a0, moneyQ_string 	
	syscall
	
	addi $v0, $zero, 5	# user input
	syscall
	
	add $s2, $zero, $v0	# save to $s2
			
	# addi $v0, $zero, 1   # Prepare syscall 0
	# syscall  
	
	add $a1, $s0, $0	# put the s registers in the a registers
	add $a0, $s1, $0
	add $a2, $s2, $0	 
	
	li $v0, 4		# start calculation message
	la $a0, good_string 	
	syscall	
	
	add $a0, $s1, $0 
	
	#addi $sp,$sp,-4     # NEW, increment stack pointer
    	#sw $ra, 0($sp)  
	
	jal maxBars 	# Call maxBars to calculate the maximum number of BobCat Bars

	# Print out final statement here
	# add $s0, $s0, $s1
	# print $s2 and $v0
	li $v0, 4		# print last statement (1/3 parts)
	la $a0, with1_string 	
	syscall
	
	li $v0, 1		# print $s2
	add $a0, $s2, $0	
	syscall
	
	li $v0, 4		# print last statement (2/3 parts)
	la $a0, with2_string 	
	syscall
	
	li $v0, 1		# print $s0
	add $a0, $s0, $0	
	syscall
	
	li $v0, 4		# print last statement (3/3 parts)
	la $a0, with3_string 	
	syscall
	
	j end			# Jump to end of program



maxBars:
	# This function calculates the maximum number of BobCat Bars.
	# It takes in 3 arguments ($a0, $a1, $a2) as n, price, and money. It returns the maximum number of bars
	
	div $a2, $a1	# divide money by price to get num of bought bars
	add $a1, $a0, $0
	mflo $t0 
	
	add $s1, $t0, $0
	
	beq $t0, $0, skip	# Dont print the "you first buy" if you cant buy anything
	
	li $v0, 4		# print number of bars bought
	la $a0, bought1_string 	
	syscall	
	
	li  $v0, 1           # service 1 is print integer
  	add $a0, $t0, $zero  # load desired value into argument register $a0, using pseudo-op
    	syscall
    	
    	li $v0, 4		# print number of bars bought part 2
	la $a0, bought2_string 	
	syscall	

skip:	
	add $a0, $t0, $0
	
	add $s0, $s1, $0
	
	addi $sp,$sp,-4     # NEW Increment stack pointer and save ra
    	sw $ra, 4($sp)  		
			# Should be jal newbars
	jal newBars 	# Call a helper function to keep track of the number of bars.	
	
	jr $ra
	# End of maxBars

newBars:
	# This function calculates the number of BobCat Bars a user will receive based on n.
	# It takes in 2 arguments ($a0, $a1) as number of bars so far and n.
	div $a0, $a1
	mflo $t0
	
	beq $t0, $0 endBars 
	
	add $s0, $t0, $s0 	
	
	li $v0, 4		# (print 1/2) then you will get...
	la $a0, then1_string 	
	syscall	
	
	li  $v0, 1           # print the number
  	add $a0, $t0, $zero  
    	syscall	
    	
    	li $v0, 4		# (print 2/2) ...bars
	la $a0, then2_string 	
	syscall	
    	

	add $a0, $t0, $0 	# v0 and a0 are the problem  
	
	jal newBars	
	 
endBars:	
	lw $ra, 4($sp)
	addi $sp, $sp, 4
		
	jr $ra		# should be jr $ra, save $ra to the stack
	# End of newBars

end: 
	# Terminating the program
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	li $v0, 10 
	syscall
