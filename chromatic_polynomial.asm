[org 0x0100]





jmp start

printMsg:
    push bp
    mov bp,sp

        pusha

            mov dx, [bp+6]
            mov  cx, [bp+4]
            mov  bx, 1          ; Device/handle: standard out (screen)
            mov  ah, 0x40       ; ah=0x40 - "Write File or Device"
            int  0x21           ; call dos services

        popa

    pop bp
RET 4

cp:
	push bp
	mov bp,sp
	
	mov bx,[bp+6]
	mov cx,[bp+4]
	
	
	mov si,0
	outer_loop:
		mov cx,1
			flag:
				mov ax,3	;calculating offset to put the the color in the array
				mul si
				add ax,4
				push si
				mov si,ax
				mov [bx+si],cx	;assigning color to the edge
				pop si
				
				mov di,0
				inner_loop:
					cmp si,di
					jne continue
					
					add di,2
					cmp di,[bp+4]
					jne inner_loop	
					
					
					
					continue:
				if1:	;1st cindition
					mov ax,3 
					mul di
					add ax,0
					push di
					mov di,ax
					mov ax,[bx+di]
					pop di
					
					
					push ax
					mov ax,3 
					mul si
					add ax,0
					push si
					mov si,ax 
					mov dx,[bx+si]
					pop si
					pop ax
					
					cmp ax,dx
					je if2
					
					;2nd condition
					mov ax,3 
					mov ax,3 
					mul di
					add ax,0
					push di
					mov di,ax
					mov ax,[bx+di]
					pop di
					
					push ax
					mov ax,3 
					mul si
					add ax,2
					push si
					mov si,ax 
					mov dx,[bx+si]
					pop si
					pop ax
					
					cmp ax,dx
					je if2
					
					;3rd condition
					mov ax,3 
					mul di
					add ax,2
					push di
					mov di,ax
					mov ax,[bx+di]
					pop di
					
					push ax
					mov ax,3 
					mul si
					add ax,0
					push si
					mov si,ax 
					mov dx,[bx+si]
					pop si
					pop ax
					
					cmp ax,dx
					je if2
					
					;4th condition
					mov ax,3 
					mul di
					add ax,2
					push di
					mov di,ax
					mov ax,[bx+di]
					pop di
					
					push ax
					mov ax,3 
					mul si
					add ax,2
					push si
					mov si,ax 
					mov dx,[bx+si]
					pop si
					pop ax
					
					cmp ax,dx
					je if2
					
					jmp inc_outer_loop
					
						if2:	mov ax,3 
							mul di
							add ax,4
							push di
							mov di,ax
							mov ax,[bx+di]
							pop di
							
							push ax
							mov ax,3 
							mul si
							add ax,4
							push si
							mov si,ax 
							mov dx,[bx+si]
							pop si
							pop ax
							
							cmp ax,dx
							jne inc_inner_loop
							
							inc cx
							jmp flag
					
				inc_inner_loop:	
					add di,2
					cmp di,[bp+4]
					jne inner_loop	
					

	inc_outer_loop:
		add si,2
		cmp si,[bp+4]
		jne outer_loop
		
		
	;finding coloring index
		mov dx,-1
		mov cx,[bp+4]
		mov si,0
	max_loop: 
		mov ax,3 
		mul si
		add ax,4
		push si
		mov si,ax 
		mov ax,[bx+si]
		pop si
		
		cmp dx,ax
		jge inc_max_loop
		mov dx,ax
		
		
	inc_max_loop:
		add si,2
		cmp si,cx
		jne max_loop

	mov word [cpi], dx	
	
	pop bp
	ret 4



start:
	push arr
	mov ax,[m]
	mov cx,2
	mul cx
	push ax
	call cp
	
	push str1
	push len1
	call printMsg
	
	mov dx,[cpi]		;printing the chromatix index
	add dx,48
	mov [cpi],dx
	;add word [cpi],48
	mov dx,cpi
	mov cx,1
	mov bx,1
	mov  ah, 0x40      
        int  0x21       

	pusha
        push endl
        push endlLen
        call printMsg
        popa

	mov cx,[m]
	;mul 2
	;mov cx,ax
	mov si,0
	mov bx,arr
	print:	
		pusha
		push str2
		push len2
		call printMsg
		popa 
		
		pusha
		
		mov ax,3 
		mul si
		add ax,4
		push si
		mov si,ax 
		;add word [bx+si],48
		add bx,si
		add word [bx],48
		mov dx,bx
		sub bx,si
		pop si
	
		mov cx,1
		mov bx,1
		mov  ah, 0x40      
        	int  0x21
 		
 		pusha
        	push endl
        	push endlLen
        	call printMsg
        	popa
        	
        	popa
        	add si,2   
		loop print
	
exit:
	mov ax,0x4c
	int0x21
		
m dw 5
n dw 3
c dw 0
cpi dw 0

arr dw 3,1,0
    dw 2,4,0
    dw 5,2,0
    dw 4,3,0
    dw 1,5,0	


str1 db 'The chromatic polynomial of the graph is:'
len1 EQU $ - str1

str2 db 'The color of the edge is '
len2 EQU $ - str2

endl        db ' ', 0x0a
endlLen     EQU $-endl
