unsigned char letters[] = "abcdefghij";
int even = 0;
int odd = 0;

void ex02()
{
    unsigned int count = 0;

    while (letters[count]) {
        // O valor avaliado no IF é letters[count]. O 'count' é incrementado independentemente se o bitwise AND for verdadeiro ou falso.
        if (letters[count++] & 1)
            odd++;
        else
            even++;
    }
}

/*

Traduza apenas o arquivo ex02.c abaixo para Assembly o mais literal possível.

Se necessário, use estes os registradores para valores temporários: %rax, %rcx, %rdx, %rdi, %rsi, %r8, %r9, %r10, %r11.

Não utilizar %rbx, %r12 - %r15.

*/