section .data
        fizz db "Fizz", 10, 0
        buzz db "Buzz", 10, 0
        fizzbuzz db "FizzBuzz", 10, 0
        fizz_len equ buzz - fizz - 1        ; string length is one byte less then the object size
        buzz_len equ fizzbuzz - buzz - 1
        fizzbuzz_len equ $ - fizzbuzz - 1

section .bss
        num_str resb 5 ; 3 digits + \n + \0
        num_str_sz equ $ - num_str


section .text
        global _start

_start:
        mov r8, 1 ; Main loop counter init

loop:
      mov rbx, 3
      mov rcx, 5

      xor rdx,rdx
      mov rax,r8
      div rbx
      cmp rdx, 0
      sete bl

      xor rdx,rdx
      mov rax,r8
      div rcx
      cmp rdx, 0
      sete bh

      cmp bx, 257 ; see if both bh and bl are set to 1
      je print_fizzbuzz

      cmp bl, 1
      je print_fizz

      cmp bh, 1
      je print_buzz


print_number:
        mov rax, r8 ; arg1 == counter
        mov rbx, num_str ; arg2 == pointer to buffer for string
        mov rcx, num_str_sz - 1 ; give i_to_s() buffer size - 1
                                 ; to leave room for '\n' at the end
        call itoa ; rax value turned into str in num_str, pointed to by rdi

        mov rdx, num_str + num_str_sz ; ptr to end of str buffer
        sub rdx, rdi     ; rdx == actual strlen(num_str), we still have the pointer in rdi

        mov byte [num_str + num_str_sz - 1], 10 ; Overwrite '\0' with '\n'
        mov byte [num_str + num_str_sz], 0 ; Add '\0' at the true end of the string

        mov rsi, rdi ; copy str pointer to correct register for syscall argument

        jmp call_sys_write

print_fizzbuzz:
        mov rsi, fizzbuzz ; copy str pointer to correct register for syscall argument
        mov rdx, fizzbuzz_len ; copy string length to correct register for syscall argument
        jmp call_sys_write

print_fizz:
       mov rsi, fizz
       mov rdx, fizz_len
       jmp call_sys_write

print_buzz:
       mov rsi, buzz
       mov rdx, buzz_len

call_sys_write:
        mov rax, 1 ; call sys_write
        mov rdi, 1 ; write to stdout
                   ; rsi alredy has the pointer to the str
                   ; rdx already has the str length
        syscall    ; *Reminder* rcx and r11 get clobberd by syscall

        inc r8 ; r8++
        cmp r8, 101
        jne loop ; Main loop end, loop exits when rbx == 101

        mov rax, 60 ; exit program (rdi == exit status)
        mov rdi, 0
        syscall

itoa: ; stringify integer
        ; input in rax
        ; str ptr in rbx
        ; str length in rcx
        ; string stored in num_str global var
        ; returns a pointer to the begining of the string in rdi
        push rdx ; Will use these regsiters so saving them now
        push r8

        mov rdi, rcx  ; init loop counter
        dec rdi

itoa_loop: ; Start of itoa_loop

       cmp rax, 9 ; exit loop if we have only one digit left
       jle itoa_loop_exit

        xor rdx,rdx ; clear rdx
        mov r8, 10 ; divide by 10
        div r8 ; rdx gets least siginificant digit
        add dl, 48 ; turn binary number into actuall ascii/utf8 digit char
        mov [rbx + rdi], dl ; move lower 8 bits of rdx into buffer
        dec rdi

        cmp rdi, 0 ; exit loop if reached end of str buffer (rdi == 0)
        je itoa_loop_exit

        jmp itoa_loop


itoa_loop_exit:
       mov byte [rbx + rcx], 0 ; put null in the end of string
       cmp rdi, 0 ; did we get here because we ran out of room?
       je buffer_full

       add al, 48 ; turn binary number into actuall ascii/utf8 digit char
       mov [rbx + rdi], al ; move first digit into num_str
       jmp skip_buffer_full

buffer_full:                ; Fixup rdi to point to start of string in num_str
       mov rdi, rbx
       jmp end
skip_buffer_full:
       add rdi, rbx
       jmp end

end:   pop r8
       pop rdx
       ret
