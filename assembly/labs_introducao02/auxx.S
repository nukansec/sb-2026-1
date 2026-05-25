.data

    # char str[] = "BEBAMUITOCAFE"
    .globl str
    .align 1
str: 
    # A diretiva .string já insere o '\0' (byte 0x00) automaticamente no final.
    .string "BEBAMUITOCAFE"

#-------------------------------------------------------------------------------

.text

.globl process
process:
    pushq   %rbp
    movq    %rsp, %rbp

    # Inicialização de 'ptr'.
    # O '$' pega o endereço de memória inicial da string e joga no registrador %r8.
    movq    $str, %r8

beginwhile:
    # cmpb (Compare Byte): Lê 1 byte do endereço apontado por %r8 e compara com 0.
    # É a tradução exata do "while (*ptr != '\0')"
    cmpb    $0, (%r8)
    je      endwhile            # Se for igual (Jump if Equal) a 0, sai do loop

    # --- Bloco do while ---

    # *ptr = *ptr + 32
    # Lemos apenas 1 byte (movb) para o registrador %al (parte baixa de %rax)
    movb    (%r8), %al
    addb    $32, %al            # Soma 32 para converter para minúscula
    movb    %al, (%r8)          # Escreve o byte modificado de volta na memória

    # ptr++
    # Como é um ponteiro de char, incrementamos (incq) o endereço em 1 byte.
    incq    %r8

    jmp     beginwhile          # Volta para o início do loop

endwhile:
    leave
    ret

# Compilar e Testar: $ gcc -no-pie -o process-asm main.c auxx.S