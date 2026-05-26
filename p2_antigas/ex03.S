.section .rodata
fmt: .string "%d, %ld\n"

#------------------------------------------------
.data
    .globl values
    .align 4
values: .int 10, 20, 10, 40, 20, 50, 30, 10

#------------------------------------------------
.text
    .globl process
process:
    pushq   %rbp
    movq    %rsp, %rbp
    
    # Aloca 32 bytes na pilha para salvar os registradores "caller-saved"
    subq    $32, %rsp

    # int i = 7; (Usaremos %ecx para 'i')
    movl    $7, %ecx

begin_for:
    cmpl    $0, %ecx            # if (i < 0) -> end_for
    jl      end_for

    # ==========================================
    # Lendo values[i]
    # ==========================================
    movq    $values, %r8
    movslq  %ecx, %r9           # %r9 = (long)i
    imulq   $4, %r9             # Multiplica por 4 bytes (int)
    addq    %r8, %r9            # %r9 = &values[i]
    
    movl    (%r9), %r8d         # %r8d = values[i]

    # ==========================================
    # if (stamp > values[i])
    # ==========================================
    cmpl    %r8d, %edi          # Compara values[i] com stamp (%edi)
    jle     else_if             # Lógica Invertida: Se stamp <= values[i], vai pro else

    # --- Bloco do IF ---
    movq    %rsi, %r11          # %r11 = limit
    imulq   $2, %r11            # %r11 = (2 * limit)

    # 🚨 REGRA CRÍTICA: Salvar o estado antes do 'call' 
    movq    %rdi, -8(%rbp)      # Salva 'stamp'
    movq    %rsi, -16(%rbp)     # Salva 'limit' original
    movq    %rcx, -24(%rbp)     # Salva 'i'
    movq    %r11, -32(%rbp)     # Salva o cálculo (2 * limit)

    # --- Preparando paramêtros para call aux() ---
    
    # 1º Param (short size): É o 'i' convertido pra short (%cx -> %di)
    movw    %cx, %di            
    
    # 2º Param (int *slice): É o endereço de (values + i)
    movq    $values, %rsi       # %rsi = &values
    movslq  %ecx, %r10          # %r10 = (long)i
    imulq   $4, %r10            # vezes 4 bytes
    addq    %r10, %rsi          # %rsi = &values[i]
    
    call    aux

    # 🚨 RESTAURAÇÃO DE ESTADO APÓS O CALL
    movq    -8(%rbp), %rdi
    movq    -16(%rbp), %rsi
    movq    -24(%rbp), %rcx
    movq    -32(%rbp), %r11

    # Finalizando a conta: limit = (2*limit) + retorno_do_aux
    addq    %rax, %r11          # %r11 = (2 * limit) + %rax
    movq    %r11, %rsi          # Atualiza a variável 'limit' (%rsi)
    
    jmp     end_if

else_if:
    # --- Bloco do ELSE ---
    
    # Salvar o estado antes de chamar o printf!
    movq    %rdi, -8(%rbp)
    movq    %rsi, -16(%rbp)
    movq    %rcx, -24(%rbp)

    # Preparando parâmetros para o printf
    movq    %rsi, %rdx          # 3º Param: limit (%rdx)
    movl    %edi, %esi          # 2º Param: stamp (%esi)
    movq    $fmt, %rdi          # 1º Param: string de formato
    movl    $0, %eax            # 0 floats para printf
    
    call    printf

    # Restaurando o estado pós-printf
    movq    -8(%rbp), %rdi
    movq    -16(%rbp), %rsi
    movq    -24(%rbp), %rcx

end_if:
    # Atualiza o for (i--)
    decl    %ecx
    jmp     begin_for

end_for:
    # return limit;
    movq    %rsi, %rax          # Coloca 'limit' (%rsi) no %rax para retorno
    leave
    ret