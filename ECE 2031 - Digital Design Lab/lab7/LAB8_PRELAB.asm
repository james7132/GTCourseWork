        ORG     0
Start:  CALL	CALC
        JUMP    Start
        
		ORG     &H010
CALC:	LOAD	A
		AND		B
		XOR		C
		STORE	D
		RETURN

		ORG		&H002F
A:      DW      &H00FF
B:      DW      &HA5A5
C:      DW      &H3300
D:      DW      &H0000

