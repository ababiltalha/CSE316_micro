.MODEL SMALL

.STACK 100H

.DATA
CR EQU 0DH
LF EQU 0AH
; YOUR VARIABLES HERE 
X DB ?


.CODE
MAIN PROC         
    ; INITIALIZE DS
    MOV AX, @DATA
    MOV DS, AX
    
    MOV AH,1
    INT 21H
    
    MOV X,AL
    
    MOV DL,'1'
    MOV AH,2
    INT 21H

    ; NEWLINE
    
    MOV DH, 'A'
    SUB X, DH
    MOV DH, 7
    SUB DH, X
    MOV CH, '0'
    ADD CH, DH

    MOV DL, CH
    MOV AH, 2
    INT 21H


    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN

    
     