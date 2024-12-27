; ===== [ EXTERNS  ] =====
extern LoadIconA
extern LoadCursorA
extern RegisterClassExA

extern CreateWindowExA

extern PeekMessageA
extern TranslateMessage
extern DispatchMessageA

extern DestroyWindow
extern PostQuitMessage
extern DefWindowProcA

extern ShowWindow
extern SetFocus
extern SetForegroundWindow

; ===== [ INCLUDES ] =====
%include "includes/win/winuser.inc"
%include "includes/win/macros.inc"

%include "includes/common/preprocessors.inc"

dwExStyle       EQU     WS_EX_APPWINDOW | WS_EX_WINDOWEDGE
dwStyle         EQU     WS_OVERLAPPEDWINDOW | WS_CLIPSIBLINGS | WS_CLIPCHILDREN


; ===== [  .DATA   ] =====
section .data
    mbFatalTitle        db "Error: create_window.asm", 0
    mbRegErrMessage     db "[ wregister_win_class ]  Registering the custom class failed!", 0
    mbIniErrMessage     db "[ wcreate_win ]  Creating a window failed!", 0

    wndClassName        db "WindowClass", 0

    windowClassStruct:
    istruc tagWNDCLASSEXA
        at .cbSize,          dd sizeof(tagWNDCLASSEXA)
        at .style,           dd CS_HREDRAW | CS_VREDRAW | CS_OWNDC
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

; IN : RDI HINSTANCE hInstance
extern wregister_win_class
wregister_win_class:
    enter 32, 0

    ; Load hInstance
    mov             [rel windowClassStruct + tagWNDCLASSEXA.hInstance], rdi

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



; IN : RDI HINSTANCE hInstance
; IN : RSI PTR windowTitle
; OUT: RAX HANDLE hWnd
extern wcreate_win
wcreate_win:
    enter           32 + 8 * 8, 0

    mov             rcx, dwExStyle                      ; DWORD     dwExStyle
    lea             rdx, [rel wndClassName]             ; LPCSTR    lpClassName
    mov             r8, rsi                             ; LPCSTR    lpWindowName
    mov             r9, dwStyle                         ; DWORD     dwStyle
    mov             qword arg(1), 0                     ; int       X
    mov             qword arg(2), 0                     ; int       Y
    mov             qword arg(3), 640                   ; int       nWidth
    mov             qword arg(4), 480                   ; int       nHeight
    mov             qword arg(5), NULL                  ; HWND      hWndParent
    mov             qword arg(6), NULL                  ; HMENU     hMenu
    mov             qword arg(7), rdi                   ; HINSTANCE hInstance
    mov             qword arg(8), NULL                  ; LPVOID    lpParam

    call            CreateWindowExA

    cmp             rax, 0
    jne             .exit

    wfatal_error     mbFatalTitle, mbIniErrMessage

.exit:
    leave
    ret    


; IN : RDI HANDLE hwnd
extern wshow_win
wshow_win:
    enter           32, 0

    mov             rcx, rdi
    mov             rdx, SW_SHOW
    call            ShowWindow

    mov             rcx, rdi
    call            SetFocus

    mov             rcx, rdi
    call            SetForegroundWindow

    leave
    ret

; RETURNS: RAX BOOL wm_quit (1)
extern whandle_win_events
whandle_win_events:
    enter           32 + 8, 0

    lea             rcx, [rel eventMessage]             ; LPMSG lpMsg
    mov             rdx, NULL                           ; HWND hWnd
    mov             r8, 0                               ; UINT wMsgFilterMin
    mov             r9, 0                               ; UINT wMsgFilterMin
    mov             qword arg(1), PM_REMOVE             ; UINT wRemoveMessage

    call            PeekMessageA

    ; Return if PeekMessage returned 0 (No new message)
    cmp             rax, 0
    je              .exit

    ; Return 1 if the message is WM_QUIT
    cmp             qword [rel eventMessage + tagMSG.message], WM_QUIT
    je              .wm_quit
    

    lea             rcx, [rel eventMessage]             ; LPMSG lpMsg
    call            TranslateMessage

    lea             rcx, [rel eventMessage]             ; LPMSG lpMsg
    call            DispatchMessageA

    jmp             .exit

.wm_quit:
    mov             rax, 1
    jmp             .exit                               ; Not needed

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
