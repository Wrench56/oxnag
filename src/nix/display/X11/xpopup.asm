; ===== [ EXTERNS  ] =====
extern memccpy
extern system

; ===== [ INCLUDES ] =====

%include "src/flags.inc"
%include "includes/common/macros.inc"
%include "includes/common/preprocessors.inc"

MAX_LENGTH              EQU 255 - 36

; ===== [  .DATA   ] =====
section .data
    command         db "printf '"
    text            times MAX_LENGTH + 1 db 32
    ______________  db " | xmessage -center -file -", 0

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
    mov             rdx, 0
    mov             rcx, MAX_LENGTH
    call            memccpy
    
    test            rax, rax
    je              .show_popup

    ; Add newline
    mov             byte [rax - 1], 92
    mov		        byte [rax], 110
    inc             rax

    ; Load message
    mov             rdi, rax
    mov	            rsi, rbx
    mov		        rdx, 0

    lea             rcx, [rel text + MAX_LENGTH]
    sub             rcx, rax
    call            memccpy

    test            rax, rax
    je              .close_at_end

    ; Add closeing quote
    mov             byte [rax - 1], 39
    jmp             .show_popup

.close_at_end:
    mov             byte [rel text + MAX_LENGTH + 1], 39

.show_popup:
    ; Show popup
    lea             rdi, [rel command]
    call            system

    ret
