mod vec3;
use vec3::Vec3;

fn write_color(v : Vec3) {
    let v = 255.999 * v;
    println!("{} {} {}", v.x as u32, v.y as u32, v.z as u32)
}

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

            let v = Vec3::new(r, g, b);
            write_color(v);
        }
    }
}
