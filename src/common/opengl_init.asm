; ===== [ EXTERNS  ] =====
extern glShadeModel
extern glClearColor
extern glClearDepth
extern glEnable
extern glDepthFunc
extern glHint

; ===== [ INCLUDES ] =====
%include "includes/common/macros.inc"
%include "includes/common/preprocessors.inc"
%include "includes/common/opengl.inc"



; ===== [  .DATA   ] =====
section .data
    BG_RED          dd 0.5
    BG_GREEN        dd 0.5
    BG_BLUE         dd 1.0
    BG_ALPHA        dd 0.5

    BG_CLEAR_DEPTH  dd 1.0


; ===== [  .TEXT   ] =====
section .text
extern glinit
glinit:
    prologue        32

    argxmov         1, GL_SMOOTH
    call            glShadeModel

    movss           xmm0, [rel BG_RED]
    movss           xmm1, [rel BG_GREEN]
    movss           xmm2, [rel BG_BLUE]
    movss           xmm3, [rel BG_ALPHA]
    call            glClearColor

    movss           xmm0, [rel BG_CLEAR_DEPTH]
    call            glClearDepth

    argxmov         1, GL_DEPTH_TEST
    call            glEnable

    argxmov         1, GL_LEQUAL
    call            glDepthFunc

    argxmov         1, GL_PERSPECTIVE_CORRECTION_HINT
    argxmov         2, GL_NICEST
    call            glHint

    epilogue	    32
    ret
