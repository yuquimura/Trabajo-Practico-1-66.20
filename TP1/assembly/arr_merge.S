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
#ra	    #40
#gp	    #36
#fp	    #32
#########
#p1	    #28
#p2	    #24
#merged #20
#i	    #16
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

	sw zero,28(sp) #int p2 = 0;

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
	beq t0,t1,else #p1 == n1

    lw t1,28(sp) #t1 == p2
    lw t0,60(sp) #t0 == n2
	beq t0,t1,if2  #p2 == n2

    lw t1,24(sp) #t1 == p1
	sll t1,0x2 #p1 = 4*p1
	lw t0,48(sp) #Cargo el vector en t0
	add t0,t0,t1 #t0 += 4*p1

	lw t1,28(sp) #t1 == p2
	sll t1,0x2 #p2 = 4*p2
	lw t2,56(sp) #t2 == vector2
	add t2,t2,t1 #t2 += 4*p2
	slt t1,t2,t0 #(t2?t0) 1:0
    subu t1,0x1,t1
    beqz t1,if2

else:#Tambien funciona para el primer if
    lw t0, 20(sp) #merged
    lw t1, 16(sp) #i
    lw t2, 56(sp) #vector2
    lw t3, 28(sp) #p2

    sll t1,0x2 #i=4*i
    add t0,t0,t1 #merged[i]
    sll t3,0x2
    add t2,t2,t3 #vector2[p2]
    lw t2,0(t2) #cargo el valor
    sw t0,0(t2) #guardo el valor

    #actualizo i
    lw t1, 16(sp) #i
    addiu t1,0x1,t1 #Le sumo uno a i
    sw t1, 16(sp) #guarde i actualizado

    #actualizo p2
    lw t1, 28(sp) #p2
    addiu t1,0x1,t1 #Le sumo uno a p2
    sw t1, 28(sp) #guarde p2 actualizado

    #Veo si termine
    lw t0,0(sp) #Vuelvo a cargar el a0 = 4*(n1+n2)
    srl t0,0x2 #t2 = n1+n2

    sw zero,16(sp) #i = 0
    lw t2, 16(sp) #t2 = i
    slt t1,t2,t0 #(t2?t0) 1:0
    subu t1,0x1,t1
    beqz t1,loop
    nop
    b end
if2:
    lw t0, 20(sp) #merged
    lw t1, 16(sp) #i
    lw t2, 48(sp) #vector1
    lw t3, 24(sp) #p1

    sll t1,0x2 #i=4*i
    add t0,t0,t1 #merged[i]
    sll t3,0x2
    add t2,t2,t3 #vector1[p1]
    lw t2,0(t2) #cargo el valor
    sw t0,0(t2) #guardo el valor

    #Actualizo valor de i
    lw t1, 16(sp) #i
    addiu t1,0x1,t1 #Le sumo uno a i
    sw t1, 16(sp) #guarde i actualizado

     #Actualizo valor de p1
    lw t1, 24(sp) #p1
    addiu t1,0x1,t1 #Le sumo uno a p1
    sw t1, 24(sp) #guarde p1 actualizado

    sw zero,16(sp) #i = 0
    lw t2, 16(sp) #t2 = i
    slt t1,t2,t0 #(t2?t0) 1:0
    subu t1,0x1,t1
    beqz t1,loop
    nop
    b end

end:
    lw t0, 20(sp) #merged
    sw t0, v0
	move sp,fp
    lw fp,36(sp)
    lw gp,40(sp)
    lw ra,44(sp)
    addu sp,sp,48
    jr ra

.end arr_merge
	
	
	

	
		

