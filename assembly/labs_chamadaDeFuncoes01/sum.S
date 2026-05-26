.section .rodata

str01:  .string "Hello"

#-------------------------------------------------------------------------------
    .data

    .globl  val
    .align  4
val:    .int    432

    .globl  age
    .align  2
age:    .short  4

    .globl  r
    .align  4
r:      .int    0

    .globl  err
    .align  8
err:    .quad   2048

#-------------------------------------------------------------------------------
    .text

    .globl  main
main:
    pushq   %rbp
    movq    %rsp, %rbp

    # ========================================================
    # Chamada: val = sum("Hello", val, age, &r)
    # ========================================================
    
    # 1º Param: const char *prefix (Ponteiro = 64 bits -> %rdi)
    movq    $str01, %rdi
    
    # 2º Param: int v1 (32 bits -> %esi)
    movl    val, %esi
    
    # 3º Param: short v2 (16 bits -> %dx)
    movw    age, %dx
    
    # 4º Param: int *s (Ponteiro = 64 bits -> %rcx)
    # O '$' pega o endereço da variável 'r' na memória
    movq    $r, %rcx
    
    call    sum

    # O retorno da função 'sum' (que é um 'int') está no %eax
    movl    %eax, val

    # ========================================================
    # Chamada: show(err, val, r)
    # ========================================================
    
    # 1º Param: long err (64 bits -> %rdi)
    movq    err, %rdi
    
    # 2º Param: int val (32 bits -> %esi)
    movl    val, %esi
    
    # 3º Param: int r (32 bits -> %edx)
    movl    r, %edx
    
    call    show

    # return 0
    movl    $0, %eax

    leave
    ret