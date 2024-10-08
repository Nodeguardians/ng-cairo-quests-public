use src::sandworm_harness::untangle_harness;

#[test]
fn test_untangle_harness_1() {
    let harness = array![1, 21, 31, 41, 51, 61, 71];
    let knot = 41;

    let untangled_harness = untangle_harness(harness, knot);

    assert(untangled_harness.len() == 5, 'Unexpected length');
    assert(*untangled_harness[0] == 41, 'Unexpected content');
    assert(*untangled_harness[1] == 51, 'Unexpected content');
    assert(*untangled_harness[2] == 61, 'Unexpected content');
    assert(*untangled_harness[3] == 71, 'Unexpected content');
    assert(*untangled_harness[4] == 53, 'Unexpected content');
}

#[test]
fn test_untangle_harness_2() {
    let harness = array![22, 33, 11, 44, 66, 99, 77];
    let knot = 99;

    let untangled_harness = untangle_harness(harness, knot);

    assert(untangled_harness.len() == 3, 'Unexpected length');
    assert(*untangled_harness[0] == 99, 'Unexpected content');
    assert(*untangled_harness[1] == 77, 'Unexpected content');
    assert(*untangled_harness[2] == 176, 'Unexpected content');
}