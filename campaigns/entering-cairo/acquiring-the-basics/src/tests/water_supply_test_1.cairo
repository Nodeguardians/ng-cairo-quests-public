use src::water_supply::combine_water;

#[test]
fn test_combine_water() {
    // Explicitly declare types to verify fn signatures not changed
    let x: u32 = 14;
    let y: u128 = 15;
    let z: u64 = combine_water(x, y);
    assert(z == 29, 'Unexpected Sum');

    assert(combine_water(10, 200) == 210, 'Unexpected Sum');
    assert(combine_water(156, 100) == 256, 'Unexpected Sum');
    assert(combine_water(99, 99) == 198, 'Unexpected Sum');
}