
#  60(sp)|    n     |	arg2
#  56(sp)| vector   |	arg1 	
# 		 |==========|
#     	 |///SRA////|
#     	 |==========|
#  52(sp)|          |
#  48(sp)|    ra    |
#  44(sp)|    gp    |
#  40(sp)|    fp    |
#        |==========|
#        |///LTA////|
#        |==========|
#  36(sp)|          |
#  32(sp)|	return  |	return_value
#  28(sp)|    n2    |	local
#  24(sp)|    n1    |	local
#  20(sp)| vector2  |	local
#  16(sp)| vector1  |	local
#        |==========|
#        |////ABA///|
#        |==========|
#  12(sp)|          |
#  8(sp) |          |
#  4(sp) |          |
#  0(sp) |          |   <-- sp,fp
#        |==========|


	.text
	.ent merge_sort
	.globl merge_sort

merge_sort:
	
	############  Stackframe creation  ############
	.frame 	fp,56
	subu 	sp,sp,56

	#Building Saved Registers Area
	.cprestore 40         # lo vi por ahi, no se si esta bien
	sw		fp,40(sp)
	sw 		gp,44(sp)
	sw 		ra,48(sp)

	# Save arguments on caller's ABA
	sw 		a0,sp(56)
	sw		a1,sp(60)

	############  Mergesort  ############

	#Set the return to NULL
	addu 	v0,zero,zero
	
	#If there are nothing to do, return
	beq 	a0, zero, return
	nop 
	beq 	a1, zero, return
	nop

	#If n=1 go to caso_base
	addiu 	t0, 1,	zero
	beq 	a1, t0, caso_base
	nop

	
	#Initialice local variables
	lw		t0, 60(fp)			# t0 = largo del vector original
	divu	t1, t0, 2			# t1 = largo de la primera mitad
	subu	t2, t0, t1     		# t2 = largo de la segunda mitad

	sw		t1, 24(fp)			#Guardo variables locales en memoria	
	sw		t2, 28(fp)			


	#First recursive call
	lw    	t3, 56(fp)			# t3 = direccion de la primera mitad

	move	a0, t3 	 			
	move	a1, t1				
	jal 	merge_sort 			# Llamado recursivo
	sw 		v0, 16(fp)			# Almaceno retorno (dir. a la primera mitad ordenada)


	#Second recursive call
	sll 	t4, t1, 2			# t4 = t1*4  (tamaño en bytes de la primera mitad)
	addu 	t3, t3, t4			# t3 = direccion de la segunda mitad  	

	move	a0, t3 	 			
	move	a1, t2	
	jal 	merge_sort
	sw 		v0, 20(fp)	 		# Almaceno retorno (dir. a la primera segunda ordenada)


	#Merge
	lw		a0, 24(fp)			# a0 = primera mitad ordenada
	move 	a1, t1 				# a1 = largo primera mitad
	lw		a2, 28(fp)			# a2 = segunda mitad ordenada
	move 	a3,	t2				# a3 = largo segunda mitad
	jal		arr_merge
	nop
	sw 		v0, 32(fp)			# Vector final ordenado


	#Free 
	lw		a0, 24(fp)
	jal		myfree
	lw		a0, 28(fp)
	jal		myfree

	#Set return variable
	lw 		v0, 40(fp)
	b 		return
	nop

caso_base:
	
	addiu	a0,4,zero			# a0 = 4
	jal 	mymalloc  			# v0 = direecion del nuevo vector

	lw		t0,56(sp)			# t0 = direccion del vector
	lw 		t1,0(t0)			# t1 = elemento del vector
	sw 		t1,0(v0)			# Se almacena el elemento en el nuevo vector

return:
	
	# Unwinding stack
	lw		fp,40(sp)
	lw		gp,44(sp)
	lw		ra,48(sp)

	jr ra

	.end merge_sort