%ifidn __OUTPUT_FORMAT__, win64
    extern whandle_win_events

    ; handle_window_event is cross platform
    %define handle_window_event     call whandle_win_events
%endif


section .text

extern mainloop
mainloop:
    enter           32, 0

.mloop:
    ; Call OS specific window handling

    handle_window_event

    ; Break if handle_window_event returned 1
    cmp             rax, 1
    je              .exit

    jmp             .mloop


.exit:
    leave
    ret
