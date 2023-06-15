use array::ArrayTrait;
use integer::u128_wide_mul;
use option::OptionTrait;
use traits::Into;
use traits::TryInto;

use brainfuck::logic::utils::ProgramState;
use brainfuck::logic::utils::ProgramStateTrait;

fn append_instructions(ref instructions: Array<u8>, bytes: u128) {
    if bytes == 0 { return (); }
    let instruction = bytes / 0x1000000000000000000000000000000;
    if instruction != 0 { 
        instructions.append(instruction.try_into().unwrap());
    }

    let (_, new_bytes) = u128_wide_mul(bytes, 0x100);
    append_instructions(ref instructions, new_bytes);
}

fn into_instructions(program: @Array<felt252>) -> Array<u8> {
    let mut instructions = ArrayTrait::new();
    let mut i = 0;
    loop {
        if i == program.len() { break(); }

        let next: u256 = (*program[i]).into();
        append_instructions(ref instructions, next.high);
        append_instructions(ref instructions, next.low);

        i += 1;
    };

    instructions
}

fn run_instructions(instructions: @Array<u8>, input: Array<u8>) -> Array<u8>{
    let mut state = ProgramStateTrait::new(input);

    loop {
        let pc = *(@state).pc;
        if pc == instructions.len() { break (); }

        let instr = *instructions[pc];
        state.tick(instr);
    };

    state.output
}

fn check_instructions(instructions: @Array<u8>) {
    let mut pc = 0;
    let mut loop_ctr: usize = 0;

    loop {
        if pc == instructions.len() { break (); }

        let instr = *instructions[pc];
        if instr == '[' {
            loop_ctr += 1;
        } else if instr == ']' {
            assert(loop_ctr > 0, 'UNEXPECTED_END_LOOP'); 
            loop_ctr -= 1;
        } else if (instr != '<' & instr != '>' & instr != '+' 
                & instr != '-' & instr != '.' & instr != ',') {
            panic_with_felt252('INVALID_INSTRUCTION');
        }

        pc += 1;
    };

    assert(loop_ctr == 0, 'EXPECTED_END_LOOP');
}

trait ProgramTrait {
    fn check(self: @Array<felt252>);
    fn execute(self: @Array<felt252>, input: Array<u8>) -> Array<u8>;
}

impl ProgramImpl of ProgramTrait {

    fn check(self: @Array<felt252>) {
        let instructions = into_instructions(self);
        check_instructions(@instructions);
    }

    fn execute(self: @Array<felt252>, input: Array<u8>) -> Array<u8> {
        let instructions = into_instructions(self);
        run_instructions(@instructions, input)
    }

}
