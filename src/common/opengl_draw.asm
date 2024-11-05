; ===== [ EXTERNS  ] =====
extern glClear
extern glLoadIdentity

; ===== [ INCLUDES ] =====
%include "includes/common/preprocessors.inc"
%include "includes/common/opengl.inc"

section .code

extern gldraw_scene
gldraw_scene:
    enter           32, 0

    

    leave
    ret
