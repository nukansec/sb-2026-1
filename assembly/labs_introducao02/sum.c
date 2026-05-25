#include <stdio.h>

long sum = 0;
long vet[5] = {10, 20, 30, 40, 50};

int main()
{
    int i = 0;
    
    // O ponteiro recebe o endereço base do vetor.
    long *ptr = vet;

    while (i < 5) {
        sum = sum + *ptr;

        // Aritmética de Ponteiro:
        // Como 'ptr' é do tipo long* (8 bytes em 64-bits), esse '++' 
        // não avança 1 byte, mas sim 8 bytes na memória de cada vez.
        ptr++;
        
        // Inteiro normal, soma 1.
        i++;
    }

    printf("Soma: %ld\n", sum);

    return 0;
}