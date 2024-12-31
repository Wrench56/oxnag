; ===== [ EXTERNS  ] =====
extern strncpy
extern system

; ===== [ INCLUDES ] =====

%include "src/flags.inc"
%include "includes/common/macros.inc"
%include "includes/common/preprocessors.inc"

MAX_LENGTH              EQU 128

; ===== [  .DATA   ] =====
section .data
    command         db "xmessage -center ", 0
    text            times MAX_LENGTH db 0


; ===== [  .TEXT   ] =====
section .text

; IN: RDI - title string (null-terminated)
; IN: RSI - message string (null-terminated)
global xpopup
xpopup:

    ; Save message
    mov             rbx, rsi

    ; Load title
    mov             rsi, rdi
    lea             rdi, [rel text]
    mov             rdx, MAX_LENGTH
    call            strncpy

    mov             rdi, rax
    mov             rsi, rbx

    ; Add newline
    mov             byte [rax + 1], 10

    ; Load message
    mov             rbx, MAX_LENGTH - 1
    sub             rbx, rax
    mov             rdx, rbx
    call            strncpy

    ; Show popup
    lea             rdi, [rel text]
    call            system

    ret
