use array::ArrayTrait;
use option::OptionTrait;

use src::scarab::Scarab;
use src::scarab::ScarabTrait;
use src::scarab::Talent;

fn skirmish(ref scarab1: Scarab, ref scarab2: Scarab) {
    if (scarab1.is_dead() | scarab2.is_dead()) { return (); }

    take_dmg(ref scarab1, scarab2.attack);
    take_dmg(ref scarab2, scarab1.attack);

    end_turn(ref scarab1);
    end_turn(ref scarab2);

    skirmish(ref scarab1, ref scarab2);
}

// ╔══════════════════════════════════════╗
// ║          HELPER FUNCTIONS            ║
// ╚══════════════════════════════════════╝

fn take_dmg(ref target: Scarab, mut amount: u8) {
    
    match target.talent {
        Talent::Talentless(_) => { },
        Talent::Venomous(_) => { },
        Talent::Swift(_) => { 
            if (amount <= 3) { amount = 1 }
        },
        Talent::Guardian(_) => {
            target.talent = Talent::Talentless(());
            return ();
        }
    };

    if (amount >= *(@target).health) { 
        target.health = 0; 
    } else {
        target.health -= amount;
    }
}

fn end_turn(ref scarab: Scarab) {
    match scarab.talent {
        Talent::Talentless(_) => { },
        Talent::Venomous(_) => { 
            scarab.attack += 1;
        },
        Talent::Swift(_) => { },
        Talent::Guardian(_) => { }
    };
}