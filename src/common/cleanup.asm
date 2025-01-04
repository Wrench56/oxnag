%include "src/flags.inc"

%include "includes/common/preprocessors.inc"
%include "includes/common/macros.inc"


%ifidn TARGET_OS, OS_WINDOWS
    extern wcleanup

    %define os_spec_cleanup     call wcleanup
%else
    %warning No OS_type=TARGET_OS specific cleanup implemented

    %define os_spec_cleanup     
%endif


section .text
extern cleanup
cleanup:
    prologue        32

    os_spec_cleanup

    epilogue	    32
    ret
