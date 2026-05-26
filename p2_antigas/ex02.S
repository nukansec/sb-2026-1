.data

    # int i = 0;
    .globl  i
    .align  4
i:  .int    0

    # int swap = 10;
    .globl  swap
    .align  4
swap: .int  10

    # long factor = 2048;
    .globl  factor
    .align  8
factor: .quad 2048

    # short vetor[4] = {100, 200, 300, 400};
    .globl  vetor
    .align  2
vetor: .short 100, 200, 300, 400

#-------------------------------------------------------------------------------

.text

.globl converter
converter:
    pushq   %rbp
    movq    %rsp, %rbp
    
    # void converter() { short *ptr; }
    # Vamos alocar 16 bytes na pilha para guardar a variável local 'ptr' (que tem 8 bytes)
    # mantendo o alinhamento da pilha. 'ptr' ficará em -8(%rbp)
    subq    $16, %rsp

begin_for:
    # ==========================================
    # Condição do FOR: i < (swap * 2)
    # ==========================================
    movl    swap, %eax          # %eax = swap
    imull   $2, %eax            # %eax = swap * 2
    
    cmpl    %eax, i             # if (i >= swap * 2) -> end_for
    jge     end_for

    # ==========================================
    # ptr = &vetor[i] + 2;
    # ==========================================
    movq    $vetor, %r8         # %r8 = Endereço Base de 'vetor'
    movslq  i, %r9              # Estica 'i' (int) para 64 bits em %r9
    imulq   $2, %r9             # %r9 = i * 2 (tamanho de short)
    addq    %r8, %r9            # %r9 = &vetor[i]
    
    # Aritmética de ponteiro: +2 posições de short = +4 bytes físicos
    addq    $4, %r9             # %r9 = &vetor[i] + 2
    movq    %r9, -8(%rbp)       # Salva na variável local 'ptr' na pilha

    # ==========================================
    # swap = (int)mixer(*ptr, vetor, swap, factor);
    # ==========================================
    
    # 1º Param (short value -> %di)
    movq    -8(%rbp), %r10      # Recupera o ponteiro 'ptr' da pilha
    movw    (%r10), %di         # Desreferencia (*ptr) pegando 2 bytes

    # 2º Param (short *v -> %rsi)
    movq    $vetor, %rsi        # Passa o endereço base do vetor

    # 3º Param (int i -> %edx)  -- Atenção: a variável passada é 'swap'
    movl    swap, %edx          

    # 4º Param (long f -> %rcx) -- Passa a variável 'factor'
    movq    factor, %rcx        

    call    mixer

    # O retorno de 'mixer' é long, então está em %rax.
    # O C faz um cast explícito para (int), truncando para 32 bits (%eax).
    movl    %eax, swap          # swap = (int)mixer(...)

    # ==========================================
    # factor = (long)swap;
    # ==========================================
    # O C promove o 'swap' (int) para long antes de atribuir a 'factor'.
    movslq  swap, %rax          # Estensão de sinal de 32 para 64 bits
    movq    %rax, factor        # factor = (long)swap

    # ==========================================
    # vetor[factor] = (short)upper(factor, swap);
    # ==========================================
    
    # Chamada de upper(factor, swap):
    # 1º Param (long f -> %rdi)
    movq    factor, %rdi        
    
    # 2º Param (int i -> %esi)
    movl    swap, %esi          
    
    call    upper

    # O retorno de 'upper' é int, então está em %eax.
    # Precisamos guardá-lo em vetor[factor], fazendo cast para (short).
    
    movq    $vetor, %r8         # %r8 = Endereço base de 'vetor'
    movq    factor, %r9         # %r9 = índice 'factor' (já é um long de 64 bits)
    imulq   $2, %r9             # Multiplica por 2 bytes (tamanho de short)
    addq    %r8, %r9            # %r9 = Endereço de vetor[factor]
    
    # Cast para short: Pegamos apenas os 16 bits mais baixos (%ax) do retorno
    movw    %ax, (%r9)          # Grava o short na memória

    # ==========================================
    # if (swap > 0)
    # ==========================================
    cmpl    $0, swap            # Se swap <= 0, pula o bloco do IF
    jle     end_if

    # swap = i ^ 0xFFEEDDCC;
    movl    i, %r10d            # %r10d = i
    xorl    $0xFFEEDDCC, %r10d  # %r10d = i ^ 0xFFEEDDCC (O $ indica valor literal/imediato)
    movl    %r10d, swap         # swap = resultado

end_if:
    # ==========================================
    # Incremento do FOR (i++)
    # ==========================================
    incl    i
    jmp     begin_for

end_for:
    leave
    ret