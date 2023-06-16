use array::ArrayTrait;

fn triangular_sum(array: Array::<u128>) -> u128 {
    if (array.len() == 1) { return *array[0]; }

    let mut next_arr = ArrayTrait::<u128>::new();
    let mut i = 0;

    loop {
        if (i == array.len() - 1) { break (); }

        next_arr.append(*array[i] + *array[i + 1]);
        i += 1;
    };

    triangular_sum(next_arr)
}
