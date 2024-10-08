use src::demon::{ Demon, DemonTrait };

// RULE: Do not modify this struct!
#[derive(Drop)]
struct You {
    equipped_spell: Option<felt252>,
    cleanse_count: u32
}

#[generate_trait]
impl YouImpl of YouTrait {

    // Set self.equipped_spell to `spell`.
    fn equip_spell(ref self: You, spell: felt252) {
        
    }

    // Modifies `demons` depending on the equipped spell.
    fn cleanse(ref self: You, ref demons: Array<Demon>) {

    }

}
