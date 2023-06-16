use array::ArrayTrait;

/// @dev Brainfuck program that multiplies (mod 256)
fn simple_mul() -> Array<felt252> {
    let mut program = ArrayTrait::new();
    program.append(',>,<[>[->+>+<<]>[-<+>]<<-]>>>.');
    program
}

/// @dev Brainfuck program that relies on proper underflow/overflow management
/// Returns 255 - a - b
fn overflow_program() -> Array<felt252> {
    let mut program = ArrayTrait::new();
    program.append('-<,<,>[->-<]<[->>-<<]>>.');
    program
}

/// @dev Brainfuck program that returns 'Hello World'
fn hello_world() -> Array<felt252> {
    let mut program = ArrayTrait::new();
    program.append('++++++++[>++++[>++>+++>+++>+<<<');
    program.append('<-]>+>+>->>+[<]<-]>>.>---.+++++');
    program.append('++..+++.>>.<-.<.+++.------.----');
    program.append('----.>>+.');

    program
}

/// @dev Brainfuck program that relies on loop skipping
/// Echos input
fn echo() -> Array<felt252> {
    let mut program = ArrayTrait::new();
    program.append('[+[[+][]+]],[[->+<]>.>,]');
    program
}

/// @dev Brainfuck program that relies on proper memory implementation
/// Memory size must be 255 and </> must wrap
/// If not, infinite loop
fn memory_program() -> Array<felt252> {
    let mut program = ArrayTrait::new();
    program.append('<+>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    program.append('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    program.append('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    program.append('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    program.append('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    program.append('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    program.append('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    program.append('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    program.append('>>>>>>>>>>-[]');
    program
}

/// @dev Invalid Brainfuck program (unopened ])
fn invalid_program_1() -> Array<felt252> {
    let mut program = ArrayTrait::new();
    program.append('-<,<,>[->-<]]'); // 
    program
}

/// @dev Invalid Brainfuck program (unclosed [)
fn invalid_program_2() -> Array<felt252> {
    let mut program = ArrayTrait::new();
    program.append('-<,<,>[[->-<]');
    program
}

/// @dev Invalid Brainfuck program (invalid character)
fn invalid_program_3() -> Array<felt252> {
    let mut program = ArrayTrait::new();
    program.append('-<,<,>x');
    program
}