; ===== [ EXTERNS  ] =====
extern write

; ===== [ INCLUDES ] =====
%include "includes/posix/unistd.inc"
%include "includes/common/macros.inc"

; ===== [  .DATA   ] =====
section .data

; ===== [  .TEXT   ] =====
section .text

; IN:
;   RDI: message pointer
;   RSI: message length
extern pprint
pprint:
    prologue        0

    mov             rdx, rsi
    mov             rsi, rdi
    mov             rdi, STDOUT
    call            write

    epilogue        0
    ret
