.model small

.stack 100h

.data
cr equ 0dh
lf equ 0ah

hw db 'Hello World$'
; db means declare byte(type of variable), $ means end of string    

x db ?
; ? means uninit variable 

a db ?
b db ?

.code

main proc
    ; init
    mov ax, @data
    mov ds, ax
    
    ; greet
    lea dx, hw
    mov ah, 9
    int 21h
    
    ; load effective address
           
    ; value of ah is indicating the next i/o op when interrupted
    ; such as input or output, what kind of input or output
    ; here 9 means put the string as output
              
    ; appending a new line
    
    mov dx, cr
    mov ah, 2
    int 21h  
    mov dx, lf
    mov ah, 2
    int 21h  
    
    
    
    ; input x                     
    mov ah, 1
    int 21h
    mov x, al                     
              
    ; ah = 1 means single character input
    ; it takes the value in al 
    ; and puts it in x in mov x, al          
    
    ; add 2 to x 
    ; add 31 decimal to the character 
    ; so that the previous small letter is found      
    add x, 31d    
    
    ; the first location is the memory
    ; of the result of the op \, here x
              
    ; newline combo
    mov dx, cr
    mov ah, 2
    int 21h  
    mov dx, lf
    mov ah, 2
    int 21h
      
    ; output updated value of x
    mov dl, x
    mov ah, 2                          
    int 21h
    ; ah =2 means single character output
    ; aaaaaaa
                  
    ; input the first num
    
    mov ah, 1
    int 21h
    mov a, al
    
    ; input the second num
    
    mov ah, 1
    int 21h
    mov b, al
    
    mov bh, a
    
    ; add (IMPORTANT: two memory locations cannot be MOV, ADD, SUB)
    
    add b, bh  
    
    ; sub for getting the hex of sum
    sub b, 48d
    mov dl, b
    mov ah, 2                          
    int 21h
          
    ; exit
    mov ah, 4ch
    int 21h

main endp
end main