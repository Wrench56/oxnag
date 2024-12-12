%include "includes/common/preprocessors.inc"
%include "includes/common/macros.inc"

section .data
    header_msg          db "[     ] ==========================================", 10
    header_msg_len      equ $ - header_msg
    boot_msg            db "[     ] Hello from oxnag!", 10
    boot_msg_len        equ $ - boot_msg
    author_msg          db "[     ] Made by:", 10
    author_msg_len      equ $ - author_msg
    author1             db "[     ]  > Mark Devenyi <markdevenyidev@gmail.com>", 10
    author1_len         equ $ - author1


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
    log             boot_msg, boot_msg_len
    log             header_msg, header_msg_len
    log             author_msg, author_msg_len
    log             author1, author1_len
    log             header_msg, header_msg_len

    leave
    ret
