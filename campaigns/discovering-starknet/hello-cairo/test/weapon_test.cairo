use array::ArrayTrait;
use array::ArrayTCloneImpl;
use clone::Clone;
use option::OptionTrait;

// TEST FUNCTIONS

fn is_equal(array_a: Array<felt252>, array_b: Array<felt252>) -> bool {
    if (array_a.len() != array_b.len()) {
        return false;
    }

    let mut i = 0;
    loop {
        if (i == array_a.len()) { break true; }
        let felt_a = *array_a[i];
        let felt_b = *array_b[i];

        if (felt_a != felt_b) { 
            break false; 
        }
        i += 1;
    }
}

fn sample_book() -> Array<felt252> {
    let mut book = ArrayTrait::<felt252>::new();
    book.append('q38r');
    book.append('tuefnra');
    book.append('rf2');
    book.append('t3st4');

    book
}

#[test]
#[available_gas(10000000)]
fn test_summon_spellbook() {
    let mut inventory = ArrayTrait::new();

    inventory.append(Weapon::Sword(()));
    inventory.append(Weapon::Spellbook(sample_book()));
    inventory.append(Weapon::Sword(()));

    let equipped = summon_weapon(@inventory, 1).expect('Option is empty');

    let is_expected = match equipped {
        Weapon::Sword(weapon) => false,
        Weapon::Spellbook(actual) => is_equal(actual, sample_book())
    };
    assert(is_expected, 'Incorrect equipped weapon');
}

#[test]
fn test_summon_sword() {
    let mut inventory = ArrayTrait::new();

    inventory.append(Weapon::Spellbook(sample_book()));
    inventory.append(Weapon::Spellbook(sample_book()));
    inventory.append(Weapon::Sword(()));
    inventory.append(Weapon::Spellbook(sample_book()));

    let equipped = summon_weapon(@inventory, 2).expect('Option is empty');

    let is_expected = match equipped {
        Weapon::Sword(weapon) => true,
        Weapon::Spellbook(_) => false
    };
    assert(is_expected, 'Incorrect equipped weapon');
}

#[test]
fn test_summon_invalid_weapon() {
    let mut inventory = ArrayTrait::new();

    inventory.append(Weapon::Spellbook(sample_book()));
    inventory.append(Weapon::Sword(()));
    inventory.append(Weapon::Sword(()));

    let equipped_option = summon_weapon(@inventory, 3);
    assert(equipped_option.is_none(), 'Unexpected equipped weapon');
}