// Alocações de diferentes tamanhos na memória (.data)
short v1[4] = {32, 34, 27, 4};             // 2 bytes por elemento
int   v2[5] = {12, 22, 31, 23, 6};         // 4 bytes por elemento
char  v3[4] = {0, 0, 0, 0};                // 1 byte por elemento
long  v4[8] = {0, 0, 0, 0, 0, 0, 0, 0};    // 8 bytes por elemento

int   i = 0;
short j = 0;

void aux() 
{
    // Loop Externo
    for (i = 0; i < 4; i++) {
        j = 0;
        
        // Loop Interno
        while (j < 5) {
            
            // O compilador promove 'j' (short) para int antes de comparar com 'i' (int)
            if (i == j) {
                // v1[i] (short) + v2[j] (int) -> Resultado é int.
                // O resultado int é truncado para char antes de salvar em v3.
                v3[i] = v1[i] + v2[j];
            }
            else {
                // Calcula o índice somando i(int) + j(short). 
                // Promove tudo para long, soma com o valor existente e salva.
                v4[i + j] += v1[i] + v2[j];
            }
            j++;
        }
    }
}

/*

Traduza apenas o arquivo aux.c abaixo para Assembly o mais literal possível.

Se necessário, use estes os registradores para valores temporários: %rax, %rcx, %rdx, %rdi, %rsi, %r8, %r9, %r10, %r11.

Não utilizar %rbx, %r12 - %r15.

Compilar e Rodar: $  gcc -no-pie -o aux main.c aux.S

*/