// TODO: Delete
use option::OptionTrait;
use debug::PrintTrait;

#[derive(Copy, Drop)]
struct Scarab {
    attack: u8,
    health: u8,
    talent: Talent
}

#[derive(Copy, Drop)]
enum Talent {
    Talentless: (),
    Venomous: (),
    Swift: (),
    Guardian: ()
}

trait ScarabTrait {
    fn new(attack: u8, health: u8) -> Scarab;
    fn with_talent(attack: u8, health: u8, talent: Talent) -> Scarab;

    fn attack(self: @Scarab) -> u8;
    fn health(self: @Scarab) -> u8;
    fn is_dead(self: @Scarab) -> bool;
}

impl ScarabImpl of ScarabTrait {

    fn new(attack: u8, health: u8) -> Scarab {
        Scarab {
            attack: attack,
            health: health,
            talent: Talent::Talentless(())
        }
    }

    fn with_talent(attack: u8, health: u8, talent: Talent) -> Scarab {
        Scarab {
            attack: attack,
            health: health,
            talent: talent
        }
    }

    fn attack(self: @Scarab) -> u8 { *self.attack }
    fn health(self: @Scarab) -> u8 { *self.health }
    fn is_dead(self: @Scarab) -> bool { *self.health == 0_u8 }

}
