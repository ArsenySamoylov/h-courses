mod vec3;
use vec3::Vec3;

mod ray;
mod hit_record;
use hit_record::HittableList;

mod sphere;
use sphere::Sphere;

mod interval;
mod camera;
use camera::Camera;

mod material;
use material::{Lambertian, Metal};

fn main() {
    let mut world = HittableList::new();

    world.objects.push(Box::new(Sphere::new(
        Vec3::new(0.0, 0.0, -1.0),
        0.5,
        Box::new(Lambertian::new(Vec3::new(0.8, 0.3, 0.3))),
    )));

    world.objects.push(Box::new(Sphere::new(
        Vec3::new(0.0, -100.5, -1.0),
        100.0,
        Box::new(Lambertian::new(Vec3::new(0.8, 0.8, 0.0))),
    )));

    world.objects.push(Box::new(Sphere::new(
        Vec3::new(1.0, 0.0, -1.0),
        0.5,
        Box::new(Metal::new(Vec3::new(0.8, 0.6, 0.2), 1.0)),
    )));

    world.objects.push(Box::new(Sphere::new(
        Vec3::new(-1.0, 0.0, -1.0),
        0.5,
        Box::new(Metal::new(Vec3::new(0.8, 0.8, 0.8), 0.3)),
    )));

    let cam = Camera::new();
    cam.render(&world);
}