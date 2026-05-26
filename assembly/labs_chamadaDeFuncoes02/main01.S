.section .rodata

fmt01:  .string "'a' maior do que 'b'\n"
fmt02:  .string "Valor de 'b': %d\n"

#-------------------------------------------------------------------------
    .data

    .globl  a
a:  .byte   97

    .globl  b
    .align  1
b:  .byte   105

#-------------------------------------------------------------------------
    .text

    .globl  main
main:
    pushq   %rbp
    movq    %rsp, %rbp
    
    # ========================================================
    # Chamada: int ret = maximo(a, b)
    # ========================================================
    
    # Parâmetros char (8 bits) usam as partes mais baixas dos registradores
    movb    a, %dil             # 1º param (char x) -> %dil
    movb    b, %sil             # 2º param (char y) -> %sil
    call    maximo

    # O retorno é um 'int', então pegamos os 32 bits do %eax
    # Salvamos 'ret' no registrador %ecx temporariamente
    movl    %eax, %ecx          # ret = maximo()

    # ========================================================
    # if (ret == a)
    # ========================================================
    movsbl  a, %edx             # %edx = (int)a (Extensão de sinal)
    cmpl    %edx, %ecx          # if (ret != a) -> else_if
    jne     else_if

    # --- Bloco do IF ---
    movq    $fmt01, %rdi        # 1º param: Ponteiro para a string
    movl    $0, %eax            # REGRA DO PRINTF: Zero indica "sem floats"
    call    printf
    
    jmp     end_if

else_if:
    # --- Bloco do ELSE ---
    movq    $fmt02, %rdi        # 1º param: Ponteiro para a string
    movsbl  b, %esi             # 2º param: (int)b em %esi
    movl    $0, %eax            # REGRA DO PRINTF: Zero indica "sem floats"
    call    printf

end_if:

    # return 0  
    movl    $0, %eax

    leave
    ret