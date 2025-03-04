; Writer program to send data to port 5030
section .data
    ip_addr     db  50, 188, 120, 138    ; IP: 50.188.120.138
    port        dw  0x8913              ; Port 5030 (network byte order: 0x1389)
    message     db  "Hello from writer!", 0
    msg_len     equ $ - message

section .bss
    sockfd      resq 1
    sockaddr    resb 16                 ; sockaddr_in structure

section .text
    global _start

_start:
    ; Create socket (AF_INET = 2, SOCK_STREAM = 1, protocol = 0)
    mov rax, 41         ; sys_socket
    mov rdi, 2          ; AF_INET
    mov rsi, 1          ; SOCK_STREAM
    mov rdx, 0          ; protocol
    syscall
    mov [sockfd], rax

    ; Prepare sockaddr_in structure
    mov word [sockaddr], 2          ; AF_INET
    mov word [sockaddr+2], 0x8913   ; port 5030 in network byte order
    mov dword [sockaddr+4], 0x8A78BC32  ; IP 50.188.120.138 in network byte order
    mov qword [sockaddr+8], 0       ; padding

    ; Connect to remote host
    mov rax, 42         ; sys_connect
    mov rdi, [sockfd]
    mov rsi, sockaddr
    mov rdx, 16         ; sockaddr length
    syscall

    ; Send message
    mov rax, 1          ; sys_write
    mov rdi, [sockfd]
    mov rsi, message
    mov rdx, msg_len
    syscall

    ; Close socket
    mov rax, 3          ; sys_close
    mov rdi, [sockfd]
    syscall

    ; Exit
    mov rax, 60         ; sys_exit
    xor rdi, rdi
    syscall
