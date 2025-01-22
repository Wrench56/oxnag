%include "includes/display/X11/macros.inc"

; Arguments:
;  > 1: string - title
;  > 2: string - message
%ifnmacro nfatal_error 
    %macro nfatal_error 2
        %ifidn DISPLAY_SERVER, DS_XORG
            x11popup %1, %2
        %else
            %error The macro `nfatal_error` is currently not implemented for display server DISPLAY_SERVER
        %endif
        mov             rdx, 1
        call            exit
    %endmacro
%endif
