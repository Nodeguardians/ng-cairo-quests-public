use array::ArrayTrait;
use option::OptionTrait;

use src::scarab::Scarab;
use src::scarab::ScarabTrait;
use src::scarab_skirmish::skirmish;

#[derive(Drop)]
struct TeamState {
    current_index: usize,
    current_scarab: Scarab,
    scarabs: @Array<Scarab>
}

fn battle(
    ref team1: Array<Scarab>, 
    ref team2: Array<Scarab>
) {
    let mut state1 = TeamState {
        current_index: 0,
        current_scarab: *team1[0],
        scarabs: @team1
    };

    let mut state2 = TeamState {
        current_index: 0,
        current_scarab: *team2[0],
        scarabs: @team2
    };
    
    let result = battle_recursive(ref state1, ref state2);

    team1 = get_team(state1);
    team2 = get_team(state2);
}

// ╔══════════════════════════════════════╗
// ║          HELPER FUNCTIONS            ║
// ╚══════════════════════════════════════╝

fn battle_recursive(
    ref state1: TeamState,
    ref state2: TeamState
) {
    let mut scarab1 = state1.current_scarab;
    let mut scarab2 = state2.current_scarab;

    skirmish(ref scarab1, ref scarab2);
    
    state1.current_scarab = scarab1;
    state2.current_scarab = scarab2;

    let continue1 = next(ref state1);
    let continue2 = next(ref state2);

    if (!continue1 | !continue2) { return (); }

    battle_recursive(ref state1, ref state2)
}

fn next(ref state: TeamState) -> bool {
    if !(@state).current_scarab.is_dead() { 
        return true;
    }

    state.current_index += 1;

    if (state.current_index >= state.scarabs.len()) {
        return false;
    }

    state.current_scarab = *state.scarabs[state.current_index];
    true
}

fn get_team(state: TeamState) -> Array<Scarab> {
    let mut array = ArrayTrait::new();
    if state.current_index >= state.scarabs.len() { 
        return array; 
    }

    array.append(state.current_scarab);

    let mut i = state.current_index + 1;
    loop {
        if i >= state.scarabs.len() { break (); }
        array.append(*state.scarabs[i]);
        i += 1;
    };

    array
}