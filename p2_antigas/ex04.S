.section .rodata
fmt: .string "i = %d, sum = %d\n"

#------------------------------------------------
.data
    .globl max
    .align 4
max: .int 256

    .globl lim
    .align 2
lim: .short -3

    .globl timer
    .align 1
timer: .byte 100

    .globl vet1
    .align 8
vet1: .quad 1, 0, 2, 3, 4

    .globl vet2
    .align 4
vet2: .int 0, 0, 0, 0, 0

#------------------------------------------------
.text

.globl modify
modify:
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $32, %rsp
    
    # Parâmetros recebidos:
    # %rdi = int *v1
    # %rsi = long *v2
    # %dl  = char value

begin_while01:
    # 🚨 Salva os parâmetros atuais na pilha
    movq    %rdi, -8(%rbp)
    movq    %rsi, -16(%rbp)
    movq    %rdx, -24(%rbp)
    movq    %rcx, -32(%rbp)     # 'index'

    # --- Chamada de calc(v2, v1) ---
    # Trocando os parâmetros de ordem! v2 vai pro 1º e v1 pro 2º.
    movq    %rdi, %r8           # r8 temporário para v1
    movq    %rsi, %rdi          # 1º Param: v2 (%rsi -> %rdi)
    movq    %r8, %rsi           # 2º Param: v1 (%r8 -> %rsi)
    
    call    calc
    
    # Restaura os registradores
    movq    -8(%rbp), %rdi
    movq    -16(%rbp), %rsi
    movq    -24(%rbp), %rdx
    movq    -32(%rbp), %rcx

    # if (value <= calc(v2, v1)) break
    cmpl    %al, %dl            # %dl tem 'value', %al tem o retorno do 'calc'
    jle     end_while01

    # --- Chamada de complex(max, lim, v1) ---
    # Salva de novo!
    movq    %rdi, -8(%rbp)
    movq    %rsi, -16(%rbp)
    movq    %rdx, -24(%rbp)
    movq    %rcx, -32(%rbp)
    
    movq    %rdi, %rdx          # 3º Param: int *v1 (%rdi -> %rdx)
    movl    max, %edi           # 1º Param: int max
    movw    lim, %si            # 2º Param: short lim
    
    call    complex
    
    # Restaura tudo novamente
    movq    -8(%rbp), %rdi
    movq    -16(%rbp), %rsi
    movq    -24(%rbp), %rdx
    movq    -32(%rbp), %rcx
    
    # index = retorno da função
    movq    %rax, %rcx          # Atualiza 'index' (%rcx)
    jmp     begin_while01

end_while01:

    # ==========================================
    # v1[ v2[index] ] = (int)value;
    # ==========================================
    
    # 1. Resolve a parte interna: v2[index]
    # v2 é um vetor de 'long', então multiplica o índice por 8
    movq    %rcx, %r8           # %r8 = index
    imulq   $8, %r8             # %r8 = index * 8
    addq    %rsi, %r8           # %r8 = &v2[index]
    
    movq    (%r8), %r9          # LÊ O VALOR: %r9 = v2[index]

    # 2. Resolve a parte externa: v1[ %r9 ]
    # v1 é vetor de 'int', então multiplica por 4
    imulq   $4, %r9             # %r9 = v2[index] * 4
    addq    %rdi, %r9           # %r9 = &v1[ v2[index] ]

    # 3. Faz o cast do 'value' (char -> int) e grava
    movsbl  %dl, %r8d           # Extensão de sinal de char pra int
    movl    %r8d, (%r9)         # Grava na memória

    leave
    ret

#------------------------------------------------

.globl basic
basic:
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $32, %rsp

    # int sum está em %edi
    
    # long *ptr = vet1;
    movq    $vet1, %rcx         # rcx = ptr

begin_while02:
    # while (sum < timer)
    movsbl  timer, %r9d         # Estica timer para int
    cmpl    %r9d, %edi          # Compara sum com timer
    jge     end_while02

    # if (sum == 13) break;
    cmpl    $13, %edi
    je      end_while02

    # ==========================================
    # for (int i = 0; i < 10; i++, sum++)
    # ==========================================
    movl    $0, %r8d            # %r8d = i = 0
begin_for02:
    cmpl    $10, %r8d
    jge     end_for02

    # Salva estado antes do printf
    movq    %rdi, -8(%rbp)      # sum
    movq    %rcx, -16(%rbp)     # ptr
    movq    %r8, -24(%rbp)      # i

    # printf("i = %d, sum = %d\n", i, sum)
    movl    %edi, %edx          # 3º Param: sum
    movl    %r8d, %esi          # 2º Param: i (CORREÇÃO DE BUG DO ORIGINAL)
    movq    $fmt, %rdi          # 1º Param: formato
    movl    $0, %eax
    
    call    printf

    # Restaura
    movq    -8(%rbp), %rdi
    movq    -16(%rbp), %rcx
    movq    -24(%rbp), %r8

    # Atualiza o for (i++, sum++)
    incl    %r8d
    incl    %edi
    jmp     begin_for02

end_for02:

    # --- Chamada de modify(vet2, ptr, timer) ---
    movq    %rdi, -8(%rbp)      # Salva 'sum'
    movq    %rcx, -16(%rbp)     # Salva 'ptr'
    
    movq    $vet2, %rdi         # 1º Param: int *v1
    movq    %rcx, %rsi          # 2º Param: ptr (long *v2)
    movb    timer, %cl          # 3º Param: char timer
    
    call    modify

    movq    -8(%rbp), %rdi      # Restaura 'sum'
    movq    -16(%rbp), %rcx     # Restaura 'ptr'

    # ptr++ (Aritmética: avança 8 bytes pois é ponteiro pra long)
    addq    $8, %rcx

    jmp     begin_while02

end_while02:
    leave
    ret