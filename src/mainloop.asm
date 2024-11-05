extern SwapBuffers

;extern gldraw_scene
extern glClear
extern glLoadIdentity

%ifidn __OUTPUT_FORMAT__, win64
    extern whandle_win_events

    ; handle_window_event is cross platform
    %define handle_window_event     call whandle_win_events
%endif


%include "includes/win/macros.inc"
%include "includes/common/opengl.inc"   

section .data
    hDC                 dq 0
    mbFatalTitle        db "Error: attach_opengl.asm", 0
    mbPFCErrMessage     db "[ wgl_spfd ]  Can't find a suitable PixelFormat", 0



section .text

; IN : RCX hDC
extern mainloop
mainloop:
    enter           32, 0

    mov             [rel hDC], rcx

.mloop:
    ; Call OS specific window handling

    handle_window_event

    ; Break if handle_window_event returned 1
    cmp             rax, 1
    je              .exit



    ; Draw OpenGL screen
    mov             rcx, GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT
    call            glClear

    ; Reset the current Modelview matrix
    call            glLoadIdentity

    ; Swap buffers
    mov             rcx, [rel hDC]
    call            SwapBuffers

    jmp             .mloop


.exit:
    wfatal_error    mbFatalTitle, mbPFCErrMessage
    leave
    ret
