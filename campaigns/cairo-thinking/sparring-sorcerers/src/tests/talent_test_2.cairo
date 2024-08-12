use src::sorcerer::Talent;
use src::sorcerer::Sorcerer;
use src::sorcerer::SorcererTrait;
use src::sorcerer_duel::duel;

use src::tests::test_utils::TestSorcererTrait;

#[test]
#[available_gas(230000)]
fn test_venomous_talent() {
    let mut sorcerer1 = SorcererTrait::new(1, 10);
    let mut sorcerer2 = SorcererTrait::with_talent(1, 3, Talent::Venomous(()));

    duel(ref sorcerer1, ref sorcerer2);
    sorcerer1.assert_health(4);
    sorcerer2.assert_health(0);

    let mut sorcerer1 = SorcererTrait::with_talent(1, 20, Talent::Venomous(()));
    let mut sorcerer2 = SorcererTrait::with_talent(1, 100, Talent::Venomous(()));

    duel(ref sorcerer1, ref sorcerer2);
    sorcerer1.assert_health(0);
    sorcerer2.assert_health(79);
}

#[test]
#[available_gas(200000)]
fn test_swift_talent() {
    let mut sorcerer1 = SorcererTrait::new(2, 7);
    let mut sorcerer2 = SorcererTrait::with_talent(4, 3, Talent::Swift(()));

    duel(ref sorcerer1, ref sorcerer2);
    sorcerer1.assert_health(0);
    sorcerer2.assert_health(1);

    let mut sorcerer1 = SorcererTrait::with_talent(1, 3, Talent::Swift(()));
    let mut sorcerer2 = SorcererTrait::new(3, 6);

    duel(ref sorcerer1, ref sorcerer2);
    sorcerer1.assert_health(0);
    sorcerer2.assert_health(3);

    let mut sorcerer1 = SorcererTrait::new(4, 9);
    let mut sorcerer2 = SorcererTrait::with_talent(4, 3, Talent::Swift(()));

    duel(ref sorcerer1, ref sorcerer2);
    sorcerer1.assert_health(5);
    sorcerer2.assert_health(0);
}

#[test]
#[available_gas(135000)]
fn test_guardian_talent() {
    let mut sorcerer1 = SorcererTrait::with_talent(4, 2, Talent::Guardian(()));
    let mut sorcerer2 = SorcererTrait::new(1, 6);

    duel(ref sorcerer1, ref sorcerer2);
    sorcerer1.assert_health(1);
    sorcerer2.assert_health(0);

    let mut sorcerer1 = SorcererTrait::new(1, 9);
    let mut sorcerer2 = SorcererTrait::with_talent(4, 1, Talent::Guardian(()));

    duel(ref sorcerer1, ref sorcerer2);
    sorcerer1.assert_health(1);
    sorcerer2.assert_health(0);
}

#[test]
#[available_gas(190000)]
fn test_all_talents() {
    let mut sorcerer1 = SorcererTrait::with_talent(3, 12, Talent::Guardian(()));
    let mut sorcerer2 = SorcererTrait::with_talent(2, 18, Talent::Venomous(()));

    duel(ref sorcerer1, ref sorcerer2);
    sorcerer1.assert_health(0);
    sorcerer2.assert_health(6);

    let mut sorcerer1 = SorcererTrait::with_talent(2, 5, Talent::Swift(()));
    let mut sorcerer2 = SorcererTrait::with_talent(2, 8, Talent::Venomous(()));

    duel(ref sorcerer1, ref sorcerer2);
    sorcerer1.assert_health(0);
    sorcerer2.assert_health(2);
}