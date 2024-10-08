#[derive(Drop)]
struct Location {
    x: u32,
    y: u32,
    z: u32
}

#[derive(Drop)]
struct WindSpirit {
    strength: u32,
    path: Array<Location> 
}

#[generate_trait]
impl WindSpiritImpl of WindSpiritTrait {

    fn move_to(ref self: WindSpirit, location: Location) {

        // if self.path.len() == 0 {
        //     self.path.append(location);
        //     return;
        // }

        // let last_index = self.path.len() - 1;
        // let current_location = *self.path[last_index];
        
        // if location != current_location {
        //     self.path.append(location);
        // }
        
    }

    fn split(mut self: WindSpirit) -> Array<WindSpirit> {

        let mut arr = ArrayTrait::new();

        // self.strength /= 2;

        // arr.append(self.clone());
        // arr.append(self);

        arr

    }
}
