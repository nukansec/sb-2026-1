// Array de caracteres global. 
// O C automaticamente insere um byte nulo '\0' no final da string na memória.
char str[] = "BEBAMUITOCAFE";

void process()
{
    char *ptr = str;

    // Em C, strings terminam com '\0' (que tem valor numérico 0).
    // O while(*ptr) verifica justamente se o byte atual é diferente de 0.
    while (*ptr) {

        // Converte de Maiúscula para Minúscula.
        // Na tabela ASCII, a diferença entre 'A' (65) e 'a' (97) é exatamente 32.
        *ptr = *ptr + 32;

        // Aritmética de Ponteiro:
        // Como 'ptr' é do tipo char* (1 byte), o compilador traduz esse '++' para avançar exatamente 1 byte na memória.
        ptr++;
    }
}