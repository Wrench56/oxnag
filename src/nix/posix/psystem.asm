; ===== [ EXTERNS  ] =====
extern fork
extern execve
extern exit
extern waitpid

; ===== [ INCLUDES ] =====
%include "src/flags.inc"
%include "src/cdef.inc"


; ===== [  .DATA  ] =====
    args           db "/bin/sh", 0, "-l", NULL
    status         dd 0

; ===== [  .TEXT  ] =====
section .text

; IN: pointer to command (null-terminated)
; OUT: status (check `system()` POSIX man page)
global psystem
psystem:
    test            rdi, rdi
    jz              .access

    call            fork                                   ; ==> pid_t
    test            rax, rax
    jnz             .parent

    cmp             rax, -1
    je              .fork_fail

    mov             rdi, args                               ; const char* pathname
    mov             rsi, args                               ; char* const argv[]
    xor             rdx, rdx                                ; char* const envp[]
    call            execve                                  ; ==> int

    mov             rdi, 127                                ; int status
    call            exit                                    ; ==> void

.parent
    mov             rdi, rax                                 ; pid_t pid
    mov             rsi, status                              ; int* status
    xor             rdx, rdx                                 ; int options
    call            waitpid

    mov             rax, [rel status]
    ret

.access:
    mov             rdi, args                                 ; const char* pathname
    mov             rsi, X_OK                                 ; int mode
    call            access                                    ; ==> int

    add             rsp, 16
    ret

.fork_fail:
    mov             rax, -1
    ret

