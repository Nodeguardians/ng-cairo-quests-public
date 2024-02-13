use array::ArrayTrait;

use src::contracts::brainfuck_vm::IBrainfuckVMDispatcherTrait;

use src::tests::sample_programs;
use src::tests::test_utils::{ 
    array_u8_to_string, 
    assert_array,
    deploy_brainfuck_vm
};

#[test]
#[available_gas(6000000)]
fn test_deploy() {
    let vm = deploy_brainfuck_vm();
    let program_id = vm.deploy(sample_programs::hello_world());

    let program = vm.get_program(program_id);   
    assert_array(program, sample_programs::hello_world());
}

#[test]
#[should_panic()]
fn test_deploy_invalid_program() {
    let vm = deploy_brainfuck_vm();
    vm.deploy(sample_programs::invalid_program_1());
}

#[test]
#[available_gas(8000000)]
fn test_multiple_deploy() {
    let vm = deploy_brainfuck_vm();
    let id1 = vm.deploy(sample_programs::hello_world());
    let id2 = vm.deploy(sample_programs::echo());

    let program1 = vm.get_program(id1);   
    let program2 = vm.get_program(id2);   

    assert_array(program1, sample_programs::hello_world());
    assert_array(program2, sample_programs::echo());
}

#[test]
#[available_gas(60000000)]
fn test_call() {
    let vm = deploy_brainfuck_vm();
    let program_id = vm.deploy(sample_programs::hello_world());

    let return_data = vm.call(program_id, ArrayTrait::new());
    let return_string = array_u8_to_string(return_data);
    assert(return_string == 'Hello World!', 'Unexpected return data');
}

#[test]
#[available_gas(150000000)]
fn test_call_2() {
    let vm = deploy_brainfuck_vm();
    let program_id = vm.deploy(sample_programs::echo());

    let mut input = ArrayTrait::new();
    input.append('B');
    input.append('r');
    input.append('a');
    input.append('i');
    input.append('n');
    input.append(0); // EOL

    let return_data = vm.call(program_id, input);
    let return_string = array_u8_to_string(return_data);
    assert(return_string == 'Brain', 'Unexpected return data');

}


#[test]
#[available_gas(100000000)]
fn test_multiple_call() {
    let vm = deploy_brainfuck_vm();

    let id1 = vm.deploy(sample_programs::hello_world());
    let id2 = vm.deploy(sample_programs::echo());

    let return_data = vm.call(id1, ArrayTrait::new());
    let return_string = array_u8_to_string(return_data);
    assert(return_string == 'Hello World!', 'Unexpected return data');

    let mut input = ArrayTrait::new();
    input.append('!');
    input.append('$');
    input.append('#');
    input.append('!');
    input.append(0);

    let return_data = vm.call(id2, input);
    let return_string = array_u8_to_string(return_data);
    assert(return_string == '!$#!', 'Unexpected return data');
}
