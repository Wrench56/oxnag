; =============== [OxNAG] ===============
; This file contains compile flags for
; the codebase. Enable them by 
; uncommenting them. Defining such flags
; prompts the NASM preprocessor to enable
; specific functionalities.
;
; This file should contain all possible
; feature flag uncommented or not.
; =======================================


; Enable to log on a separate console
%define LOG_TO_CONSOLE

; Specify which OS to compile for
%define TARGET_OS OS_LINUX

; Display server
%define DISPLAY_SERVER DS_XORG


; ============= [Constants] =============
; These constants are specific to 
; `flags.inc`.
; =======================================

; OS types (64-bit only)
%define OS_LINUX   0
%define OS_MAC     1
%define OS_WINDOWS 2

; Display Server types
%define DS_NONE    0
%define DS_WIND    1
%define DS_XORG    2
%define DS_WAYLAND 3
%define DS_QUARTZ  4
