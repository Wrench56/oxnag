; ===== [ EXTERNS  ] =====
extern ReleaseDC
extern DestroyWindow
extern ExitProcess

extern wglMakeCurrent
extern wglDeleteContext

extern wconsole_cleanup
extern wunregister_win_class

extern hWnd
extern hRC
extern hDC
extern hInstance

; ===== [ INCLUDES ] =====
%include "includes/common/macros.inc"
%include "includes/win/typedef.inc"
%include "includes/win/macros.inc"

; ===== [  .DATA   ] =====
section .data
    exit_msg        db "[      ] Bye-bye!", 10
    exit_msg_len    equ $ - exit_msg
    errorTitle      db "Error: wcleanup.asm", 0
    errorMsg        db "[ wgui_cleanup ]  Error during cleanup", 0

; ===== [  .TEXT   ] =====
section .text
extern wcleanup
wcleanup:
    enter           32, 0

    log             exit_msg, exit_msg_len

    call            wgui_cleanup

    call            wconsole_cleanup

    xor             rcx, rcx
    call            ExitProcess

    leave
    ret


wgui_cleanup:
    enter           32, 0

    mov             rcx, NULL
    mov             rdx, NULL
    call            wglMakeCurrent
    cmp             rax, 0
    je              .error

    mov             rcx, [rel hRC]
    call            wglDeleteContext
    mov             qword [rel hRC], NULL
    cmp             rax, 0
    je              .error

    mov             rcx, [rel hWnd]
    mov             rdx, [rel hDC]
    call            ReleaseDC
    mov             qword [rel hDC], NULL
    cmp             rax, 0
    je              .error

    mov             rcx, [rel hWnd]
    call            DestroyWindow
    mov             qword [rel hWnd], NULL
    cmp             rax, 0
    je              .error

    call            wunregister_win_class
    mov             qword [rel hInstance], NULL

    leave
    ret
.error:
    wfatal_error    errorTitle, errorMsg
