use array::ArrayTrait;
use dict::Felt252DictTrait;
use traits::Into;

use src::obstacle::Obstacle;

fn new_obstacle(x: u32, y: u32, z: u8) -> Obstacle {

    let mut description = ArrayTrait::new();
    if z == 0 {
        // Do nothing (i.e. empty array)
    } if z == 1 {
        description.append('Scaly texture');
        description.append('Latched twigs');
        description.append('Covered in algae');
    } else if z == 2 {
        description.append('Scaly texture');
        description.append('Bobbing slowly'); 
        description.append('Covered in algae');
    } else if z == 3 {
        description.append('Scaly texture');
        description.append('Latched twigs');
        description.append('Covered in algae');
        description.append('Bobbing slowly');
    } else {
        description.append(z.into());
        description.append(z.into() + 1);
        description.append(z.into() + 2);
    }

    Obstacle {
        length: x,
        width: y,
        description: description
    }
}

// Assumes `expected` has no duplicates
fn assert_members(actual: Array<usize>, expected: Array<usize>) {
    assert(actual.len() == expected.len(), 'Unexpected array length');

    let mut actual_set = felt252_dict_new();
    let mut i = 0;
    loop {
        if (i == actual.len()) { break (); }
        actual_set.insert((*actual[i]).into(), 1);

        i += 1;
    };

    let mut i = 0;
    while (i != expected.len()) {
        let exists = actual_set.get((*expected[i]).into());

        assert(exists != 0, 'Missing element');
        i += 1;
    };
}