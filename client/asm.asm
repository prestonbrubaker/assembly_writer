; Reader program to listen on port 5030
section .data
    port        dw  0x8913          ; Port 5030 (network byte order)
    backlog     equ 5

section .bss
    sockfd      resq 1
    clientfd    resq 1
    sockaddr    resb 16
    buffer      resb 64
    client_addr resb 16

section .text
    global _start

_start:
    ; Create socket
    mov rax, 41         ; sys_socket
    mov rdi, 2          ; AF_INET
    mov rsi, 1          ; SOCK_STREAM
    mov rdx, 0          ; protocol
    syscall
    mov [sockfd], rax

    ; Prepare sockaddr_in structure
    mov word [sockaddr], 2          ; AF_INET
    mov word [sockaddr+2], 0x8913   ; port 5030
    mov dword [sockaddr+4], 0       ; INADDR_ANY
    mov qword [sockaddr+8], 0       ; padding

    ; Bind socket
    mov rax, 49         ; sys_bind
    mov rdi, [sockfd]
    mov rsi, sockaddr
    mov rdx, 16
    syscall

    ; Listen
    mov rax, 50         ; sys_listen
    mov rdi, [sockfd]
    mov rsi, backlog
    syscall

    ; Accept connection
    mov rax, 43         ; sys_accept
    mov rdi, [sockfd]
    mov rsi, client_addr
    mov rdx, 16
    syscall
    mov [clientfd], rax

    ; Read from socket
    mov rax, 0          ; sys_read
    mov rdi, [clientfd]
    mov rsi, buffer
    mov rdx, 64
    syscall

    ; Write to stdout
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, buffer
    mov rdx, 64
    syscall

    ; Close sockets
    mov rax, 3
    mov rdi, [clientfd]
    syscall

    mov rax, 3
    mov rdi, [sockfd]
    syscall

    ; Exit
    mov rax, 60
    xor rdi, rdi
    syscall
