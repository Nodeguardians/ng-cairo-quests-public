// TODO: Delete
use debug::PrintTrait;

use src::scarab::Scarab;
use src::scarab::ScarabTrait;
use src::scarab_skirmish::skirmish;

use test::test_utils::TestScarabTrait;

#[test]
#[available_gas(220000)]
fn test_skirmish_1() {
    let mut scarab1 = ScarabTrait::new(7, 4);
    let mut scarab2 = ScarabTrait::new(1, 3);

    skirmish(ref scarab1, ref scarab2);
    scarab1.assert_health(3);
    scarab2.assert_health(0);

    let mut scarab1 = ScarabTrait::new(4, 10);
    let mut scarab2 = ScarabTrait::new(2, 6);

    skirmish(ref scarab1, ref scarab2);
    scarab1.assert_health(6);
    scarab2.assert_health(0);
}

#[test]
#[available_gas(300000)]
fn test_skirmish_2() {
    let mut scarab1 = ScarabTrait::new(5, 17);
    let mut scarab2 = ScarabTrait::new(3, 20);

    skirmish(ref scarab1, ref scarab2);
    scarab1.assert_health(5);
    scarab2.assert_health(0);

    let mut scarab1 = ScarabTrait::new(1, 7);
    let mut scarab2 = ScarabTrait::new(4, 2);

    skirmish(ref scarab1, ref scarab2);
    scarab1.assert_health(0);
    scarab2.assert_health(0);
}
