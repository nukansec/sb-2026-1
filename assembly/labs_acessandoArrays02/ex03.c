int size = 5;
short a[5] = {5,1,7,2,9};
int   b[5] = {6,3,8,4,2};
long nums[5] = {0}; 
short factor = 100;

void ex03()
{
    int i = 0;
    short *ptr = a;

    while (i < size) {
        if (a[i] > 6)
            nums[i] = b[0] + factor;
        else
            nums[i] = *ptr * b[i];
        
        i++;
        ptr++; // Avança 2 bytes na memória (tamanho de um short)
    }
}

/*

Traduza apenas o arquivo ex03.c abaixo para Assembly o mais literal possível.

Se necessário, use estes os registradores para valores temporários: %rax, %rcx, %rdx, %rdi, %rsi, %r8, %r9, %r10, %r11.

Não utilizar %rbx, %r12 - %r15.

*/