use src::hawk_spirit::HawkSpirit;
use src::hawk_spirit_trait::{
    HawkSpiritTrait,
    find_oasis
};

#[test]
fn fly_test() {
    let hawk_1 = HawkSpirit {
        position: 2,
        speed: 3
    };
    let new_hawk_1 = hawk_1.fly();

    assert(new_hawk_1.position == 5, 'Unexpected position!');
    assert(new_hawk_1.speed == 3, 'Unexpected speed!');

    let hawk_2 = HawkSpirit {
        position: 11,
        speed: 12
    };
    let new_hawk_2 = hawk_2.fly();

    assert(new_hawk_2.position == 23, 'Unexpected position!');
    assert(new_hawk_2.speed == 12, 'Unexpected speed!');
}

#[test]
fn is_at_oasis_test() {
    let oasis_map = array![true, false, true, false];

    let hawk_0 = HawkSpirit {
        position: 0,
        speed: 1
    };

    let hawk_1 = HawkSpirit {
        position: 1,
        speed: 1
    };

    let hawk_2 = HawkSpirit {
        position: 2,
        speed: 1
    };

    let hawk_3 = HawkSpirit {
        position: 3,
        speed: 1
    };

    assert(hawk_0.is_at_oasis(@oasis_map), 'Oasis should be found!');
    assert(!hawk_1.is_at_oasis(@oasis_map), 'Unexpected Oasis found!');
    assert(hawk_2.is_at_oasis(@oasis_map), 'Oasis should be found!');
    assert(!hawk_3.is_at_oasis(@oasis_map), 'Unexpected Oasis found!');


}

#[test]
fn find_oasis_test() {
    let oasis_map = array![false, false, false, true, false, false, true, false, false];

    let hawk_0 = HawkSpirit {
        position: 1,
        speed: 3
    };

    let hawk_1 = HawkSpirit {
        position: 2,
        speed: 2
    };

    let hawk_2 = HawkSpirit {
        position: 0,
        speed: 1
    };

    let result = find_oasis(array![hawk_0, hawk_1, hawk_2], @oasis_map);
    assert(result == 6, 'Unexpected oasis index!')

}