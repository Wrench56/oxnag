layout regs + src
set disassembly-flavor intel
set debuginfod enabled on

# Auto-refresh on breakpoint hit
define hook-stop
  refresh
end

