        ORG     0
Start:  LOAD    B       ;Load value stored in B
        ADD     C       ;Add value stored in C
        ADD		D
        STORE   A       ;Store value in A
Here:   JUMP    Here    ;Loop here forever
        ORG     &H010
A:      DW      &H0000
B:      DW      &H0004
C:      DW      &H0003
D:      DW      &H0005

