#include <stdio.h>
#include <string.h>

// O 'extern' indica ao compilador que essas variáveis existem e terão seus endereços resolvidos na etapa de Linkagem (ld).
extern char c;
extern short s;
extern int i;
extern int j;
extern long l;
extern unsigned int ui;
extern unsigned long ul;

// Assinaturas das funções definidas no auxx.c / auxx.S
void cast();
void atribuicoes();
void expressoes();
void bitAbit();
void ponteiros();

void printValores()
{
    printf("c  = %d\n", c);
    printf("s  = %d\n", s);
    printf("i  = %d\n", i);
    printf("j  = %d\n", j);
    printf("l  = %ld\n", l);
    printf("ui = %u\n", ui);
    printf("ul = %lu\n", ul);
}

int main()
{
    printf("Valores antes da chamada das funções:\n");
    printValores();

    atribuicoes();
    printf("\nValores depois da chamada de função de atribuição:\n");
    printValores();

    cast();
    printf("\nValores depois da chamada de função de cast:\n");
    printValores();

    expressoes();
    printf("\nValores depois da chamada de função de expressões:\n");
    printValores();

    bitAbit();
    printf("\nValores depois da chamada de função de bit a bit:\n");
    printValores();

    ponteiros();
    printf("\nValores depois da chamada de função de ponteiros:\n");
    printValores();

    return 0;
}