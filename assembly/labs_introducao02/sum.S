.section .rodata

# Formatação do printf. O '\n' no final já fica embutido.
fmt: .string "Soma: %ld\n"

#-------------------------------------------------------------------------------

.data

    # long sum = 0;
    .globl sum
    .align 8
sum: 
    .quad 0

    # long vet[5] = {10, 20, 30, 40, 50};
    .globl vet
    .align 8
vet: 
    .quad 10, 20, 30, 40, 50    # Aloca 5 blocos consecutivos de 8 bytes

#-------------------------------------------------------------------------------

.text

.globl main
main:
    pushq   %rbp
    movq    %rsp, %rbp

    # Inicializações
    movl    $0, %ecx            # int i = 0 (usamos %ecx, 32 bits, para o 'int')
    movq    $vet, %r8           # long *ptr = vet (usamos %r8, 64 bits, para o endereço)

beginwhile:
    # cmpl (Compare Long): Compara 'i' com 5
    cmpl    $5, %ecx
    jge     endwhile            # Se 'i' >= 5 (Jump if Greater or Equal), sai do loop

    # --- Bloco do while ---

    # sum = sum + *ptr
    movq    (%r8), %rdx         # Desreferencia o ponteiro: lê 8 bytes no rdx
    addq    %rdx, sum           # Soma rdx diretamente na variável global 'sum' na memória

    # ptr++ (A MÁGICA DA ARITMÉTICA DE PONTEIROS AQUI)
    # Veja que não é um 'incq'. O assembly exige que você diga exatamente 
    # o tamanho do salto na memória. Como o array é de 'longs', pulamos 8 bytes.
    addq    $8, %r8

    # i++
    # 'i' é apenas um contador normal, então usamos um incremento simples de 1.
    incl    %ecx

    jmp     beginwhile

endwhile:

    # Preparação para chamar a função printf da libc do C (Convenção x86-64):
    # 1º argumento vai no %rdi (O endereço da string de formatação)
    # 2º argumento vai no %rsi (O valor da variável sum)
    movq    $fmt, %rdi    
    movq    sum, %rsi
    
    # %eax deve ser zerado antes de chamar funções variádicas (como printf)
    # para avisar que não estamos passando parâmetros de ponto flutuante.
    movl    $0, %eax      
    call    printf

    # return 0;
    movl    $0, %eax      
    leave
    ret

# Compilar e Testar: $ gcc -no-pie -o sum sum.S