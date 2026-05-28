#  Struct Produto (Tamanho total: 24 bytes)
#  offset 0:  char mes  (1 byte) + (7 bytes de padding)
#  offset 8:  long preco (8 bytes)
#  offset 16: int ano   (4 bytes) + (4 bytes de padding)

.section .rodata
fmt:    .string "Diferença em %d/%d: %ld\n"

    .data
    # Reserva 48 bytes zerados para 'struct Produto prods[SIZE]' (2 * 24 = 48)
    .globl  prods
    .align  8
prods:  .zero   48

#-------------------------------------------------------------------------------

    .text

    .globl media
media:
    pushq %rbp
    movq %rsp, %rbp

    # =========================================
    # Proteção de Registradores (Callee-saved)
    # =========================================
    # O professor exigiu o uso de %r12d e %r13. Esses registradores pertencem ao grupo "preservado". Se formos usá-los, temos que salvar os valores originais na pilha para não quebrar a função main que nos chamou.
    subq    $16, %rsp
    movq    %r12, -8(%rbp)
    movq    %r13, -16(%rbp)

    # ==========================================
    # Inicializando variáveis locais
    # ==========================================
    # Parâmetros recebidos:
    # %rdi = ptr (endereço base do array de structs)
    # %rsi = size (long)

    movl    $0, %r12d       # int i = 0;    (Exigência: usar %r12d)
    movq    $0, %r13        # long soma = 0; (Exigência: usar %r13)

for01:
    # ==================================================
    # Lógica de Acesso à Struct: soma += ptr[i].preco;
    # ==================================================
    
    # 1. Calcular o endereço de ptr[i]
    # Fórmula: Endereço Base + (índice * tamanho_da_struct)
    movslq  %r12d, %rax     # %rax = (long)i
    imulq   $24, %rax       # %rax = i * 24 bytes
    addq    %rdi, %rax      # %rax = &ptr[i] (Soma com Endereço Base)

    # 2. Acessar o campo específico (preco) e somar
    # Como 'preco' mora no offset 8 da struct, lemos o endereço (%rax + 8).
    # A instrução '8(%rax)' lê diretamente 8 bytes à frente da base da struct.
    addq    8(%rax), %r13   # soma += ptr[i].preco

    # i++
    incl    %r12d
    jmp for01

endfor01:

    # ========================================================================
    # return soma / size;
    # ========================================================================
    # A divisão exige que o dividendo esteja em %rax.
    movq    %r13, %rax      # Coloca 'soma' em %rax
    
    # 'cqo' (ou 'cqto') estende o sinal de %rax para %rdx:%rax para a divisão.
    cqto                     
    
    # Divide %rdx:%rax pelo operando 'size' (%rsi).
    # O Quociente vai automaticamente para %rax (que já é o nosso retorno).
    idivq   %rsi            

    # ========================================================================
    # Restauração e Epílogo
    # ========================================================================
    # Devolvemos os valores intactos de %r12 e %r13 para a função main
    movq    -8(%rbp), %r12
    movq    -16(%rbp), %r13

    leave
    ret

# -------------------------------------------------------------------------------

.globl main
main:
    pushq   %rbp
    movq    %rsp, %rbp
    
    # Espaço para salvar variáveis locais 'i' (%r8) e 'm' (%r9) antes dos calls
    subq    $16, %rsp

    movl    $0, %r8d        # int i = 0; (Usando %r8d)

    # ==========================================================
    # Inicializando o array global de structs
    # ==========================================================
    movq    $prods, %r10

    movb    $1, (%r10)      # prods[0].mes = JAN
    movq    $100, 8(%r10)   # prods[0].preco = 100
    movl    $2020, 16(%r10) # prods[0].ano = 2020

    addq    $24, %r10       # Avança para o Próximo elemento (prods[1])
    
    movb    $2, (%r10)      # prods[1].mes = FEV
    movq    $120, 8(%r10)   # prods[1].preco = 120
    movl    $2020, 16(%r10) # prods[1].ano = 2020

    # ==========================================================
    # Chamada: m = media(prods, SIZE);
    # ==========================================================
    # Salva 'i' porque %r8 é destruído no call
    movq    %r8, -8(%rbp)   

    movq    $prods, %rdi    # 1º Param: ptr
    movq    $2, %rsi        # 2º Param: size = 2 (Usa movq porque é tipo long)
    call    media

    movq    %rax, %r9       # Salva o retorno em %r9 (m)
    movq    -8(%rbp), %r8   # Restaura 'i'

    # ==========================================================
    # Loop de impressão
    # ==========================================================

begin_while:
    cmpl    $2, %r8d        # if (i >= SIZE) sai do loop
    jge     end_while

    # Salva 'i' e 'm' antes do printf! (Ambos são Caller-saved)
    movq    %r8, -8(%rbp)   
    movq    %r9, -16(%rbp)

    # 4º Param: prods[i].preco - m (long -> %rcx)
    movq    8(%r11), %rcx   # Pega o preço
    subq    %r9, %rcx       # CORREÇÃO: Subtrai 'm' do preço

    # 3º Param: prods[i].ano (int -> %edx)
    movl    16(%r11), %edx  

    # 2º Param: (int)prods[i].mes (char estendido pra int -> %esi)
    movsbl  (%r11), %esi    

    # 1º Param: String de formatação
    movq    $fmt, %rdi

    movl    $0, %eax        # CORREÇÃO: Zerar o %eax antes de printf
    call    printf

    # Restaura 'i' e 'm'
    movq    -8(%rbp), %r8   
    movq    -16(%rbp), %r9  

    incl    %r8d            # i++
    jmp     begin_while

end_while:
    movl    $0, %eax        # return 0; (Em C, sucesso retorna 0, não 1)
    leave
    ret