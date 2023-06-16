use array::ArrayTrait;
use option::OptionTrait;

use src::scarab::Scarab;
use src::scarab::ScarabTrait;

trait TestScarabTrait {
    fn assert_health(self: @Scarab, expected: u8);
}

impl TestScarabImpl of TestScarabTrait {
    fn assert_health(self: @Scarab, expected: u8) {
        assert(self.health() == expected, 'Unexpected Scarab: bad health');
        if expected == 0 {
            assert(self.is_dead(), 'Unexpected Scarab: not dead');
        }
    }
}

fn assert_team(mut actual: Array<Scarab>, mut expected: Array<Scarab>) {
    assert(actual.len() == expected.len(), 'Unexpected team size');

    loop {
        if actual.is_empty() { break (); }

        let s1 = actual.pop_front().unwrap();
        let s2 = expected.pop_front().unwrap();

        assert(s1.health() == s2.health(), 'Unexpected scarab: bad health');
        assert(s1.attack() == s2.attack(), 'Unexpected scarab: bad attack');
    }

}

fn assert_defeated(actual: Array<Scarab>) {
    assert(actual.len() == 0, 'Unexpected team size');
}