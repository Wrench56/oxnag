section .text

; WARNING:
; The string's max length is 4GB
extern strlen
strlen:
    push            rbx
    mov             rbx, rcx
    xor             al, al
    mov             rdi, rcx
    mov             rcx, 0xffffffff
    repne           scasb
    sub             rdi, rbx
    dec             rdi
    mov             rax, rdi
    pop             rbx
    ret