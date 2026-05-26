.data

    .globl  vet
    .align  2
vet: .short 50, 10, 67, 42

    .globl  max
    .align  2
max: .short 0

#-------------------------------------------------------------------------------

.text

.globl  ex01
ex01:
    pushq   %rbp
    movq    %rsp, %rbp

    # char i
    # i -> %cl (registrador de 8 bits)

    # for (i = 0; i < 4; i++)
    movb    $0, %cl             # i = 0
for01:
    cmpb    $4, %cl             # _if (i >= 4) -> endfor
    jge     endfor01

    # ==========================================
    # Acesso a vet[i]
    # ==========================================
    movq    $vet, %r8           # r8 = Endereço Base do vetor
    
    # MOVSBQ: Move Sign-extended Byte to Quad. 
    # Converte o char 'i' para um long de 64 bits para ser usado na matemática de ponteiros.
    movsbq  %cl, %r9            # r9 = (long)i
    
    imulq   $2, %r9             # Multiplica por 2 porque é um vetor de shorts (2 bytes)
    addq    %r8, %r9            # r9 = Endereço exato de vet[i]

    movw    (%r9), %dx          # dx = vet[i]

    # ==========================================
    # if (vet[i] > max)
    # ==========================================
    cmpw    max, %dx            # _if (vet[i] <= max) -> endif
    jle     endif01

    # max = vet[i]
    movw    %dx, max

endif01:
    incb    %cl                 # i++
    jmp     for01

endfor01:
    leave
    ret