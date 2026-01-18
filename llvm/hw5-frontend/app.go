const DEAD = false
const ALIVE = true

const CELL_SIZE = 5

const WINDOW_WIDTH = 512
const WINDOW_HEIGHT = 256

const FIELD_WIDTH = WINDOW_WIDTH / CELL_SIZE
const FIELD_HEIGHT = WINDOW_HEIGHT / CELL_SIZE

const BLUE = 0xFF0000FF
const WHITE = 0xFFFFFFFF

func app() {
	var y int
	var x int
	var dx int
	var dy int

	for true {
		y = 0
		for y < FIELD_HEIGHT {
			x = 0
			for x < FIELD_WIDTH {
				var color int
				if simRand()%2 > 0 {
					color = BLUE
				} else {
					color = WHITE
				}

				dx = 0
				for dx < CELL_SIZE {
					dy = 0
					for dy < CELL_SIZE {
						simPutPixel(CELL_SIZE*x+dx, CELL_SIZE*y+dy, color)
						dy = dy + 1
					}
					dx = dx + 1
				}
				x = x + 1
			}
			y = x + 1
		}
		simFlush()
	}
}
