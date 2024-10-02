use src::demon::Demon;
use src::you::{ You, YouTrait };

#[test]
fn equip_spell_test() {
    let mut you = You { 
        equipped_spell: Option::None, 
        cleanse_count: 0
    };

    you.equip_spell('Cleanse All');

    let result = match you.equipped_spell {
        Option::Some(spell) => {
            spell == 'Cleanse All'
        },
        Option::None => false
    };

    assert!(result, "Spell not equipped!");
}


#[test]
fn cleanse_all_demons_test() {

    let mut demons = array![
        Demon::Bush,
        Demon::Cactus(14),
        Demon::Cactus(125),
        Demon::Tree(array![1, 1]),
        Demon::Tree(array![1, 2]),
    ];

    let expected_demons = array![
        Demon::Bush,
        Demon::Cactus(0),
        Demon::Cactus(0),
        Demon::Tree(array![0, 0]),
        Demon::Tree(array![0, 0]),
    ];

    let mut you = You {
        equipped_spell: Option::Some('Cleanse All'),
        cleanse_count: 0
    };

    you.cleanse(ref demons);

    assert!(expected_demons == demons, "Unexpected demons!");
    assert!(you.cleanse_count == 5, "Unexpected cleanse count!");
}

#[test]
fn cleanse_evil_demons_test() {
    let mut demons = array![
        Demon::Bush,
        Demon::Cactus(14),
        Demon::Cactus(125),
        Demon::Tree(array![1, 1]),
        Demon::Tree(array![1, 2]),
    ];

    let expected_demons = array![
        Demon::Bush,
        Demon::Cactus(14),
        Demon::Cactus(0),
        Demon::Tree(array![0, 0]),
        Demon::Tree(array![1, 2]),
    ];

    let mut you = You {
        equipped_spell: Option::Some('Cleanse Evil'),
        cleanse_count: 0
    };

    you.cleanse(ref demons);

    assert!(expected_demons == demons, "Unexpected demons!");
    assert!(you.cleanse_count == 2, "Unexpected cleanse count!");
}

#[test]
fn cleanse_no_demons_test() {
    let mut demons = array![
        Demon::Bush,
        Demon::Cactus(125),
        Demon::Tree(array![1, 1]),
    ];

    let expected_demons = array![
        Demon::Bush,
        Demon::Cactus(125),
        Demon::Tree(array![1, 1]),
    ];

    let mut you = You {
        equipped_spell: Option::Some('Fireball'),
        cleanse_count: 0
    };

    you.cleanse(ref demons);

    assert!(expected_demons == demons, "Unexpected demons!");
    assert!(you.cleanse_count == 0, "Unexpected cleanse count!");
}

#[test]
fn cleanse_without_spell_test() {
    let mut demons = array![
        Demon::Bush,
        Demon::Cactus(125),
        Demon::Tree(array![1, 1]),
    ];

    let expected_demons = array![
        Demon::Bush,
        Demon::Cactus(125),
        Demon::Tree(array![1, 1]),
    ];

    let mut you = You {
        equipped_spell: Option::None,
        cleanse_count: 0
    };

    you.cleanse(ref demons);

    assert!(expected_demons == demons, "Unexpected demons!");
    assert!(you.cleanse_count == 0, "Unexpected cleanse count!");
}