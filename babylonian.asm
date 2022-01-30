.model small
.stack 100h
.data
    nr dw 0 ; initializez variabila nr cu 0
    cifra dw 0
    y dw 1
    x dw 0
    d dw 2
    mesaj db 'Introduceti un numar intreg pozitiv! $'

.code
    mov bx, @data
    mov ds, bx 

    mov dx, offset mesaj ; offset e ca & in cpp
    mov ah, 09h
    int 21h

    mov dl, 13 ; linie noua
    mov ah, 02h 
    int 21h

    mov dl, 10 ; carriage return
    mov ah, 02h
    int 21h

    ; citesc numarul
    citire: 
        mov ah, 01h    
        int 21h ; citesc caracterul si ramane codul ascii in al      
        cmp al, 13 ; repet citirea pana dau de enter 
        je citireterminata 
        mov ah, 0   ; resetez ah de cand l-am folosit sa citesc   
        sub al, 48 ; scad 48 ca sa transform din ascii in cifra   
        mov cifra, ax ; salvez cifra citita pt mai tarziu
        mov ax, nr    
        mov bx, 10     
        mul bx ; pregatesc numarul sa adaug o noua cifra la final     
        mov nr, ax    ; mut numarul prelucrat in nr
        mov ax, cifra ; iau cifra citita
        add nr, ax    ; si o adaug la final
        jmp citire


    citireterminata: ; am citit complet numarul
        mov cx, 0 ; initializez contorul cu 0 pentru mai tarziu

        mov ax, nr
        sub ax, y
        cmp ax, 0 ; verific daca (x - y) respecta conditia
        jle cazSpecial

        mov ax, nr
        mov x, ax

    babylonian:
        mov ax, x
        add ax, y ; ax = x + y
        mov dx, 0 ; golesc dx deoarece fac o op intre registru si memorie
        div d ; ax devine (x + y) / 2
        mov x, ax ; noul x

        mov ax, nr ; ii dau lui ax valoarea numarului initial
        mov dx, 0 ; golesc dx ca sa impart
        div x
        mov y, ax ; noul y
        mov ax, x
        sub ax, y ; fac x - y ca sa verific conditia
        cmp ax, 0
        jle amTerminat
        jmp babylonian

    special PROC
        mov ax, nr 
        jmp descompunere
        ret
    special ENDP

    cazSpecial:
        call special

    amTerminat:
        mov ax, x

    descompunere:
        mov dx, 0   ; golesc dx de fiecare data ca sa iau restul (ultima cifra a numarului)
        mov bx, 10   
        div bx ; iau ultima cifra a numarului
        push dx ; introduc cifra in stiva
        inc cx ; numar cifrele numarului
        cmp ax, 0 ; verific daca am introdus toate cifrele numarului in stiva  
        je afisare 
        jmp descompunere ; repeta pana cand catul devine 0


    afisare:
        pop dx ; scoate din stiva in dx    
        add dl, 48 ; adun 48 ca sa fac cifra cod ascii
        mov ah, 02h ; afisez un char
        int 21h
        loop afisare ; repeta de cx ori 
    
    mov ah, 4ch
    int 21h
end