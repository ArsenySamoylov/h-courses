#include <stdbool.h>

#include "sim.h"



#define DEAD false
#define ALIVE true

void init(int frame[FIELD_HEIGHT][FIELD_WIDTH]) {
  for (int y = 0; y < FIELD_HEIGHT; y++)
          for (int x = 0; x < FIELD_WIDTH; x++)
                      frame[y][x] = simRand() % 100 < ALIVE_PROB;
}

int countNeighbors(int x, int y, int frame[FIELD_HEIGHT][FIELD_WIDTH]) {
    // int count = 0;
    // for (int dy = -1; dy <= 1; dy++) {
    //     for (int dx = -1; dx <= 1; dx++) {
    //         if (dx == 0 && dy == 0) 
    //           continue;

    //         int nx = x + dx;
    //         int ny = y + dy;
    //         if (nx >= 0 && nx < FIELD_WIDTH && ny >= 0 && ny < FIELD_HEIGHT) {
    //             if (frame[ny][nx]) {
    //                 count++;
    //             }
    //         }
    //     }
    // }
    // return count;
    return simRand() % 4;
  }

void drawCell(int x, int y, int color) {
  for(int dx = 0; dx < CELL_SIZE; dx++)
    for(int dy = 0; dy < CELL_SIZE; dy++)
        simPutPixel(CELL_SIZE*x+dx, CELL_SIZE*y+dy, color);
}

void render(int frame[FIELD_HEIGHT][FIELD_WIDTH]) {
    for (int y = 0; y < FIELD_HEIGHT; y++) {
        for (int x = 0; x < FIELD_WIDTH; x++) {
            int color = frame[y][x] ? BLUE : WHITE;
            drawCell(x, y, color);
        }
    }
}

void update(int current[FIELD_HEIGHT][FIELD_WIDTH], int next[FIELD_HEIGHT][FIELD_WIDTH]) {
    for (int y = 0; y < FIELD_HEIGHT; y++) {
        for (int x = 0; x < FIELD_WIDTH; x++) {
            int neighbors = countNeighbors(x, y, current);

            if (current[y][x] == DEAD) {
              next[y][x] = neighbors == 3;
            } else {
              next[y][x] = (neighbors < 2 || neighbors > 3) ? 
                      DEAD : current[y][x];
            }
        }
    }
}

void app(void) {
  int buff1[FIELD_HEIGHT][FIELD_WIDTH] = {};
  int buff2[FIELD_HEIGHT][FIELD_WIDTH] = {};

  int (*current)[FIELD_HEIGHT][FIELD_WIDTH] = &buff1;
  int (*next)[FIELD_HEIGHT][FIELD_WIDTH] = &buff2;
  init(*current);

  do {
    update(*current, *next);
    render(*next);
    
    int (*temp)[FIELD_HEIGHT][FIELD_WIDTH] = current;
    current = next;
    next = temp;
  } while(simFlush() == 0);
}