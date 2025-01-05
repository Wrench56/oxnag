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

%define True                    1
%define None                    0


; ===== [ DEFINITIONS ] =====
%define VisualID                uint64


; ===== [ STRUCTS ] =====
struc istruct
    .visual:          ptr
    .visualid:        VisualID
    .screen:          int32
    .depth:           int32
    .class:           int32
    .red_mask:        uint64
    .green_mask:      uint64
    .blue_mask:       uint64
    .colormap_size:   int32
    .bits_per_rgb:    int32
endstruc
