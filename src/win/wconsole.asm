; ===== [ EXTERNS  ] =====
extern WriteConsoleA
extern GetStdHandle
extern AllocConsole

; ===== [ INCLUDES ] =====
%include "includes/common/preprocessors.inc"
%include "includes/win/macros.inc"

; ===== [  .DATA   ] =====
section .data
    stdout                dd 0
    getStdFatalTitle      db "Error: wconsole.asm", 0
    getStdErrMessage      db "[ wload_stdout ]  Failed to get console handle", 0

; ===== [  .TEXT   ] =====
section .text
extern wload_stdout
wload_stdout:
    enter           32, 0

    call            AllocConsole

    mov             rcx, STD_OUTPUT_HANDLE
    call            GetStdHandle

    cmp             rax, 0
    je              .failure_console_info
    mov             [rel stdout], rax

    leave
    ret

.failure_console_info:
    wfatal_error    getStdFatalTitle, getStdErrMessage

; IN:
;   RCX: message pointer
;   RDX: message length
extern wprint
wprint:
    enter           32 + 8 * 1, 0

    mov             r8, rdx
    mov             rdx, rcx

    mov             rcx, [rel stdout]
    mov             r9, NULL
    mov             qword arg(1), NULL
    call            WriteConsoleA

    leave
    ret
