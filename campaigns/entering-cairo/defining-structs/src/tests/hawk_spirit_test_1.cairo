use src::hawk_spirit::{ 
    HawkSpirit,
    summon_hawk
};

#[test]
fn summon_hawk_test() {
    let hawk_1 = summon_hawk(11);

    assert(hawk_1.position == 0, 'Unexpected position!');
    assert(hawk_1.speed == 11, 'Unexpected speed!');

    let hawk_2 = summon_hawk(211);

    assert(hawk_2.position == 0, 'Unexpected position!');
    assert(hawk_2.speed == 211, 'Unexpected speed!');
}
