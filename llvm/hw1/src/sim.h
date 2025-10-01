#pragma once

#define WINDOW_WIDTH 512
#define WINDOW_HEIGHT 256

void simInit(void);
void app(void);
void simExit(void);
void simFlush(void);
void simPutPixel(int x, int y, int argb);
int simRand(void);
