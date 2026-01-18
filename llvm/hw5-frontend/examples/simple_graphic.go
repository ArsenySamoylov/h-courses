const BLUE = 0xFF0000FF

func main() {
	var x int = 0
	var y int = 0
	for true {
		simPutPixel(x, y, BLUE)
		x = x + 1
		y = y + 1
		simFlush()
	}
}