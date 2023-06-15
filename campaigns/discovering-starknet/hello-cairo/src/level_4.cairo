use array::ArrayTrait;
use array::ArrayTCloneImpl;
use clone::Clone;
use option::OptionTrait;

#[derive(Drop)]
enum Weapon {
    Sword: (),
    Spellbook: Array<felt252>
}

fn summon_weapon(inventory: @Array<Weapon>, weapon_index: usize) -> Option<Weapon> {
    if (weapon_index >= inventory.len()) {
        return Option::None(());
    }

    let weapon = inventory.at(weapon_index);

    let weapon_clone = match weapon {
        Weapon::Sword(_) => Weapon::Sword(()),
        Weapon::Spellbook(arr) => Weapon::Spellbook(arr.clone())
    };

    Option::Some(weapon_clone)
}
