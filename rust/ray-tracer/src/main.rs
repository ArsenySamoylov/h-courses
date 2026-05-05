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

fn main() {
    let mut world = HittableList::new();

    world.objects.push(Box::new(
        Sphere::new(Vec3::new(0.0, 0.0, -1.0), 0.5)
    ));

    world.objects.push(Box::new(
        Sphere::new(Vec3::new(0.0, -100.5, -1.0), 100.0)
    ));

    let cam = Camera::new();

    cam.render(&world);
}