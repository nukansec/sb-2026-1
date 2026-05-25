// Cria e inicializa as variáveis globais na seção .data
char c = -20;
int i = -256;
int j = 512;
long l = 128;
unsigned short us = 111;
unsigned int ui = 1024;
unsigned long ul = 2048;

void aux() 
{
    // ==========================================
    // Atribuições simples
    // ==========================================
    j = 68000;
    l = 4096;
    i = j;

    // ==========================================
    // Expressões
    // ==========================================
    j = 10 + i - 5;
    i = (i * 2) - (j + 5);

    // ==========================================
    // Casts (Conversões de Tipo)
    // ==========================================
    
    // De int (com sinal) para unsigned int (sem sinal).
    // O tamanho é o mesmo (4 bytes), os bits não mudam, apenas a forma de ler.
    ui = i;
    
    // De char (1 byte) para int (4 bytes).
    // Aqui ocorre Extensão de Sinal: o bit mais significativo do char é copiado para preencher os 3 bytes extras do int.
    j = c;
    
    // De unsigned int (4 bytes) para unsigned long (8 bytes).
    // Aqui ocorre Extensão com Zeros: os 4 bytes extras são preenchidos com 0.
    ul = ui;
    
    // De unsigned long (8 bytes) para unsigned short (2 bytes).
    // Aqui ocorre Truncamento: os 6 bytes mais significativos são jogados fora.
    us = ul;
    
    // Soma de dois ints, guardada em um char (1 byte).
    // A soma acontece em 32 bits, mas apenas os 8 bits finais são salvos.
    c = i + j;

    // ==========================================
    // Ponteiros
    // ==========================================
    long *ptr;
    
    // O ponteiro recebe o endereço de memória da variável 'l'
    ptr = &l;
    
    // O operador '*' desreferencia o ponteiro, ou seja, vai até o endereço guardado em 'ptr' e escreve o valor 128 lá dentro.
    *ptr = 128;

    int *iptr;
    iptr = &i;
    
    // Vai até o endereço guardado em 'iptr', lê o valor, soma com 'j' e guarda em 'j'.
    j = j + *iptr;
}

// Compilar e Testar o programa: gcc -no-pie -o main main.c auxx.c