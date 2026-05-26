.data

    # int s = 0;
    .globl  s
    .align  4
s:  .int    0

    # int nums[4] = {65, -105, 111, 34};
    .globl  nums
    .align  4
nums: .int  65, -105, 111, 34

#-------------------------------------------------------------------------------

.text

.globl sum
sum:
    pushq   %rbp
    movq    %rsp, %rbp

    # int i = 0;
    movl    $0, %ecx

loop_while:
    cmpl    $4, %ecx            # if(i >= 4) -> end_while
    jge     end_while

    # =========================================================
    # Cálculo manual do Offset do Array: &nums[i]
    # =========================================================
    
    movq    $nums, %rdx         # rdx recebe o Endereço Base do array
    movslq  %ecx, %r8           # r8 = (long)i -> Prepara o índice para cálculo em 64 bits
    
    imulq   $4, %r8             # r8 = i * sizeof(int). Calcula o deslocamento em bytes.
    addq    %rdx, %r8           # r8 = Endereço Base + Deslocamento (&nums[i])

    # =========================================================

    # Desreferencia o ponteiro calculado para ler o valor contido nele
    movl    (%r8), %eax         # eax = nums[i]
    addl    %eax, s             # s = s + eax

    incl    %ecx                # i++

    jmp     loop_while

end_while:
    leave
    ret

# Compilar e Testar: $ gcc -no-pie -o sum main01.c sum.S