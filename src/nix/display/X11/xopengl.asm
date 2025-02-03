; ===== [ EXTERNS  ] =====
extern glXGetProcAddressARB
extern glXMakeCurrent
extern glXSwapBuffers

extern XSync

extern xdisplay
extern xwindow

; ===== [ INCLUDES ] =====
%include "src/flags.inc"
%include "includes/common/macros.inc"

%include "includes/display/X11/glx.inc"

; ===== [  .DATA   ] =====
section .data
    fatalTitle                          db "Error: xopengl.asm", 0
    fatalLoadCCMsg                      db "[ xgl_init_context ]: Failed to load 'glXCreateContextAttribsARB' function", 0
    fatalCCMsg                          db "[ xgl_init_context ]: Failed to create OpenGL 3.x context", 0
    fatalMCMsg                          db "[ xgl_init_context ]: Failed to make context current", 0
	glXCreateContextAttribsARB          db "glXCreateContextAttribsARB", 0
    
    context_attribs:
    dd GLX_CONTEXT_MAJOR_VERSION_ARB, 3, \
       GLX_CONTEXT_MINOR_VERSION_ARB, 0, \
       None


; ===== [  .TEXT   ] =====
section .text
; IN: RDI - *display
; IN: RSI - *bestFbc
global xgl_init_context
xgl_init_context:
    prologue        0
    push            rbx
    push            r12

    mov             rbx, rdi                            ; STORES[rbx]: Display*
    mov             r12, rsi                            ; STORES[r12]: GLXFBConfig*

    mov             rdi, glXCreateContextAttribsARB     ; const GLubyte* procName
    call            glXGetProcAddressARB                ; ==> void*
    test            rax, rax
    jz              .fail_to_load_cc

    mov             rdi, rbx                            ; Display* display
    mov             rsi, r12                            ; GLXFBConfig* config
    xor             rdx, rdx                            ; GLXContext share_context
    mov             rcx, True                           ; Bool direct
    mov             r8, context_attribs                 ; const int* attrib_list
    call            rax                                 ; ==> GLXContext
    cmp             rax, 0
    je              .fail_to_cc
    mov             r12, rax                            ; STORES[r12]: GLXContext

    ; TODO: Properly handle errors
    mov             rdi, rbx                            ; Display* display
    mov             rsi, False                          ; Bool discard
    call            XSync                               ; ==> int

    mov             rdi, rbx                            ; Display* display
    mov             rsi, [rel xwindow]                  ; GLXDrawable drawable
    mov             rdx, r12                            ; GLXContext ctx
    call            glXMakeCurrent                      ; ==> Bool
    test            rax, rax
    jz              .fail_to_mc

    pop             r12
    pop             rbx
    epilogue        0
    ret
.fail_to_load_cc:
    fatal_error     fatalTitle, fatalLoadCCMsg
.fail_to_cc:
    fatal_error     fatalTitle, fatalCCMsg
.fail_to_mc:
    fatal_error     fatalTitle, fatalMCMsg


global xglswap_buffer
xglswap_buffer:
    prologue        0

    mov             rdi, [rel xdisplay]                 ; Display* dpy
    mov             rsi, [rel xwindow]                  ; GLXDrawable drawable
    call            glXSwapBuffers                      ; ==> void

    epilogue        0
    ret
