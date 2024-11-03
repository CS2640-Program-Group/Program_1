# Elijah Rosal, Caleb Szeto, Ryan Hansen, Eric Chen, Cameron Bolanos
# CS2640
# 10-23-2024
# Program 1: Getting Familiar with Assembly
# Github Repo Link: https://github.com/CS2640-Program-Group/Program_1 

.data
buffer: .space 20
prompt1: .asciiz "Enter the first integer: "
prompt2: .asciiz "Enter the second integer: "
invalid: .asciiz "Invalid input. Enter a valid integer.\n"
result1: .asciiz "The first integer you entered is: "
result2: .asciiz "The second integer you entered is: "
equals: .asciiz " = "
addSign: .asciiz " + "
subSign: .asciiz " - "
mulSign: .asciiz " x "
divSign: .asciiz " / "
divZero: .asciiz "Division by 0"
newline: .asciiz "\n"
equal_msg: .asciiz "User inputs are the same"
not_equal_msg: .asciiz "User inputs are different" 

.text

main: 
# Task 1
input_first:
	li $t3, 0 		# Initialise checkpoint
	li $s0, 0		# Initialize $s0 to hold the result (integer)
	# Prompt for the first integer
	li $v0, 4		# Load syscall for print_string
        la $a0, prompt1		# Load address of prompt1
        syscall			# Print the prompt

        # Read the string input (user input)
        li $v0, 8		# Load syscall for read_string
        la $a0, buffer		# Load buffer address
        li $a1, 20		# Specify max length for input (20 characters)
        syscall			# Read the string

        # Convert string to integer and validate
        jal check_numeric	# Jump to numeric check subroutine
	
input_second:
	li $t3, 1		# Update checkpoint
	li $s1, 0		# Initialize $s1 to hold the result (integer)
	# Prompt for the second integer
	li $v0, 4		# Load syscall for print_string
        la $a0, prompt2		# Load address of prompt1
        syscall			# Print the prompt

        # Read the string input (user input)
        li $v0, 8		# Load syscall for read_string
        la $a0, buffer		# Load buffer address
        li $a1, 20		# Specify max length for input (20 characters)
        syscall			# Read the string

        # Convert string to integer and validate
        jal check_numeric	# Jump to numeric check subroutine
printing:
	# Output the first integer
	li $v0, 4		# Load syscall for print_string
	la $a0, result1		# Load address of result1
	syscall			# Print the result prompt

	jal print_first		# Jump and link to print_first subroutine
	
	# Output newline
	jal print_newline	# Jump and link to print_newline subroutine

	# Output the second integer
	li $v0, 4		# Load syscall for print_string
	la $a0, result2		# Load address of result2
	syscall			# Print the result prompt

	jal print_sec		# Jump and link to print_sec subroutine
	
	# Output newline
	jal print_newline	# Jump and link to print_newline subroutine

# Task 2
	# Add the integers together
addition:
	add $t2, $s0, $s1	# Adds the two integers
		
	# Print Result
	jal print_first		# Jump and link to print_first subroutine
	
	li $v0, 4		# Load syscall for print_string
	la $a0, addSign		# Load address of addSign
	syscall			# Print ' + '
	
	jal print_sec		# Jump and link to print_sec subroutine

	jal print_equals		# Jump and link to print_equals subroutine
	
	move $a0, $t2		# Move the result of $s0 - $s1 into $a0 for printing
	li $v0, 1		# Load syscall for print_int
	syscall			# Print the integer value
	
	# Output newline
	jal print_newline	# Jump and link to print_newline subroutine
		
	# Subtract the first integer from the second
subtraction:
	sub $t2, $s0, $s1
		
	# Print Result
	jal print_first		# Jump and link to print_first subroutine
	
	li $v0, 4		# Load syscall for print_string
	la $a0, subSign		# Load address of subSign
	syscall			# Print ' + '
	
	jal print_sec		# Jump and link to print_sec subroutine
	
	jal print_equals		# Jump and link to print_equals subroutine
	
	move $a0, $t2		# Move the result of $s0 + $s1 into $a0 for printing
	li $v0, 1		# Load syscall for print_int
	syscall			# Print the integer value
	
	# Output newline
	jal print_newline	# Jump and link to print_newline subroutine
		
	# Multiply the two integers together
multiply:
	mul $t2, $s0, $s1
	
	# Print Result
	jal print_first		# Jump and link to print_first subroutine
	
	li $v0, 4		# Load syscall for print_string
	la $a0, mulSign		# Load address of mulSign
	syscall			# Print ' + '
	
	jal print_sec		# Jump and link to print_sec subroutine
	
	jal print_equals		# Jump and link to print_equals subroutine
	
	move $a0, $t2		# Move the result of $s0 x $s1 into $a0 for printing
	li $v0, 1		# Load syscall for print_int
	syscall			# Print the integer value
	
	# Output newline
	jal print_newline	# Jump and link to print_newline subroutine
	
	# Divide the first integer by the second
division:
	beq $s1, 0, division_by_zero
	div $t2, $s0, $s1
		
	# Print Result
	jal print_first		# Jump and link to print_first subroutine
	
	li $v0, 4		# Load syscall for print_string
	la $a0, divSign		# Load address of divSign
	syscall			# Print ' + '
	
	jal print_sec		# Jump and link to print_sec subroutine
	
	jal print_equals		# Jump and link to print_equals subroutine
	
	move $a0, $t2		# Move the result of $s0 / $s1 into $a0 for printing
	li $v0, 1		# Load syscall for print_int
	syscall			# Print the integer value
	
	# Output newline
	jal print_newline	# Jump and link to print_newline subroutine
		
	j equality		# Jump past division_by_zero
	
	division_by_zero:
		li $v0, 4		# Load syscall for print_string
		la $a0, divZero		# Load address of divZero
		syscall			# Print divZero
		# Output newline
		jal print_newline	# Jump and link to print_newline subroutine
		
# Task 3
	# Equal or Not
equality:
	beq $s0, $s1, equal
		
	li $v0, 4		# Load syscall for print_string
	la $a0, not_equal_msg	# Load the address of not_equal_msg
	syscall			# Print message for $s0 != $s1
		
	j end
		
	equal:
		li $v0, 4		# Load syscall for print_string
		la $a0, equal_msg	# Load the address of the equal_msg
		syscall			# Print message for $s0 = $s1
	
end:
	# Exit the program
	li $v0, 10		# Load syscall for exit
	syscall			# Exit the program
	
# Subroutines

check_numeric:
	la $t0, buffer		# Load buffer address into $t0
	li $t2, 0		# Initialize sign flag (0 = positive, 1 = negative)

	# Check if the first character is a minus sign for negative numbers
        	lb $t1, 0($t0)			# Load the first byte from buffer
        	beq $t1, 0, invalid_input	# If first character is null, input is invalid
        	beq $t1, '-', negative		# If the first character is '-', set flag to negative
        	j process_digits			# If not '-', process digits
	
negative:
        	li $t2, 1              # Set sign flag to 1 (negative)
	addi $t0, $t0, 1       # Move to the next character to process digits

process_digits:
loop:	
	lb $t1, 0($t0)			# Load byte from buffer
	beq $t1, 10, end_check		# If we encounter a null terminator (10), exit loop
	blt $t1, '0', invalid_input	# If char < '0', it's not a digit
	bgt $t1, '9', invalid_input	# If char > '9', it's not a digit

        	# Convert char to integer and add to result
        	sub $t1, $t1, '0'		# Convert ASCII character to integer
        	beq $t3, 1, second		# Check if we are working with the second integer
        	mul $s0, $s0, 10			# Shift previous result by 10 (for decimal place)
        	add $s0, $s0, $t1		# Add the digit to $s0
        	addi $t0, $t0, 1			# Move to the next character in the buffer
        	j loop				# Repeat for the next character
        
        	second:
        	mul $s1, $s1, 10			# Shift previous result by 10 (for decimal place)
        	add $s1, $s1, $t1		# Add the digit to $s1
        	addi $t0, $t0, 1			# Move to the next character in the buffer
	j loop				# Repeat for the next character

end_check:
	# If the sign flag is set, make the result negative
	beq $t2, 0, done		# If sign flag is 0 (positive), skip negation
	beq $t3, 1, other
	sub $s0, $zero, $s0	# Negate $s0 if it's a negative number
	j done
	other:
	sub $s1, $zero, $s1	# Negate $s1 if it's a negative number

done:
	jr $ra			# Return to main program

invalid_input:
	jal print_newline	# Jump and link to print_newline subroutine
	li $v0, 4		# Load syscall for print_string
	la $a0, invalid		# Load address of invalid input message
	syscall			# Print invalid input message
	beq $t3, 1, input_second	# Jump back to input_second
	j input_first		# Jump back to input_first to prompt again
	
print_first:
	move $a0, $s0		# Move the value of $s0 to $a0 for printing
	li $v0, 1		# Load syscall for print_int
	syscall			# Print the integer value
	jr $ra			# Return to caller
	
print_sec:
	move $a0, $s1		# Move the value of $s1 to $a0 for printing
	li $v0, 1		# Load syscall for print_int
	syscall			# Print the integer value
	jr $ra			# Return to caller
	
print_newline:
	li $v0, 4		# Load syscall for print_string
	la $a0, newline		# Load address of newline
	syscall			# Print the newline
	jr $ra			# Return to caller
	
print_equals:
	li $v0, 4		# Load syscall for print_string
	la $a0, equals		# Load address of equals
	syscall			# Print equals sign
	jr $ra			# Return to caller
