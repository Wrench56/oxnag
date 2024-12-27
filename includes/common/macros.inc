%include "src/flags.inc"
%include "includes/common/preprocessors.inc"

; Arguments:
;  > 1: string - message
;  > 2: number - length of message
%ifidn TARGET_OS, OS_WINDOWS
    extern wprint

    %macro log 2
        %ifdef LOG_TO_CONSOLE
            mov             rdi, %1
            mov             rsi, %2
            call            wprint
        %endif
    %endmacro
%endif

; Arguments:
;  > 1: number - stack frame size
;  > 2: number - nesting level
%macro prologue 2
    %ifidn TARGET_OS, OS_WINDOWS
        enter       %1, %2
    %endif
%endmacro

; No arguments
%macro epilogue 0
    %ifidn TARGET_OS, OS_WINDOWS
        leave
    %endif
%endmacro

; Arguments:
;  > 1: number - argument number
;  > 2: any    - argument value
%macro argxmov 2
    %ifidn TARGET_OS, OS_WINDOWS
        ; Windows x64 ABI
        %if %1 = 1
            mov     rcx, %2
        %elif %1 = 2
            mov     rdx, %2
        %elif %1 = 3
            mov     r8, %2
        %elif %1 = 4
            mov     r9, %2
        %elif %1 > 4
            mov     rsp + ((%1 - 1) * 8), %2
        %else
            %error Invalid "argxmov" argument number: %1
        %endif
    %elif TARGET_OS, OS_LINUX
        ; System V AMD64 ABI
        %if %1 = 1
            mov     rdi, %2
        %elif %1 = 2
            mov     rsi, %2
        %elif %1 = 3
            mov     rdx, %2
        %elif %1 = 4
            mov     rcx, %2
        %elif %1 = 5
            mov     r8, %2
        %elif %1 = 6
            mov     r9, %2
        %elif %1 > 6
            mov     [rsp + 8 * (%1 - 6)], %2
        %else
            %error Invalid "argxmov" argument number: %1
        %endif
    %else
        %error Unsupported output format
    %endif
%endmacro

; Arguments:
;  > 1: number - argument number
;  > 2: any    - memory address or value to load
%macro argxlea 2
    %ifidn TARGET_OS, OS_WINDOWS
        ; Windows x64 ABI
        %if %1 = 1
            lea     rcx, %2
        %elif %1 = 2
            lea     rdx, %2
        %elif %1 = 3
            lea     r8, %2
        %elif %1 = 4
            lea     r9, %2
        %elif %1 > 4
            ; TODO: This is relatively slow
            ;       I don't want to erase some register values though
            %warning Slow "argxlea" detected for argument %1 (assembling for Windows x64 ABI)
            xchg    [rsp + 8 * (%1 - 1)], rax
            lea     rax, %2
            xchg    [rsp + 8 * (%1 - 1)], rax
        %else
            %error Invalid "argxlea" argument number: %1
        %endif
    %elif TARGET_OS, OS_LINUX
        ; System V AMD64 ABI
        %if %1 = 1
            lea     rdi, %2
        %elif %1 = 2
            lea     rsi, %2
        %elif %1 = 3
            lea     rdx, %2
        %elif %1 = 4
            lea     rcx, %2
        %elif %1 = 5
            lea     r8, %2
        %elif %1 = 6
            lea     r9, %2
        %elif %1 > 6
            %warning Slow "argxlea" detected for argument %1 (assembling for System V AMD64 ABI)
            xchg    [rsp + 8 * (%1 - 6)], rax
            lea     rax, %2
            xchg    [rsp + 8 * (%1 - 6)], rax
        %else
            %error Invalid "argxlea" argument number: %1
        %endif
    %else
        %error Unsupported output format
    %endif
%endmacro

; Arguments:
;  > 1: string - title
;  > 2: string - message
%macro fatal_error 2
    %ifidn TARGET_OS, OS_WINDOWS
        %include "includes/win/macros.inc"
        wfatal_error %1, %2
    %endif
%endmacro
