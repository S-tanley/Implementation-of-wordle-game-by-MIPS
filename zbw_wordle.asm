#Name: Stanley Zheng 郑博文
#ID: 2022141520163
.data
debug: .word 1
myString1:  .asciiz "Welcome to my simply wordle game, let's play it!\n"  # 定义一个以null结尾的ASCII字符串
myString2:	.asciiz "What do you want to do?\n    (1)Play\n    (2)Quit\n"
myString3:  .asciiz "="
myString4:  .asciiz "\n"
myString5:  .asciiz "\nWrong choice, please choose again.\n"
myString6:  .asciiz "\nMake your guess:"
myString7:  .asciiz "\nCongratuations! You win! The  word was indeed: "
myString8:  .asciiz "\nWhoops, it seems you could not guess :(\n The word was: "
myString9: .asciiz "\nYou are in debug mode, the word system choose is:"
mySign1:  .asciiz "["
mySign2:  .asciiz "]"
mySign3:  .asciiz "("
mySign4:  .asciiz ")"
mySign5:  .asciiz "1"   
mySign6:  .asciiz "2"   
seed: .word 42
words: .asciiz "applebraveclouddanceearthflutegrapehappyigloojumboknifelatchmirthnympholiveplumbquietrulershadetrainunityvowelwristxeroxyachtzebraamberblushchimedemonemberfrostgloomhasteinletjoustkioskledgemangonexusoasisprismquotaranchscoldtweetusualvenomwhiskyodelzonedalloyblackcharmdwellelbowfairyglidehingeissuejointknacklunarmoundnudgeoperapouchquirkreedyslatetraceushervocalwaterxylonyarnszestyalphablinkciderdivererrorflockgiddyhoundicingjazzyknurllatchmangonixieovalsplaidquailridesscamptwineusualvowelwovenxeroxyokedadeptblisscrisp"
char_array:  .space 5
player_input: .space 5
buffer: .space 2

.text
.globl main
main:
	lw $a0, seed #this block generate random number
	li $a1, 100 
	li $v0, 42 
	syscall
	li $v0, 42 
	syscall
	
	move $t0, $v0
	mul $t0, $t0, 5	
    core_loop:
	    #print hello page
	    jal hello_page
	    
	    #decide play or quit
	    jal play_decide
	    
	    #5 guess
	    jal choose_word
	    li $t2, 0
	    
    	addi $t0, $t0, 5 #find next words position
	    guess_loop:
	    	li $t1, 0
		    la $a0, myString6
		    li $v0, 4
		    syscall
		    li $v0, 8             
	    	la $a0, player_input #get input 
	    	li $a1, 6           
	    	syscall
	    	jal check #check player's guess right or wrong
	    	addi $t2, $t2, 1
	    	beq $t1, 5, scussess
	    	beq $t2, 5, fail
	    	beq $zero, 0, guess_loop
 
fail: # print rhe fail information
	la $a0, myString8 
	li $v0, 4
	syscall
	li $s0, 0
	la $s1, char_array
	s_loop:
		lb $s2, ($s1)
		move $a0, $s2
		li $v0, 11
		syscall
		addi $s0, $s0, 1
		addi $s1, $s1, 1
		blt $s0, 5, s_loop
	beq $zero, 0, core_loop
	
scussess: # print the scussess information
	la $a0, myString7
	li $v0, 4
	syscall
	li $s0, 0
	la $s1, char_array
	ss_loop:
		lb $s2, ($s1)
		move $a0, $s2
		li $v0, 11
		syscall
		addi $s0, $s0, 1
		addi $s1, $s1, 1
		blt $s0, 5, ss_loop
	beq $zero, 0, core_loop
   
check:
	addi $sp, $sp, -4   
    sw $ra, 0($sp)
	
	la $a0, myString4 #change line
    li $v0, 4
    syscall
	
	la $s0, char_array
	la $s1, player_input
	li $s2, 0 #flag for first loop
	loop1:
		beq $s2, 5, end_loop1 
		lb $s3, ($s0)
		lb $s4, ($s1)
		bne $s3, $s4, check2
		addi $t1, $t1, 1 #not goes to check2 means same position, same letter
		la $a0, mySign1
		li $v0, 4
		syscall
		move $a0, $s4
		li $v0, 11
		syscall
		la $a0, mySign2
		li $v0, 4
		syscall
		addi $s0, $s0, 1
		addi $s1, $s1, 1
		addi $s2, $s2, 1
		blt $s2, 5, loop1
	
	end_loop1:	
	lw $ra, 0($sp)      
    addi $sp, $sp, 4    
    jr $ra
    
check2:
    li $t7, 0 #check weather this letter also appear in the word the system chosen
    la $s6, char_array
    loop2: #this loop repeat 5 times, means check every letter one by one.
    	lb $s7, ($s6) 
    	beq $s4, $s7, right1 #this letter also appear in the word the system chosen, goes to right1
    	addi $t7, $t7, 1
    	addi $s6, $s6, 1
    	blt $t7, 5, loop2
	move $a0, $s4
	li $v0, 11
	syscall
	addi $s0, $s0, 1
	addi $s1, $s1, 1
	addi $s2, $s2, 1
	beq $zero, 0, loop1
    
right1:
	la $a0, mySign3 
	li $v0, 4
	syscall
	move $a0, $s4
	li $v0, 11
	syscall
	la $a0, mySign4
	li $v0, 4
	syscall
	addi $s0, $s0, 1
	addi $s1, $s1, 1
	addi $s2, $s2, 1
	beq $zero, 0, loop1
  
choose_word: #from words to choose word this time the system will use
	addi $sp, $sp, -4   
    sw $ra, 0($sp)

	la $a1, words
	la $a2, char_array
	move $s0, $t0 #use the number in $t0 to decide the position
	addi $s1, $s0, 5
	li $s3, 0
	lw $s4, debug
	beq $s4, 1, debug_mode
	loop_for_choose_word:
		lb $s2 ($a1)
		addi $a1, $a1, 1   # point to the next char
        addi $s3, $s3, 1  
        ble $s3, $s0, loop_for_choose_word
        sb $s2, ($a2)
        beq $s4, 1, out
        back:
        addi $a2, $a2, 1
		bge $s3, $s1, end_loop
		beq $zero, 0, loop_for_choose_word
		end_loop:
			lw $ra, 0($sp)      
	    	addi $sp, $sp, 4    
	    	jr $ra
		out:
			move $a0, $s2
			li $v0, 11
			syscall
			beq $zero, 0, back
		debug_mode:
			la $a0, myString9
			li $v0, 4
			syscall
			beq $zero, 0, loop_for_choose_word
play_decide: #check if player want to continue to play
	addi $sp, $sp, -4   
    sw $ra, 0($sp)
    
	li $v0, 8
	la $a0, buffer # 将缓冲区的地址加载到 $a0 寄存器中
	li $a1, 2 # 读取一个字符
	syscall
	
	la $s0, mySign5
	la $s1, mySign6
	lb $a0, 0($s0)   # 加载第一个字符到 $a0
    lb $a1, 0($s1) 
    la $s3, buffer
    lb $s4, 0($s3)
	beq $s4, $a0, continue
	
	beq $s4, $a1, over
	
	la $a0, myString5
	li $v0, 4
	syscall
	beq $zero, 0, play_decide
	
	over: #not want to play
		li $v0, 10        
    	syscall
    	
    continue: # still want to play
    	lw $ra, 0($sp)      
    	addi $sp, $sp, 4    
    	jr $ra


hello_page: # print the hello page
	addi $sp, $sp, -4   
    sw $ra, 0($sp) 
    
    la $a0, myString4
    li $v0, 4
    syscall
    
    #print the line "==="
    jal print_line
    
	la $a0, myString1
    li $v0, 4
    syscall
    
    #print the line "==="
    jal print_line
    	
    la $a0, myString2
    li $v0, 4
    syscall
    
    lw $ra, 0($sp)      
    addi $sp, $sp, 4    
    jr $ra

print_line: #print the line in hello page
	addi $sp, $sp, -4   
    sw $ra, 0($sp)
    
    li $s0, 0
    li $s1, 50
    loop_start:
    	la $a0, myString3
    	li $v0, 4
    	syscall
    	addi $s0, $s0, 1
    	bne $s0, $s1, loop_start
    la $a0, myString4
    li $v0, 4
    syscall
    
    lw $ra, 0($sp)      
    addi $sp, $sp, 4    
    jr $ra
    
