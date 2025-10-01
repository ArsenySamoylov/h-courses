#include <stdlib.h>
#include <time.h>
#include <stdbool.h>
#include <assert.h>

#include <SDL2/SDL.h>

#include "sim.h"

#define FPS 50

static SDL_Renderer *Renderer = NULL;
static SDL_Window *Window = NULL;
static int Ticks = 0;

void simInit(void) {
    SDL_Init(SDL_INIT_VIDEO);
    SDL_CreateWindowAndRenderer(WINDOW_WIDTH, WINDOW_HEIGHT, 0, &Window, &Renderer);
    SDL_SetRenderDrawColor(Renderer, 0, 0, 0, 0);
    SDL_RenderClear(Renderer);

    srand(time(NULL));
    
    simPutPixel(0, 0, 0);
    simFlush();
}

void simExit(void) {
    SDL_Event event;
    while(true) {
        if(SDL_PollEvent(&event) && event.type == SDL_QUIT)
            break;
    }
    SDL_DestroyRenderer(Renderer);
    SDL_DestroyWindow(Window);
    SDL_Quit();
}

void simFlush(void) {
    SDL_PumpEvents();
    assert(SDL_TRUE != SDL_HasEvent(SDL_QUIT));
    Uint32 ticksDelta = SDL_GetTicks() - Ticks;
    if(ticksDelta < FPS) {
        SDL_Delay(FPS - ticksDelta);
    }

    SDL_RenderPresent(Renderer);
}
void simPutPixel(int x, int y, int argb) {
    assert(x >= 0 && x < WINDOW_WIDTH);
    assert(y >= 0 && y < WINDOW_HEIGHT);

    Uint8 a = (argb >> 24) & 0xFF;
    Uint8 r = (argb >> 16) & 0xFF;
    Uint8 g = (argb >>  8) & 0xFF;
    Uint8 b = (argb      ) & 0xFF;

    SDL_SetRenderDrawColor(Renderer, r, g, b, a);
    SDL_RenderDrawPoint(Renderer, x, y);
    Ticks = SDL_GetTicks();
}

int simRand(void) {
    return rand();
}