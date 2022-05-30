.MODEL SMALL
.STACK 100H
.DATA
NL DB 13,10,'$'
PROMPT DB 'ENTER ALPHABET',13,10,'$'
V DB ' IS VOWEL',13,10,'$'
C DB ' IS CONSONANT',13,10,'$'
X DB ' IS NOT ALPHABET',13,10,'$'
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    LEA DX,prompt
    MOV AH,9
    INT 21H
   
    MOV AH,1
    INT 21H
    
    CMP AL, 'a'
    JNGE IS_CAP
    CMP AL, 'z'
    JLE IS_SMALL
    JMP IS_CAP
    
IS_SMALL:
    SUB AL,32
    JMP IS_CAP 
    
    
IS_CAP:    
    CMP AL,'A'
    JNGE END_F 
    CMP AL,'Z'
    JLE DETECT
    JMP END_F

DETECT:
    CMP AL,'A'
    JE VOWEL
    CMP AL,'E'
    JE VOWEL
    CMP AL,'I'
    JE VOWEL
    CMP AL,'O'
    JE VOWEL
    CMP AL,'U'
    JE VOWEL
    JMP CONS
    
VOWEL:
    LEA DX,V
    MOV AH,9
    INT 21H
    LEA DX, NL
    MOV AH, 9 
    INT 21H
    JMP END_0

CONS:
    LEA DX,C
    MOV AH,9
    INT 21H
    LEA DX, NL
    MOV AH, 9 
    INT 21H
    JMP END_0
    


END_F:
    LEA DX,X
    MOV AH,9
    INT 21H
    LEA DX, NL
    MOV AH, 9 
    INT 21H

END_0:
    
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN 