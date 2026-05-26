.data

    # Diretivas de alinhamento são estritas de acordo com o tamanho do dado
    .globl  c
    .align  1
c:  .byte   67      # 1 byte

    .globl  s
    .align  2
s:  .short   23      # 2 bytes

    .globl  i
    .align  4
i:  .int   0       # 4 bytes

    .globl  j
    .align  4
j:  .int   0       # 4 bytes

    .globl  l
    .align  8
l:  .quad   1023    # 8 bytes

    .globl  ui
    .align  4
ui: .int   2047    # 4 bytes

    .globl  ul
    .align  8
ul: .quad   4095    # 8 bytes

#---------------------------------------------------------------------------------

.text

.globl atribuicoes
atribuicoes:
    pushq   %rbp
    movq    %rsp, %rbp

    # Escrita direta na memória de acordo com os tamanhos:
    movb    $93, c      # byte (8 bits)
    movw    $75, s      # word/short (16 bits)
    movl    $52, j      # long/int (32 bits)
    movq    $7265, l    # quad (64 bits)

    # i = j (Via registrador eax de 32 bits)
    movl    j, %eax
    movl    %eax, i

    leave
    ret

#---------------------------------------------------------------------------------

.globl cast
cast:
    pushq   %rbp
    movq    %rsp, %rbp

    # ui = i
    movl    i, %ecx
    movl    %ecx, ui

    # j = s (Extensão de sinal de Word para Long)
    # Copia 16 bits de 's', mantendo o sinal, para preencher 32 bits em %edx
    movswl  s, %edx
    movl    %edx, j

    # ul = ui
    # No x86-64, qualquer operação que escreve em um registrador de 32 bits (eax)
    # automaticamente zera a metade superior do registrador de 64 bits correspondente (rax).
    # Isso funciona como um "zero extend" automático e gratuito.
    movl    ui, %eax
    movq    %rax, ul

    # s = c + j
    movsbl  c, %r8d         # r8d = (int)c (Extensão com sinal de byte para long)
    addl    j, %r8d         # Soma 32 bits
    movw    %r8w, s         # Truncamento! Pega apenas os 16 bits baixos (%r8w) e salva em 's'

    leave
    ret

#---------------------------------------------------------------------------------

.globl expressoes
expressoes:
    pushq   %rbp
    movq    %rsp, %rbp

    # i = j * s;
    movswl  s, %edi         # edi = (int)s
    imull   j, %edi         # edi = edi * j
    movl    %edi, i

    # j = 1 + (s * 3);
    movswl  s, %esi         # esi = (int)s
    imull   $3, %esi
    addl    $1, %esi
    movl    %esi, j

    # ui = 2 * (i + s * 2);
    movswl  s, %eax         # eax = (int)s
    imull   $2, %eax
    addl    i, %eax
    imull   $2, %eax
    movl    %eax, ui

    # ul = (l + j * 3) - (s + 1024);
    movl    j, %edx
    imull   $3, %edx
    movslq  %edx, %rdx      # rdx = (long)edx (Extensão de sinal de int para quad!)
    addq    l, %rdx         # rdx = l + (j * 3)
    
    movswq  s, %rcx         # rcx = (long)s (Extensão direta de word para quad)
    addq    $1024, %rcx     # rcx = s + 1024
    subq    %rcx, %rdx      # rdx = rdx - rcx
    movq    %rdx, ul

    leave
    ret

#---------------------------------------------------------------------------------

.globl bitAbit
bitAbit:
    pushq   %rbp
    movq    %rsp, %rbp

    # c = c & 0x0F
    andb    $0x0F, c        # andb -> AND de 8 bits (byte)

    # s = s | 0x80
    orw     $0x80, s        # orw -> OR de 16 bits (word)

    # i = i ^ 0x55
    xorl    $0x55, i        # xorl -> XOR de 32 bits (long)

    # j = (j | s) ^ c
    movswl  s, %ecx         # ecx = (int)s
    orl     j, %ecx         # ecx = j | s
    movsbl  c, %r10d        # r10d = (int)c
    xorl    %r10d, %ecx     # ecx = ecx ^ c
    movl    %ecx, j

    # DICA DE CIBERSEGURANÇA (SHIFTS):
    # 'sar' (Shift Arithmetic Right): Preenche os novos bits à esquerda copiando o bit de sinal.
    # 'shr' (Shift Logical Right): Preenche os novos bits à esquerda apenas com zeros.

    # l = l >> 2; (l é COM sinal, então o compilador usa SAR para não quebrar números negativos)
    sarq    $2, l

    # ui = ui << 1;
    shll    $1, ui          # shl é Shift Left normal (Sempre entra zero pela direita)

    # ul = ul >> 4; (ul é SEM sinal, então o compilador usa SHR, preenchendo o topo com zeros)
    shrl    $4, ul

    leave
    ret

#---------------------------------------------------------------------------------

.globl ponteiros
ponteiros:
    pushq   %rbp
    movq    %rsp, %rbp

    # ptr = &s;
    # O endereço físico de 's' vai para o registrador %r11 de 64 bits.
    movq    $s, %r11

    # *ptr = 128;
    # Vai até o endereço guardado em %r11 e escreve a 'word' (16 bits) 128 lá.
    movw    $128, (%r11)

    leave
    ret

# Compilar e Testar: $ gcc -no-pie -o main-asm main.c auxx.S