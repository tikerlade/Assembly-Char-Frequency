;This program is counting frequency of letters in string
;and than prints histogram of frequency

.model  small
.stack  100h
.data
    ;Arrays for counting frequency
    alphabet dw 26 dup(0)
    alph_copy dw 26 dup(0)
    
    ;Variables for counting number of UPPER- and lower- case letters 
    upper_count db 0
    lower_count db 0
    
    ;Variable for track max-frequency
    max dw 0
    
    ;Strings for better UI(User Interface)
    intro db "Enter number of strings(max=6): $"
    upper_title db "Number of upper_case letters in string: $"
    lower_title db "Number of lower_case letters in string: $"
    max_title db "Maximum frequency in string: $"
.code


;Macro that will print [symbol]
print_symbol macro symbol
    push ax                            ;Saving registers that we'll use
    push dx
    
    mov ah, 02h                        ;Get interrupt that will print [symbol]
    mov dl, symbol
    int 21h
    
    pop dx                             ;Setting parameters back
    pop ax
endm


;Macro that will print [string]
print_string macro string
    push ax                            ;Saving registers that we'll use
    push dx
    
    mov ah, 09h                        ;Get interrupt that will print [symbol]
    lea dx, string
    int 21h
   
    pop dx                             ;Setting parameters back
    pop ax
endm

;Macro that will print [number](0-99) 
print_number macro
    push ax                            ;Saving registers that we'll use
    push dx
    
    aam
    add ax, 3030h                      ;Add 3030h to get decimal representation of number
    push ax
    mov dl, ah                         ;Print tens
    mov ah, 02h
    int 21h
    pop dx                             ;Print ones
    mov ah, 02h
    int 21h
    
    print_symbol 0Ah                   ;Move to new line
    
    pop dx                             ;Setting parameters back
    pop ax
endm

;Main thread
main:
;--------------------------------
    mov ax, @data                      ;Some preparations for \'exe\' compiling
    mov ds, ax
    xor ax,ax
    
    print_string intro                 ;Printing intro
    
    mov ah, 01h                        ;Read number of strings
    int 21h
    

    mov ch, 0                          ;Calculating input's number by subtracking 30h(48d)
    sub al, 30h                        ;because given input is in ASCII code
    mov cl, al
    
    print_symbol 0Ah                   ;New line printing
;---------------------------------    
    
    ;Reading-loop goes through
    ;number of strings
    ;-------------------------------------
    reading_loop:
        push cx                       ;Saving outer loop counter
        
        mov cx, 80                    ;Setting counter for loop through string elements
        chars_reading:
            
            mov ah, 01h               ;Getting symbol
            int 21h
            
            cmp al, 13                ;Compare with ENTER
            je end_string
            
            ;Check if input symbol UPPERCASE or not
            ;-------------------------------
            cmp al, 41h               ;if it's ASCII less than (41h) -> not counting this symbol
            jl next_symbol
            cmp al, 5Ah               ;if it's ASCII greater than (5Ah)  -> check if it a lowercase
            jg upper_checked
            ;-------------------------------
            
            
            ;If UPPERCASE
            ;-------------------------------
            inc [upper_count]         ;increment UPPERCASE_counter
            lea si, alphabet             ;increment counter of letter
            sub al, 41h               ;evaluate index of letter
            mov ah, 0h
            mov bl, 4h
            mul bl                    ;multiply this index by 4, because in array every symbol = 4bytes
            mov ah, 0h                ;for a reslut in AL we have bias
            mov bh, 0h                ;preventing errors by setting to 0 BH and AH
            mov bx, ax
            mov dx, [bx+si]
            inc dx                    ;increment counter of current letter
            mov [bx+si], dx
            
            mov dx, [bx+si]
            cmp dx, [max]             ;Check if number of current letters is maximum
            jle upper_checked
            mov [max], dx
            ;-------------------------------
            
            
            ;When symbol not UPPERCASE
            ;-------------------------------
            upper_checked:
            
                ;Check if input symbol lowercase or not
                ;---------------------------
                cmp al, 61h           ;if it's ASCII less than (61h) -> not counting this symbol
                jl next_symbol
                cmp al, 7Ah           ;if it's ASCII greater than (7Ah)  -> not counting this symbol
                jg next_symbol
                ;---------------------------
                
                ;If lowercase
                ;---------------------------
                inc [lower_count]     ;increment lowercase_counter
                lea si, alphabet         ;increment counter of letter
                sub al, 61h           ;evaluate index of letter
                mov ah, 0h
                mov bl, 4h
                mul bl                ;multiply this index by 4, because in array every symbol = 4bytes
                mov ah, 0h            ;for a reslut in AL we have bias
                mov bh, 0h            ;preventing errors by setting to 0 BH and AH
                mov bx, ax
                mov dx, [bx+si]
                inc dx                ;increment counter of current letter
                mov [bx+si], dx
                
                mov dx, [bx+si]
                cmp dx, [max]         ;Check if number of current letters is maximum
                jle next_symbol
                mov [max], dx
            
            next_symbol:
            loop chars_reading
        
        end_string: 
        pop cx                       ;Getting back counter outer loop counter
        loop reading_loop
    print_symbol 0Ah
        ;----------------------------


;-------------------------
    
    ;Printing number of UPPERCASE symbols
    print_string upper_title
    mov al, upper_count
    print_number

;-------------------------
    
    ;Printing number of lowercase symbols
    print_string lower_title
    mov al, lower_count
    print_number
    
;-------------------------

    ;Printing max-frequenty
    print_string max_title
    mov ax, max
    print_number

    print_symbol 0Ah
;---------------------------

    ;Printing Histogram
    ;we'll print [max] number of strings
    ;because the most frequently appeared symbol we meet [max] times

    mov cx, [max]
    print_histo:
        push cx                       ;Saving outer loop counter

        mov cx, 26                    ;Set new counter for going through alphabet
        mov si, alphabet                 ;Get address of alphabet
        print_space_hash:
            mov dx, [max]
            mov bx, [si]
            cmp bx, 0h                ;Check wheter letter appeared in text or not
            je pass
            cmp dx, bx                ;Was it appeared  as many times as value in [max] times
            jg space
            print_symbol 23h          ;Print # if it appeared as many times as value in [max] times
            jmp pass
            
            space:
            print_symbol 0h              ;Print space if it appeared less times than value in [max] times
            
            pass:
            add si, 4h              ;Going to the next letter
            loop print_space_hash
        
        dec [max]                   ;As we print # or space we decrement value in [max]
        print_symbol 0Ah       
        pop cx
        loop print_histo


    ;--------------------------
    
    ;Printing used in string letters
    lea si, alphabet
    mov bx, 0
    mov cx, 26
    print_used_alph:
        mov dx, [si]
        cmp dx, 0h                  ;If counter os letter frequency is not null -> we'll print it
        je letter_not_used
        mov dx, 41h                 ;Loading code of A letter
        add dx, bx                  ;adding shift(number of letter)
        mov ah, 02h
        int 21h
        
        letter_not_used:
        inc bx                      ;going to the next symbol
        add si, 4h                  ;add 4 to start index, because in array every symbol = 4bytes
        loop print_used_alph
    print_symbol 0Ah
    print_symbol 0Ah
    ;--------------------------

        
    ;Printing frequency of all elements
    lea si, alphabet
    mov cx, 26
    print_frequency:
        mov ax, [si]
        aam                         ;This part like in a macro at the top,
        add ax, 3030h               ;but here we print letters from register
        push ax
        mov dl, ah
        mov ah, 02h
        int 21h
        pop dx
        mov ah, 02h
        int 21h        
        print_symbol 0h
        
        add si, 4h
        loop print_frequency
    print_symbol 0Ah
    print_symbol 0h
    ;----------------------


    ;Printing alphabet
    mov bx, 0
    mov cx, 26
    print_full_alpha:
        mov dx, bx                  
        add dx, 41h                 ;Adding to the shift number of first letter 
        
        mov ah, 02h
        int 21h
        
        print_symbol 0h             ;Printing two spaces for beauty
        print_symbol 0h
        inc bx
        loop print_full_alpha
    ;-------------------------
    
    mov ax,4c00h
    int 21h
end main