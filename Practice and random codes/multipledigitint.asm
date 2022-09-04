.MODEL SMALL
.STACK 100H
.DATA

X DB ?
NL DB 13,10,"$"
PROMPT DB "PLEASE ENTER A NUMBER:",13,10,"$"


.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    LEA DX, PROMPT
    MOV AH, 9
    INT 21H
           
    MOV DX, 0
INPUT_LOOP:

    MOV AH, 1
    INT 21H
    

    CMP AL, 13
    JE BREAK
    CMP AL, 10
    JE BREAK
    
    SUB AL, '0' ; YOU ACTUALLY CAN DO THIS
    MOV X, AL
    
    MOV AX, 10  ; MULTIPLIES WITH THIS REGISTER
    MUL DX     ; ONLY ONE PARAMETER
; PRODUCT GOES TO AX
; GET IT BACK TO DX
    MOV DX, AX
    
; AL HAS THE INPUT AND WE SUBTRACT 0 FROM IT 
; AND PUT AH TO 0 SO WE CAN MULTIPLY THE WHOLE REGISTER
; 

; WE WILL BE USING DX FOR THE MUL PURPOSE,
; SO WE SHOULD CLEAR IT BEFORE THE 
    
    ADD DL, X
    
    JMP INPUT_LOOP

    
BREAK:   


    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN