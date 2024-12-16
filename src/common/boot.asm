%include "includes/common/preprocessors.inc"
%include "includes/common/macros.inc"
%include "includes/win/macros.inc"
%include "includes/common/opengl.inc"

extern strlen

extern glGetString

%macro log_gl_string 1
    mov             rcx, %1
    call            glGetString
    cmp             rax, 0
    je              .get_string_fail 
    mov             rdi, rax
    call            strlen
    log             rdi, rax
%endmacro

section .data
    header_msg          db "[      ] Hello from oxnag!", 10, \
                           "[      ] ==========================================", 10, \
                           "[      ] Made by:", 10, \
                           "[      ]  > Mark Devenyi <markdevenyidev@gmail.com>", 10, \
                           "[      ] ==========================================", 10
    header_msg_len      equ $ - header_msg
    gl_vendor           db "[opengl] OpenGL info:", 10, "[opengl]  > Vendor         "
    gl_vendor_len       equ $ - gl_vendor
    gl_renderer         db 10, "[opengl]  > Renderer       "
    gl_renderer_len     equ $ - gl_renderer
    gl_version          db 10, "[opengl]  > Version        "
    gl_version_len      equ $ - gl_version
    gl_shading          db 10, "[opengl]  > Shading Lang   "
    gl_shading_len      equ $ - gl_shading
    separator           db "[      ] =========================================="
    separator_len       equ $-separator
    new_line            db 10
    glGetStrFatalTitle  db "Error: boot.asm", 0
    glGetStrFatalMsg    db "[ boot_process ]: glGetString returned error"


%ifidn __OUTPUT_FORMAT__, win64
    extern wboot
    %define os_spec_boot    call wboot
%endif


section .text
extern boot_process
boot_process:
    enter           32, 0

    ; Run OS-specific boot process
    os_spec_boot

    ; Bootup message
    log             header_msg, header_msg_len

    leave
    ret

extern gl_context_info
gl_context_info:
    enter           32, 0

    ; Vendor
    log             gl_vendor, gl_vendor_len
    log_gl_string   GL_VENDOR
    log             gl_renderer, gl_renderer_len
    log_gl_string   GL_RENDERER
    log             gl_version, gl_version_len
    log_gl_string   GL_VERSION
    log             gl_shading, gl_shading_len
    log_gl_string   GL_SHADING_LANGUAGE_VERSION
    log             new_line, 1
    log             separator, separator_len

    leave
    ret
.get_string_fail:
    wfatal_error    glGetStrFatalTitle, glGetStrFatalMsg
