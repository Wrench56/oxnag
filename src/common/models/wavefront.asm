; ===== [ EXTERNS  ] =====
extern parse_raw_obj
extern objmesh_from_raw
extern free_raw_obj
extern free_obj_mesh

extern glGenVertexArrays
extern glGenBuffers
extern glBindVertexArray
extern glBindBuffer
extern glBufferData
extern glVertexAttribPointer
extern glEnableVertexAttribArray

extern malloc
extern free

; ===== [ INCLUDES ] =====
%include "src/flags.inc"
%include "includes/common/macros.inc"
%include "includes/common/opengl.inc"
%include "includes/common/object.inc"

%include "libs/common/libobj/includes/objmesh.inc"

%define FLOAT_SIZE 4
%define UINT32_SIZE 4

; ===== [  .DATA   ] =====
section .data
    fatalTitle      db "Error: wavefront.asm", 0
    fatalMsg        db "[ upload_obj_to_gpu ]: no such wavefront file", 0

; ===== [  .TEXT   ] =====
section .text
; IN: RDI - *filename
global upload_obj_to_gpu
upload_obj_to_gpu:
    push            rbx
    push            r12
    push            r13
    push            r14

    prologue        32 + 16

    call            parse_raw_obj
    test            rax, rax
    jz              .error
    mov             rbx, rax

    mov             rdi, rax
    call            objmesh_from_raw
    mov             r12, rax

    mov             arg(1), rbx
    call            free_raw_obj

    mov             arg(1), sizeof(Object)
    call            malloc
    mov             r14, rax

    ; Copy vertex/index count
    mov             r13, [r12 + ObjMesh.vertex_count]
    mov             [r14 + Object.vertex_count], r13
    mov             r13, [r12 + ObjMesh.index_count]
    mov             [r14 + Object.index_count], r13

    ; Create buffers
    mov             arg(1), 1
    lea             arg(2), [r14 + Object.vao]
    call            glGenVertexArrays
 
    mov             arg(1), 1
    lea             arg(2), [r14 + Object.vbo]
    call            glGenBuffers

    mov             arg(1), 1
    lea             arg(2), [r14 + Object.ebo]
    call            glGenBuffers

    mov             arg(1), [r14 + Object.vao]
    call            glBindVertexArray

    ; VBO
    mov             arg(1), GL_ARRAY_BUFFER
    mov             arg(2), [r14 + Object.vbo]
    call            glBindBuffer

    mov             rbx, [r12 + ObjMesh.vertex_count]
    imul            rbx, sizeof(ObjVertex)

    mov             arg(1), GL_ARRAY_BUFFER
    mov             arg(2), rbx
    mov             arg(3), [r12 + ObjMesh.vertices]
    mov             arg(4), GL_STATIC_DRAW
    call            glBufferData

    ; EBO
    mov             arg(1), GL_ELEMENT_ARRAY_BUFFER
    mov             arg(2), [r14 + Object.ebo]
    call            glBindBuffer

    mov             rbx, [r12 + ObjMesh.index_count]
    shl             rbx, 2

    mov             arg(1), GL_ELEMENT_ARRAY_BUFFER
    mov             arg(2), rbx
    mov             arg(3), [r12 + ObjMesh.indices]
    mov             arg(4), GL_STATIC_DRAW
    call            glBufferData

    ; Position (location 0)
    xor             arg(1), arg(1)
    mov             arg(2), 3
    mov             arg(3), GL_FLOAT
    mov             arg(4), GL_FALSE
    mov             arg(5), sizeof(ObjVertex)
    mov             arg(6), 0
    call            glVertexAttribPointer

    xor             arg(1), arg(1)
    call            glEnableVertexAttribArray

    ; Normal (location 1)
    mov             arg(1), 1
    mov             arg(2), 3
    mov             arg(3), GL_FLOAT
    mov             arg(4), GL_FALSE
    mov             arg(5), sizeof(ObjVertex)
    mov             arg(6), 3 * FLOAT_SIZE
    call            glVertexAttribPointer

    mov             arg(1), 1
    call            glEnableVertexAttribArray

    ; UV (location 2)
    mov             arg(1), 2
    mov             arg(2), 2
    mov             arg(3), GL_FLOAT
    mov             arg(4), GL_FALSE
    mov             arg(5), sizeof(ObjVertex)
    mov             arg(6), 6 * FLOAT_SIZE
    call            glVertexAttribPointer

    mov             arg(1), 2
    call            glEnableVertexAttribArray

    mov             arg(1), GL_ARRAY_BUFFER
    xor             arg(2), arg(2)
    call            glBindBuffer
    
    xor             arg(1), arg(1)
    call            glBindVertexArray

    ; Free ObjMesh
    mov             rdi, r12
    call            free_obj_mesh

    ; Return
    mov             rax, r14

    epilogue        32 + 16

    pop             r14
    pop             r13
    pop             r12
    pop             rbx
    ret
.error:
    fatal_error     fatalTitle, fatalMsg

