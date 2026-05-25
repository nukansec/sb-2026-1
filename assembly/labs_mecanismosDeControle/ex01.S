.data

    .globl  a
    .align  4
a:  .int    30

    .globl  b
    .align  4
b:  .int    45

    .globl  c
    .align  4
c:  .int    -60

    .globl  d
    .align  4
d:  .int    25

#-------------------------------------------------------------------------------

.text

.globl ex01
ex01:
    pushq   %rbp
    movq    %rsp, %rbp

    # ==========================================
    # if (a > b)
    # ==========================================
    movl    a, %eax             # eax = a
    
    # Compara 'b' com 'eax' (a). 
    # Em AT&T, a leitura da comparação é invertida: compara o 2º operando em relação ao 1º.
    cmpl    b, %eax             
    
    # Lógica invertida: Se 'a' for Menor ou Igual a 'b' (Jump if Less or Equal), pula o IF.
    jle     end_if1

    # --- Bloco do IF ---
    movl    c, %eax             
    negl    %eax                # eax = -eax (inverte o sinal)
    movl    %eax, c             

    movl    c, %r9d             
    imull   $3, %r9d            # r9d = r9d * 3
    movl    %r9d, d             

end_if1:

    # ==========================================
    # if (b >= a)
    # ==========================================
    movl    b, %eax             # eax = b
    cmpl    a, %eax             
    
    # Lógica invertida: Se 'b' for estritamente Menor que 'a' (Jump if Less), pula o IF.
    jl      end_if2

    # --- Bloco do IF ---
    movl    a, %eax             
    addl    b, %eax             # eax = a + b
    imull   c, %eax             # eax = (a + b) * c
    movl    %eax, c             

    movl    $1024, d            

end_if2:

    leave
    ret