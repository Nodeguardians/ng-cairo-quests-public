use src::logic::program::ProgramTrait;

use src::tests::sample_programs;

#[test]
#[available_gas(6500000)]
fn test_check() {
    let program = sample_programs::simple_mul();
    program.check();

    let program = sample_programs::echo();
    program.check();

    let program = sample_programs::hello_world();
    program.check();
}

#[test]
#[should_panic()]
fn test_check_invalid_program_1() {
    let program = sample_programs::invalid_program_1();
    program.check();
}

#[test]
#[should_panic()]
fn test_check_invalid_program_2() {
    let program = sample_programs::invalid_program_2();
    program.check();
}

#[test]
#[should_panic()]
fn test_check_invalid_program_3() {
    let program = sample_programs::invalid_program_3();
    program.check();
}