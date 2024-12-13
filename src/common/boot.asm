%include "includes/common/preprocessors.inc"
%include "includes/common/macros.inc"

section .data
    header_msg          db "[     ] Hello from oxnag!", 10, \
                           "[     ] ==========================================", 10, \
                           "[     ] Made by:", 10, \
                           "[     ]  > Mark Devenyi <markdevenyidev@gmail.com>", 10, \
                           "[     ] ==========================================", 10
    header_msg_len      equ $ - header_msg


%ifidn __OUTPUT_FORMAT__, win64
    extern wboot
    %define os_spec_boot    call wboot
%endif


section .text
extern boot_process
boot_process:
    enter           32, 0

    ; Run OS-specific boot process
    os_spec_boot

    ; Bootup message
    log             header_msg, header_msg_len

    leave
    ret
