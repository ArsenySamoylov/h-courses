#pragma once

#define WINDOW_WIDTH 512
#define WINDOW_HEIGHT 256

#define CELL_SIZE 5

#define FIELD_WIDTH  (WINDOW_WIDTH  / CELL_SIZE)
#define FIELD_HEIGHT (WINDOW_HEIGHT / CELL_SIZE)

// Probability of a cell being alive at the start
#define ALIVE_PROB 15

#define BLUE 0xFF0000FF
#define WHITE 0xFFFFFFFF

void simInit(void);
void app(void);
void simExit(void);
int simFlush(void);
void simPutPixel(int x, int y, int argb);
int simRand(void);
