use array::ArrayTrait;

use src::find_crocodiles::find_crocodiles;
use src::tests::test_utils::{
    assert_members,
    new_obstacle
};

#[test]
#[available_gas(1800000)]
fn test_find_crocodiles() {
    let mut river = ArrayTrait::new();
    river.append(new_obstacle(1, 1, 1));
    river.append(new_obstacle(1, 2, 1)); // #1 
    river.append(new_obstacle(1, 1, 2)); 
    river.append(new_obstacle(3, 2, 1)); 
    river.append(new_obstacle(1, 1, 3)); // #4
    river.append(new_obstacle(1, 2, 2));
    river.append(new_obstacle(1, 2, 1)); // Duplicate with #1
    river.append(new_obstacle(1, 1, 3)); // Duplicate with #4
    river.append(new_obstacle(2, 1, 1));
    river.append(new_obstacle(1, 6, 3));
    river.append(new_obstacle(1, 6, 1));
    river.append(new_obstacle(1, 1, 3)); // Duplicate with #4
    river.append(new_obstacle(1, 6, 2));

    let mut expected = ArrayTrait::new(); 
    expected.append(1);
    expected.append(4);
    expected.append(6);
    expected.append(7);
    expected.append(11);

    let actual = find_crocodiles(@river);
    assert_members(actual, expected);
}