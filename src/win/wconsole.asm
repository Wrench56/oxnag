; ===== [ EXTERNS  ] =====
extern WriteConsoleA
extern GetStdHandle
extern AllocConsole
extern FreeConsole

; ===== [ INCLUDES ] =====
%include "includes/common/preprocessors.inc"
%include "includes/win/macros.inc"

; ===== [  .DATA   ] =====
section .data
    stdout                dq 0
    fatalTitle      db "Error: wconsole.asm", 0
    getStdErrMessage      db "[ wload_stdout ]  Failed to get console handle", 0
    freeConsoleErrMessage db "[ wconsole_cleanup ]  Failed to detach from console", 0

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
    wfatal_error    fatalTitle, getStdErrMessage


extern wconsole_cleanup
wconsole_cleanup:
    enter           32, 0

    call            FreeConsole
    cmp             rax, 0
    je              .failure_free_console

    leave
    ret
.failure_free_console:
    wfatal_error    fatalTitle, freeConsoleErrMessage


; IN:
;   RDI: message pointer
;   RSI: message length
extern wprint
wprint:
    enter           32 + 8 * 1, 0

    mov             rcx, [rel stdout]
    mov             rdx, rdi
    mov             r8, rsi
    mov             r9, NULL
    mov             qword arg(1), NULL
    call            WriteConsoleA

    leave
    ret
