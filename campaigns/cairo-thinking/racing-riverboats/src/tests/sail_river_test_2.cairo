use array::ArrayTrait;
use dict::Felt252DictTrait;
use option::OptionTrait;

use src::sail_river::sail_river;
use src::tests::test_utils::new_obstacle;

#[test]
#[available_gas(2000000)]
fn test_sail_river() {
    let mut river = ArrayTrait::new();
    river.append(new_obstacle(1, 1, 1));
    river.append(new_obstacle(1, 2, 1)); // #1 
    river.append(new_obstacle(1, 1, 2)); 
    river.append(new_obstacle(3, 2, 1)); // #3
    river.append(new_obstacle(1, 2, 2));
    river.append(new_obstacle(1, 1, 3)); // #5
    river.append(new_obstacle(1, 2, 1)); // Duplicate with #1
    river.append(new_obstacle(1, 3, 3)); 
    river.append(new_obstacle(1, 5, 1)); 
    river.append(new_obstacle(3, 2, 1)); // Duplicate with #3
    river.append(new_obstacle(1, 6, 1));
    river.append(new_obstacle(1, 1, 3)); // Duplicate with #5
    river.append(new_obstacle(1, 6, 2));

    let maybe_jumps = sail_river(river);
    
    match maybe_jumps {
        Option::Some(x) => {
            assert(x == 5, 'Wrong number of jumps');
        },
        Option::None(_) => {
            panic_with_felt252('Unexpected empty option');
        }
    }

}

#[test]
#[available_gas(1000000)]
fn test_sail_river_no_crocodiles() {
    let mut river = ArrayTrait::new();
    river.append(new_obstacle(1, 0, 1));
    river.append(new_obstacle(1, 1, 1));
    river.append(new_obstacle(1, 2, 1)); 
    river.append(new_obstacle(1, 3, 1));
    river.append(new_obstacle(1, 4, 1));
    river.append(new_obstacle(1, 5, 1));
    river.append(new_obstacle(1, 6, 1));
    river.append(new_obstacle(1, 7, 1)); 

    let maybe_jumps = sail_river(river);
    
    match maybe_jumps {
        Option::Some(x) => {
            assert(x == 3, 'Wrong number of jumps');
        },
        Option::None(_) => {
            panic_with_felt252('Unexpected empty option');
        }
    }
}

#[test]
#[available_gas(1600000)]
fn test_sail_river_inexistent_path() {
    let mut river = ArrayTrait::new();
    river.append(new_obstacle(1, 0, 1));
    river.append(new_obstacle(1, 1, 1)); // #1 
    river.append(new_obstacle(1, 2, 1)); 
    river.append(new_obstacle(1, 3, 1)); // #3
    river.append(new_obstacle(1, 4, 1));
    river.append(new_obstacle(1, 1, 1)); // Duplicate with #1
    river.append(new_obstacle(1, 3, 1)); // Duplicate with #3
    river.append(new_obstacle(1, 1, 1)); // Duplicate with #1
    river.append(new_obstacle(1, 3, 3)); 
    river.append(new_obstacle(1, 5, 1)); 

    let maybe_jumps = sail_river(river);
    
    assert(maybe_jumps.is_none(), 'Unexpected path');
}

#[test]
#[available_gas(450000)]
fn test_sail_river_start_crocodile() {
    let mut river = ArrayTrait::new();
    river.append(new_obstacle(2, 2, 2)); // Duplicate
    river.append(new_obstacle(2, 2, 2)); // Duplicate
    river.append(new_obstacle(1, 1, 1));

    let maybe_jumps = sail_river(river);
    
    assert(maybe_jumps.is_none(), 'Unexpected path');
}

#[test]
#[available_gas(560000)]
fn test_sail_river_end_crocodile() {
    let mut river = ArrayTrait::new();
    river.append(new_obstacle(0, 0, 0));
    river.append(new_obstacle(1, 1, 1)); // Duplicate
    river.append(new_obstacle(10, 10, 10));
    river.append(new_obstacle(1, 1, 1)); // Duplicate

    let maybe_jumps = sail_river(river);
    
    assert(maybe_jumps.is_none(), 'Unexpected path');
}