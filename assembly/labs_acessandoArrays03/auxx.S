.data

    # short v1[4] = {32, 34, 27, 4}
    .globl  v1
    .align  2
v1: .short  32, 34, 27, 4

    # int   v2[5] = {12, 22, 31, 23, 6}
    .globl  v2
    .align  4
v2: .int    12, 22, 31, 23, 6

    # char  v3[4] = {0, 0, 0, 0}
    .globl  v3
    .align  1
v3: .byte   0, 0, 0, 0

    # long  v4[8] = {0, 0, 0, 0, 0, 0, 0, 0}
    .globl  v4
    .align  8
v4: .quad   0, 0, 0, 0, 0, 0, 0, 0

    # int i = 0
    .globl  i
    .align  4
i:  .int    0

    # short j = 0
    .globl  j
    .align  2
j:  .short  0

#-------------------------------------------------------------------------------

.text

.globl  aux
aux:
    pushq   %rbp
    movq    %rsp, %rbp

    # ==========================================
    # for (i = 0; i < 4; i++)
    # ==========================================
    movl    $0, i               # Inicializa variável global i = 0
for01:
    cmpl    $4, i               # if (i >= 4) -> endfor
    jge     endfor01

    # ==========================================
    # j = 0; while (j < 5)
    # ==========================================
    movw    $0, j               # Inicializa variável global j = 0
while01:
    cmpw    $5, j               # if (j >= 5) -> endwhile
    jge     endwhile01

    # ==========================================
    # if (i == j)
    # ==========================================
    movswl  j, %edx             # edx = (int)j (Extensão de sinal de short para int)
    cmpl    %edx, i             # if (i != (int)j) -> elseif
    jne     elseif01

    # --- Bloco IF: v3[i] = v1[i] + v2[j] ---
    
    # Lendo v1[i] (short -> int)
    movq    $v1, %r8            
    movslq  i, %r9              
    imulq   $2, %r9             # 2 bytes por short
    addq    %r8, %r9            # r9 = &v1[i]
    movswl  (%r9), %edi         # edi = (int)v1[i]

    # Lendo v2[j] (int)
    movq    $v2, %r8            
    movswq  j, %r9              # r9 = (long)j
    imulq   $4, %r9             # 4 bytes por int
    addq    %r8, %r9            # r9 = &v2[j]
    movl    (%r9), %esi         # esi = v2[j]

    # Somando os dois (resultado em edi)
    addl    %esi, %edi          # edi = (int)v1[i] + v2[j]

    # Gravando em v3[i] (char)
    movq    $v3, %r8            
    movslq  i, %r9              
    # imulq $1, %r9             (Deslocamento de 1 byte pode ser omitido)
    addq    %r8, %r9            # r9 = &v3[i]
    
    # Pega apenas os 8 bits finais (%dil) do registrador %edi e grava na memória
    movb    %dil, (%r9)         # v3[i] = (char)resultado

    jmp     endif01

elseif01:
    # --- Bloco ELSE: v4[i + j] += v1[i] + v2[j] ---
    
    # Lendo v1[i]
    movq    $v1, %r8            
    movslq  i, %r9              
    imulq   $2, %r9             
    addq    %r8, %r9            
    movswl  (%r9), %edi         # edi = (int)v1[i]

    # Lendo v2[j]
    movq    $v2, %r8            
    movswq  j, %r9              
    imulq   $4, %r9             
    addq    %r8, %r9            
    movl    (%r9), %esi         # esi = v2[j]

    # Somando v1[i] + v2[j]
    addl    %esi, %edi          # edi = soma (32 bits)

    # Calculando o índice complexo: (i + j)
    movswl  j, %r10d            # r10d = (int)j
    addl    i, %r10d            # r10d = (int)j + i

    # Calculando endereço de v4[i + j]
    movq    $v4, %r8            
    movslq  %r10d, %r9          # r9 = (long)(i + j)
    imulq   $8, %r9             # 8 bytes por long
    addq    %r8, %r9            # r9 = &v4[i+j]

    # Somando o resultado antigo da memória com o novo cálculo
    movslq  %edi, %rdi          # rdi = (long)soma_dos_vetores
    addq    (%r9), %rdi         # rdi = v4[i+j] + soma_dos_vetores

    # Gravando de volta
    movq    %rdi, (%r9)         # v4[i+j] = rdi

endif01:
    # j++
    incw    j
    jmp     while01

endwhile01:
    # i++
    incl    i
    jmp     for01

endfor01:
    leave
    ret

# Compilar e Testar: $ gcc -no-pie -o auxx-asm main.c auxx.S