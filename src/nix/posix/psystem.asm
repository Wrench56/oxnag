; ===== [ EXTERNS  ] =====
extern fork
extern execlp
extern exit
extern waitpid
extern access

; ===== [ INCLUDES ] =====
%include "includes/common/cdef.inc"
%include "includes/posix/unistd.inc"

; ===== [  .DATA  ] =====
    shell_path     db "/bin/sh", 0
    shell_flag     db "-c", 0
    status         dd 0

; ===== [  .TEXT  ] =====
section .text

; IN: RDI - pointer to command (null-terminated)
; OUT: status (check `system()` POSIX man page)
global psystem
psystem:
    test            rdi, rdi
    jz              .access

    mov             rbx, rdi

    call            fork                                   ; ==> pid_t

    cmp             rax, -1
    je              .fork_fail

    test            rax, rax
    jnz             .parent

    mov             rdi, shell_path                         ; const char* pathname
    mov             rsi, shell_path                         ; const char* arg0
    mov             rdx, shell_flag                         ; const char* arg1
    mov             rcx, rbx                                ; const char* arg2
    xor             r8, r8                                  ; NULL
    call            execlp                                  ; ==> int

    mov             rdi, 127                                ; int status
    call            exit                                    ; ==> void

.parent:
    mov             rdi, rax                                 ; pid_t pid
    mov             rsi, status                              ; int* status
    xor             rdx, rdx                                 ; int options
    call            waitpid

    xor             rax, rax
    mov             eax, [rel status]
    ret

.access:
    mov             rdi, shell_path                           ; const char* pathname
    mov             rsi, X_OK                                 ; int mode
    call            access                                    ; ==> int

    ret

.fork_fail:
    mov             rax, -1
    ret

