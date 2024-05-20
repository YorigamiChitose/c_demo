#include <stdio.h>
#include <add/add.h>

int main(void) {
    printf("1 + 1 = %d\n" "Hello, world!\n", add(1, 1));
    return (!(add(1, 1) == (1 + 1)));
}

