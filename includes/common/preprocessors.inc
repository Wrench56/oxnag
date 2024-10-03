; C-like sizeof() for structs
%define sizeof(struc_type_name) (struc_type_name%+_size)

; N-th argument on the stack for syscalls
%define arg(n) [rsp + ((n + 3) * 8)]
