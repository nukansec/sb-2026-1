#include <stdio.h>

long filtro(unsigned char v, short l, long b) 
{
    long r;
    unsigned short x = (unsigned short)v;
    unsigned short y = (unsigned short)l;

    if (x < y)
        r = 0;
    else
        r = (long)l;

    printf("v = %u, l = %d, b = %ld, r = %ld\n", (unsigned int)v, (int)l, b, r);

    return r;
}

/*

Considere o programa a seguir, composto pelos arquivos “main.c” e “filtro.c”. Traduza apenas o arquivo "main.c" para Assembly (arquivo “main.S”) o mais literal possível. 

Se necessário, use estes os registradores para valores temporários: %rax, %rcx, %rdx, %rdi, %rsi, %r8, %r9, %r10, %r11. Não utilize %rbx, %r12, %r13, %r14, %r15 ainda.

Utilize o modelo abaixo para construir o seu código. Comente o seu código e note que "return 0" não está traduzido.

Importante: a função printf() pode mudar os valores de alguns registradores, ou seja, não confie que depois do printf() os registradores manterão os valores que você colocou antes de chamar a função (veremos isso nas próximas aulas).

*/