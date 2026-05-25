#include <stdio.h>

// O Linker vai procurar essas variáveis no arquivo ex01.S ou ex01.c
extern int a;
extern int b;
extern int c;
extern int d;

// Assinatura da função escrita em Assembly
void ex01();

int main()
{
    // Chama a rotina em Assembly que vai alterar as variáveis globais
    ex01();
    
    // Imprime os valores atualizados após os IFs
    printf("a = %d\n", a);
    printf("b = %d\n", b);
    printf("c = %d\n", c);
    printf("d = %d\n", d);
    
    return 0;
}