section .text

; WARNING:
; The string's max length is 4GB
; IN: RDI - Pointer to string
extern strlen
strlen:
    push            rbx
    push            rdi
    xor             al, al
    mov             rcx, 0xffffffff
    repne           scasb
    mov             rax, rdi
    pop             rdi
    sub             rax, rdi
    dec             rax
    pop             rbx
    ret
