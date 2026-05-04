use crate::vec3::Vec3;
use crate::ray::Ray;

#[derive(Clone,Copy,Debug)]
pub struct HitRecord {
    pub p:      Vec3,
    pub normal: Vec3,
    pub t:       f64,
}


pub trait Hittable {
    fn hit(&self, r: Ray, t_min: f64, t_max: f64) -> Option<HitRecord>;
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
    fn hit(&self, r: Ray, t_min: f64, t_max: f64) -> Option<HitRecord> {
        let mut closest = t_max;
        let mut result = None;

        for object in &self.objects {
            if let Some(hit) = object.hit(r, t_min, closest) {
                closest = hit.t;
                result = Some(hit);
            }
        }

        return result;
    }
}