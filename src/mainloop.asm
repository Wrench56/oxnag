extern glClear
extern glLoadIdentity

extern glGetError

%include "src/flags.inc"
%include "includes/common/macros.inc"
%include "includes/common/opengl.inc"   

%ifidn TARGET_OS, OS_WINDOWS
    extern whandle_win_events
    extern wglswap_buffer

    %define handle_window_event     call whandle_win_events
    %define swap_buffers            call wglswap_buffer
%elifidn TARGET_OS, OS_LINUX
    %ifidn DISPLAY_SERVER, DS_XORG
        extern xglswap_buffer

        %define handle_window_event     xor rax, rax
        %define swap_buffers            call xglswap_buffer
    %else
	    %error SwapBuffer for current display server (DISPLAY_SERVER) for OS_type=TARGET_OS is not implemented
    %endif
%else
   %error No OS_type=TARGET_OS specific SwapBuffer implemented
%endif

section .data
    glFatalTitle        db "Error: mainloop.asm", 0
    glErrMessage        db "[ mainloop ]  OpenGL Error", 0



section .text

extern mainloop
mainloop:
    prologue        32

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
    fatal_error     glFatalTitle, glErrMessage

.exit:
    epilogue	    32
    ret
