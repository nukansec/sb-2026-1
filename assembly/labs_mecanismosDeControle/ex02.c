int  a = 0;
long b = 2;

void ex02()
{
    // Em C, qualquer valor diferente de zero é considerado 'verdadeiro'
    if (a) {
        if (b < 5) {
            b = (a << 1) + (a * b);
        }
        else {
            a = b ^ 0x1FL;
        }
    }
}

/*

Traduza apenas o arquivo ex02.c abaixo para Assembly o mais literal possível.

Se necessário, use estes os registradores para valores temporários: %rax, %rcx, %rdx, %rdi, %rsi, %r8, %r9, %r10, %r11.

Altere os valores de 'a' e 'b' no arquivo ex02.c para testar os 'ifs'.

*Utilize o template do exercício 1. Lembre-se de modificar o nome da função de ex01 para ex02 ao copiar o template.

Compile e Teste:  gcc -no-pie -o ex02 main02.c ex02.S

*/