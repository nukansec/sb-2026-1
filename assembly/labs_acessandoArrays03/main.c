#include <stdio.h>

// O modificador 'extern' mapeia essas variáveis para as definições no arquivo Assembly
extern short v1[4];
extern int   v2[5];
extern char  v3[4];
extern long  v4[8];

// Neste laboratório, os contadores dos loops são globais!
extern int i;
extern short j;

void aux();

int main() 
{
    // Roda a rotina aninhada do Assembly
    aux();

    printf("v3: ");
    for (i = 0; i < 4; i++) {
        printf("%d ", v3[i]);
    }

    printf("\nv4: ");
    for (i = 0; i < 8; i++) {
        printf("%ld ", v4[i]);
    }

    printf("\n");

    return 0;
}