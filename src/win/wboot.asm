extern wload_stdout

%include "src/flags.inc"

section .text
extern wboot
wboot:
    enter           32, 0

    %ifdef LOG_TO_CONSOLE
        call            wload_stdout
    %endif

    leave
    ret
