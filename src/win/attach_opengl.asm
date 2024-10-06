; ===== [ EXTERNS  ] =====
extern wglCreateContext
extern wglMakeCurrent

extern ChoosePixelFormat
extern SetPixelFormat

; ===== [ INCLUDES ] =====
%include "includes/win/winuser.inc"
%include "includes/win/wingdi.inc"
%include "includes/win/macros.inc"

%include "includes/common/preprocessors.inc"


COLOR_BITS    EQU 32

section .data
    mbFatalTitle        db "Error: attach_opengl.asm", 0
    mbPFCErrMessage     db "[ wgl_spfd ]  Can't find a suitable PixelFormat", 0
    mbPFSErrMessage     db "[ wgl_spfd ]  Can't set the PixelFormat", 0
    mbCCErrMessage      db "[ wgl_init_context ]  Can't create a GL Rendering Context (RC)", 0
    mbMCErrMessage      db "[ wgl_init_context ]  Can't activate the GL Rendering Context (RC)", 0

    pfd:
    istruc tagPIXELFORMATDESCRIPTOR
        at .nSize,            dw sizeof(tagPIXELFORMATDESCRIPTOR)                 
        at .nVersion,         dw 1       
        at .dwFlags,          dd PFD_DRAW_TO_WINDOW | PFD_SUPPORT_OPENGL | PFD_DOUBLEBUFFER
        at .iPixelType,       db PFD_TYPE_RGBA   
        at .cColorBits,       db COLOR_BITS
        at .cRedBits,         db 0
        at .cRedShift,        db 0
        at .cGreenBits,       db 0
        at .cGreenShift,      db 0
        at .cBlueBits,        db 0
        at .cBlueShift,       db 0
        at .cAlphaBits,       db 0
        at .cAlphaShift,      db 0
        at .cAccumBits,       db 0
        at .cAccumRedBits,    db 0
        at .cAccumGreenBits,  db 0
        at .cAccumBlueBits,   db 0
        at .cAccumAlphaBits,  db 0
        at .cDepthBits,       db 24
        at .cStencilBits,     db 8
        at .cAuxBuffers,      db 0
        at .iLayerType,       db PFD_MAIN_PLANE
        at .bReserved,        db 0
        at .dwLayerMask,      dd 0
        at .dwVisibleMask,    dd 0
        at .dwDamageMask,     dd 0
    iend

section .code
extern wgl_attach
wgl_attach:
    enter           32, 0



; IN RCX : HDC deviceContext
extern wgl_spfd
wgl_spfd:
    enter           32, 0
    
    ; Save hDC
    mov             rbx, rcx

    lea             rdx, [rel pfd]
    call            ChoosePixelFormat

    cmp             rax, 0
    je              .fatal_choose_pixel_format

    mov             rcx, rbx
    mov             rdx, rax
    lea             r8, [rel pfd]
    call            SetPixelFormat

    cmp             rax, 0
    je              .fatal_set_pixel_format

    leave
    ret


.fatal_choose_pixel_format:
    wfatal_error     mbFatalTitle, mbPFCErrMessage

.fatal_set_pixel_format:
    wfatal_error     mbFatalTitle, mbPFSErrMessage


; IN : RCX hDC
extern wgl_init_context
wgl_init_context:
    enter           32, 0

    ; Save hDC
    mov             rbx, rcx

    call            wglCreateContext

    cmp             rax, 0
    je             .fatal_create_context

    ; Save hRC
    mov             rcx, rbx
    mov             rbx, rax

    ; Activate rendering
    mov             rdx, rax
    call            wglMakeCurrent

    cmp             rax, 0
    je              .fatal_make_current

    leave
    ret

.fatal_create_context:
    glfatal_error    mbFatalTitle, mbCCErrMessage

.fatal_make_current:
    glfatal_error    mbFatalTitle, mbMCErrMessage
