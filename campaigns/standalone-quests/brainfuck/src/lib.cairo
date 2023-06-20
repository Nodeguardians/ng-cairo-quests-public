mod contracts {
    mod brainfuck_vm;
    use brainfuck_vm::BrainfuckVM;
}

mod logic {
    mod program;
    mod utils;
}

#[cfg(test)]
mod tests {
    mod sample_programs;
    mod test_utils;

    mod program_check_test_1;
    mod program_execute_test_1;
    mod brainfuck_vm_test_2;
}