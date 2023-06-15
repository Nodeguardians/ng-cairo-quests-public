use array::ArrayTrait;
use array::ArrayTCloneImpl;
use clone::Clone;
use dict::Felt252DictTrait;
use traits::Into;

use src::obstacle::Obstacle;

fn hash(obstacle: @Obstacle) -> felt252 {
    let mut data = obstacle.description.clone();
    data.append((*obstacle.length).into());
    data.append((*obstacle.width).into());

    poseidon::poseidon_hash_span(data.span())
}

fn find_crocodiles(river: @Array<Obstacle>) -> Array<usize> {
    let mut obstacle_dict = Felt252DictTrait::new();
    find_crocodiles_recursive(river, 0, ref obstacle_dict)
}

fn find_crocodiles_recursive(
    river: @Array<Obstacle>, 
    index: usize, 
    ref obstacle_dict: Felt252Dict<usize>,
) -> Array<usize> {
    if (index == river.len()) { return ArrayTrait::new(); }

    let obstacle_hash = hash(river[index]);
    let previous_index = obstacle_dict.get(obstacle_hash);

    let is_duplicate = (obstacle_dict.get(obstacle_hash) != 0);
    obstacle_dict.insert(obstacle_hash, index + 1);

    let mut crocodiles = find_crocodiles_recursive(
        river, 
        index + 1, 
        ref obstacle_dict
    );

    if is_duplicate | obstacle_dict.get(obstacle_hash) != (index + 1) {
        crocodiles.append(index)
    }

    crocodiles
}
