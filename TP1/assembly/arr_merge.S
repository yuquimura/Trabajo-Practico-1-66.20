#Comienza codigo
.text
.align 2
.globl arr_merge
.ent arr_merge
#a3	#
#a2	#
#a1	#
#a0	#
#########
#///////#44
#ra	#40
#gp	#36
#fp	#32
#########
#p1	#28
#p2	#24
#merged #20
#i	#16
#########
#a3	#12
#a2	#8
#a1	#4
#a0	#0
#########

#int* arr_merge(int* vector1, size_t n1, int* vector2, size_t n2)
arr_merge: 
	#Creo el stack
	subu sp,sp,48
	sw ra, 44(sp)
	sw gp,40(sp)
	sw fp,36(sp)

	move fp,sp

	#Argument Area
	sw a0,48(sp)
	sw a1,52(sp)
	sw a2,56(sp)
	sw a3,60(sp)
	

	sw zero,24(sp) #int p1 = 0;
	lw t5,24(sp)    #t5 = p1;

	sw zero,28(sp) #int p2 = 0;
	lw t6,28(sp)  #t6 = p2

	lw t3, 48(sp)   #t3 = vector1
	lw t8, 56(sp)   #t8 = vector2

	#Agrego a a0 el valor de sizeof(int)* (n1 + n2)
	lw t0,52(sp) #t0 = n1
	lw t1,60(sp) #t1 = n2

	add t2,t0,t1 #t2 = n1+n2

	sll t2,0x2 #t2 = 4*(n1+n2)
	
	sw t2,0(sp)
	jal mymalloc

	#Suponiendo que funciono como un campeon
	sw v0,20(sp)
	lw t7,20(sp) #t7 = direccion de memoria del malloc
    srl t2,0x2 #t2 = n1+n2

	sw zero,16(sp) #i =0
	add t4,zero,zero #t4 = i
	blt t4,t2,loop  #i < t4 = i <n1+n2
	nop
	b end
loop:
	beq t5,t0,if1 #p1 == n1

	beq t6,t1,if2  #p2 == n2

	sll t5,0x2 #p1 = 4*p1
	add t3,t3,t5 #t3 += 4*p1
	sll t6,0x2 #p2 = 4*p2
	add t8,t8,t6
	lw t8,0(t8) #Cargo el valor de t8 en t8
	lw t6,0(t6) #Cargo el valor de t6 en t6
	beq t8,t8,if3 #vector1[p1] == #vector2[p2]


	add t4,t4,1
	blt t4,t1,loop
end:
	ksjldjlkasjlkdsal
	
	
	
	

	
		

