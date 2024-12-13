; ===== [ EXTERNS  ] =====
extern glShadeModel
extern glClearColor
extern glClearDepth
extern glEnable
extern glDepthFunc
extern glHint

; ===== [ INCLUDES ] =====
%include "includes/common/preprocessors.inc"
%include "includes/common/opengl.inc"



; ===== [  .DATA   ] =====
section .data
    BG_RED          dd 0.0
    BG_GREEN        dd 0.0
    BG_BLUE         dd 0.0
    BG_ALPHA        dd 0.5

    BG_CLEAR_DEPTH  dd 1.0


; ===== [  .TEXT   ] =====
section .text
extern glinit
glinit:
    enter           32, 0

    mov             rcx, GL_SMOOTH
    call            glShadeModel

    movss           xmm0, [rel BG_RED]
    movss           xmm1, [rel BG_GREEN]
    movss           xmm2, [rel BG_BLUE]
    movss           xmm3, [rel BG_ALPHA]
    call            glClearColor

    movss           xmm0, [rel BG_CLEAR_DEPTH]
    call            glClearDepth

    mov             rcx, GL_DEPTH_TEST
    call            glEnable

    mov             rcx, GL_LEQUAL
    call            glDepthFunc

    mov             rcx, GL_PERSPECTIVE_CORRECTION_HINT
    mov             rdx, GL_NICEST
    call            glHint

    leave
    ret
