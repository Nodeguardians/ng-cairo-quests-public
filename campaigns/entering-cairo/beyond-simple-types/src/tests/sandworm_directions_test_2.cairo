use src::sandworm_directions::give_directions;

#[test]
fn test_give_directions_1() {
    let directions = array![13, 11, 12, 13, 11, 13, 12, 11, 13];

    let main_direction = give_directions(directions);
    assert(main_direction == 13, 'Unexpected direction');
}