
section .text
global _start
_start:

    ; PID
    mov r15, 248683
    ; ADDRESS
    mov r14, 0x0000000000403680
    ; INJECT DATA
    mov r13, 0x48545541

    ; PTRACE_ATTACH
    mov rax, 101
    mov rdi, 16          ; PTRACE_ATTACH (0x10)
    mov rsi, r15         ; PID
    xor rdx,rdx          ; addr
    xor r10, r10         ; data
    syscall


    ; WAIT4: 
        ; Cuando se hace PTRACE_ATTACH, el kernel envía SIGSTOP al proceso objetivo. 
        ; Es necesario llamar a wait4 para bloquear al tracer hasta que el proceso tracee  
        ; esté efectivamente detenido antes de poder manipularlo.

        mov rax, 61
        mov rdi, r15            ; PID a esperar (-1 para cualquier hijo)
        sub rsp, 8
        mov rsi, rsp            ; &status
        xor rdx, rdx            ; options
        xor r10, r10            ; rusage
        syscall

    ; PTRACE_PEEKDATA (leer memoria)
    mov rax, 101
    mov rdi, 2       ; PTRACE_PEEKDATA
    mov rsi, r15     ; PID
    mov rdx, r14     ; addr
    sub rsp, 8
    mov r10, rsp     ; puntero a data (direccion donde se almacenará la info leída)
    syscall 


    ; PTRACE_POKEDATA (escribir en memoria)
    mov rax, 101
    mov rdi, 5     ; PTRACE_POKEDATA
    mov rsi, r15   ; PID
    mov rdx, r14   ; addr 
    mov r10, r13   ; valor de 8 bytes a escribir
    syscall

    ; EXIT
    mov rax, 60
    xor rdi,rdi 
    syscall
