#include <stdbool.h>
#include "sim.h"

int main(void) {
    simInit();
    do {
        app();
        
    } while(simFlush() == 0);

    simExit();
    return 0;
}