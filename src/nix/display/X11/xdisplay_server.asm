; ===== [ EXTERNS  ] =====
extern XOpenDisplay
extern glXQueryVersion
extern glXChooseFBConfig
extern DefaultScreen
extern glXGetVisualFromFBConfig
extern XFree

extern xdisplay

; ===== [ INCLUDES ] =====

%include "src/flags.inc"
%include "includes/common/macros.inc"
%include "includes/common/preprocessors.inc"
%include "includes/common/cdef.inc"

%include "includes/display/X11/glx.inc"


; ===== [  .DATA   ] =====
section .data
    fatalTitle      db "Error: xdisplay_server.asm", 0
    failedToOpenMsg db "[ xpick_best_fb ] Failed to open display", 0
    badVersionMsg   db "[ xpick_best_fb ] Invalid GLX version", 0
    badfbcMsg       db "[ xpick_best_fb ] Failed to retrieve framebuffer config", 0
    ; TODO: Use "local" variables instead
    glx_major       dd 0
    glx_minor       dd 0
    fbcount         dd 0
    samples         dd 0
    best_num_samp   dd -1
    bestFbc	    dq NULL
    samp_buf        dd 0

    visual_attribs:
    dd GLX_X_RENDERABLE, 1, \
       GLX_DRAWABLE_TYPE, GLX_WINDOW_BIT, \
       GLX_RENDER_TYPE, GLX_RGBA_BIT, \
       GLX_X_VISUAL_TYPE, GLX_TRUE_COLOR, \
       GLX_RED_SIZE, 8, \
       GLX_GREEN_SIZE, 8, \
       GLX_BLUE_SIZE, 8, \
       GLX_ALPHA_SIZE, 8, \
       GLX_DEPTH_SIZE, 24, \
       GLX_STENCIL_SIZE, 8, \
       GLX_DOUBLEBUFFER, 1, \
       None

; ===== [  .TEXT   ] =====
section .text

; IN: RDI - title string (null-terminated)
; IN: RSI - message string (null-terminated)
; OUT: RAX - bestFbc
global xpick_best_fb
xpick_best_fb:

    ; Open X display
    mov             rdi, NULL
    call            XOpenDisplay                            ; ==> Display*
    test            rax, rax
    jz              .failed_to_open

    mov             rbx, rax                                ; STORES[rbx]: Display*
    mov             [rel xdisplay], rax

    ; Check version
    mov             rdi, rbx                                ; Display* dpy
    lea             rsi, [rel glx_major]                    ; int major
    lea             rdi, [rel glx_minor]                    ; int minor
    call            glXQueryVersion

    test            rax, rax
    jz              .bad_version

    cmp             dword [rel glx_major], 0
    je              .bad_version

    cmp             dword [rel glx_major], 1
    je              .check_minor

    jmp             .valid_version

.check_minor:
    cmp             dword [rel glx_minor], 3
    js              .bad_version

.valid_version:

    mov             rdi, rbx                                ; Display* display
    call            DefaultScreen

    mov             rdi, rbx                                ; Display* dpy
    mov             rsi, rax                                ; int screen
    mov             rdx, [rel visual_attribs]               ; const int* attrub_list
    lea             rcx, [rel fbcount]                      ; int* nelements
    call            glXChooseFBConfig                       ; ==> GLXFBConfig*
    test            rax, rax
    je              .bad_fbc

    mov             r12, [rel fbcount]                      ; STORES[r12]: counter
    dec             r12

    mov             r13, rax                                ; STORES[r13]: fbc[]

.loop_begin:
    mov             rdi, rbx                                ; Display* dpy
    mov             rsi, [r13 + r12]                        ; GLXFBConfig config
    call            glXGetVisualFromFBConfig                ; ==> XVisualInfo*
    mov             r14, rax                                ; STORES[r14]: XVisualInfo*
    test            rax, rax
    jz              .loop_end

    ; Get number of samples
    mov             rdi, rbx                                ; Display* dpy
    mov             rsi, [r13 + r12]                        ; GLXFBConfig config
    mov             rdx, GLX_SAMPLES                        ; int attribute
    lea             rcx, [rel samples]                      ; int* value
    call            glXGetFBConfigAttrib                    ; ==> int

    mov		    rax, [rel samples]
    cmp             [rel best_num_samp], rax
    jge             .xfree

    ; Check if sample buffer exists
    mov             rdi, rbx
    mov             rsi, [r13 + r12]
    mov             rdx, GLX_SAMPLE_BUFFERS
    lea             rcx, [rel samp_buf]
    call            glXGetFBConfigAttrib

    mov             rax, [rel samp_buf]
    test            rax, rax
    jz              .xfree

    ; New best found!
    mov             rax, [r13 + r12]
    mov             qword [rel bestFbc], rax
    mov             rax, [rel samples]
    mov             dword [rel best_num_samp], rax


.xfree:
    mov             rdi, r14                                ; void* data
    call            XFree                                   ; ==> void
.loop_end:
    dec             r12
    jnz             .loop_begin

    mov             rax, [rel bestFbc]
    ret

.failed_to_open:
    fatal_error     fatalTitle, failedToOpenMsg
.bad_version:
    fatal_error     fatalTitle, badVersionMsg
.bad_fbc:
    fatal_error     fatalTitle, badfbcMsg

