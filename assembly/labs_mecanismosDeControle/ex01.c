int a = 30;
int b = 45;
int c = -60;
int d = 25;

void ex01()
{
    if (a > b) {
        c = -c;
        d = c * 3;
    }

    if (b >= a) {
        c = (a + b) * c;
        d = 1024;
    }
}

/*

Traduza apenas o arquivo ex01.c abaixo para Assembly o mais literal possível.

Se necessário, use estes os registradores para valores temporários: %rax, %rcx, %rdx, %rdi, %rsi, %r8, %r9, %r10, %r11.

Altere os valores de 'a' e 'b' em ex01.c para testar a execução dos 'ifs'.

*Utilize o template abaixo para construir o seu código de ex01.c.

Compile e Teste:  gcc -no-pie -o ex01 main01.c ex01.S

*/