.data

    .globl  i
    .align  4
i:      .int    0

    .globl  bias
    .align  8
bias:   .quad   256

    .globl  vet
    .align  1
vet:    .byte   12, 3, 20, 8

#-------------------------------------------------------------------------------
    .text

    .globl  main
main:
    pushq   %rbp
    movq    %rsp, %rbp

    # ========================================================
    # for (i = 0; i < LEN; i++)
    # ========================================================
    movl    $0, i               # i = 0

begin_for:
    cmpl    $4, i               # if (i >= 4) -> end_for
    jge     end_for

    # ========================================================
    # Chamada: bias = filtro(vet[i], LIM, bias)
    # ========================================================
    
    # --- 1º Param: unsigned char x (8 bits -> %dil) ---
    movq    $vet, %r8           # %r8 = Endereço Base do vetor
    movslq  i, %r9              # %r9 = (long)i
    # imulq $1, %r9             (Deslocamento de 1 byte; pode ser omitido)
    addq    %r9, %r8            # %r8 = &vet[i]

    # Lê apenas 1 byte (movb) e armazena no registrador de argumento %dil
    movb    (%r8), %dil

    # --- 2º Param: short lim (16 bits -> %si) ---
    # LIM é a macro que vale 10 no código C.
    movw    $10, %si

    # --- 3º Param: long b (64 bits -> %rdx) ---
    movq    bias, %rdx

    # Executa a função
    call    filtro

    # O retorno da função (long) estará obrigatoriamente no %rax.
    # bias = filtro(...)
    movq    %rax, bias

    # Atualiza o iterador: i++
    incl    i

    jmp     begin_for

end_for:

    # return 0
    movl    $0, %eax

    leave
    ret