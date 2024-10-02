use src::wind_spirit::{
    Location,
    WindSpirit,
    WindSpiritTrait
};

fn assert_location(loc: @Location, x: u32, y: u32, z: u32) {
    let is_equal = *loc.x == x && *loc.y == y && *loc.z == z;
    assert!(is_equal, "Unexpected location!");
}

#[test]
fn move_to_test() {
    let mut wind_spirit_1 = WindSpirit {
        strength: 1,
        path: array![]
    };
    
    wind_spirit_1.move_to(Location { x: 1, y: 1, z: 1 });
    wind_spirit_1.move_to(Location { x: 2, y: 3, z: 1 });
    wind_spirit_1.move_to(Location { x: 2, y: 3, z: 1 });
    wind_spirit_1.move_to(Location { x: 4, y: 3, z: 1 });

    assert!(wind_spirit_1.path.len() == 3, "Unexpected path length!");
    assert_location(wind_spirit_1.path[0], 1, 1, 1);
    assert_location(wind_spirit_1.path[1], 2, 3, 1);
    assert_location(wind_spirit_1.path[2], 4, 3, 1);

    let mut wind_spirit_2 = WindSpirit {
        strength: 2,
        path: array![]
    };
    
    wind_spirit_2.move_to(Location { x: 2, y: 2, z: 2 });
    wind_spirit_2.move_to(Location { x: 2, y: 3, z: 1 });
    wind_spirit_2.move_to(Location { x: 2, y: 6, z: 1 });
    wind_spirit_2.move_to(Location { x: 2, y: 6, z: 1 });

    assert!(wind_spirit_2.path.len() == 3, "Unexpected path length!");
    assert_location(wind_spirit_2.path[0], 2, 2, 2);
    assert_location(wind_spirit_2.path[1], 2, 3, 1);
    assert_location(wind_spirit_2.path[2], 2, 6, 1);
}

#[test]
fn split_test() {
    let mut wind_spirit = WindSpirit {
        strength: 16,
        path: array![Location { x: 1, y: 1, z: 1 }]
    };

    let result = wind_spirit.split();

    assert!(result.len() == 2, "Unexpected spirit array length!");

    let mut i: u32 = 0;
    while i < 2 {
        let wind_spirit = result[i];

        assert!(*wind_spirit.strength == 8, "Unexpected strength!");
        assert!(wind_spirit.path.len() == 1, "Unexpected path length!");
        assert_location(wind_spirit.path[0], 1, 1, 1);

        i += 1;
    }
}