%include "includes/win/typedef.inc"

extern MessageBoxA
extern GetLastError
extern ExitProcess

%macro mMessageBoxA 3
    mov     rcx, NULL
    lea     rdx, [rel %2]
    lea     r8, [rel %1]
    mov     r9, %3
    call    MessageBoxA
%endmacro

%macro fatal_error 2
    call            GetLastError
    mov             rbx, rax
    mMessageBoxA    %1, %2,  MB_ICONEXCLAMATION | MB_OK
    mov             rcx, rbx
    call            ExitProcess
%endmacro
