; ===== [ EXTERNS  ] =====
extern XOpenDisplay
extern glXQueryVersion
extern glXChooseFBConfig
extern XDefaultScreen
extern glXGetVisualFromFBConfig
extern glXGetFBConfigAttrib
extern XFree

extern XCreateColormap
extern XRootWindow
extern XCreateWindow
extern XStoreName
extern XMapWindow
extern XSync

extern xgl_init_context

extern xdisplay
extern xwindow

extern malloc
extern free

; ===== [ INCLUDES ] =====

%include "src/flags.inc"
%include "includes/common/macros.inc"
%include "includes/common/cdef.inc"

%include "includes/display/X11/glx.inc"


; ===== [  .DATA   ] =====
section .data
    fatalTitle      db "Error: xdisplay_server.asm", 0
    failedToOpenMsg db "[ xboot_gui ] Failed to open display", 0
    badVersionMsg   db "[ xpick_best_fb ] Invalid GLX version", 0
    badfbcMsg       db "[ xpick_best_fb ] Failed to retrieve framebuffer config", 0
    failInitWndMsg  db "[ xopen_window ] Failed to create X11 Window", 0
    oxnagTitle      db "OxNAG", 0
    ; TODO: Use "local" variables instead
    glx_major       dd 0
    glx_minor       dd 0
    fbcount         dd 0
    samples         dq 0
    best_num_samp   dq -1
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

; IN: RDI - *display
; OUT: RAX - *bestFbc
xpick_best_fb:
    prologue        0

    push            rbx
    push            r12
    push            r13
    push            r14

    mov             rbx, rdi                                ; STORES[rbx]: Display*
    mov             [rel xdisplay], rdi

    ; Check version
    ; STORES[rdi]: Display* dpy
    mov             rsi, glx_major                          ; int major
    mov             rdx, glx_minor                          ; int minor
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
    call            XDefaultScreen

    mov             rdi, rbx                                ; Display* dpy
    mov             rsi, rax                                ; int screen
    mov             rdx, visual_attribs                     ; const int* attrib_list
    mov             rcx, fbcount                            ; int* nelements
    call            glXChooseFBConfig                       ; ==> GLXFBConfig*
    test            rax, rax
    je              .bad_fbc

    mov             r12, [rel fbcount]                      ; STORES[r12]: counter
    dec             r12

    mov             r13, rax                                ; STORES[r13]: fbc[]

    mov             rsi, r12
    shl             rsi, 3                                  ; rsi * 2 * 2 * 2
    add             r13, rsi

.loop_begin:
    mov             rdi, rbx                                ; Display* dpy
    mov             rsi, [r13]                              ; GLXFBConfig config
    call            glXGetVisualFromFBConfig                ; ==> XVisualInfo*
    mov             r14, rax                                ; STORES[r14]: XVisualInfo*
    test            rax, rax
    jz              .loop_end

    ; Get number of samples
    mov             rdi, rbx                                ; Display* dpy
    mov             rsi, [r13]                              ; GLXFBConfig config
    mov             rdx, GLX_SAMPLES                        ; int attribute
    lea             rcx, [rel samples]                      ; int* value
    call            glXGetFBConfigAttrib                    ; ==> int

    mov             rax, [rel samples]
    cmp             [rel best_num_samp], rax
    jge             .xfree

    ; Check if sample buffer exists
    mov             rdi, rbx
    mov             rsi, [r13]
    mov             rdx, GLX_SAMPLE_BUFFERS
    lea             rcx, [rel samp_buf]
    call            glXGetFBConfigAttrib

    mov             rax, [rel samp_buf]
    test            rax, rax
    jz              .xfree

    ; New best found!
    mov             rax, [r13]
    mov             qword [rel bestFbc], rax
    mov             rax, [rel samples]
    mov             [rel best_num_samp], rax


.xfree:
    mov             rdi, r14                                ; void* data
    call            XFree                                   ; ==> int
.loop_end:
    dec             r12
    ; Use fbc[--i] for the next iteration
    sub             r13, 8

    test            r12, r12
    jnz             .loop_begin

    ; Free fbc[]
    mov             rdi, r13
    call            XFree

    mov             rax, [rel bestFbc]
    pop             r14
    pop             r13
    pop             r12
    pop             rbx

    epilogue        0
    ret

.bad_version:
    fatal_error     fatalTitle, badVersionMsg
.bad_fbc:
    fatal_error     fatalTitle, badfbcMsg


; IN: RDI - *display
; IN: RSI - *bestFbc
global xopen_window
xopen_window:
    prologue        0

    push            rbx
    push            r12
    push            r13
    push            r14

    sub             rsp, 6 * 8

    mov             rbx, rdi

    ; STORES[rdi]: Display*
    ; STORES[rsi]: GLXFBConfig*
    call            glXGetVisualFromFBConfig                ; ==> XVisualInfo*
    mov             r12, rax                                ; STORES[r12]: XVisualInfo*

    mov             rdi, rbx                                ; Display* display
    mov             esi, [r12 + XVisualInfo.screen]         ; int screen_number
    call            XRootWindow                             ; ==> Window*
    mov             r13, rax                                ; STORES[r13]: Window*

    mov             rdi, sizeof(XSetWindowAttributes)       ; size_t size
    call            malloc                                  ; ==> void*
    mov             r14, rax                                ; STORES[r14]: XSetWindowAttributes*

    mov             qword [r14 + XSetWindowAttributes.border_pixel], 0
    mov             qword [r14 + XSetWindowAttributes.background_pixmap], None
    mov             qword [r14 + XSetWindowAttributes.event_mask], StructureNotifyMask

    mov             rdi, rbx                                ; Display* display
    mov             rsi, r13                                ; Window window
    mov             rdx, [r12 + XVisualInfo.visual]         ; Visual* visual
    mov             rcx, AllocNone                          ; int alloc
    call            XCreateColormap                         ; ==> Colormap*
    mov             [r14 + XSetWindowAttributes.colormap], rax

    mov             rsi, r13                                ; Window parent
    mov             edx, 0                                  ; int32 x
    mov             ecx, 0                                  ; int32 y
    mov             r8d, 100                                ; uint32 width
    mov             r9d, 100                                ; uint32 height
    mov             dword [rsp], 0                          ; uint32 border_width
    mov             edi, [r12 + XVisualInfo.depth]
    mov             dword [rsp + 8], edi                    ; int32 depth
    mov             dword [rsp + 16], InputOutput           ; uint32 class
    mov             rdi, [r12 + XVisualInfo.visual]
    mov             [rsp + 24], rdi                         ; Visual* visual
    mov             rdi, CWBorderPixel | CWColormap | CWEventMask
    mov             [rsp + 32], rdi                         ; uint64 valuemask
    mov             [rsp + 40], r14                         ; XSetWindowAttributes* attributes
    mov             rdi, rbx                                ; Display* display
    call            XCreateWindow                           ; ==> Window
    test            rax, rax
    jz              .fail
    mov             [rel xwindow], rax

    mov             rdi, rbx                                ; Display* display
    mov             rsi, rax                                ; Window w
    mov             rdx, oxnagTitle                         ; char* window_name
    call            XStoreName                              ; ==> int

    mov             rdi, rbx                                ; Display* display
    mov             rsi, [rel xwindow]                      ; Window w
    call            XMapWindow                              ; ==> int

    mov             rdi, rbx                                ; Display* display
    xor             rsi, rsi                                ; Bool discard
    call            XSync                                   ; ==> int

    ; ===== Cleanup ===== ;
    mov             rdi, r12                                ; void* data
    call            XFree                                   ; ==> int

    mov             rdi, r14                                ; void* ptr
    call            free                                    ; ==> void

    add             rsp, 6 * 8
    pop             r14
    pop             r13
    pop             r12
    pop             rbx

    epilogue        0
    ret
.fail:
    fatal_error     fatalTitle, failInitWndMsg


global xboot_gui
xboot_gui:
    prologue        0
    push            rbx
    push            r12

    ; Open X display
    mov             rdi, NULL                               ; char* display_name
    call            XOpenDisplay                            ; ==> Display*
    test            rax, rax
    jz              .failed_to_open
    mov             rbx, rax                                ; STORES[rbx]: Display*

    ; Pick most optimal framebuffer
    mov             rdi, rbx
    call            xpick_best_fb
    mov             r12, rax

    ; Open X window
    mov             rdi, rbx
    mov             rsi, r12
    call            xopen_window

	; Initialize OpenGL context
    mov             rdi, rbx
    mov             rsi, r12
	call            xgl_init_context

    pop             r12
    pop             rbx
    epilogue        0
    ret

.failed_to_open:
    fatal_error     fatalTitle, failedToOpenMsg
