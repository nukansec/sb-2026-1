long last = 0;

// Vetor de inteiros de 64 bits (long).
// Cada elemento ocupa 8 bytes, totalizando 40 bytes contíguos na memória.
long values[5] = {50, -10, 60, -20, 70};

void swap()
{
    int i;
    int j = 4;

    // Loop com dois contadores simultâneos que convergem para o centro
    for (i = 0; i < j; i++, j--)
    {
        // Troca clássica de valores usando uma variável temporária (tmp)
        long tmp = values[i];
        values[i] = values[j];
        values[j] = tmp;
    }

    // Armazena o valor do último elemento na variável global
    last = values[4];
}

/*

Traduza o arquivo swap.c abaixo para Assembly o mais literal possível.

Obs: Comente o seu código!

Se necessário, use estes os registradores para valores temporários: %rax, %rcx, %rdx, %rdi, %rsi, %r8, %r9, %r10, %r11. Não utilizar %rbx, %r12-%r15.

*/