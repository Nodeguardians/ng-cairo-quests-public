use array::ArrayTrait;

use src::logic::program::ProgramTrait;

use src::tests::sample_programs;
use src::tests::test_utils::array_u8_to_string;

#[test]
fn test_simple_multiply() {
    let program = sample_programs::simple_mul();
    let mut input = ArrayTrait::new();
    input.append(4);
    input.append(3);

    let result = program.execute(input);
    assert(result.len() == 1,  'Unexpected result length');
    assert(*result[0] == 12, 'Unexpected result');
}

#[test]
fn test_cell_overflow() {
    let program = sample_programs::overflow_program();
    let mut input = ArrayTrait::new();
    input.append(32);
    input.append(12);

    let result = program.execute(input);
    assert(result.len() == 1,  'Unexpected result length');

    assert(*result[0] == 211, 'Unexpected result');
}

#[test]
fn test_memory() {
    let program = sample_programs::memory_program();

    let result = program.execute(ArrayTrait::new());
    assert(result.len() == 0,  'Unexpected result length');
}

#[test]
#[available_gas(140000000)]
fn test_looping() {
    let program = sample_programs::echo();
    let mut input = ArrayTrait::new();
    input.append('B');
    input.append('r');
    input.append('a');
    input.append('i');
    input.append('n');
    input.append(0); // EOL

    let result = program.execute(input);
    let result_string = array_u8_to_string(result);
    assert(result_string == 'Brain', 'Unexpected result');
}

#[test]
#[available_gas(52500000)]
fn test_hello_world() {
    let program = sample_programs::hello_world();

    let mut return_data = program.execute(ArrayTrait::new());
    let return_string = array_u8_to_string(return_data);
    assert(return_string == 'Hello World!', 'Unexpected result');
}
