#include <stdio.h>

void show(int *vet, long size);
void process(int x, short v, int *pos);

int   i = 0;
short v = 0;
short vetA[5] = {28,42,16,23,47};
int   vetB[5] = {0,0,0,0,0};

int main()
{
  while (i < 5) {
    v = vetA[i] << 2;
    printf("Iteração %d, v = %d\n", i, (int)v);
    
    // Passagem de Parâmetros Mistos: valor, valor e referência (endereço)
    process(i, v, &vetB[i]);
    i++;
  }
  show(vetB, 5);
  return 0;
}

/*

Considere o programa a seguir, composto pelos arquivos “main02.c” e “proc.c” abaixo.

Traduza apenas o arquivo "main02.c" para Assembly (arquivo “main02.S”) o mais literal possível. 

Se necessário, use estes os registradores para valores temporários: %rax, %rcx, %rdx, %rdi, %rsi, %r8, %r9, %r10, %r11.

Use o template do exercício (1). Comente o seu código!

Teste o seu programa, comparando a saída com a versão C.

*/