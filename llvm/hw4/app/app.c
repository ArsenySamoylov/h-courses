#include <stdbool.h>

#include "sim.h"

#define DEAD false
#define ALIVE true

#define CELL_SIZE 5

#define FIELD_WIDTH  (WINDOW_WIDTH  / CELL_SIZE)
#define FIELD_HEIGHT (WINDOW_HEIGHT / CELL_SIZE)

#define BLUE 0xFF0000FF
#define WHITE 0xFFFFFFFF

void app(void) {
  do {
    for (int y = 0; y < FIELD_HEIGHT; y++) {
        for (int x = 0; x < FIELD_WIDTH; x++) {
            int color =  simRand() % 2 ? BLUE:WHITE;
             for(int dx = 0; dx < CELL_SIZE; dx++)
                for(int dy = 0; dy < CELL_SIZE; dy++)
                  simPutPixel(CELL_SIZE*x+dx, CELL_SIZE*y+dy, color);
        }
    }
    simFlush();
  } while(true);
}