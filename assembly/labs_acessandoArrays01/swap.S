.data

    # long last = 0;
    .globl  last
    .align  8
last: .quad 0

    # long values[5] = {50,-10,60,-20,70};
    .globl  values
    .align  8
values: .quad 50, -10, 60, -20, 70

#-------------------------------------------------------------------------------

.text

.globl swap
swap:
    pushq   %rbp
    movq    %rsp, %rbp

    # Mapeamento de Registadores para Variáveis Locais:
    # i -> %ecx (int, 32 bits)
    # j -> %edx (int, 32 bits)

    # int j = 4;
    movl    $4, %edx

    # for (i = 0; i < j; i++, j--)
    movl    $0, %ecx            # i = 0

loop_for:
    cmpl    %edx, %ecx          # Compara 'i' com 'j'
    jge     end_for             # Se i >= j (Lógica Invertida), encerra o ciclo

    # ---------------------------------------------------------
    # PARTE 1: long tmp = values[i]
    # ---------------------------------------------------------
    movq    $values, %rdi       # %rdi = Endereço Base de values
    movslq  %ecx, %rsi          # %rsi = (long)i (Extensão de sinal do índice)
    imulq   $8, %rsi            # %rsi = i * 8 (Cada long ocupa 8 bytes)
    addq    %rdi, %rsi          # %rsi = &values[i] (Endereço Base + Deslocamento)

    movq    (%rsi), %r8         # %r8 = tmp = values[i] (Desreferencia o endereço)

    # ---------------------------------------------------------
    # PARTE 2: values[i] = values[j]
    # ---------------------------------------------------------
    movq    $values, %r9        # %r9 = Endereço Base de values
    movslq  %edx, %r10          # %r10 = (long)j (Extensão de sinal do índice)
    imulq   $8, %r10            # %r10 = j * 8
    addq    %r9, %r10           # %r10 = &values[j]

    movq    (%r10), %r11        # %r11 = values[j]
    movq    %r11, (%rsi)        # Escrita: values[i] = values[j]

    # ---------------------------------------------------------
    # PARTE 3: values[j] = tmp
    # ---------------------------------------------------------
    # Reutiliza o endereço de &values[j] que já foi calculado e guardado em %r10
    movq    %r8, (%r10)         # Escrita: values[j] = tmp (%r8)

    # ---------------------------------------------------------
    # Atualização do ciclo (for update)
    # ---------------------------------------------------------
    incl    %ecx                # i++
    decl    %edx                # j--

    jmp     loop_for

end_for:

    # ---------------------------------------------------------
    # last = values[4];
    # ---------------------------------------------------------
    movq    $values, %rdi       # %rdi = Endereço Base de values
    
    # DICA DE ARQUITETURA (Endereçamento por Deslocamento):
    # Em vez de fazer a multiplicação manual para achar a posição 4,
    # usamos o deslocamento direto no ponteiro: 32(%rdi).
    # Como 4 * 8 bytes = 32, a instrução lê diretamente 32 bytes à frente de %rdi.
    movq    32(%rdi), %rax      # %rax = values[4]
    movq    %rax, last          # last = %rax

    leave
    ret