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
	#lw t5,24(sp)    #t5 = p1;

	sw zero,28(sp) #int p2 = 0;
	#lw t6,28(sp)  #t6 = p2

	#lw t3, 48(sp)   #t3 = vector1
	#lw t8, 56(sp)   #t8 = vector2

	#Agrego a a0 el valor de sizeof(int)* (n1 + n2)
	lw t0,52(sp) #t0 = n1
	lw t1,60(sp) #t1 = n2
	add t0,t0,t1 #t0 = n1+n2
	sll t0,0x2 #t0 = 4*(n1+n2)
	
	sw t0,0(sp) $#a0 4*(n1+n2)
	jal mymalloc

	#Suponiendo que funciono como un campeon
	sw v0,20(sp) #20(sp) = merged
	lw t0,0(sp) #Vuelvo a cargar el a0 = 4*(n1+n2)
    srl t0,0x2 #t2 = n1+n2

	sw zero,16(sp) #i = 0
	lw t2, 16(sp) #t2 = i
	slt t1,t2,t0 #(t2?t0) 1:0
	subu t1,0x1,t1
	beqz t1,loop
	nop
	b end
loop:
    lw t1,24(sp) #t1 == p1
    lw t0,52(sp) #t0 == n1
	beq t0,t1,if1 #p1 == n1

    lw t1,28(sp) #t1 == p1
    lw t0,60(sp) #
	beq t6,t1,if2  #p2 == n2

	sll t5,0x2 #p1 = 4*p1
	add t3,t3,t5 #t3 += 4*p1
	sll t6,0x2 #p2 = 4*p2
	add t8,t8,t6
	lw t8,0(t8) #Cargo el valor de t8 en t8
	lw t6,0(t6) #Cargo el valor de t6 en t6
	slt t8,t8,if3 #vector1[p1] == #vector2[p2]


	add t4,t4,1
	blt t4,t1,loop
end:
	ksjldjlkasjlkdsal
	
	
	
	

	
		

