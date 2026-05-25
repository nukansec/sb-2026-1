// Declaração global. O compilador alocará essas variáveis na seção .data
char c = 67;
short s = 23;
int i = 0;
int j = 0;
long l = 1023;
unsigned int ui = 2047;
unsigned long ul = 4095;

void atribuicoes()
{
    c = 93;
    s = 75;
    j = 52;
    l = 7265;
    i = j;
}

void cast()
{
    ui = i;     // int para unsigned int (mesmo tamanho, bits intocados)
    j = s;      // short (2 bytes) para int (4 bytes). Extensão de sinal ocorre aqui.
    ul = ui;    // unsigned int para unsigned long. Extensão com zeros.
    
    // O C promove 'c' (char) e 'j' (int) para o maior tipo (int) antes da soma.
    // O resultado (int) é então truncado para caber em 's' (short).
    s = c + j;  
}

void expressoes()
{
    // A ordem de precedência matemática e os tipos são respeitados
    i = j * s;
    j = 1 + (s * 3);
    ui = 2 * (i + s * 2);
    ul = (l + j * 3) - (s + 1024);
}

void bitAbit()
{
    c = c & 0x0F;   // Zera os 4 bits mais significativos (Mantém apenas o Nibble inferior)
    s = s | 0x80;   // Força o 8º bit (valor 128) a ser '1'
    i = i ^ 0x55;   // XOR com o padrão 01010101 (inverte bits alternados)
    j = (j | s) ^ c;
    
    // Shifts
    l = l >> 2;     // Divisão por 4. Como l tem sinal, o C usa Shift Aritmético (sar).
    ui = ui << 1;   // Multiplicação por 2. (shl)
    ul = ul >> 4;   // Divisão por 16. Como ul NÃO tem sinal, o C usa Shift Lógico (shr).
}

void ponteiros()
{
    short *ptr;
    ptr = &s;       // ptr recebe o endereço de memória de s
    *ptr = 128;     // Escreve 2 bytes no endereço apontado por ptr
}

// Compilar e Testar: $ gcc -no-pie -o main main.c auxx.c