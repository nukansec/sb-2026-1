.data

    .globl  size
    .align  4
size:   .int    5

    .globl  a
    .align  2
a:      .short  5,1,7,2,9

    .globl  b
    .align  4
b:      .int    6,3,8,4,2

    .globl  nums
    .align  8
nums:   .quad   0,0,0,0,0

    .globl  factor
    .align  2
factor: .short  100

#-------------------------------------------------------------------------------

.text

.globl  ex03
ex03:
    pushq   %rbp
    movq    %rsp, %rbp

    # int i = 0;
    movl    $0, %ecx

    # short *ptr = a;
    movq    $a, %rdx

while01:
    cmpl    size, %ecx          # _if (i >= size) -> endwhile
    jge     endwhile01

    # ==========================================
    # Avaliação do IF: a[i] > 6
    # ==========================================
    movq    $a, %r8             # r8 = &a
    movslq  %ecx, %r9           # r9 = (long)i
    imulq   $2, %r9             # Multiplica tamanho do short
    addq    %r8, %r9            # r9 = &a[i]

    movw    (%r9), %di          # di = a[i]
    cmpw    $6, %di             # _if (a[i] <= 6) -> elseif
    jle     elseif01

    # ==========================================
    # nums[i] = b[0] + factor;
    # ==========================================
    # C cast steps:
    # 1. Lê b[0] (int)
    # 2. Converte 'factor' (short) para int
    # 3. Soma os dois (resultado int)
    # 4. Converte o resultado int para long para guardar em nums[i]
    
    movq    $b, %r8             
    movl    (%r8), %r10d        # r10d = b[0]

    movswl  factor, %r11d       # r11d = (int)factor (Promoção)
    addl    %r10d, %r11d        # r11d = b[0] + factor

    # Calcula endereço de nums[i]
    movq    $nums, %r8          
    movslq  %ecx, %r9           
    imulq   $8, %r9             # 8 bytes por long
    addq    %r8, %r9            # r9 = &nums[i]

    # Converte o resultado da soma para long e salva
    movslq  %r11d, %r11         # r11 = (long)r11d
    movq    %r11, (%r9)         # nums[i] = resultado

    jmp     endif01

elseif01:
    # ==========================================
    # nums[i] = *ptr * b[i];
    # ==========================================
    movw    (%rdx), %si         # si = *ptr
    movswl  %si, %esi           # Promoção de short para int

    # Pega b[i]
    movq    $b, %r8             
    movslq  %ecx, %r9           
    imulq   $4, %r9             # 4 bytes por int
    addq    %r8, %r9            # r9 = &b[i]
    movl    (%r9), %edi         # edi = b[i]

    imull   %esi, %edi          # edi = (int)*ptr * b[i]

    # Guarda em nums[i]
    movq    $nums, %r8          
    movslq  %ecx, %r9           
    imulq   $8, %r9             
    addq    %r8, %r9            # r9 = &nums[i]

    movslq  %edi, %rdi          # Cast final de int para long
    movq    %rdi, (%r9)         

endif01:
    # i++
    incl    %ecx

    # ptr++ (Aritmética de ponteiro: pula 2 bytes do short)
    addq    $2, %rdx

    jmp     while01

endwhile01:
    leave
    ret