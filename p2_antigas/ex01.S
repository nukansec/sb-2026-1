.data

    # char bias = 3; (1 byte)
    .globl  bias
    .align  1
bias:   .byte   3

    # short max = 1024; (2 bytes)
    .globl  max
    .align  2
max:    .word   1024

    # long complement[4] = {0,0,0,0}; (4 elementos de 8 bytes = 32 bytes)
    .globl  complement
    .align  8
complement: .quad 0, 0, 0, 0

#-------------------------------------------------------------------------------

.text

.globl auxiliar
auxiliar:
    # ---------------- PRÓLOGO ----------------
    pushq   %rbp                # Guarda a base da pilha anterior
    movq    %rsp, %rbp          # Define a nova base da pilha para esta função
    
    # Aloca 16 bytes na pilha (alinhamento padrão) para a variável local 'int range'
    # A variável 'range' viverá no endereço -4(%rbp)
    subq    $16, %rsp           

    # ---------------- int range = init_complement(); ----------------
    call    init_complement     # Chama a função externa
    movl    %eax, -4(%rbp)      # O retorno (int) vem sempre no %eax. Guardamos na pilha.

    # ---------------- if (range < max) ----------------
    # 'max' é short (16 bits) e 'range' é int (32 bits).
    # O C exige que se promova o 'max' para 32 bits antes de comparar.
    movswl  max, %edx           # Lê 'max' estendendo o sinal para 32 bits no %edx
    
    # Em AT&T, compara-se o segundo com o primeiro (range em relação a max)
    cmpl    %edx, -4(%rbp)      
    jge     else_block          # Lógica invertida: se range >= max, salta para o ELSE

    # ---------------- Bloco IF Verdadeiro ----------------

    # 1. complement[range]++;
    movq    $complement, %r8    # %r8 = Endereço base do vetor 'complement'
    
    # Para usar 'range' como índice de memória, temos de o estender para 64 bits
    movslq  -4(%rbp), %r9       # %r9 = (long)range
    imulq   $8, %r9             # %r9 = índice * 8 bytes (tamanho de um long)
    addq    %r8, %r9            # %r9 = Endereço exato de complement[range]
    
    incq    (%r9)               # Vai à memória e soma 1 diretamente ao valor (quad)

    # 2. if (range)
    cmpl    $0, -4(%rbp)        # Compara range com 0
    je      end_if              # Se for igual a 0 (falso), salta e ignora o resto do IF

    # 3. bias = (char)(range * max);
    movl    -4(%rbp), %eax      # %eax = range (32 bits)
    movswl  max, %edx           # %edx = (int)max (promove short para int)
    
    imull   %edx, %eax          # %eax = range * max (Multiplicação de 32 bits)
    
    # O cast para 'char' (truncamento) ocorre aqui: pegamos apenas nos 8 bits mais 
    # baixos do registo %eax (que se chama %al) e gravamos na memória.
    movb    %al, bias           # bias = últimos 8 bits do resultado

    # 4. range = (int)(bias >> 3);
    # O C promove sempre tipos menores para 'int' antes de operações matemáticas.
    movsbl  bias, %eax          # %eax = (int)bias (Estende o sinal do char para 32 bits)
    
    # Shift Aritmético: Como o 'bias' tem sinal (signed char), usamos 'sar' em vez de 'shr' 
    # para preservar os números negativos.
    sarl    $3, %eax            # %eax = %eax >> 3
    
    movl    %eax, -4(%rbp)      # range = %eax (Grava o resultado de volta na pilha)

    jmp     end_if              # Terminou o bloco IF verdadeiro, salta o ELSE

    # ---------------- Bloco ELSE ----------------
else_block:
    
    # complement[bias] = (long)max;
    movq    $complement, %r8    # %r8 = Endereço base do vetor
    
    # Promove 'bias' (char de 1 byte) para long (64 bits) para usar como índice
    movsbq  bias, %r9           # %r9 = (long)bias
    imulq   $8, %r9             # Multiplica por 8 bytes
    addq    %r8, %r9            # %r9 = Endereço exato de complement[bias]

    # Promove 'max' (short de 2 bytes) para long (64 bits) antes de gravar
    movswq  max, %r10           # %r10 = (long)max
    
    movq    %r10, (%r9)         # Escreve o valor promovido na memória do vetor

end_if:
    # ---------------- EPÍLOGO ----------------
    leave                       # Destrói a estrutura da pilha atual (restaura %rsp e %rbp)
    ret                         # Regressa a quem chamou a função