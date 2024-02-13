use array::ArrayTrait;
use option::OptionTrait;
use result::ResultTrait;
use traits::{ Into, TryInto };

use starknet::class_hash::Felt252TryIntoClassHash;
use starknet::deploy_syscall;

use src::contracts::brainfuck_vm::{ 
    BrainfuckVM, 
    IBrainfuckVMDispatcher
};

fn assert_array<T, impl TPartialEq: PartialEq<T>, impl TDrop: Drop<T>>(
    mut actual: Array<T>, 
    mut expected: Array<T>
) {
    assert(
        actual.len() == expected.len(), 
        'Unexpected array length' 
    );
    while (actual.len() > 0) {  
        let actual_item = actual.pop_front().unwrap();
        let expected_item = expected.pop_front().unwrap();

        assert(
            actual_item == expected_item, 
            'Unexpected item'
        );
    }
}

fn array_u8_to_string(mut data: Array<u8>) -> felt252 {
    assert(data.len() <= 31, 'Return data too big');
    let mut data_string = '';
    loop {
        match data.pop_front() {
            Option::Some(c) => { 
                data_string *= 0x100;
                data_string += c.into(); 
            },
            Option::None(_) => { break (); }
        };
    };

    data_string
}

fn deploy_brainfuck_vm() -> IBrainfuckVMDispatcher {
    let vm_hash = BrainfuckVM::TEST_CLASS_HASH.try_into().unwrap();

    let (vm_address, _) = deploy_syscall(
        vm_hash,
        0,
        ArrayTrait::new().span(),
        false
    ).unwrap();

    IBrainfuckVMDispatcher { 
        contract_address: vm_address 
    }
}