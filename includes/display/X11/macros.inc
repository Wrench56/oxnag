; Arguments:
;  > 1: string - title
;  > 2: string - message
%ifnmacro x11popup
    extern xpopup

    %macro x11popup 2
        mov rdi, %1
        mov rsi, %2
        call xpopup
    %endmacro
%endif
