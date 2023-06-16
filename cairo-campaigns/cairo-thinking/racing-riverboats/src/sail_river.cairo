use array::ArrayTrait;
use box::BoxTrait;

use src::obstacle::Obstacle;
use src::find_crocodiles::find_crocodiles;

const INFINITY: usize = 0xffffffff;

fn sail_river(obstacles: Array<Obstacle>) -> Option<usize> {
    
    let crocodiles = find_crocodiles(@obstacles);

    // If no crocodiles, terminate early
    if crocodiles.len() == 0 { 
        return Option::Some((obstacles.len() + 2) / 3);
    } 
    
    // Else if crocodiles at start or end, terminate early
    if (*crocodiles[0] == obstacles.len() - 1 
            | *crocodiles[crocodiles.len() - 1] == 0) {
        return Option::None(());
    };

    // Else, calcualte using DP

    let mut jumps = ArrayTrait::new();
    jumps.append(INFINITY);
    jumps.append(INFINITY);
    jumps.append(0);

    if obstacles.len() != 1 {
        sail_river_recursive(obstacles.len() - 2, crocodiles, ref jumps);
    }

    let total_jumps = *jumps[jumps.len() - 1];
    if total_jumps == INFINITY {
        Option::None(())
    } else {
        Option::Some(total_jumps)
    }
}

fn sail_river_recursive(
    position: usize,
    mut crocodiles: Array<usize>,
    ref jumps: Array<usize>
) {
    let has_croc = match crocodiles.get(0) {
        Option::Some(next_croc) => position == *next_croc.unbox(),
        Option::None(_) => false
    };

    if has_croc {
        jumps.append(INFINITY);
        crocodiles.pop_front();
    } else {
        jumps.append(find_best_jump(@jumps))
    }

    if position != 0 {
        sail_river_recursive(position - 1, crocodiles, ref jumps);
    }
    
}

#[inline(always)]
fn find_best_jump(jumps: @Array<usize>) -> usize {
    let end = jumps.len();
    let jump_1 = *jumps[end - 1];
    let jump_2 = *jumps[end - 2];
    let jump_3  = *jumps[end - 3];

    let mut least_jumps = if jump_3 <= jump_1 & jump_3 <= jump_2 { 
        jump_3
    } else if jump_2 <= jump_1 {
        jump_2
    } else { 
        jump_1
    };

    if least_jumps == INFINITY {
        INFINITY
    } else {
        least_jumps + 1
    }

}