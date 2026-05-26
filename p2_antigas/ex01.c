int init_complement();

char bias = 3;
short max = 1024;
long complement[4] = {0, 0, 0, 0};

void auxiliar() {
    int range = init_complement();

    if (range < max) {
        complement[range]++;
        if (range) {
            bias = (char)(range * max);
            range = (int)(bias >> 3);
        }
    }
    else {
        complement[bias] = (long)max;
    }
}