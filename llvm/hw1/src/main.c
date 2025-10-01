#include <stdbool.h>
#include "sim.h"
int main(void) {
    simInit();
    while(true) {
        app();
        simFlush();
    };
    simExit();
    return 0;
}