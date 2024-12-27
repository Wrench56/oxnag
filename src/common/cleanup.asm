%include "src/flags.inc"

%include "includes/common/preprocessors.inc"
%include "includes/common/macros.inc"


%ifidn TARGET_OS, OS_WINDOWS
    extern wcleanup

    %define os_spec_cleanup     call wcleanup
%endif


section .text
extern cleanup
cleanup:
    prologue        32, 0

    os_spec_cleanup

    epilogue
    ret
