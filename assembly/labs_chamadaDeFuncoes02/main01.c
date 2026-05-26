#include <stdio.h>

int maximo(char x, char y);

char a = 97;
char b = 105;

int main()
{
   // Use um registrador para 'ret'
   int ret = maximo(a, b);

   if (ret == a)
     printf("'a' maior do que 'b'\n");
   else
     printf("Valor de 'b': %d\n", (int)b);

   return 0;
}

/*

Considere o programa a seguir, composto pelos arquivos “main01.c” e “max.c” abaixo.

Traduza apenas o arquivo "main01.c" para Assembly (arquivo “main01.S”) o mais literal possível.

Se necessário, use estes os registradores para valores temporários: %rax, %rcx, %rdx, %rdi, %rsi, %r8, %r9, %r10, %r11.

Utilize o template abaixo para construir o seu código. Comente o seu código!

Teste o seu programa, comparando a saída com a versão C.

*/