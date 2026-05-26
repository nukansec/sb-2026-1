#include <stdio.h>

// Declaração de variáveis globais e funções que estão noutros ficheiros/arquivos
extern long last;
extern long values[5];

void swap();

int main()
{
    // Executa a função em Assembly para inverter o array
    swap();

    // Exibe os elementos do array modificados na memória
    for (int i = 0; i < 5; i++) {
        printf("values[%d] = %ld\n", i, values[i]);
    }

    // Exibe o último valor processado
    printf("last = %ld\n", last);

    return 0;
}