CPU X64

; ===== [ EXTERNS  ] =====
extern wregister_win_class
extern wcreate_win
extern wshow_win
extern wmainloop_win

extern wgl_spfd
extern wgl_init_context

extern glinit

extern ExitProcess
extern GetModuleHandleA
extern GetDC

; ===== [ INCLUDES ] =====

%include "includes/common/preprocessors.inc"

%ifidn __OUTPUT_FORMAT__, win64
    %include "includes/win/winuser.inc"
    %include "includes/win/wingdi.inc"
%endif

; ===== [  .DATA   ] =====
section .data
    wndTitle            db "OxNAG", 0
    hInstance           dd 0
    hWnd                dd 0
    hDc                 dd 0
    hRC                 dd 0


; ===== [  .TEXT   ] =====
section .text

global _start
_start:
    sub         rbp, 8
    enter       32 + 16, 0

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
    mov         [rel hDc], rax

    ; Choose pixel settings
    mov         rcx, rax
    call        wgl_spfd

    ; Init Rendering Context
    mov         rcx, [rel hDc]
    call        wgl_init_context

    mov         [rel hRC], rax

    ; Show window
    mov         rcx, rax
    call        wshow_win

    call        glinit

    ; Run window
    call        wmainloop_win

    call         _exit


_exit:
    enter       32, 0

    xor         rcx, rcx
    call        ExitProcess
