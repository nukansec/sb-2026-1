.data

    # O compilador alinha as variáveis na memória para otimizar a leitura do processador.
    # Variáveis menores ganham alinhamentos menores.
    .globl  c
    .align  1
c:  .byte   -20     # 1 byte

    .globl  i
    .align  4
i:  .int    -256    # 4 bytes

    .globl  j
    .align  4
j:  .int    512     # 4 bytes

    .globl  l
    .align  8
l:  .quad   128     # 8 bytes

    .globl  us
    .align  2
us: .short  111     # 2 bytes

    .globl  ui
    .align  4
ui: .int    1024    # 4 bytes

    .globl  ul
    .align  8
ul: .quad   2048    # 8 bytes

#-------------------------------------------------------------------------------

.text

.globl aux
aux:
    # Prólogo da função: salva o base pointer antigo e cria o novo frame da pilha
    pushq   %rbp
    movq    %rsp, %rbp

    # ==========================================
    # Atribuições simples
    # ==========================================
    movl    $68000, j           # O '$' indica valor imediato (constante)
    movq    $4096, l

    # A arquitetura x86 não permite copiar direto de Memória para Memória.
    # Por isso, usamos o registrador %eax como "ponte".
    movl    j, %eax
    movl    %eax, i

    # ==========================================
    # Expressões
    # ==========================================
    # j = 10 + i - 5
    movl    $10, %ecx           # ecx = 10
    addl    i, %ecx             # ecx = 10 + i
    subl    $5, %ecx            # ecx = 10 + i - 5
    movl    %ecx, j             # j = ecx

    # i = (i * 2) - (j + 5)
    movl    i, %edx             # edx = i
    imull   $2, %edx            # edx = i * 2 (imull é multiplicação com sinal)
    movl    j, %edi             # edi = j
    addl    $5, %edi            # edi = j + 5
    subl    %edi, %edx          # edx = edx - edi
    movl    %edx, i

    # ==========================================
    # Casts
    # ==========================================
    
    # ui = i (mesmo tamanho, 32 bits, apenas copia)
    movl    i, %esi
    movl    %esi, ui

    # j = c (extensão com sinal de 8 para 32 bits)
    # movsbl = MOVe Sign-extension Byte to Long
    # Se 'c' for negativo, ele preenche o resto de %eax com '1's.
    movsbl  c, %eax
    movl    %eax, j

    # ul = ui (extensão sem sinal de 32 para 64 bits)
    # Ao mover para um registrador de 32 bits (edx), o x86-64 automaticamente
    # zera a parte alta do registrador de 64 bits (rdx). Depois gravamos o rdx inteiro.
    movl    ui, %edx
    movq    %rdx, ul

    # us = ul (truncamento de 64 para 16 bits)
    # Lemos os 64 bits de 'ul' para %rax.
    # Em seguida, gravamos APENAS os 16 bits mais baixos (%ax) na variável 'us'.
    movq    ul, %rax
    movw    %ax, us

    # c = i + j (truncamento da soma)
    movl    i, %ecx
    addl    j, %ecx             # A soma é feita em 32 bits no %ecx
    movb    %cl, c              # Gravamos APENAS os 8 bits finais (%cl) na memória

    # ==========================================
    # Ponteiros
    # ==========================================
    
    # ptr = &l
    # O '$' na frente de uma variável em Assembly pega o ENDEREÇO dela, não o valor.
    movq    $l, %r10            # r10 agora guarda a posição de memória de 'l'

    # *ptr = 128
    # Os parênteses () significam "vá até o endereço guardado neste registrador".
    movq    $128, (%r10)        # Escreve 128 na memória apontada por r10

    # iptr = &i
    movq    $i, %rdx            # rdx guarda a posição de memória de 'i'

    # j = j + *iptr
    movl    j, %eax             # eax = j
    addl    (%rdx), %eax        # Soma o valor apontado por rdx com o eax
    movl    %eax, j

    # Epílogo da função: destrói o frame da pilha e retorna
    leave
    ret