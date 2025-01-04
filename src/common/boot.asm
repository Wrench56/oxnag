%include "src/flags.inc"

%include "includes/common/preprocessors.inc"
%include "includes/common/macros.inc"
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
    header_msg          db "[      ] Hello from oxnag!", 10
    header_msg_len      equ $ - header_msg
    authors_msg         db "[      ] Made by:", 10, \
                           "[      ]  > Mark Devenyi <markdevenyidev@gmail.com>", 10
    authors_msg_len     equ $ - authors_msg
    window_msg          db "[      ] GUI created (OS specific)", 10
    window_msg_len      equ $ - window_msg
    gl_vendor           db "[opengl] OpenGL info:", 10, "[opengl]  > Vendor         "
    gl_vendor_len       equ $ - gl_vendor
    gl_renderer         db 10, "[opengl]  > Renderer       "
    gl_renderer_len     equ $ - gl_renderer
    gl_version          db 10, "[opengl]  > Version        "
    gl_version_len      equ $ - gl_version
    gl_shading          db 10, "[opengl]  > Shading Lang   "
    gl_shading_len      equ $ - gl_shading
    separator           db "[      ] ==========================================", 10
    separator_len       equ $-separator
    new_line            db 10
    glGetStrFatalTitle  db "Error: boot.asm", 0
    glGetStrFatalMsg    db "[ boot_process ]: glGetString returned error"


%ifidn TARGET_OS, OS_WINDOWS
    extern wboot
    extern wboot_gui

    %define os_spec_boot        call wboot
    %define os_spec_boot_gui    call wboot_gui
%else
    %define os_spec_boot
    %define os_spec_boot_gui
%endif


section .text
extern boot_process
boot_process:
    prologue        32

    ; Run OS-specific boot process
    os_spec_boot

    ; Bootup message
    log             header_msg, header_msg_len
    log             separator, separator_len
    log             authors_msg, authors_msg_len
    log             separator, separator_len

    epilogue	    32
    ret

extern boot_gui
boot_gui:
    prologue        32

    os_spec_boot_gui

    log             window_msg, window_msg_len
    log             separator, separator_len

    epilogue	    32
    ret

extern gl_context_info
gl_context_info:
    prologue        32

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

    epilogue        32
    ret
.get_string_fail:
    fatal_error    glGetStrFatalTitle, glGetStrFatalMsg
