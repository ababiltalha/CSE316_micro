.MODEL SMALL
.STACK 100H

.DATA
    X DB ?
    NL DB 0DH, 0AH, "$" 
    MSG1 DB "INSERT THE DIGIT HERE : $"
    QT DB "QUOTIENT : $" 
    RM DB "REMAINDER : $"

.CODE
    MAIN PROC
        MOV AX, @DATA
        MOV DS, AX 
        ;PROMT
        LEA DX, MSG1
        MOV AH, 9H
        INT 21H     
        
        ;INPUT NUMERATOR
        MOV AH, 1
        INT 21H  
        MOV BL, AL
        MOV AH, 0H    
                      
                      
        ;DIVISION OF AX/BH
        SUB AL, '0'
        MOV BH, 2
        DIV BH              
           
           
        ;NOW QUOTIENT IS IN AL. MOVING IT TO BL
        MOV BL, AL
        ;REMAINDER IS IN AH
        MOV BH, AH
        ;MOVING REMAINDER TO BH BECAUSE WE NEED AH              
        
        ;NEWLINE
        LEA DX, NL
        MOV AH, 9H
        INT 21H       
        
              
        ;PRINT QUOTIENT      
        LEA DX, QT
        MOV AH, 9H
        INT 21H
         
        ADD BL, '0' 
        MOV DL, BL
        MOV AH, 2
        INT 21H 

        LEA DX, NL
        MOV AH, 9H
        INT 21H  
        
        
        ;PRINT REMAINDER      
        LEA DX, RM
        MOV AH, 9H
        INT 21H
        
        ADD BH, '0' 
        MOV DL, BH
        MOV AH, 2
        INT 21H 

        LEA DX, NL
        MOV AH, 9H
        INT 21H
        
        MOV AH, 4CH
        INT 21H
        
    MAIN ENDP
END MAIN