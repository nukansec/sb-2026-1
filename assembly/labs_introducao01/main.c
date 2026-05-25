#include <stdio.h>

// A palavra-chave 'extern' não cria as variáveis. 
// Ela apenas avisa ao compilador: "Fique tranquilo, essas variáveis existem na memória, mas foram declaradas em outro arquivo (aux.c). 
// O Linker vai juntar tudo no final."
extern char c;
extern int i;
extern int j;
extern long l;
extern unsigned short us;
extern unsigned int ui;
extern unsigned long ul;

// Declaração da assinatura da função que está no aux.c
void aux();

int main() 
{
    // Chama a função que vai manipular as variáveis globais
    aux();

    printf("c  = %d\n", c);
    printf("i  = %d\n", i);
    printf("j  = %d\n", j);
    printf("l  = %ld\n", l);
    printf("us = %u\n", us);
    printf("ui = %u\n", ui);
    printf("lu = %lu\n", ul);
    
    return 0;
}