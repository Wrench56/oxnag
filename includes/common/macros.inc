%include "src/flags.inc"

; Arguments:
;  > 1: string - message
;  > 2: number - length of message
%ifidn __OUTPUT_FORMAT__, win64
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
    %ifidn __OUTPUT_FORMAT__, win64
        enter       %1, %2
    %endif
%endmacro

; No arguments
%macro epilogue 0
    %ifidn __OUTPUT_FORMAT__, win64
        leave
    %endif
%endmacro
