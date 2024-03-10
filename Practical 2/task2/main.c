#include <stdio.h>
#include <stdlib.h>

extern char** populateMatrix();
extern char encryptChar(char**, char, char);

int main()
{
    char** matrix = populateMatrix();

    char input = 'B';
    char key = 'Z';
    printf("%c - %c -> %c\n", input, key, encryptChar(matrix, input, key));
    input = 'Z';
    key = 'Z';
    printf("%c - %c -> %c\n", input, key, encryptChar(matrix, input, key));
    input = 'A';
    key = 'L';
    printf("%c - %c -> %c\n", input, key, encryptChar(matrix, input, key));
    input = 'O';
    key = 'P';
    printf("%c - %c -> %c\n", input, key, encryptChar(matrix, input, key));

    for (int i = 0; i < 26; ++i) {
        free(matrix[i]);
    }
    free(matrix);

    return 0;
}
/*
B - Z -> A
Z - Z -> Y
A - L -> L
O - P -> D
*/