use crate::vec3::Vec3;
use crate::hit_record::Hittable;
use crate::hit_record::HitRecord;
use crate::ray::Ray;

pub struct Sphere {
    pub center: Vec3,
    pub radius: f64,
}

impl Sphere {
    pub fn new(center: Vec3, r: f64) -> Sphere {
        Self { center, radius: r }
    }
}

impl Hittable for Sphere {
    fn hit(&self, r: Ray, t_min: f64, t_max: f64) -> Option<HitRecord> {
        let oc = self.center - r.origin;
        let a = r.direction.length_squared();
        let h = r.direction.dot(oc);
        let c = oc.length_squared() - self.radius * self.radius;
        let discriminant = h*h - a*c;

        if discriminant < 0.0 {
            return None;
        }

        let sqrtd = discriminant.sqrt();

        // Find the nearest root that lies in the acceptable range.
        let mut root = (h - sqrtd) / a;
        if root <= t_min || root >= t_max {
            root = (h + sqrtd) / a;
            if root <= t_min || root >= t_max {
                return None;
            }
        } 

        let p = r.at(root);
        let normal = (p - self.center) / self.radius;
        return Some(HitRecord{
                    p, 
                    normal, 
                    t:root
        });
    }
}