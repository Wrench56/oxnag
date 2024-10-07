; 64-bit type definitions based on Windows
; Source: https://learn.microsoft.com/en-us/windows/win32/winprog/windows-data-types

%if __BITS__ = 64
    %define PTR     resq 1  ; Define PTR as resq (64-bit)
%else
    %define PTR     resd 1  ; Define PTR as resd (32-bit)
%endif

%define UNINIT      0
%define NULL        0

%define WNDPROC     PTR

%define BYTE_       resb 1
%define UINT        resd 1
%define INT_        resd 1
%define WORD_       resw 1
%define DWORD_      resd 1
%define ATOM        resw 1

%define LPCSTR      PTR

%define WPARAM      PTR
%define LPARAM      PTR
%define POINT       PTR

; Handles
%define HANDLE      PTR

%define HINSTANCE   HANDLE
%define HICON       HANDLE
%define HCURSOR     HICON
%define HBRUSH      HANDLE
%define HWND        HANDLE
