; ===== [ EXTERNS  ] =====
extern LoadIconA
extern LoadCursorA
extern RegisterClassExA
extern CreateWindowExA
extern ShowWindow
extern UpdateWindow
extern GetMessageA
extern TranslateMessage
extern DispatchMessageA
extern DestroyWindow
extern PostQuitMessage
extern DefWindowProcA

; ===== [ INCLUDES ] =====
%include "includes/win/winuser.inc"
%include "includes/win/macros.inc"

%include "includes/common/preprocessors.inc"

; ===== [  .DATA   ] =====
section .data
    mbFatalTitle        db "Error: create_window.asm", 0
    mbRegErrMessage     db "[ wregister_win_class ]  Registering the custom class failed!", 0
    mbIniErrMessage     db "[ wcreate_win ]  Creating a window failed!", 0

    wndClassName        db "WindowClass", 0

    windowClassStruct:
    istruc tagWNDCLASSEXA
        at .cbSize,          dd sizeof(tagWNDCLASSEXA)
        at .style,           dd 0
        at .lpfnWndProc,     dq UNINIT
        at .cbClsExtra,      dd 0
        at .cbWndExtra,      dd 0
        at .hInstance,       dq UNINIT ; Load during runtime
        at .hIcon,           dq UNINIT ; Load during runtime
        at .hCursor,         dq UNINIT ; Load during runtime
        at .hbrBackground,   dq COLOR_WINDOWFRAME
        at .lpszMenuName,    dq NULL
        at .lpszClassName,   dq UNINIT
        at .hIconSm,         dq UNINIT ; Load during runtime
    iend


; ===== [   .BSS   ] =====
section .bss
    eventMessage        resq 0

; ===== [  .TEXT   ] =====
section .text

; IN : RCX HINSTANCE hInstance
extern wregister_win_class
wregister_win_class:
    enter 32, 0

    ; Load hInstance
    mov             [rel windowClassStruct + tagWNDCLASSEXA.hInstance], rcx

    ; Load icons
    mov             rcx, NULL
    mov             rdx, IDI_APPLICATION
    call            LoadIconA
    mov             [rel windowClassStruct + tagWNDCLASSEXA.hIcon], rax

    mov             rcx, NULL
    mov             rdx, IDI_APPLICATION
    call            LoadIconA
    mov             [rel windowClassStruct + tagWNDCLASSEXA.hIconSm], rax

    ; Load cursor icon
    mov             rcx, NULL
    mov             rdx, IDC_ARROW
    call            LoadCursorA
    mov             [rel windowClassStruct + tagWNDCLASSEXA.hCursor], rax

    ; Load class name
    lea             rax, [rel wndClassName]
    mov             [rel windowClassStruct + tagWNDCLASSEXA.lpszClassName], rax

    ; Load callback
    lea             rax, [rel wndproc_callback]
    mov             [rel windowClassStruct + tagWNDCLASSEXA.lpfnWndProc], rax

    ; Register window class
    lea             rcx, [rel windowClassStruct]
    call            RegisterClassExA

    cmp             rax, 0
    jne              .exit

    wfatal_error     mbFatalTitle, mbRegErrMessage

.exit:
    leave
    ret



; IN : RCX HINSTANCE hInstance
; IN : RDX PTR windowTitle
; OUT: RAX HANDLE hWnd
extern wcreate_win
wcreate_win:
    enter           32 + 8 * 8, 0

    mov             qword arg(7), rcx                   ; HINSTANCE hInstance
    mov             r8, rdx                             ; LPCSTR    lpWindowName

    mov             rcx, WS_EX_COMPOSITED               ; DWORD     dwExStyle
    lea             rdx, [rel wndClassName]             ; LPCSTR    lpClassName
    mov             r9, WS_POPUP | WS_VISIBLE           ; DWORD     dwStyle
    mov             dword arg(1), CW_USEDEFAULT         ; int       X
    mov             dword arg(2), CW_USEDEFAULT         ; int       Y
    mov             dword arg(3), 640                   ; int       nWidth
    mov             dword arg(4), 480                   ; int       nHeight
    mov             qword arg(5), NULL                  ; HWND      hWndParent
    mov             qword arg(6), NULL                  ; HMENU     hMenu
    mov             qword arg(8), NULL                  ; LPVOID    lpParam

    call            CreateWindowExA

    cmp             rax, 0
    jne             .exit

    wfatal_error     mbFatalTitle, mbIniErrMessage

.exit:
    leave
    ret    


; IN : RCX HANDLE hwnd
extern wshow_win
wshow_win:
    enter           32, 0
    mov             rbx, rcx

    mov             rdx, SW_SHOWMAXIMIZED
    call            ShowWindow

    mov             rcx, rbx                            ; HINSTANCE hInstance
    call            UpdateWindow

    leave
    ret


extern wmainloop_win
wmainloop_win:
    enter           32, 0

.while_loop:
    lea             rcx, [rel eventMessage]             ; LPMSG lpMsg
    mov             rdx, NULL                           ; HWND hWnd
    mov             r8, 0                               ; UINT wMsgFilterMin
    mov             r9, 0                               ; UINT wMsgFilterMin

    call            GetMessageA

    ; Stop if GetMessage returned 0 (WM_QUIT)
    cmp             rax, 0
    je              .exit

    lea             rcx, [rel eventMessage]             ; LPMSG lpMsg
    call            TranslateMessage

    lea             rcx, [rel eventMessage]             ; LPMSG lpMsg
    call            DispatchMessageA

    ; Loop
    jmp             .while_loop
.exit:
    leave
    ret


extern wndproc_callback
wndproc_callback:
    enter           32, 0

    cmp             rdx, WM_CLOSE
    jz              .wm_close

    cmp             rdx, WM_DESTROY
    jz              .wm_destroy


    call            DefWindowProcA
    jmp             .exit


.wm_close:
    call            DestroyWindow
    xor             rax, rax
    jmp             .exit

.wm_destroy:
    xor             rcx, rcx                            ; int nExitCode
    call            PostQuitMessage
    xor             rax, rax
    jmp             .exit

.exit:
    leave
    ret
