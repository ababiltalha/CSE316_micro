
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

.MODEL SMALL
.STACK 100H

.DATA
    X DB ?
    NL DB 0DH, 0AH, "$" 
    MSG1 DB "INSERT THE DIGIT TO MULTIPLY : $"

.CODE
    MAIN PROC
        MOV AX, @DATA
        MOV DS, AX 
        ;PROMPT
        LEA DX, MSG1
        MOV AH, 9H
        INT 21H  
        
        MOV AH, 1
        INT 21H
        MOV BL, 10 ;MULTIPLY BY 10
        MOV AH, 0  ;PUTTING AH = 0 TO TEST IF THE RESULT IS IN AL OR AX. TURNS OUT IT IS IN AX BECAUSE AH CHANGED AFTER MUL 
        MUL BL     ;MULTIPLYING AL WITH BL=10=A
        
        MOV AH, 4CH
        INT 21H
        
    MAIN ENDP
END MAIN




