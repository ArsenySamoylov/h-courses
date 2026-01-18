const BLUE = 0xFF0000FF
const WHITE = 0xFFFFFFFF

func app() {
	for true {
		simPutPixel(0, 0, BLUE)
		simPutPixel(1, 0, WHITE)
		simPutPixel(0, 1, BLUE)
		simPutPixel(1, 1, WHITE)

		simFlush()
	}
}