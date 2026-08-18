; ===== [ EXTERNS  ] =====
extern fopen
extern fseek
extern ftell
extern rewind
extern fread
extern fclose

extern malloc
extern free

extern glCreateShader
extern glShaderSource
extern glCompileShader
extern glCreateProgram
extern glAttachShader
extern glLinkProgram
extern glDeleteShader
extern glGetShaderiv
extern glGetProgramiv

; ===== [ INCLUDES ] =====
%include "src/flags.inc"
%include "includes/common/macros.inc"
%include "includes/common/opengl.inc"
%include "includes/posix/unistd.inc"

; ===== [  .DATA   ] =====
section .data
    fatalTitle              db "Error: shaders.asm", 0
    fatalFileMsg            db "[ load_shader ]: no such shader file", 0
    fatalMallocMsg          db "[ load_shader ]: malloc failed", 0
    fatalCompileMsg         db "[ compile_shader ]: compile failed", 0
    fatalLinkMsg            db "[ create_shader_program ]: link failed", 0
    READ_BYTE_MODE          db "rb", 0
    shader_src_ptr          dq 0

    VERTEX_SHADER_NAME      db "src/common/shaders/vertex.glsl", 0
    FRAGMENT_SHADER_NAME    db "src/common/shaders/fragment.glsl", 0
    success                 dq 0

; ===== [  .TEXT   ] =====
section .text
; IN: RDI - *filename
; OUT: RAX - void *shaderCode
load_shader:
    push            rbx
    push            r12

    prologue        32

%ifidn TARGET_OS, OS_WINDOWS
    mov             arg(1), rdi
%endif
    mov             arg(2), READ_BYTE_MODE
    call            fopen
    test            rax, rax
    jz              .file_error
    mov             rbx, rax

    mov             arg(1), rbx
    xor             arg(2), arg(2)
    mov             arg(3), SEEK_END
    call            fseek

    mov             arg(1), rbx
    call            ftell
    mov             r12, rax

    mov             arg(1), rbx
    call            rewind

    lea             arg(1), [r12 + 1]
    call            malloc
    test            rax, rax
    jz              .malloc_error

    mov             byte [rax + r12], 0

    mov             arg(1), rax
    mov             arg(2), 1
    mov             arg(3), r12
    mov             arg(4), rbx
    mov             r12, rax
    call            fread

    mov             arg(1), rbx
    call            fclose

    mov             rax, r12

    epilogue        32

    pop             r12
    pop             rbx
    ret
.file_error:
    fatal_error     fatalTitle, fatalFileMsg
.malloc_error:
    fatal_error     fatalTitle, fatalMallocMsg

; IN: RDI - const char* filename
; IN: RSI - GLenum shader_type
compile_shader:
    push            rbx
    push            r12

    prologue        32

    mov             r12, rsi

    call            load_shader
    mov             rbx, rax

    mov             arg(1), r12
    call            glCreateShader
    mov             r12, rax


    mov             [shader_src_ptr], rbx
    mov             arg(1), r12
    mov             arg(2), 1
    mov             arg(3), shader_src_ptr
    xor             arg(4), arg(4)
    call            glShaderSource

    mov             arg(1), r12
    call            glCompileShader

    mov             arg(1), rbx
    call            free

    mov             arg(1), r12
    mov             arg(2), GL_COMPILE_STATUS
    mov             arg(3), success
    call            glGetShaderiv
    mov             rax, [success]
    test            rax, rax
    jz              .compile_error

    mov             rax, r12

    epilogue        32

    pop             r12
    pop             rbx
    ret
.compile_error:
    fatal_error     fatalTitle, fatalCompileMsg


global create_shader_program:
create_shader_program:
    push            rbx
    push            r12
    push            r13
    push            r14

    prologue        32

    mov             rdi, VERTEX_SHADER_NAME
    mov             rsi, GL_VERTEX_SHADER
    call            compile_shader
    mov             r13, rax

    mov             rdi, FRAGMENT_SHADER_NAME
    mov             rsi, GL_FRAGMENT_SHADER
    call            compile_shader
    mov             r14, rax

    call            glCreateProgram
    mov             rbx, rax

    mov             arg(1), rbx
    mov             arg(2), r13
    mov             rbx, rax
    call            glAttachShader

    mov             arg(1), rbx
    mov             arg(2), r14
    call            glAttachShader

    mov             arg(1), rbx
    call            glLinkProgram

    mov             arg(1), rbx
    mov             arg(2), GL_LINK_STATUS
    mov             arg(3), success
    call            glGetProgramiv

    ; Cleanup
    mov             arg(1), r13
    call            glDeleteShader

    mov             arg(1), r14
    call            glDeleteShader

    ; Check glLinkProgram() success
    mov             rax, [success]
    test            rax, rax
    jz              .link_error

    mov             rax, rbx

    epilogue        32

    pop             r14
    pop             r13
    pop             r12
    pop             rbx

    ret
.link_error:
    fatal_error     fatalTitle, fatalLinkMsg

