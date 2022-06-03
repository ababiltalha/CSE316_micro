.MODEL SMALL
.STACK 100H

.DATA
ARRAY DW 100 DUP(?)
N DB ?
ARRAY_SIZE DW ?
PROMPT1 DB "ENTER SIZE OF ARRAY: ",13,10,"$"
PROMPT2 DB 13,10,10,"ENTER ELEMENTS: ",13,10,"$"
PROMPT_PRINT DB 13,10,"SORTED ARRAY: $"
PROMPT3 DB 13,10,10,"ENTER SEARCH KEY: ",13,10,"$"
NL DB 13,10,"$"
SUCCESS DB "FOUND AT $"
FAILURE DB "NOT FOUND$"
INV_SIZE DB 13,10,"INVALID INPUT$"
FLAG DB 0
KEY DW ?
NUMBER_STRING DB "00000$"

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    MOV DX, OFFSET PROMPT1
    MOV AH, 9
    INT 21H
    
;; ENTRY
    MOV DX, 0

INPUT_LOOP_N:
    MOV AH, 1
    INT 21H
    CMP AL, 13
    JE BREAK_1
    CMP AL, 45
    JE INVALID_SIZE

    SUB AL, '0'     ; AL HAS THE INPUT AND WE SUBTRACT 0 FROM IT 
    MOV N, AL
    MOV AX, 10      ; MULTIPLIES WITH THIS REGISTER
    MUL DX          ; ONLY ONE PARAMETER, PRODUCT GOES TO AX
    MOV DX, AX      ; GET IT BACK TO DX   
    ADD DL, N 
    JMP INPUT_LOOP_N 
BREAK_1:
    MOV ARRAY_SIZE, DX  ; NOW SIZE HAS THE ARRAY SIZE
    CMP ARRAY_SIZE, 0
    JLE INVALID_SIZE
    
    MOV DX, OFFSET PROMPT2
    MOV AH, 9
    INT 21H
    
    MOV CX, ARRAY_SIZE  ; LOOP ITERATOR
    LEA SI, ARRAY       ; SETTING ARRAY ADDRESS
    MOV DX, 0
INPUT_LOOP_ARRAY:
    INPUT_LOOP_ENTRY:
        MOV AH, 1           
        INT 21H             ; INPUT THE NUMBER 
        CMP AL, 13          
        JE BREAK_2          ; IF ENTER IS PRESSED PUT THE ACCUMULATED INTEGER IN THE ARRAY
        CMP AL, 45          ; CHECK IF - IS INPUTTED
        JNE POSITIVE_ENTRY  ; IF NOT, INPUT THE NUMBER
        MOV FLAG, 1         ; IF - THEN CHANGE FLAG TO 1 WHICH WILL NEGATE THE INPUTTED NUMBER AFTER PRESSING ENTER
        JMP INPUT_LOOP_ENTRY
    POSITIVE_ENTRY:    
        SUB AL, '0' 
        MOV N, AL
        MOV AX, 10 
        MUL DX 
        MOV DX, AX    
        ADD DL, N 
        JMP INPUT_LOOP_ENTRY 
    BREAK_2:
        CMP FLAG, 1
        JNE POSITIVE
        NEG DX
    POSITIVE:
        MOV [SI], DX        ; SETTING INT VALUE IN ARRAY
        ADD SI, 2
        MOV DX, OFFSET NL   ; NEWLINE
        MOV AH, 9
        INT 21H
        MOV DX, 0
        MOV FLAG, 0           ; RE-INIT DX AND FLAG FOR INPUT
    LOOP INPUT_LOOP_ARRAY



;;  SORT   
    LEA SI, ARRAY
    MOV CX, ARRAY_SIZE
          
INSERTION_SORT_LOOP:
    PUSH CX
    DEC CX
    MOV BX, ARRAY_SIZE
    SUB BX, CX
    MOV DX, BX
    DEC DX      ; WE START CHECKING FROM THE PREVIOUS ONE UNTIL INDEX 0
    ADD BX, BX  ; BECAUSE EACH ENTRY IS A WORD, PASS TWO INDICES TO GET NEXT 
    MOV AX, SI[BX]
    INSERTION_LOOP_INNER:
        CMP DX,0
        JNGE INNER_BREAK
        
        MOV BX, DX
        ADD BX, BX
        MOV CX, SI[BX]
        CMP CX, AX
        JLE INNER_BREAK
        
        MOV BX, DX
        INC BX
        ADD BX, BX
        MOV SI[BX], CX
        DEC DX
        JMP INSERTION_LOOP_INNER
    INNER_BREAK:
    MOV BX, DX
    INC BX
    ADD BX, BX
    MOV SI[BX], AX  
    POP CX
    DEC CX
    CMP CX, 1               ; HAS TO RUN ONE LESS TIME THAN ARRAY SIZE
    JE SORT_BREAK
    JMP INSERTION_SORT_LOOP ; LOOP KEYWORD DOES NOT WORK (?)

SORT_BREAK:
    
;; DISPLAY SORTED ARRAY
    MOV AH, 9
    LEA DX, PROMPT_PRINT
    INT 21H
    
    MOV CX, ARRAY_SIZE
    LEA DI, ARRAY
    XOR BX, BX
PRINT_ARRAY_LOOP:
    PUSH CX
    ; MOV FLAG, 0
    MOV AX, [DI]
    CALL PRINT
    MOV AH ,2
    MOV DL, ' '
    INT 21H 
    ADD DI, 2
    POP CX
    LOOP PRINT_ARRAY_LOOP
         

;; BINARY SEARCH
SEARCH:
    MOV AH, 9
    LEA DX, PROMPT3
    INT 21H 
    
    XOR DX, DX
    INPUT_LOOP_SEARCH:          ; INPUT FOR SEARCH
        MOV AH, 1           
        INT 21H                 ; INPUT THE NUMBER
        CMP AL, 'e'
        JE EXIT 
        CMP AL, 13          
        JE BREAK_3              ; IF ENTER IS PRESSED PUT THE INTEGER IN THE ARRAY
        CMP AL, 45              ; CHECK IF - IS INPUTTED
        JNE POSITIVE_ENTRY_2    ; IF NOT, INPUT THE NUMBER
        MOV FLAG, 1             ; IF - THEN CHANGE FLAG TO 1 WHICH WILL NEGATE THE INPUTTED NUMBER AFTER PRESSING ENTER
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
        MOV KEY, DX         ; SETTING INT VALUE IN KEY
        MOV DX, OFFSET NL   ; NEWLINE
        MOV AH, 9
        INT 21H
        MOV DX, 0
        MOV FLAG, 0 
   
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
    
    ; MOV FLAG, 0
    MOV AH, 9
    LEA DX, SUCCESS
    INT 21H
    MOV AX, BX
    INC AX
    CALL PRINT ;    
    JMP SEARCH
    
EXIT:    
    MOV AH, 4CH
    INT 21H
INVALID_SIZE:
    MOV DX, OFFSET INV_SIZE
    MOV AH, 9
    INT 21H
    MOV AH, 4CH
    INT 21H
MAIN ENDP

PRINT PROC                      ; PRINTS A WORD INTEGER IN AX
    
    LEA SI, NUMBER_STRING       ; IS "00000"
    ADD SI, 5                   ; START FROM ONE'S DIGIT
    
    CMP AX, 0
    JNL PRINT_LOOP
    MOV FLAG, 1
    NEG AX
    
    PRINT_LOOP:
        DEC SI
        
        MOV DX, 0               ; DX:AX = 0000:AX
        MOV CX, 10
        DIV CX
        
        ADD DL, '0'
        MOV [SI], DL
        
        CMP AX, 0
        JNE PRINT_LOOP
    
    CMP FLAG, 0
    JNG NOT_NEGATIVE
    MOV AH, 2
    MOV DL, 45
    INT 21H
    MOV FLAG, 0
NOT_NEGATIVE:
    MOV DX, SI
    MOV AH, 9
    INT 21H
    
    
    RET
PRINT ENDP
END MAIN
