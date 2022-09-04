.MODEL SMALL 
.STACK 100H 
.DATA 

CR EQU 0DH
LF EQU 0AH
PROMPTMSG DB 'TYPE A LINE OF TEXT',0DH,0AH,'$'
NOCAP_MSG DB 0DH,0AH,'NO CAPITALS $'
CAP_MSG DB   0DH,0AH,'FIRST CAPITAL= $'
  
;The initial values "]" and "@" were chosen because "]'' follows "Z" Jn the ASCII sequence, and "@" precedes "A". Thus the first capital entered will 
;replace both of these values.
FIRST DB ']'
LAST DB '@'

INP DB ?  

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    ;PROMPT MESSAGE
    LEA DX, PROMPTMSG
    MOV AH, 9
    INT 21H
    
    MOV AH,1
    INT 21H
    
    WHILE_:
        CMP AL, CR
        JE END_WHILE
        
        CMP AL, 'A'
        JNGE END_IF
        CMP AL, 'Z'
        JNLE END_IF
       
    CHECK_FIRST: 
        CMP AL, FIRST
        JNL CHECK_LAST
        
        MOV FIRST,AL
        
    CHECK_LAST:
        CMP AL, LAST
        JNG END_IF
        
        MOV LAST,AL
            
                
    END_IF:
        INT 21H 
        JMP WHILE_
        
    END_WHILE:
        MOV AH, 9
        CMP FIRST,']' 
        JNE CAPS
        ;IF NO CAPITALS WERE TYPED
        LEA DX,NOCAP_MSG
        JMP DISPLAY
    CAPS:
        LEA DX,CAP_MSG
    DISPLAY:            ;capitals 
        INT 21H
    
    
    ;dos exit 
    MOV AH,4CH 
    INT 21H 
    MAIN ENDP 
    END MAIN 
        