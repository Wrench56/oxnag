; ===== [ EXTERNS  ] =====
extern write

; ===== [ INCLUDES ] =====
%include "includes/posix/unistd.inc"

; ===== [  .DATA   ] =====
section .data

; ===== [  .TEXT   ] =====
section .text

; IN:
;   RDI: message pointer
;   RSI: message length
extern pprint
pprint:
    mov             rdx, rsi
    mov             rsi, rdi
    mov             rdi, STDOUT
    call            write

    ret
