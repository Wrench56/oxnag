CPU X64

; ===== [ EXTERNS  ] =====
extern wregister_win_class
extern wcreate_win
extern wshow_win

extern wgl_spfd
extern wgl_init_context

extern glinit

extern mainloop

extern ExitProcess
extern GetModuleHandleA
extern GetDC

extern boot_process
extern gl_context_info

; ===== [ INCLUDES ] =====

%include "includes/common/preprocessors.inc"

%ifidn __OUTPUT_FORMAT__, win64
    %include "includes/win/winuser.inc"
    %include "includes/win/wingdi.inc"
%endif

; ===== [  .DATA   ] =====
section .data
    wndTitle            db "OxNAG", 0
    hInstance           dq 0
    hWnd                dq 0
    hDC                 dq 0
    hRC                 dq 0


; ===== [  .TEXT   ] =====
section .text

global _start
_start:
    sub         rbp, 8
    enter       32 + 16, 0

    call        boot_process

    xor         rcx, rcx
    call        GetModuleHandleA
    mov         [rel hInstance], rax

    ; Register custom window class
    mov         rcx, rax
    call        wregister_win_class

    ; Create window (returns hWnd)
    mov         rcx, [rel hInstance]
    lea         rdx, [rel wndTitle]
    call        wcreate_win
    mov         [rel hWnd], rax

    mov         rcx, [rel hWnd]
    call        GetDC
    mov         [rel hDC], rax

    ; Choose pixel settings
    mov         rcx, rax
    call        wgl_spfd

    ; Init Rendering Context
    mov         rcx, [rel hDC]
    call        wgl_init_context

    mov         [rel hRC], rax

    ; Show window
    mov         rcx, [rel hWnd]
    call        wshow_win

    call        glinit

    ; OpenGL context info
    call        gl_context_info

    ; Run mainloop
    mov         rcx, [rel hDC]
    call        mainloop

    call         _exit


_exit:
    enter       32, 0

    xor         rcx, rcx
    call        ExitProcess
