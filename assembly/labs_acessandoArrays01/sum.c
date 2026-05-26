int s = 0;

// Um array de ints. Como cada int tem 4 bytes, 
// esse array ocupa um bloco contíguo de 16 bytes na memória.
int nums[4] = {65, -105, 111, 34};

void sum()
{
    int i = 0;
    
    while (i < 4) {
        // Para acessar nums[i], o computador não sabe o que é um array.
        // Ele precisa calcular: endereço_de_nums + (i * 4 bytes).
        s = s + nums[i];
        i++;
    }
}

/*

Traduza o arquivo sum.c abaixo para Assembly o mais literal possível.

Obs: Comente o seu código!

Se necessário, use estes os registradores para valores temporários: %rax, %rcx, %rdx, %rdi, %rsi, %r8, %r9, %r10, %r11. Não utilizar %rbx, %r12-%r15.

Compilar e Testar: $ gcc -no-pie -o sum main01.c sum.S

*/