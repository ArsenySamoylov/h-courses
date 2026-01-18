const BLUE = 0xFF0000FF
const WHITE = 0xFFFFFFFF

const MINUS_ONE = 0xFFFFFFFF

const WINDOW_WIDTH = 512
const WINDOW_HEIGHT = 256

func app() {
	var x int = simRand() % WINDOW_WIDTH
	var y int = simRand() % WINDOW_HEIGHT
	var color int = BLUE
	var y_vel int = 1
	var x_vel int = 1

	for true {
		if y == WINDOW_HEIGHT-1 {
			y_vel = MINUS_ONE
			color = WHITE
		}

		if x == WINDOW_WIDTH-1 {
			x_vel = MINUS_ONE
			color = WHITE
		}

		y = y + y_vel
		x = x + x_vel

		if y == 0 {
			y_vel = 1
			color = BLUE
		}

		if x == 0 {
			x_vel = 1
			color = BLUE
		}

		simPutPixel(x, y, color)
		simFlush()
	}
}