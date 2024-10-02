use src::food_supply::ration_food;

#[test]
fn test_ration_food() {
    assert(ration_food(0) == 0, 'Unexpected Day 0');
    assert(ration_food(1) == 1, 'Unexpected Day 1');
    assert(ration_food(2) == 1, 'Unexpected Day 2');
    assert(ration_food(3) == 2, 'Unexpected Day 3');
    assert(ration_food(4) == 0, 'Unexpected Day 4');
    assert(ration_food(5) == 5, 'Unexpected Day 5');
    assert(ration_food(6) == 8, 'Unexpected Day 6');
    assert(ration_food(7) == 13, 'Unexpected Day 7');
    assert(ration_food(8) == 21, 'Unexpected Day 8');
    assert(ration_food(9) == 0, 'Unexpected Day 10');
}
