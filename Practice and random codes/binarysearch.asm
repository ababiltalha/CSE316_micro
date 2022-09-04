.MODEL SMALL
.STACK 100H
.DATA
ARRAY DW -3, 2, 3, 5, 6
N DB ?
ARRAY_SIZE DW 5
PROMPT1 DB "ENTER SIZE OF ARRAY:",13,10,"$"
PROMPT2 DB 13,10,"ENTER ELEMENTS:",13,10,"$"
PROMPT3 DB 13,10,"ENTER SEARCH KEY:",13,10,"$"
NL DB 13,10,"$"
SUCCESS DB " FOUND AT $"
FAILURE DB " NOT FOUND",13,10,"$"
INV_SIZE DB 13,10,"INVALID INPUT","$"
FLAG DB 0
KEY DW ?
NUMBER_STRING DB "00000$"

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    
SEARCH:
    MOV AH, 9
    LEA DX, PROMPT3
    INT 21H 
    
;; INPUT FOR SEARCH
    XOR DX, DX
    INPUT_LOOP_SEARCH:
        MOV AH, 1           
        INT 21H             ; INPUT THE NUMBER
        ; CMP AL, 'e'
        ; JE EXIT 
        CMP AL, 13          
        JE BREAK_3          ; IF ENTER IS PRESSED PUT THE ACCUMULATED INTEGER IN THE ARRAY
        CMP AL, 45          ; CHECK IF - IS INPUTTED
        JNE POSITIVE_ENTRY_2  ; IF NOT, INPUT THE NUMBER
        MOV FLAG, 1         ; IF - THEN CHANGE FLAG TO 1 WHICH WILL NEGATE THE INPUTTED NUMBER AFTER PRESSING ENTER
        JMP INPUT_LOOP_SEARCH
    POSITIVE_ENTRY_2:    
        SUB AL, '0' 
        MOV N, AL
        MOV AX, 10 
        MUL DX 
        MOV DX, AX    
        ADD DL, N 
        JMP INPUT_LOOP_SEARCH 
    BREAK_3:
        CMP FLAG, 1
        JNE POSITIVE_2
        NEG DX
    POSITIVE_2:
        MOV KEY, DX        ; SETTING INT VALUE IN AX FOR SEARCH
        MOV DX, OFFSET NL   ; NEWLINE
        MOV AH, 9
        INT 21H
        MOV DX, 0
        MOV FLAG, 0 
    
    
    
;;     
    LEA SI, ARRAY
    ; MOV AX, KEY
    MOV CX, ARRAY_SIZE      ; HIGHER
    MOV DX, 0               ; LOWER
BINARY_SEARCH_LOOP:    
    CMP CX, DX
    JL NOT_FOUND_PRINT      ; IF LOWER>HIGHER
    MOV BX, CX              
    ADD BX, DX              
    SHR BX, 1               ; BX= LOWER+HIGHER/2
    
    ADD BX, BX
    MOV AX, SI[BX]
    CMP AX, KEY
    JE FOUND_PRINT          ; THE SEARCH KEY IS FOUND IN THE ARRAY 
    JL RIGHT                ; IN THE RIGHT SUBARRAY
    JMP LEFT                ; IN THE LEFT SUBARRAY

    RIGHT:                   
        SHR BX, 1           ; DIVIDE BY 2        
        INC BX                      
        MOV DX, BX          ; NEW LOWER    
        JMP BINARY_SEARCH_LOOP              
    LEFT:
        SHR BX, 1                    
        DEC BX                      
        MOV CX, BX          ; NEW HIGHER    
        JMP BINARY_SEARCH_LOOP
    
                      
NOT_FOUND_PRINT:
    MOV AH, 9
    LEA DX, FAILURE
    INT 21H
    JMP SEARCH
    
FOUND_PRINT:
    SHR BX, 1
    
    MOV FLAG, 0
    MOV AH, 9
    LEA DX, SUCCESS
    INT 21H
    MOV AX, BX
    CALL PRINT ;    
    JMP SEARCH
    
EXIT:
    MOV AH, 4CH
    INT 21H
MAIN ENDP

PRINT PROC ; PRINTS A WORD INTEGER IN AX
    
    LEA SI, NUMBER_STRING
    ADD SI, 5
    
    CMP AX, 0
    JNL PRINT_LOOP
    MOV FLAG, 1
    
    PRINT_LOOP:
        DEC SI
        
        MOV DX, 0   ; DX:AX = 0000:AX
        MOV CX, 10
        DIV CX
        
        ADD DL, '0'
        MOV [SI], DL
        
        CMP AX, 0
        JNE PRINT_LOOP
    
    MOV DX, SI
    MOV AH, 9
    INT 21H
    
    RET

PRINT ENDP

END MAIN 