CPU X64

; ===== [ EXTERNS  ] =====
extern wregister_win_class
extern wcreate_win
extern wshow_win

extern wgl_spfd
extern wgl_init_context

extern glinit

extern mainloop

extern ExitProcess
extern GetModuleHandleA
extern GetDC

extern boot_process
extern boot_gui
extern gl_context_info

extern cleanup

; ===== [ INCLUDES ] =====

%include "src/flags.inc"
%include "includes/common/macros.inc"

%ifidn TARGET_OS, OS_WINDOWS
    %include "includes/win/winuser.inc"
    %include "includes/win/wingdi.inc"
%endif

; ===== [  .TEXT   ] =====
section .text

global _start
_start:
%ifidn TARGET_OS, OS_WINDOWS
    ; On Windows, the stack is NOT 16 byte aligned by default
    prologue        0
%endif

    ; Initialize misc OS specific things (e.g. debug console)
    call            boot_process

    ; Initialize OS specific GUI
    call            boot_gui

    ; Initialize OpenGL context
    call            glinit

    ; OpenGL context info
    call            gl_context_info

    ; Run mainloop
    call            mainloop

_exit:
    call            cleanup
