short vet[4] = {50, 10, 67, 42};
short max = 0;

void ex01()
{
    // Cuidado de Segurança: Um char assinado vai de -128 a 127. 
    // Se o vetor tivesse mais de 127 posições, teríamos um loop infinito ou overflow.
    char i;
    for (i = 0; i < 4; i++) {
        if (vet[i] > max)
            max = vet[i];
    }
}

/*

Traduza apenas o arquivo ex01.c abaixo para Assembly o mais literal possível.

Se necessário, use estes os registradores para valores temporários: %rax, %rcx, %rdx, %rdi, %rsi, %r8, %r9, %r10, %r11.

Não utilizar %rbx, %r12 - %r15.

*/