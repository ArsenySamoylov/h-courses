use crate::vec3::Vec3;
use crate::ray::Ray;
use crate::interval::Interval;
use crate::material::Material;

#[derive(Clone,Copy)]
pub struct HitRecord<'a> {
    pub p:      Vec3,
    pub normal: Vec3,
    pub t:       f64,
    pub material: &'a dyn Material,
}


pub trait Hittable {
    fn hit(&self, r: Ray, ray_t: Interval) -> Option<HitRecord>;
}


pub struct HittableList {
    pub objects: Vec<Box<dyn Hittable>>,
}

impl HittableList {
    pub fn new() -> HittableList {
        Self {objects : Vec::new()}
    }
}

impl Hittable for HittableList {
    fn hit(&self, r: Ray, ray_t: Interval) -> Option<HitRecord> {
        let mut closest = ray_t.max;
        let mut result = None;

        for object in &self.objects {
            if let Some(hit) = object.hit(r, Interval::new(ray_t.min, closest)) {
                closest = hit.t;
                result = Some(hit);
            }
        }

        return result;
    }
}