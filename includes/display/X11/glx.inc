%include "includes/common/cdef.inc"

%define GLX_SAMPLES             100001
%define GLX_SAMPLE_BUFFERS      100000

%define GLX_X_RENDERABLE        32786
%define GLX_RENDER_TYPE         32785
%define GLX_DRAWABLE_TYPE       32784
%define GLX_X_VISUAL_TYPE       34
%define GLX_STENCIL_SIZE        13
%define GLX_DEPTH_SIZE          12
%define GLX_ALPHA_SIZE          11
%define GLX_BLUE_SIZE           10
%define GLX_GREEN_SIZE          9
%define GLX_RED_SIZE            8
%define GLX_DOUBLEBUFFER        5

%define GLX_WINDOW_BIT          1
%define GLX_RGBA_BIT            1
%define GLX_TRUE_COLOR          32770

%define AllocNone               0
%define AllocAll                1

%define True                    1
%define None                    0

%define StructureNotifyMask     1 << 17

%define InputOutput             1
%define InputOnly               2

%define CWBackPixmap            1 << 0
%define CWBackPixel             1 << 1
%define CWBorderPixmap          1 << 2
%define CWBorderPixel           1 << 3
%define CWBitGravity            1 << 4
%define CWWinGravity            1 << 5
%define CWBackingStore          1 << 6
%define CWBackingPlanes         1 << 7
%define CWBackingPixel          1 << 8
%define CWOverrideRedirect      1 << 9
%define CWSaveUnder             1 << 10
%define CWEventMask             1 << 11
%define CWDontPropagate         1 << 12
%define CWColormap              1 << 13
%define CWCursor                1 << 14

; ===== [ DEFINITIONS ] =====
%define XID                     uint64

%define VisualID                uint64
%define Pixmap                  XID
%define Colormap                XID
%define Cursor                  XID
%define Bool                    int32

; ===== [ STRUCTS ] =====
struc XVisualInfo
    .visual:                    ptr
    .visualid:                  VisualID
    .screen:                    int32
    .depth:                     uint32
    .class:                     int32
    .__padding__                int32
    .red_mask:                  uint64
    .green_mask:                uint64
    .blue_mask:                 uint64
    .colormap_size:             int32
    .bits_per_rgb:              int32
endstruc

struc XSetWindowAttributes
    .background_pixmap:         Pixmap
    .background_pixel:          uint64
    .border_pixmap:             Pixmap
    .border_pixel:              uint64
    .bit_gravity:               int32
    .win_gravity:               int32
    .backing_store:             int32
    .__padding_1__              int32
    .backing_planes:            uint64
    .backing_pixel:             uint64
    .save_under:                Bool
    .__padding_2__              int32
    .event_mask:                int64
    .do_not_propagate_mask:     int64
    .override_redirect:         Bool
    .__padding_3__              int32
    .colormap:                  Colormap
    .cursor:                    Cursor
endstruc
