mod vec3;
use vec3::Vec3;

mod ray;
use ray::Ray;

fn write_color(v: Vec3) {
    let v = 255.999 * v;
    println!("{} {} {}", v.x as u32, v.y as u32, v.z as u32)
}

fn ray_color(r: Ray) -> Vec3 {
    let unit_direction = r.direction.unit();
    let a = 0.5 * (unit_direction.y + 1.0);
    return (1.0 - a)*Vec3::new(1.0, 1.0, 1.0) + a*Vec3::new(0.5, 0.7, 1.0);
}

fn main() {
    // Image

    let aspect_ration: f64 = 16.0 / 9.0;

    let image_width:  u32 = 400;
    let image_height: u32 = ((image_width as f64) / aspect_ration) as u32;
    let image_aspect_ratio: f64 = (image_width as f64) / (image_height as f64);

    // Camera

    let viewport_height: f64 = 2.0;
    let viewport_width:  f64 = viewport_height * image_aspect_ratio;
    
    let focal_length:    f64 = 1.0;
    let camer_center: Vec3 = Vec3::new(0.0, 0.0, 0.0);

    // Navigating vectors
    let viewport_u = Vec3::new(viewport_width, 0.0, 0.0);
    let viewport_v = Vec3::new(0.0, -viewport_height, 0.0);

    let pixel_delta_u = viewport_u / (image_width  as f64);
    let pixel_delta_v = viewport_v / (image_height as f64);

    // Upper left pixel
    let viewport_upper_left = camer_center - Vec3::new(0.0, 0.0, focal_length) - viewport_u/2.0 - viewport_v/2.0;
    let pixel00_loc = viewport_upper_left + 0.5 * (pixel_delta_u + pixel_delta_v);

    // Render

    println!("P3");
    println!("{} {}", image_width, image_height);
    println!("255");

    for j in 0 .. image_height {
        for i in 0 .. image_width {
            let pixel_center = pixel00_loc + ((i as f64) * pixel_delta_u) + ((j as f64) * pixel_delta_v);
            let ray_direction = pixel_center - camer_center;
            let ray = Ray::new(camer_center, ray_direction);

            write_color(ray_color(ray));
        }
    }
}
