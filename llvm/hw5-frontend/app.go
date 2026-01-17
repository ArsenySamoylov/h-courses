const DEAD = false
const ALIVE = true

const CELL_SIZE = 5

const FIELD_WIDTH = WINDOW_WIDTH / CELL_SIZE
const FIELD_HEIGHT = WINDOW_HEIGHT / CELL_SIZE

const BLUE = 0xFF0000FF
const WHITE = 0xFFFFFFFF

func app() {
	for {
		for y := 0; y < FIELD_HEIGHT; y++ {
			for x := 0; x < FIELD_WIDTH; x++ {
				var color int
				if simRand()%2 != 0 {
					color = BLUE
				} else {
					color = WHITE
				}

				for dx := 0; dx < CELL_SIZE; dx++ {
					for dy := 0; dy < CELL_SIZE; dy++ {
						simPutPixel(CELL_SIZE*x+dx, CELL_SIZE*y+dy, color)
					}
				}
			}
		}
		simFlush()
	}
}
