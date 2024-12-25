extern glClear
extern glLoadIdentity

extern glGetError

%ifidn __OUTPUT_FORMAT__, win64
    extern whandle_win_events
    extern wglswap_buffer

    ; handle_window_event is cross platform
    %define handle_window_event     call whandle_win_events
    %define swap_buffers            call wglswap_buffer
%endif

%include "includes/common/macros.inc"

%include "includes/win/macros.inc"
%include "includes/common/opengl.inc"   

section .data
    glFatalTitle        db "Error: mainloop.asm", 0
    glErrMessage        db "[ mainloop ]  OpenGL Error", 0



section .text

extern mainloop
mainloop:
    prologue        32, 0

.mloop:
    ; Call OS specific window handling
    handle_window_event

    ; Break if handle_window_event returned 1
    cmp             rax, 1
    je              .exit

    ; Handle OpenGl error
    call            glGetError
    cmp             rax, GL_NO_ERROR
    jne             .gl_error

    ; Draw OpenGL screen
    argxmov         1, GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT
    call            glClear

    ; Reset the current Modelview matrix
    call            glLoadIdentity

    ; Swap buffers (OS specific)
    swap_buffers

    jmp             .mloop


.gl_error:
    wfatal_error     glFatalTitle, glErrMessage

.exit:
    epilogue
    ret
