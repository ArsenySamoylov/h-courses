#include <stdbool.h>

#include "sim.h"

// Probability of a cell being alive at the start
#define ALIVE_PROB 15
#define CELL_SIZE 5

#define FIELD_WIDTH  (WINDOW_WIDTH  / CELL_SIZE)
#define FIELD_HEIGHT (WINDOW_HEIGHT / CELL_SIZE)

static int buff1[FIELD_HEIGHT][FIELD_WIDTH] = {};
static int buff2[FIELD_HEIGHT][FIELD_WIDTH] = {};

static int (*current)[FIELD_HEIGHT][FIELD_WIDTH] = &buff1;
static int (*next)   [FIELD_HEIGHT][FIELD_WIDTH] = &buff2;

#define DEAD false
#define ALIVE true

#define BLUE 0xFF0000FF
#define WHITE 0xFFFFFFFF

void init(void) {
  for (int y = 0; y < FIELD_HEIGHT; y++)
          for (int x = 0; x < FIELD_WIDTH; x++)
                      (*current)[y][x] = simRand() % 100 < ALIVE_PROB;
}

int countNeighbors(int x, int y) {
    int count = 0;
    for (int dy = -1; dy <= 1; dy++) {
        for (int dx = -1; dx <= 1; dx++) {
            if (dx == 0 && dy == 0) 
              continue;

            int nx = x + dx;
            int ny = y + dy;
            if (nx >= 0 && nx < FIELD_WIDTH && ny >= 0 && ny < FIELD_HEIGHT) {
                if ((*current)[ny][nx]) {
                    count++;
                }
            }
        }
    }
    return count;
}

void drawCell(int x, int y, int color) {
  for(int dx = 0; dx < CELL_SIZE; dx++)
    for(int dy = 0; dy < CELL_SIZE; dy++)
        simPutPixel(CELL_SIZE*x+dx, CELL_SIZE*y+dy, color);
}

void render(void) {
    for (int y = 0; y < FIELD_HEIGHT; y++) {
        for (int x = 0; x < FIELD_WIDTH; x++) {
            int color = ((*current)[y][x]) ? BLUE : WHITE;
            drawCell(x, y, color);
        }
    }
}

void update(void) {
    for (int y = 0; y < FIELD_HEIGHT; y++) {
        for (int x = 0; x < FIELD_WIDTH; x++) {
            int neighbors = countNeighbors(x, y);

            if ((*current)[y][x] == DEAD) {
              (*next)[y][x] = neighbors == 3;
            } else {
              (*next)[y][x] = (neighbors < 2 || neighbors > 3) ? 
                      DEAD : (*current)[y][x];
            }
        }
    }

    int (*temp)[FIELD_HEIGHT][FIELD_WIDTH] = current;
    current = next;
    next = temp;
}

void app(void) {
  static bool isInitted = false;

  if(!isInitted) {
    init();
    isInitted = true;
  }

  update();
  render();
}