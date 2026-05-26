long mixer (short value, short *v, int i, long f);
int upper (long f, int i);

int i = 0;
int swap = 10;
long factor = 2048;
short vetor[4] = {100, 200, 300, 400};

void converter() {
    short *ptr;
    for ( ; i < (swap * 2); i++) {
        ptr = &vetor[i] + 2;
        swap = (int)mixer(*ptr, vetor, swap, factor);
        factor = (long)swap;
        vetor[factor] = (short)upper(factor, swap);
        if (swap > 0) {
            swap = i ^ 0xFFEEDDCC;
        }
    }
}