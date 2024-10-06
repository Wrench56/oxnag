%include "includes/win/typedef.inc"

%define HBRUSH      HANDLE


; ===== pixel types ===== ;
%define PFD_TYPE_RGBA        0
%define PFD_TYPE_COLORINDEX  1

; ===== layer types ===== ;
%define PFD_MAIN_PLANE       0
%define PFD_OVERLAY_PLANE    1
%define PFD_UNDERLAY_PLANE   (-1)


; ===== PIXELFORMATDESCRIPTOR flags ===== ;
%define PFD_DOUBLEBUFFER                0x00000001
%define PFD_STEREO                      0x00000002
%define PFD_DRAW_TO_WINDOW              0x00000004
%define PFD_DRAW_TO_BITMAP              0x00000008
%define PFD_SUPPORT_GDI                 0x00000010
%define PFD_SUPPORT_OPENGL              0x00000020
%define PFD_GENERIC_FORMAT              0x00000040
%define PFD_NEED_PALETTE                0x00000080
%define PFD_NEED_SYSTEM_PALETTE         0x00000100
%define PFD_SWAP_EXCHANGE               0x00000200
%define PFD_SWAP_COPY                   0x00000400
%define PFD_SWAP_LAYER_BUFFERS          0x00000800
%define PFD_GENERIC_ACCELERATED         0x00001000
%define PFD_SUPPORT_DIRECTDRAW          0x00002000
%define PFD_DIRECT3D_ACCELERATED        0x00004000
%define PFD_SUPPORT_COMPOSITION         0x00008000

; ===== PIXELFORMATDESCRIPTOR flags for use in ChoosePixelFormat only ===== ;
%define PFD_DEPTH_DONTCARE              0x20000000
%define PFD_DOUBLEBUFFER_DONTCARE       0x40000000
%define PFD_STEREO_DONTCARE             0x80000000


struc tagPIXELFORMATDESCRIPTOR
    .nSize:                             WORD_
    .nVersion:                          WORD_
    .dwFlags:                           DWORD_
    .iPixelType:                        BYTE_
    .cColorBits:                        BYTE_
    .cRedBits:                          BYTE_
    .cRedShift:                         BYTE_
    .cGreenBits:                        BYTE_
    .cGreenShift:                       BYTE_
    .cBlueBits:                         BYTE_
    .cBlueShift:                        BYTE_
    .cAlphaBits:                        BYTE_
    .cAlphaShift:                       BYTE_
    .cAccumBits:                        BYTE_
    .cAccumRedBits:                     BYTE_
    .cAccumGreenBits:                   BYTE_
    .cAccumBlueBits:                    BYTE_
    .cAccumAlphaBits:                   BYTE_
    .cDepthBits:                        BYTE_
    .cStencilBits:                      BYTE_
    .cAuxBuffers:                       BYTE_
    .iLayerType:                        BYTE_
    .bReserved:                         BYTE_
    .dwLayerMask:                       DWORD_
    .dwVisibleMask:                     DWORD_
    .dwDamageMask:                      DWORD_
endstruc
