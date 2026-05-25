#include <stdio.h>

extern int  a;
extern long b;

void ex02();

int main()
{
    ex02();

    // Entendendo a formatação do printf:
    // %d     -> Imprime como decimal com sinal
    // 0x     -> Imprime os caracteres literais "0x"
    // %.8X   -> Imprime em Hexadecimal (X maiúsculo), forçando 8 casas. 
    //           Se faltar número, preenche com zeros à esquerda. Ideal para ver os 32 bits (4 bytes) do 'int'.
    printf("a = %d (0x%.8X)\n", a, a);
    
    // %ld    -> Imprime como long decimal
    // %.16lX -> Imprime em Hexadecimal como long (lX), forçando 16 casas.
    //           Ideal para visualizar exatamente os 64 bits (8 bytes) na arquitetura x86-64.
    printf("b = %ld (0x%.16lX)\n", b, b);

    return 0;
}