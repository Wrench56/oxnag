%include "src/flags.inc"

; Arguments:
;  > ECX: string - message
;  > EDX: number - length of message
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
