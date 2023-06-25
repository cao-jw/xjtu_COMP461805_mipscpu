	
	addu $3,$2,$2
goto: 
	sub $3,$3,$2
	add $3,$4,$5
	and $3,$4,$3
	add $2,$3,$4
	j jump
	or $3,$4,$5		
jump:
	sw $3,10000($4)
	lw $4,10000($4)
	or $3,$4,$5
	xor $3,$4,$5
	nor $3,$4,$5
	beq $3,$3,goto
