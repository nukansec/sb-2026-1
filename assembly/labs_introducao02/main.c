#include <stdio.h>

// Avisa ao compilador que o array 'str' existe, mas foi alocado em outro arquivo.
extern char str[];

void process();

int main() 
{
    // A função process vai manipular a string diretamente na memória global
    process();

    printf("%s\n", str);

    return 0;
}