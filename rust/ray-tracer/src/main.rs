fn main() {
    let width = 256;
    let height = 256;

    println!("P3");
    println!("{} {}", width, height);
    println!("255");

    for j in 0 .. height {
        for i in 0 .. width {
            let r = (i as f64) / ((width-1)  as f64);
            let g = (j as f64) / ((height-1)  as f64);
            let b = 0.0;

            let ir = (255.999 * r) as u32;
            let ig = (255.999 * g) as u32;
            let ib = (255.999 * b) as u32;

            println!("{} {} {}", ir, ig, ib);
        }
    }
}
