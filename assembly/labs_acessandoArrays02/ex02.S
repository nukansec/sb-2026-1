.data

    .globl  letters
    .align  1
letters: .string "abcdefghij"

    .globl  even
    .align  4
even:   .int 0

    .globl  odd
    .align  4
odd:    .int 0

#-------------------------------------------------------------------------------

.text

.globl  ex02
ex02:
    pushq   %rbp
    movq    %rsp, %rbp

    # unsigned int count = 0
    movl    $0, %ecx

while01:
    # ==========================================
    # while (letters[count] != 0)
    # ==========================================
    movq    $letters, %r8       # r8 = &letters
    
    # O x86-64 tem uma peculiaridade: qualquer gravação em registrador de 32 bits (r9d) 
    # zera a parte alta do registrador de 64 bits (r9). Isso funciona como um cast automático para unsigned.
    movl    %ecx, %r9d          # r9 = (unsigned long)count
    
    # imulq $1, %r9 (Omitido pois multiplicar por 1 byte de char é redundante)
    addq    %r8, %r9            # r9 = &letters[count]

    movb    (%r9), %dl          # dl = letters[count]

    cmpb    $0, %dl             # _if (dl == 0) -> endwhile
    je      endwhile01

    # ==========================================
    # letters[count++] & 1
    # ==========================================
    # A avaliação do IF: pega o valor atual e faz um AND bit a bit com 1
    andb    $1, %dl

    # Agora executa o "++" do count (pós-incremento) imediatamente antes de desviar o fluxo
    incl    %ecx                # count++

    cmpb    $0, %dl             # _if ((letters[antigo_count] & 1) == 0) -> elseif
    je      elseif01

    # odd++
    incl    odd
    jmp     endif01

elseif01:
    # even++
    incl    even

endif01:
    jmp     while01

endwhile01:
    leave
    ret