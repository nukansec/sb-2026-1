// Assinatura da função externa
short calculate_bonus(int base, char modifier, long *acc);

// Variáveis Globais
char  key = 5;
short threshold = 512;
int   scores[4] = {100, 600, 300, 800};
long  total = 0;

void practice_exam() 
{
    int i;
    short temp;

    for (i = 0; i < 4; i++) {
        // Cuidado: tamanhos diferentes na comparação!
        if (scores[i] < threshold) {
            
            // Cuidado: promoção de tipos e truncamento
            temp = (short)(key * 4);
            total = total + temp;
            
        } else {
            
            // Cuidado: passagem de valor, valor e referência
            temp = calculate_bonus(scores[i], key, &total);
            
            // Cuidado: shift com extensão
            scores[i] = (int)(temp << 2);
            
        }
    }
}