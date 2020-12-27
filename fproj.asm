%include "simple_io.inc"

global asm_main

SECTION .data

bordar: dq 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
err1: db "incorrect  number of command line arguments",0
err2: db "input string too long ",0
simple_message: db "palindrome array: ",0
plusmsg: db "+++  ",0
dotmsg: db "...  ",0
spmsg: db "     ",0
prd: db "prd",10,0


SECTION .bss

length: resq 1
string: resq 1

SECTION .text

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; maxbord subroutine
;; expects the following parameters on the stack:  fake
;;                                                 string length
;;                                                 string address
;; returns value of maximal border in rax
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
maxpal:
	enter 0,0
	saveregs

	mov r12, [rbp+24]	;string length
	mov r13, [rbp+32]
	mov r14, 1	;max = 1
	mov r15, 2	;loop control
	add r12, 1	;L+1
	jmp LOOP1

	
	LOOP1:
		cmp r15, r12
		jge MaxpalEND
		mov rdi, 0
		mov rsi, 1	;flag = 1
		mov rbx, [rbp+32]
		jmp LOOP2
		
		LOOP2:
			cmp rdi, r15
			je LOOP2END
			
			mov cl, byte [rbx]
			add rbx, r15
			sub rbx, rdi
			sub rbx, rdi
			sub rbx, 1

			cmp cl, byte [rbx]
			je LOOP2jmp

			mov rsi, 0
			jmp LOOP1jmp			
		LOOP2jmp:
			add rdi, 1
			mov rbx, [rbp+32]
			add rbx, rdi			
			jmp LOOP2		
		
		LOOP2END:
			jmp LOOP1jmp
	
	LOOP1jmp:
		cmp rsi, 1
		je maxassign
		add r15, 2
		jmp LOOP1


	maxassign:
		mov r14, r15
		add r15, 2
		jmp LOOP1

	
	MaxpalEND:
		mov rax, r14
		restoregs
		leave 
		ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; end of maxbord routine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; simple_display subroutine
;;   expects on the stack: array lenght
;;                         address of the array
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
simple_display:
  enter 0,0
  saveregs

  mov r12, [rbp+24] ;; array length
  mov r13, [rbp+32] ;; array address

  ;; display the message
  mov rax, simple_message
  call print_string            ;; no need for print_nl as the string contains newline

  ;; display the first item of the array without the trailing comma
  mov rax, [r13]
  call print_int
  add r13, 8                   ;; next step in the array

  ;; in a loop  print comma and number
  ;; r14 controls the loop
  mov r14, 1        ;; we already displayed the first item

  S1:
    cmp r14, r12
    je S2 
    mov al, ','
    call print_char
    mov rax, [r13]
    call print_int 

    add r13,8                    ;; next step in the array
    inc r14                      ;; update the control register
    jmp S1

  S2:
    call print_nl                ;; finish the line
    restoregs
    leave
    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; end  of simple_display subroutine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; display_line subroutine
;;     expects on the stack:   level
;;                             length
;;                             array address
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
display_line:
	enter 0,0
	saveregs
		

	mov r12, [rbp+16]	;level
	mov r13, [rbp+24]	;length
	mov r14, [rbp+32]	;address array


	mov r15, 0	;loop control

	M1:
		cmp r15, r13		;if the end is reaches end the program
		je M4
		
		mov rbx, r14
		mov rsi, r15		;mov rbx, [r14+8*r15]
		imul rsi, 8
		add rbx, rsi
		
	
		mov rsi, r12
		add rsi, 1		;level + 1

 
		cmp[rbx], rsi	;compare palar[i] with level+1
		jl Empty
		
		mov cl, byte '+'	; assigns a to be +
		jmp continue		; jumps to continue

	Empty:
		mov cl, byte ' '	; else assigns nothing to a 
		jmp continue		; jumps to conntinue
		
	continue:
		mov rsi, 0		; runs for loop starting from 0
		M2:
			cmp rsi, [rbx]	; runs up to the length of the index in palar rbx
			je L2END	; if at any point the counter is greater it ends the loop

			mov al, cl	; prints the + or the empty space
			call print_char
			
			;mov al, byte ' ' 
			;call print_char
			
			inc rsi
			jmp M2
	L2END:
		mov rsi, r13
		sub rsi, 1
		cmp r15, rsi
		je printnothing
	
		mov rsi, r12
		sub rsi, 1
		cmp r12, 0
		je printdot

		mov al, byte ' ' 
		call print_char
		jmp LOOPiterate		


	printnothing:
		mov al, byte ' '
		call print_char 	
		jmp M4

		
	printdot:
		mov al, byte '.'
		call print_char
		jmp LOOPiterate

	LOOPiterate:
		add r15, 1
		jmp M1	

	M4:
		;mov rax, -1
		;call print_int
		call print_nl
		restoregs
		leave
		ret
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; end of display_line subroutine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; fancy_display subroutine
;;   expects on the stack:  fake
;;                          length
;;                          array address
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fancy_display:
	enter 0,0
	saveregs
	
	mov r12, [rbp+24]	;length
	mov r13, [rbp+32]	;array address

	mov r14, 0		;holds max
	mov r15, 0		;controls the loop

	K1:
		cmp r15, r12
		je K3
		
		cmp r15, r14
		jg K2
		
		inc r15
		jmp K1

	K2:
		mov r14, r15
		inc r15
		jmp K1

	K3:
		mov rbx, r14
		sub rbx, 1			;loop 2 control	
		jmp K4

	K4:
		cmp rbx, -1
		je K5

		push r13
		push r12
		push rbx
		call display_line
		add rsp, 24


		sub rbx, 1
		jmp K4


	K5:
		restoregs
		leave 
		ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  end of fancy_display
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; asm_main subroutine
;;    expects 1 command line argument, a string of length between 1 and 12
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_main:
  enter 0,0
  saveregs

  ;;check number of command line arguments
  cmp rdi, 2
  jne err1_end

  ;; safe registers to use rbx, r12, r13, r14, r15

  mov rbx, [rsi+8]  ;; rbx points to the string
  mov rax, rbx
  call print_string
  call print_nl
  ;; we need to remember the beginning of the string, we use memory location [string]
  mov [string], rbx

  mov r12, 0        ;; counter for the bytes
  L1:
    ;; need to compare [r12] with null byte
    ;; memory versus memory is not permitted, must use register versus memory
    mov al, byte 0       ;; al contains null byte
    cmp al, byte [rbx]
    je L2
    inc rbx
    inc r12
    jmp L1
  L2:
    ;; r12 contains the length
    ;; is the length OK ?
    cmp r12, 16
    ja err2_end

    ;; length is OK, remember it in memory location [length]
    mov [length], r12


    ;; [string] is the address of the string
    ;; [length] is the length of the string and also the length of the resulting arraryu
    ;; bordar is the address of the array

    ;; the main loop
    ;; we use r12 to step through the string
    mov r12, [string]
    ;; we use r13 to hold the length
    mov r13, [length]
    ;; we use r14 to step through the array
    mov r14, bordar

    ;; the loop is controlled by r13, until it is 0
  L3:
    cmp r13, 0
    je L4
 
    ;; call maxbord   
    push r12     ;; push the moving string address
    push r13     ;; push the moving length
    sub rsp, 8   ;; push fake
    call maxpal
    add rsp, 24  ;; clean the stack

    ;; returned value is in rax, store it in the array
    mov [r14], rax

    inc r12      ;; next step in the string
    dec r13      ;; decrement the length
    add r14, 8   ;; next step in the array
    jmp L3
  L4:
    ;; the array bordar is filled with numbers

    ;; r12 does not point to the beginning of the string anymore
    ;; r13 is not the length of the string anymore
    ;; r14 does not point to the beginning of the array anymore

    ;; call simple_display
    push bordar           ;; push array
    push qword [length]   ;; push length
    sub rsp, 8            ;; push fake
    call simple_display
    add rsp, 24           ;; clean teh stack

    ;; call fency_display
    push bordar           ;; push array
    push qword [length]   ;; push length
    sub rsp, 8            ;; push fake
    call fancy_display
    add rsp, 24           ;; clean teh stack

    ;; done, go to end
    jmp asm_main_end

err1_end:
  mov rax, err1
  call print_string
  jmp asm_main_end

err2_end:
  mov rax, err2
  call print_string
  jmp asm_main_end

asm_main_end:
  restoregs 
  leave
  ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; end of asm_main subroutine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
