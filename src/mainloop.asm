extern glClear
extern glLoadIdentity

extern glGetError

extern glUseProgram
extern glBindVertexArray
extern glDrawElements
extern glBindVertexArray

extern upload_obj_to_gpu
extern create_shader_program

%include "src/flags.inc"
%include "includes/common/macros.inc"
%include "includes/common/opengl.inc"
%include "includes/common/object.inc"

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
    test_obj_file       db "assets/h2r.obj", 0
    shader_program      dq 0
    object              dq 0

section .text

extern mainloop
mainloop:
    prologue        32

    call            create_shader_program
    mov             [shader_program], rax

    mov             arg(1), test_obj_file
    call            upload_obj_to_gpu
    mov             [object], rax



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
    mov             arg(1), GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT
    call            glClear

    ; Reset the current Modelview matrix
    call            glLoadIdentity

    mov             arg(1), [shader_program]
    call            glUseProgram

    mov             rax, [rel object]
    mov             arg(1), [rax + Object.vao]
    call            glBindVertexArray

    mov             rax, [rel object]
    mov             arg(1), GL_TRIANGLES
    mov             arg(2), [rax + Object.index_count]
    mov             arg(3), GL_UNSIGNED_INT
    xor             arg(4), arg(4)
    call            glDrawElements

    ; Swap buffers (OS specific)
    swap_buffers

    jmp             .mloop


.gl_error:
    fatal_error     glFatalTitle, glErrMessage

.exit:
    epilogue	    32
    ret
