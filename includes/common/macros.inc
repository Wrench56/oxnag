%include "src/flags.inc"

%ifidn TARGET_OS, OS_WINDOWS
    %include "includes/win/macros.inc"
%elifidn TARGET_OS, OS_LINUX
    %include "includes/nix/macros.inc"
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
        ; This is equivalent to `sub rsp, 8` (LLVM optimization)
        push rax
        %ifidn TARGET_OS, OS_WINDOWS
            sub	rsp, %1
        %endif
    %endmacro
%endif

; Arguments:
;  > 2: number - stack frame size
%ifnmacro epilogue
    %macro epilogue 1
        ; This is equivalent to `add rsp, 8` (LLVM optimization)
        pop rcx
        %ifidn TARGET_OS, OS_WINDOWS
            add rsp, %1
        %endif
    %endmacro
%endif

; Arguments:
;  > 1: number - argument number
%ifidn TARGET_OS, OS_WINDOWS
    ; Windows x64 ABI
    %define __stack_arg(n) [rsp + 8 * (n + 3)]

    %define __arg1  rcx
    %define __arg2  rdx
    %define __arg3  r8
    %define __arg4  r9
    %define __arg5  __stack_arg(1)
    %define __arg6  __stack_arg(2)
    %define __arg7  __stack_arg(3)
    %define __arg8  __stack_arg(4)
    %define __arg9  __stack_arg(5)
    %define __arg10 __stack_arg(6)
    %define __arg11 __stack_arg(7)
    %define __arg12 __stack_arg(8)
    %define __arg13 __stack_arg(9)
    %define __arg14 __stack_arg(10)
    %define __arg15 __stack_arg(11)
    %define __arg16 __stack_arg(12)

%elifidn TARGET_OS, OS_LINUX
    ; System V AMD64 ABI
    %define __stack_arg(n) [rsp + 8 * n]

    %define __arg1  rdi
    %define __arg2  rsi
    %define __arg3  rdx
    %define __arg4  rcx
    %define __arg5  r8
    %define __arg6  r9
    %define __arg7  __stack_arg(1)
    %define __arg8  __stack_arg(2)
    %define __arg9  __stack_arg(3)
    %define __arg10 __stack_arg(4)
    %define __arg11 __stack_arg(5)
    %define __arg12 __stack_arg(6)
    %define __arg13 __stack_arg(7)
    %define __arg14 __stack_arg(8)
    %define __arg15 __stack_arg(9)
    %define __arg16 __stack_arg(10)

%else
    %error Unsupported output format
%endif

%define arg(n) __arg %+ n


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
            nfatal_error %1, %2
        %else
            %error The macro `fatal_error` for the current display server is not implemented
        %endif
    %endmacro
%endif

