#include <stdio.h>

int sum(const char *prefix, int v1, short v2, int *s)
{
   *s = v1 + v2;
   printf("%s: %d\n", prefix, *s);
   return v1 * v2;
}

void show(long err, int val, int r)
{
   printf("err = %ld, val = %d, r = %d\n", err, val, r);
}

/*

Considere o programa a seguir, composto pelos arquivos “main.c” e “sum.c”. Traduza apenas o arquivo "main.c" para Assembly (arquivo “main.S”) o mais literal possível.

Se necessário, use estes registradores para valores temporários: %rax, %rcx, %rdx, %rdi, %rsi, %r8, %r9, %r10, %r11. Não utilize %rbx, %r12, %r13, %r14, %r15 ainda.

Utilize o modelo abaixo para construir o seu código. Comente o seu código e note que "return 0" não está traduzido.

Teste o seu programa, comparando a saída com a versão C.

*/