#include <stdio.h>
int main() {
    int dividend, divisor, quotient, remainder;
    dividend = 10;
    divisor = 3;

    // Computes quotient
    quotient = dividend / divisor;

    // Computes remainder
    remainder = dividend % divisor;

    printf("Quotient = %d\n", quotient);
    printf("Remainder = %d", remainder);
    return 0;
}