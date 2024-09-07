#include <stdio.h>
#include <add/add.h>

int main(int argc, char *argv[], char *envp[]) {
    printf("1 + 1 = %d\n" "Hello, world!\n", add(1, 1));
    for (int i = 0; i < argc; i ++) {
        printf("%s\n", argv[i]);
    }
    return (!(add(1, 1) == (1 + 1)));
}

