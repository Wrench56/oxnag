section .text

global _start
_start:
    jmp         _exit

_exit:
    xor         ax, ax
    ret
