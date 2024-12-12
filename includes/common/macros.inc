%include "src/flags.inc"

; Arguments:
;  > ECX: string - message
;  > EDX: number - length of message
%ifidn __OUTPUT_FORMAT__, win64
    extern wprint

    %macro log 2
        %ifdef LOG_TO_CONSOLE
            mov             rcx, %1
            mov             rdx, %2
            call            wprint
        %endif
    %endmacro
%endif
