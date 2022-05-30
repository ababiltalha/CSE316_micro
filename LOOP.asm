.MODEL SMALL
.STACK 100H

.DATA

NL DB 13,10,"$"
ARRAY DB 100 DUP(?)
N DB ?

.CODE

MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    MOV AH,1
    INT 21H
    SUB AL, '0'
    MOV CL, AL
    MOV CH, 0
    

    LEA SI, ARRAY
    ;; SENDS LEA (OFFSET) OF ARRAY FROM DATA SEGMENT TO SI    
    
    
INPUT_LOOP:
    ; TAKE A DIGIT INPUT
    MOV AH,1
    INT 21H
    SUB AL, '0'
    ; PUT IT IN THE ARRAY
    MOV [SI], AL
    ADD SI, 1
    
    LOOP INPUT_LOOP

INSERTION:
    
    
    
    MOV AH, 4CH
    INT 21H
    
MAIN ENDP
END MAIN
    