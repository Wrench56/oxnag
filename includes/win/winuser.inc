%include "includes/win/typedef.inc"

; Macros

; Mask the value to 16 bits (WORD)
%define MAKEINTRESOURCE_A(a)            (a & 0xFFFF)

%define CW_USEDEFAULT                   0x80000000

; ===== Standard Icon IDs ===== ;
%define IDI_APPLICATION                 MAKEINTRESOURCE_A(32512)
%define IDI_HAND                        MAKEINTRESOURCE_A(32513)
%define IDI_QUESTION                    MAKEINTRESOURCE_A(32514)
%define IDI_EXCLAMATION                 MAKEINTRESOURCE_A(32515)
%define IDI_ASTERISK                    MAKEINTRESOURCE_A(32516)
%define IDI_WINLOGO                     MAKEINTRESOURCE_A(32517)
%define IDI_WARNING                     IDI_EXCLAMATION
%define IDI_ERROR                       IDI_HAND
%define IDI_INFORMATION                 IDI_ASTERISK

; ===== Standard Cursor IDs ===== ;
%define IDC_ARROW                       MAKEINTRESOURCE_A(32512)
%define IDC_IBEAM                       MAKEINTRESOURCE_A(32513)
%define IDC_WAIT                        MAKEINTRESOURCE_A(32514)
%define IDC_CROSS                       MAKEINTRESOURCE_A(32515)
%define IDC_UPARROW                     MAKEINTRESOURCE_A(32516)
%define IDC_SIZENWSE                    MAKEINTRESOURCE_A(32642)
%define IDC_SIZENESW                    MAKEINTRESOURCE_A(32643)
%define IDC_SIZEWE                      MAKEINTRESOURCE_A(32644)
%define IDC_SIZENS                      MAKEINTRESOURCE_A(32645)
%define IDC_SIZEALL                     MAKEINTRESOURCE_A(32646)
%define IDC_HAND                        MAKEINTRESOURCE_A(32649)
%define IDC_HELP                        MAKEINTRESOURCE_A(32651)

; ===== Color types ====== ;
%define CTLCOLOR_MSGBOX                 0
%define CTLCOLOR_EDIT                   1
%define CTLCOLOR_LISTBOX                2
%define CTLCOLOR_BTN                    3
%define CTLCOLOR_DLG                    4
%define CTLCOLOR_SCROLLBAR              5
%define CTLCOLOR_STATIC                 6
%define CTLCOLOR_MAX                    7

%define COLOR_SCROLLBAR                 0
%define COLOR_BACKGROUND                1
%define COLOR_ACTIVECAPTION             2
%define COLOR_INACTIVECAPTION           3
%define COLOR_MENU                      4
%define COLOR_WINDOW                    5
%define COLOR_WINDOWFRAME               6
%define COLOR_MENUTEXT                  7
%define COLOR_WINDOWTEXT                8
%define COLOR_CAPTIONTEXT               9
%define COLOR_ACTIVEBORDER              10
%define COLOR_INACTIVEBORDER            11
%define COLOR_APPWORKSPACE              12
%define COLOR_HIGHLIGHT                 13
%define COLOR_HIGHLIGHTTEXT             14
%define COLOR_BTNFACE                   15
%define COLOR_BTNSHADOW                 16
%define COLOR_GRAYTEXT                  17
%define COLOR_BTNTEXT                   18
%define COLOR_INACTIVECAPTIONTEXT       19
%define COLOR_BTNHIGHLIGHT              20

%define COLOR_3DDKSHADOW                21
%define COLOR_3DLIGHT                   22
%define COLOR_INFOTEXT                  23
%define COLOR_INFOBK                    24

%define COLOR_HOTLIGHT                  26
%define COLOR_GRADIENTACTIVECAPTION     27
%define COLOR_GRADIENTINACTIVECAPTION   28
%define COLOR_MENUHILIGHT               29
%define COLOR_MENUBAR                   30

%define COLOR_DESKTOP                   COLOR_BACKGROUND
%define COLOR_3DFACE                    COLOR_BTNFACE
%define COLOR_3DSHADOW                  COLOR_BTNSHADOW
%define COLOR_3DHIGHLIGHT               COLOR_BTNHIGHLIGHT
%define COLOR_3DHILIGHT                 COLOR_BTNHIGHLIGHT
%define COLOR_BTNHILIGHT                COLOR_BTNHIGHLIGHT

%define CS_VREDRAW                      0x0001
%define CS_HREDRAW                      0x0002
%define CS_OWNDC                        0x0020

; ===== Window styles ===== ;
%define WS_OVERLAPPED                   0x00000000
%define WS_POPUP                        0x80000000
%define WS_CHILD                        0x40000000
%define WS_MINIMIZE                     0x20000000
%define WS_VISIBLE                      0x10000000
%define WS_DISABLED                     0x08000000
%define WS_CLIPSIBLINGS                 0x04000000
%define WS_CLIPCHILDREN                 0x02000000
%define WS_MAXIMIZE                     0x01000000
%define WS_CAPTION                      0x00C00000
%define WS_BORDER                       0x00800000
%define WS_DLGFRAME                     0x00400000
%define WS_VSCROLL                      0x00200000
%define WS_HSCROLL                      0x00100000
%define WS_SYSMENU                      0x00080000
%define WS_THICKFRAME                   0x00040000
%define WS_GROUP                        0x00020000
%define WS_TABSTOP                      0x00010000

%define WS_MINIMIZEBOX                  0x00020000
%define WS_MAXIMIZEBOX                  0x00010000

%define WS_OVERLAPPEDWINDOW             (WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX)

; ===== Extended Window Styles =====     ;
%define WS_EX_DLGMODALFRAME             0x00000001
%define WS_EX_NOPARENTNOTIFY            0x00000004
%define WS_EX_TOPMOST                   0x00000008
%define WS_EX_ACCEPTFILES               0x00000010
%define WS_EX_TRANSPARENT               0x00000020
%define WS_EX_MDICHILD                  0x00000040
%define WS_EX_TOOLWINDOW                0x00000080
%define WS_EX_WINDOWEDGE                0x00000100
%define WS_EX_CLIENTEDGE                0x00000200
%define WS_EX_CONTEXTHELP               0x00000400

%define WS_EX_APPWINDOW                 0x00040000
%define WS_EX_COMPOSITED                0x02000000

; ===== Window Messages =====
%define WM_NULL                         0x0000
%define WM_CREATE                       0x0001
%define WM_DESTROY                      0x0002
%define WM_MOVE                         0x0003
%define WM_SIZE                         0x0005

%define WM_ACTIVATE                     0x0006
%define WA_INACTIVE                     0
%define WA_ACTIVE                       1
%define WA_CLICKACTIVE                  2

%define WM_SETFOCUS                     0x0007
%define WM_KILLFOCUS                    0x0008
%define WM_ENABLE                       0x000A
%define WM_SETREDRAW                    0x000B
%define WM_SETTEXT                      0x000C
%define WM_GETTEXT                      0x000D
%define WM_GETTEXTLENGTH                0x000E
%define WM_PAINT                        0x000F
%define WM_CLOSE                        0x0010
%define WM_QUERYENDSESSION              0x0011
%define WM_QUERYOPEN                    0x0013
%define WM_ENDSESSION                   0x0016
%define WM_QUIT                         0x0012
%define WM_ERASEBKGND                   0x0014
%define WM_SYSCOLORCHANGE               0x0015
%define WM_SHOWWINDOW                   0x0018
%define WM_WININICHANGE                 0x001A

; ===== ShowWindow() Commands =====     ;
%define SW_HIDE                         0
%define SW_SHOWNORMAL                   1
%define SW_NORMAL                       1
%define SW_SHOWMINIMIZED                2
%define SW_SHOWMAXIMIZED                3
%define SW_MAXIMIZE                     3
%define SW_SHOWNOACTIVATE               4
%define SW_SHOW                         5
%define SW_MINIMIZE                     6
%define SW_SHOWMINNOACTIVE              7
%define SW_SHOWNA                       8
%define SW_RESTORE                      9
%define SW_SHOWDEFAULT                  10
%define SW_FORCEMINIMIZE                11
%define SW_MAX                          11

; ===== Message Box ===== ; 
%define MB_OK                           0x00000000
%define MB_OKCANCEL                     0x00000001
%define MB_ABORTRETRYIGNORE             0x00000002
%define MB_YESNOCANCEL                  0x00000003
%define MB_YESNO                        0x00000004
%define MB_RETRYCANCEL                  0x00000005
%define MB_CANCELTRYCONTINUE            0x00000006


%define MB_ICONHAND                     0x00000010
%define MB_ICONQUESTION                 0x00000020
%define MB_ICONEXCLAMATION              0x00000030
%define MB_ICONASTERISK                 0x00000040
%define MB_USERICON                     0x00000080
%define MB_ICONWARNING                  MB_ICONEXCLAMATION
%define MB_ICONERROR                    MB_ICONHAND

%define MB_ICONINFORMATION              MB_ICONASTERISK
%define MB_ICONSTOP                     MB_ICONHAND

%define MB_DEFBUTTON1                   0x00000000
%define MB_DEFBUTTON2                   0x00000100
%define MB_DEFBUTTON3                   0x00000200
%define MB_DEFBUTTON4                   0x00000300

%define MB_APPLMODAL                    0x00000000
%define MB_SYSTEMMODAL                  0x00001000
%define MB_TASKMODAL                    0x00002000
%define MB_HELP                         0x00004000

%define MB_NOFOCUS                      0x00008000
%define MB_SETFOREGROUND                0x00010000
%define MB_DEFAULT_DESKTOP_ONLY         0x00020000
%define MB_TOPMOST                      0x00040000
%define MB_RIGHT                        0x00080000
%define MB_RTLREADING                   0x00100000
%define MB_SERVICE_NOTIFICATION         0x00200000

%define MB_TYPEMASK                     0x0000000F
%define MB_ICONMASK                     0x000000F0
%define MB_DEFMASK                      0x00000F00
%define MB_MODEMASK                     0x00003000
%define MB_MISCMASK                     0x0000C000

; ===== PeekMessage options ===== ;
%define PM_NOREMOVE		                0x0000
%define PM_REMOVE		                0x0001
%define PM_NOYIELD		                0x0002

; ===== Window messages ===== ;
%define WM_NULL                         0x0000
%define WM_CREATE                       0x0001
%define WM_DESTROY                      0x0002
%define WM_NCDESTROY			        WM_DESTROY
%define WM_MOVE                         0x0003
%define WM_SIZE                         0x0005
%define WM_ACTIVATE                     0x0006
%define WM_SETFOCUS                     0x0007
%define WM_KILLFOCUS                    0x0008
%define WM_ENABLE                       0x000A
%define WM_SETREDRAW					0x000B
%define WM_SETTEXT                      0x000C
%define WM_GETTEXT                      0x000D
%define WM_GETTEXTLENGTH                0x000E
%define WM_PAINT                        0x000F
%define WM_CLOSE                        0x0010
%define WM_QUIT                         0x0012
%define WM_ERASEBKGND                   0x0014
%define WM_SHOWWINDOW                   0x0018
%define WM_CTLCOLOR                     0x0019
%define WM_NEXTDLGCTL                   0x0028
%define WM_DRAWITEM                     0x002B
%define WM_MEASUREITEM                  0x002C
%define WM_DELETEITEM 					0x002D
%define WM_VKEYTOITEM					0x002E
%define WM_CHARTOITEM					0x002F
%define WM_SETFONT          		    0x0030
%define WM_GETFONT      		        0x0031
%define WM_COMPAREITEM					0x0039
%define WM_WINDOWPOSCHANGED             0x0047
%define WM_NOTIFY                       0x004E
%define WM_NCCALCSIZE                   0x0083
%define WM_NCHITTEST                    0x0084
%define WM_NCPAINT                      0x0085
%define WM_GETDLGCODE                   0x0087
%define WM_NCMOUSEMOVE                  0x00A0
%define WM_NCLBUTTONDOWN                0x00A1
%define WM_NCLBUTTONUP                  0x00A2
%define WM_NCLBUTTONDBLCLK              0x00A3
%define WM_NCRBUTTONDOWN                0x00A4
%define WM_NCRBUTTONUP                  0x00A5
%define WM_NCRBUTTONDBLCLK              0x00A6
%define WM_KEYFIRST                     0x0100
%define WM_KEYDOWN                      0x0100
%define WM_KEYUP                        0x0101
%define WM_CHAR                         0x0102
%define WM_DEADCHAR                     0x0103
%define WM_SYSKEYDOWN                   0x0104
%define WM_SYSKEYUP                     0x0105
%define WM_SYSCHAR                      0x0106
%define WM_SYSDEADCHAR                  0x0107
%define WM_KEYLAST                      0x0108
%define WM_INITDIALOG	                0x0110
%define WM_COMMAND                      0x0111
%define WM_SYSCOMMAND                   0x0112
%define WM_TIMER                        0x0113
%define WM_HSCROLL                      0x0114
%define WM_VSCROLL                      0x0115

%define WM_ENTERIDLE                    0x0121

%define WM_CTLCOLORMSGBOX               0x0132
%define WM_CTLCOLOREDIT                 0x0133
%define WM_CTLCOLORLISTBOX              0x0134
%define WM_CTLCOLORBTN                  0x0135
%define WM_CTLCOLORDLG                  0x0136
%define WM_CTLCOLORSCROLLBAR            0x0137
%define WM_CTLCOLORSTATIC               0x0138

%define WM_MOUSEFIRST                   0x0200
%define WM_MOUSEMOVE                    0x0200
%define WM_LBUTTONDOWN                  0x0201
%define WM_LBUTTONUP                    0x0202
%define WM_LBUTTONDBLCLK                0x0203
%define WM_RBUTTONDOWN                  0x0204
%define WM_RBUTTONUP                    0x0205
%define WM_RBUTTONDBLCLK                0x0206
%define WM_MBUTTONDOWN                  0x0207
%define WM_MBUTTONUP                    0x0208
%define WM_MBUTTONDBLCLK                0x0209
%define WM_MOUSEWHEEL                   0x020A
%define WM_MOUSELAST                    0x020A
%define WM_HOTKEY                       0x0312

%define WM_USER                         0x0400


%define STD_OUTPUT_HANDLE               -11

struc tagWNDCLASSEXA
    .cbSize:                            UINT
    .style:                             UINT
    .lpfnWndProc:                       WNDPROC
    .cbClsExtra:                        INT_
    .cbWndExtra:                        INT_
    .hInstance:                         HINSTANCE
    .hIcon:                             HICON
    .hCursor:                           HCURSOR
    .hbrBackground:                     HBRUSH
    .lpszMenuName:                      LPCSTR
    .lpszClassName:                     LPCSTR
    .hIconSm:                           HICON
endstruc

struc tagMSG
    .hwnd:                              HWND
    .message:                           UINT
    .wParam:                            WPARAM
    .lParam:                            LPARAM
    .time:                              DWORD_
    .pt:                                POINT
    .lPrivate:                          DWORD_
endstruc
