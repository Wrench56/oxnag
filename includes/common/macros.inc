%include "src/flags.inc"
%include "includes/common/preprocessors.inc"

%ifidn TARGET_OS, OS_WINDOWS
    %include "includes/win/macros.inc"
%endif

; Arguments:
;  > 1: string - message
;  > 2: number - length of message
%ifnmacro log
    %macro log 2
        %ifidn TARGET_OS, OS_WINDOWS
            extern wprint
        
            %ifdef LOG_TO_CONSOLE
                mov             rdi, %1
                mov             rsi, %2
                call            wprint
            %endif
        %elifidn TARGET_OS, OS_LINUX
            extern pprint

            %ifdef LOG_TO_CONSOLE
                mov             rdi, %1
                mov             rsi, %2
                call            pprint
            %endif
        %else
            %warning The macro `log` for the current platform is not implemented
        %endif
    %endmacro
%endif

; Arguments:
;  > 1: number - stack frame size
%ifnmacro prologue
    %macro prologue 1
        %ifidn TARGET_OS, OS_WINDOWS
            sub	rsp, %1
        %endif
    %endmacro
%endif

; Arguments:
;  > 2: number - stack frame size
%ifnmacro epilogue
    %macro epilogue 1
        %ifidn TARGET_OS, OS_WINDOWS
            add rsp, %1
        %endif
    %endmacro
%endif

; Arguments:
;  > 1: number - argument number
;  > 2: any    - argument value
%ifnmacro argxmov
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
        %elifidn TARGET_OS, OS_LINUX
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
%endif

; Arguments:
;  > 1: number - argument number
;  > 2: any    - memory address or value to load
%ifnmacro argxlea
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
        %elifidn TARGET_OS, OS_LINUX
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
%endif

; Arguments:
;  > 1: string - title
;  > 2: string - message
%ifnmacro fatal_error
    %macro fatal_error 2
        %ifidn DISPLAY_SERVER, DS_WIND
            wfatal_error %1, %2
        %elifidn DISPLAY_SERVER, DS_XORG
            %ifidn TARGET_OS, OS_WINDOWS
                ; Seriously, if you are using X on Windows, you are a legend...
                %error Currently, the X display server is not supported for Windows
            %endif
            extern xpopup

            mov rdi, %1
            mov rsi, %2
            call xpopup
        %else
            %warning The macro `fatal_error` for the current display server is not implemented
        %endif
    %endmacro
%endif
