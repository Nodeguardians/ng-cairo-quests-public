use array::ArrayTrait;
use option::OptionTrait;

use src::sorcerer::Sorcerer;
use src::sorcerer::SorcererTrait;
use src::sorcerer::Talent;
use src::sorcerer_battle::battle;

use src::tests::test_utils::{ assert_team, assert_defeated };

#[test]
#[available_gas(255000)]
fn test_battle_1() {
    let mut team1 = ArrayTrait::new();
    team1.append(SorcererTrait::new(4, 3));
    team1.append(SorcererTrait::new(2, 2));
    team1.append(SorcererTrait::new(1, 1));

    let mut team2 = ArrayTrait::new();
    team2.append(SorcererTrait::new(2, 1));
    team2.append(SorcererTrait::new(1, 5));

    battle(ref team1, ref team2);

    let mut expected = ArrayTrait::new();
    expected.append(SorcererTrait::new(2, 1));
    expected.append(SorcererTrait::new(1, 1));

    assert_team(team1, expected);
    assert_defeated(team2);

}

#[test]
#[available_gas(340000)]
fn test_battle_2() {
    let mut team1 = ArrayTrait::new();
    team1.append(SorcererTrait::new(1, 1));
    team1.append(SorcererTrait::new(2, 2));
    team1.append(SorcererTrait::new(3, 3));
    team1.append(SorcererTrait::new(5, 5));

    let mut team2 = ArrayTrait::new();
    team2.append(SorcererTrait::new(1, 1));
    team2.append(SorcererTrait::new(2, 2));
    team2.append(SorcererTrait::new(3, 3));
    team2.append(SorcererTrait::new(2, 2));
    team2.append(SorcererTrait::new(3, 3));

    battle(ref team1, ref team2);

    assert_defeated(team1);
    assert_defeated(team2);

}

#[test]
#[available_gas(180000)]
fn test_battle_3() {
    let mut team1 = ArrayTrait::new();
    team1.append(SorcererTrait::new(1, 7));
    team1.append(SorcererTrait::with_talent(1, 2, Talent::Swift(())));

    let mut team2 = ArrayTrait::new();
    team2.append(SorcererTrait::new(7, 1));
    team2.append(SorcererTrait::new(2, 1));

    battle(ref team1, ref team2);

    let mut expected = ArrayTrait::new();
    expected.append(SorcererTrait::new(1, 1));
    
    assert_team(team1, expected);
    assert_defeated(team2);
}

#[test]
#[available_gas(690000)]
fn test_battle_4() {
    let mut team1 = ArrayTrait::new();
    team1.append(SorcererTrait::with_talent(1, 8, Talent::Swift(())));
    team1.append(SorcererTrait::with_talent(2, 1, Talent::Guardian(())));
    team1.append(SorcererTrait::with_talent(1, 10, Talent::Venomous(())));
    team1.append(SorcererTrait::new(2, 11)); // (2, 7)
    team1.append(SorcererTrait::new(2, 3));
    team1.append(SorcererTrait::new(2, 6));

    let mut team2 = ArrayTrait::new();
    team2.append(SorcererTrait::new(3, 2));
    team2.append(SorcererTrait::new(2, 2));
    team2.append(SorcererTrait::new(4, 3));
    team2.append(SorcererTrait::new(1, 12));
    team2.append(SorcererTrait::with_talent(4, 7, Talent::Guardian(())));

    battle(ref team1, ref team2);

    let mut expected = ArrayTrait::new();
    expected.append(SorcererTrait::new(2, 7));
    expected.append(SorcererTrait::new(2, 3));
    expected.append(SorcererTrait::new(2, 6));
    
    assert_team(team1, expected);
    assert_defeated(team2);

}