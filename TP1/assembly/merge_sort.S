
#  60($sp)|    n     |	arg2
#  56($sp)| vector   |	arg1 	
# 		 |==========|
#     	 |///S$ra////|
#     	 |==========|
#  52($sp)|          |
#  48($sp)|    $ra    |
#  44($sp)|    $gp    |
#  40($sp)|    $fp    |
#        |==========|
#        |///LTA////|
#        |==========|
#  36($sp)|          |
#  32($sp)|	return  |	return_value
#  28($sp)|    n2    |	local
#  24($sp)|    n1    |	local
#  20($sp)| vector2  |	local
#  16($sp)| vector1  |	local
#        |==========|
#        |////ABA///|
#        |==========|
#  12($sp)|          |
#  8($sp) |          |
#  4($sp) |          |
#  0($sp) |          |   <-- $sp,$fp
#        |==========|


	.text
	.ent merge_sort
	.globl merge_sort

merge_sort:
	
	############  Stackf$rame creation  ############

	subu 	$sp,$sp,56
	sw		$fp,40($sp)
	sw 		$gp,44($sp)
	sw 		$ra,48($sp)

	# Save arguments on caller's ABA
	sw 		$a0,56($sp)
	sw		$a1,60($sp)

	############  Mergesort  ############

	#Set the return to NULL
	addu 	$v0,$zero,$zero
	
	#If there are nothing to do, return
	beq 	$a0, $zero, return
	nop 
	beq 	$a1, $zero, return
	nop

	#If n=1 go to caso_base
	addiu 	$t0,$zero,1
	beq 	$a1, $t0, caso_base
	nop

	
	#Initialice local variables
	lw		$t0, 60($fp)			# $t0 = largo del vector original
	divu	$t1, $t0, 2			# $t1 = largo de la prime$ra mitad
	subu	$t2, $t0, $t1     		# $t2 = largo de la segunda mitad

	sw		$t1, 24($fp)			#Guardo variables locales en memoria	
	sw		$t2, 28($fp)			


	#First recursive call
	lw    	$t3, 56($fp)			# $t3 = direccion de la prime$ra mitad

	move	$a0, $t3 	 			
	move	$a1, $t1				
	jal 	merge_sort 			# Llamado recursivo
	sw 		$v0, 16($fp)		# Almaceno retorno (dir. a la prime$ra mitad ordenada)


	#Second recursive call
	sll 	$t4, $t1, 2			# $t4 = $t1*4  (tamaño en bytes de la prime$ra mitad)
	addu 	$t3, $t3, $t4			# $t3 = direccion de la segunda mitad  	

	move	$a0, $t3 	 			
	move	$a1, $t2	
	jal 	merge_sort
	sw 		$v0, 20($fp)	 	# Almaceno retorno (dir. a la prime$ra segunda ordenada)


	#Merge
	lw		$a0, 24($fp)			# $a0 = prime$ra mitad ordenada
	move 	$a1, $t1 				# $a1 = largo prime$ra mitad
	lw		$a2, 28($fp)			# $a2 = segunda mitad ordenada
	move 	$a3,	$t2				# $a3 = largo segunda mitad
	jal		arr_merge
	nop
	sw 		$v0, 32($fp)			# Vector final ordenado


	#Free 
	lw		$a0, 24($fp)
	jal		myfree
	lw		$a0, 28($fp)
	jal		myfree

	#Set return variable
	lw 		$v0, 40($fp)
	b 		return
	nop

caso_base:
	
	addiu	$a0,$zero,4			# $a0 = 4
	jal 	mymalloc  			# v0 = direecion del nuevo vector

	lw		$t0,56($sp)			# $t0 = direccion del vector
	lw 		$t1,0($t0)			# $t1 = elemento del vector
	sw 		$t1,0($v0)			# Se almacena el elemento en el nuevo vector

return:
	
	# Unwinding stack
	lw		$fp,40($sp)
	lw		$gp,44($sp)
	lw		$ra,48($sp)

	jr $ra

	.end merge_sort

###################################################################################
#Comienza codigo
.text
.align 2
.globl arr_merge
.ent arr_merge
#$a3	#
#$a2	#
#$a1	#
#$a0	#
#########
#///////#44
#$ra	    #40
#$gp	    #36
#$fp	    #32
#########
#p1	    #28
#p2	    #24
#merged #20
#i	    #16
#########
#$a3	#12
#$a2	#8
#$a1	#4
#$a0	#0
#########

#int* arr_merge(int* vector1, size_t n1, int* vector2, size_t n2)
arr_merge: 
	#Creo el stack
	subu $sp,$sp,48
	sw $ra, 44($sp)
	sw $gp,40($sp)
	sw $fp,36($sp)

	move $fp,$sp

	#Argument Area
	sw $a0,48($sp)
	sw $a1,52($sp)
	sw $a2,56($sp)
	sw $a3,60($sp)

	sw $zero,24($sp) #int p1 = 0;

	sw $zero,28($sp) #int p2 = 0;

	#Agrego a $a0 el valor de sizeof(int)* (n1 + n2)
	lw $t0,52($sp) #$t0 = n1
	lw $t1,60($sp) #$t1 = n2
	add $t0,$t0,$t1 #$t0 = n1+n2
	sll $t0,0x2 #$t0 = 4*(n1+n2)
	
	sw $t0,0($sp)#$a0 4*(n1+n2)
	jal mymalloc

	#Suponiendo que funciono como un campeon
	sw $v0,20($sp) #20($sp) = merged
	lw $t0,0($sp) #Vuelvo a cargar el $a0 = 4*(n1+n2)
    srl $t0,0x2 #$t2 = n1+n2

	sw $zero,16($sp) #i = 0
	lw $t2, 16($sp) #$t2 = i
	slt $t1,$t2,$t0 #($t2?$t0) 1:0
	subu $t1,$t1,1
	beqz $t1,loop
	nop
	b end
loop:
    lw $t1,24($sp) #$t1 == p1
    lw $t0,52($sp) #$t0 == n1
	beq $t0,$t1,else #p1 == n1

    lw $t1,28($sp) #$t1 == p2
    lw $t0,60($sp) #$t0 == n2
	beq $t0,$t1,if2  #p2 == n2

    lw $t1,24($sp) #$t1 == p1
	sll $t1,0x2 #p1 = 4*p1
	lw $t0,48($sp) #Cargo el vector en $t0
	add $t0,$t0,$t1 #$t0 += 4*p1

	lw $t1,28($sp) #$t1 == p2
	sll $t1,0x2 #p2 = 4*p2
	lw $t2,56($sp) #$t2 == vector2
	add $t2,$t2,$t1 #$t2 += 4*p2
	slt $t1,$t2,$t0 #($t2?$t0) 1:0
    subu $t1,$t1,1
    beqz $t1,if2

else:#Tambien funciona pa$ra el primer if
    lw $t0, 20($sp) #merged
    lw $t1, 16($sp) #i
    lw $t2, 56($sp) #vector2
    lw $t3, 28($sp) #p2

    sll $t1,0x2 #i=4*i
    add $t0,$t0,$t1 #merged[i]
    sll $t3,0x2
    add $t2,$t2,$t3 #vector2[p2]
    lw $t2,0($t2) #cargo el valor
    sw $t0,0($t2) #guardo el valor

    #actualizo i
    lw $t1, 16($sp) #i
    addiu $t1,$t1,1 #Le sumo uno a i
    sw $t1, 16($sp) #guarde i actualizado

    #actualizo p2
    lw $t1, 28($sp) #p2
    addiu $t1,$t1,1 #Le sumo uno a p2
    sw $t1, 28($sp) #guarde p2 actualizado

    #Veo si termine
    lw $t0,0($sp) #Vuelvo a cargar el $a0 = 4*(n1+n2)
    srl $t0,0x2 #$t2 = n1+n2

    sw $zero,16($sp) #i = 0
    lw $t2, 16($sp) #$t2 = i
    slt $t1,$t2,$t0 #($t2?$t0) 1:0
    subu $t1,$t1,1
    beqz $t1,loop
    nop
    b end
if2:
    lw $t0, 20($sp) #merged
    lw $t1, 16($sp) #i
    lw $t2, 48($sp) #vector1
    lw $t3, 24($sp) #p1

    sll $t1,0x2 #i=4*i
    add $t0,$t0,$t1 #merged[i]
    sll $t3,0x2
    add $t2,$t2,$t3 #vector1[p1]
    lw $t2,0($t2) #cargo el valor
    sw $t0,0($t2) #guardo el valor

    #Actualizo valor de i
    lw $t1, 16($sp) #i
    addiu $t1,$t1,1 #Le sumo uno a i
    sw $t1, 16($sp) #guarde i actualizado

     #Actualizo valor de p1
    lw $t1, 24($sp) #p1
    addiu $t1,$t1,1 #Le sumo uno a p1
    sw $t1, 24($sp) #guarde p1 actualizado

    sw $zero,16($sp) #i = 0
    lw $t2, 16($sp) #$t2 = i
    slt $t1,$t2,$t0 #($t2?$t0) 1:0
    subu $t1,$t1,1
    beqz $t1,loop
    nop
    b end

end:
    lw $t0, 20($sp) #merged
    sw $t0, $v0
	move $sp,$fp
    lw $fp,36($sp)
    lw $gp,40($sp)
    lw $ra,44($sp)
    addu $sp,$sp,48
    jr $ra

.end arr_merge
	
	






