; ===== [ EXTERNS  ] =====
extern wregister_win_class
extern wcreate_win
extern wshow_win

extern wgl_spfd
extern wgl_init_context
extern wsave_hDC

extern GetModuleHandleA
extern GetDC

extern wload_stdout

extern hWnd
extern hRC
extern hDC

%include "src/flags.inc"


; ===== [  .DATA   ] =====
section .data
    wndTitle        db "OxNAG", 0
    hInstance       dq 0


section .text
extern wboot
wboot:
    enter           32, 0

    %ifdef LOG_TO_CONSOLE
        call            wload_stdout
    %endif

    leave
    ret


extern wboot_gui
wboot_gui:
    enter           32 + 2 * 8, 0

    xor             rcx, rcx
    call            GetModuleHandleA
    mov             [rel hInstance], rax

    ; Register custom window class
    mov             rdi, rax
    call            wregister_win_class

    ; Create window (returns hWnd)
    mov             rdi, [rel hInstance]
    lea             rsi, [rel wndTitle]
    call            wcreate_win
    mov             [rel hWnd], rax

    mov             rcx, [rel hWnd]
    call            GetDC
    mov             [rel hDC], rax

    ; Choose pixel settings
    mov             rdi, rax
    call            wgl_spfd

    ; Init Rendering Context
    mov             rdi, [rel hDC]
    call            wgl_init_context
    mov             [rel hRC], rax

    ; Show window
    mov             rdi, [rel hWnd]
    call            wshow_win

    leave
    ret
