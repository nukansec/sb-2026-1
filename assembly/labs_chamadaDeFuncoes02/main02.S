.section .rodata

fmt:    .string "Iteração %d, v = %d\n"

#-------------------------------------------------------------------------------
    .data

    .globl  i
    .align  4
i:  .int    0

    .globl  v
    .align  2
v:  .short  0

    .globl  vetA
    .align  2
vetA: .short 28, 42, 16, 23, 47

    .globl  vetB
    .align  4
vetB: .int  0, 0, 0, 0, 0

#-------------------------------------------------------------------------------
    .text

    .globl  main
main:
    pushq   %rbp
    movq    %rsp, %rbp

begin_while:
    cmpl    $5, i               # if (i >= 5) -> end_while
    jge     end_while

    # ========================================================
    # Leitura e Shift: v = vetA[i] << 2
    # ========================================================
    movq    $vetA, %r8          
    movslq  i, %r9              
    imulq   $2, %r9             
    addq    %r8, %r9            # %r9 = &vetA[i]

    movw    (%r9), %r10w        # %r10w = vetA[i]
    shlw    $2, %r10w           # %r10w = %r10w << 2
    movw    %r10w, v            # Grava na variável global 'v'

    # ========================================================
    # Chamada: printf("Iteração %d, v = %d\n", i, (int)v)
    # ========================================================
    movq    $fmt, %rdi          # 1º param: Ponteiro para a string
    movl    i, %esi             # 2º param: int i
    movswl  v, %edx             # 3º param: (int)v (Promoção de short para int)
    movl    $0, %eax            # REGRA DO PRINTF: Zero
    call    printf

    # ========================================================
    # Chamada: process(i, v, &vetB[i])
    # ========================================================
    
    # 1. Calcula o endereço de vetB[i] para poder passar por referência
    movq    $vetB, %r8          
    movslq  i, %r9              
    imulq   $4, %r9             
    addq    %r8, %r9            # %r9 = &vetB[i] (Endereço exato na memória)

    # 2. Configura os parâmetros para a função process
    movl    i, %edi             # 1º param: int x (32 bits -> %edi)
    movw    v, %si              # 2º param: short v (16 bits -> %si)
    
    # PULO DO GATO: Passamos o ENDEREÇO armazenado em %r9, não o valor desreferenciado.
    # Por ser um endereço de memória (ponteiro), usamos 64 bits (%rdx).
    movq    %r9, %rdx           # 3º param: int *pos (64 bits -> %rdx)
    
    call    process

    # i++
    incl    i                   

    jmp     begin_while

end_while:

    # ========================================================
    # Chamada: show(vetB, 5)
    # ========================================================
    
    # Array decay: em C, passar o vetor é igual a passar o endereço do primeiro elemento
    movq    $vetB, %rdi         # 1º param: int *vet (Endereço Base -> %rdi)
    movq    $5, %rsi            # 2º param: long size (64 bits -> %rsi)
    call    show

    # return 0
    movl    $0, %eax

    leave
    ret