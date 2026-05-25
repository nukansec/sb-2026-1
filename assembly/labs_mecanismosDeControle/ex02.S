.data

    .globl  a
    .align  4
a:  .int    0

    .globl  b
    .align  8
b:  .quad   2

#-------------------------------------------------------------------------------

.text

.globl ex02
ex02:
    pushq   %rbp
    movq    %rsp, %rbp

    # ==========================================
    # if (a)  --> Equivale a if (a != 0)
    # ==========================================
    cmpl    $0, a               
    
    # Lógica invertida: Se 'a' for Igual a 0 (Jump if Equal), pula todo o bloco externo.
    je      end_if1

    # ==========================================
    # if (b < 5)
    # ==========================================
    # CORREÇÃO: Como 'b' é quad (long, 8 bytes), a comparação deve ser cmpq, não cmpl.
    cmpq    $5, b               
    
    # Lógica invertida: Se 'b' for Maior ou Igual a 5 (Jump if Greater or Equal), pula para o ELSE.
    jge     else_if2

    # --- Bloco do IF interno ---
    movl    a, %eax             
    shll    $1, %eax            # eax = a << 1

    movslq  a, %rcx             # rcx = (long)a (Extensão de sinal)
    imulq   b, %rcx             # rcx = rcx * b

    movslq  %eax, %rax          # rax = (long)(a << 1)
    addq    %rcx, %rax          # rax = (a << 1) + (a * b)
    movq    %rax, b             

    # CRÍTICO: Após executar o bloco do IF, devemos pular o bloco ELSE incondicionalmente.
    jmp     end_if2

    # ==========================================
    # else do if interno
    # ==========================================
else_if2:                       # CORREÇÃO: O label estava escrito 'else_if:'
    movq    b, %rax             

    # O compilador aceita 'xorq $0x1F, %rax' diretamente, o que poupa o uso de 
    # registradores intermediários e da instrução movabs, mas a sua lógica funciona perfeitamente!
    movabs  $0x1F, %rcx         
    xorq    %rcx, %rax          # rax = b ^ 0x1FL

    # Pega apenas os 32 bits mais baixos (%eax) do resultado e joga na variável int 'a'
    movl    %eax, a             

end_if2:

end_if1:

    leave
    ret