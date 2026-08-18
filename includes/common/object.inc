%include "includes/common/cdef.inc"

; General 3D object
struc Object
    .vao            ptr
    .vbo            ptr
    .ebo            ptr
    .vertex_count   uint64
    .index_count    uint64
endstruc

