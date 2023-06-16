use src::scarab::Talent;
use src::scarab::Scarab;
use src::scarab::ScarabTrait;
use src::scarab_skirmish::skirmish;

use test::test_utils::TestScarabTrait;

#[test]
#[available_gas(380000)]
fn test_venomous_talent() {
    let mut scarab1 = ScarabTrait::new(1, 10);
    let mut scarab2 = ScarabTrait::with_talent(1, 3, Talent::Venomous(()));

    skirmish(ref scarab1, ref scarab2);
    scarab1.assert_health(4);
    scarab2.assert_health(0);

    let mut scarab1 = ScarabTrait::with_talent(1, 20, Talent::Venomous(()));
    let mut scarab2 = ScarabTrait::with_talent(1, 100, Talent::Venomous(()));

    skirmish(ref scarab1, ref scarab2);
    scarab1.assert_health(0);
    scarab2.assert_health(79);
}


#[test]
#[available_gas(330000)]
fn test_swift_talent() {
    let mut scarab1 = ScarabTrait::new(2, 7);
    let mut scarab2 = ScarabTrait::with_talent(4, 3, Talent::Swift(()));

    skirmish(ref scarab1, ref scarab2);
    scarab1.assert_health(0);
    scarab2.assert_health(1);

    let mut scarab1 = ScarabTrait::with_talent(1, 3, Talent::Swift(()));
    let mut scarab2 = ScarabTrait::new(3, 6);

    skirmish(ref scarab1, ref scarab2);
    scarab1.assert_health(0);
    scarab2.assert_health(3);

    let mut scarab1 = ScarabTrait::new(4, 9);
    let mut scarab2 = ScarabTrait::with_talent(4, 3, Talent::Swift(()));

    skirmish(ref scarab1, ref scarab2);
    scarab1.assert_health(5);
    scarab2.assert_health(0);
}

#[test]
#[available_gas(230000)]
fn test_guardian_talent() {
    let mut scarab1 = ScarabTrait::with_talent(4, 2, Talent::Guardian(()));
    let mut scarab2 = ScarabTrait::new(1, 6);

    skirmish(ref scarab1, ref scarab2);
    scarab1.assert_health(1);
    scarab2.assert_health(0);

    let mut scarab1 = ScarabTrait::new(1, 9);
    let mut scarab2 = ScarabTrait::with_talent(4, 1, Talent::Guardian(()));

    skirmish(ref scarab1, ref scarab2);
    scarab1.assert_health(1);
    scarab2.assert_health(0);
}

#[test]
#[available_gas(320000)]
fn test_all_talents() {
    let mut scarab1 = ScarabTrait::with_talent(3, 12, Talent::Guardian(()));
    let mut scarab2 = ScarabTrait::with_talent(2, 18, Talent::Venomous(()));

    skirmish(ref scarab1, ref scarab2);
    scarab1.assert_health(0);
    scarab2.assert_health(6);

    let mut scarab1 = ScarabTrait::with_talent(2, 5, Talent::Swift(()));
    let mut scarab2 = ScarabTrait::with_talent(2, 8, Talent::Venomous(()));

    skirmish(ref scarab1, ref scarab2);
    scarab1.assert_health(0);
    scarab2.assert_health(2);
}