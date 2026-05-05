use crate::vec3::Vec3;
use crate::ray::Ray;
use crate::hit_record::Hittable;
use crate::interval::Interval;

pub struct Camera {
    aspect_ratio: f64,
    image_width: u32,
    image_height: u32,

    center: Vec3,

    pixel00_loc: Vec3,
    pixel_delta_u: Vec3,
    pixel_delta_v: Vec3,
}

impl Camera {
    pub fn new() -> Self {
        let aspect_ratio = 16.0 / 9.0;
        let image_width = 400;
        let image_height = ((image_width as f64) / aspect_ratio) as u32;

        let viewport_height = 2.0;
        let viewport_width = viewport_height
            * (image_width as f64 / image_height as f64);

        let focal_length = 1.0;
        let center = Vec3::new(0.0, 0.0, 0.0);

        let viewport_u = Vec3::new(viewport_width, 0.0, 0.0);
        let viewport_v = Vec3::new(0.0, -viewport_height, 0.0);

        let pixel_delta_u = viewport_u / image_width as f64;
        let pixel_delta_v = viewport_v / image_height as f64;

        let viewport_upper_left =
            center
            - Vec3::new(0.0, 0.0, focal_length)
            - viewport_u / 2.0
            - viewport_v / 2.0;

        let pixel00_loc =
            viewport_upper_left + 0.5 * (pixel_delta_u + pixel_delta_v);

        Self {
            aspect_ratio,
            image_width,
            image_height,
            center,
            pixel00_loc,
            pixel_delta_u,
            pixel_delta_v,
        }
    }

    pub fn render(&self, world: &impl Hittable) {
        println!("P3");
        println!("{} {}", self.image_width, self.image_height);
        println!("255");

        for j in 0..self.image_height {
            for i in 0..self.image_width {
                let pixel_center =
                    self.pixel00_loc
                    + (i as f64) * self.pixel_delta_u
                    + (j as f64) * self.pixel_delta_v;

                let ray_direction = pixel_center - self.center;
                let ray = Ray::new(self.center, ray_direction);

                Self::write_color(self.ray_color(ray, world));
            }
        }
    }

    fn ray_color(&self, r:Ray, world: &impl Hittable) -> Vec3 {
        if let Some(rec) = world.hit(r, Interval::new(0.0, f64::INFINITY)) {
            return 0.5 * Vec3::new(
                rec.normal.x + 1.0,
                rec.normal.y + 1.0,
                rec.normal.z + 1.0,
            );
        }

        let unit_direction = r.direction.unit();
        let t = 0.5 * (unit_direction.y + 1.0);

        return (1.0 - t) * Vec3::new(1.0, 1.0, 1.0) + t * Vec3::new(0.5, 0.7, 1.0);
    }

    fn write_color(pixel_color: Vec3) {
        let c = 255.999 * pixel_color;
        println!("{} {} {}", c.x as u32, c.y as u32, c.z as u32);
    }
}