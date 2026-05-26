#include <stdio.h>

// Variável global e função definidas no arquivo Assembly
extern int s;
void sum();

int main()
{
    // Chama a rotina que itera sobre o array
    sum();
    
    printf("soma = %d\n", s);
    
    return 0;
}