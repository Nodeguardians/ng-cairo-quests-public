use src::sorcerer::Sorcerer;
use src::sorcerer::SorcererTrait;
use src::sorcerer_duel::duel;

use src::tests::test_utils::TestSorcererTrait;

#[test]
#[available_gas(120000)]
fn test_duel_1() {
    let mut sorcerer1 = SorcererTrait::new(7, 4);
    let mut sorcerer2 = SorcererTrait::new(1, 3);

    duel(ref sorcerer1, ref sorcerer2);
    sorcerer1.assert_health(3);
    sorcerer2.assert_health(0);

    let mut sorcerer1 = SorcererTrait::new(4, 10);
    let mut sorcerer2 = SorcererTrait::new(2, 6);

    duel(ref sorcerer1, ref sorcerer2);
    sorcerer1.assert_health(6);
    sorcerer2.assert_health(0);
}

#[test]
#[available_gas(175000)] 
fn test_duel_2() {
    let mut sorcerer1 = SorcererTrait::new(5, 17);
    let mut sorcerer2 = SorcererTrait::new(3, 20);

    duel(ref sorcerer1, ref sorcerer2);
    sorcerer1.assert_health(5);
    sorcerer2.assert_health(0);

    let mut sorcerer1 = SorcererTrait::new(1, 7);
    let mut sorcerer2 = SorcererTrait::new(4, 2);

    duel(ref sorcerer1, ref sorcerer2);
    sorcerer1.assert_health(0);
    sorcerer2.assert_health(0);
}
