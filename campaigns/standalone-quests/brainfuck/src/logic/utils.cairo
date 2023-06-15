use array::ArrayTrait;
use dict::Felt252DictTrait;
use integer::{ u8_wrapping_add, u8_wrapping_sub };
use option::OptionTrait;
use traits::Into;

// ╔═══════════════════════════════════════╗
// ║        Helper Class: ProgramState     ║
// ╚═══════════════════════════════════════╝

#[derive(Destruct)]
struct ProgramState {
    input: Array<u8>,
    pc: usize,
    data_ptr: u8,
    memory: Felt252Dict<u8>,
    jump_locs: Stack,
    output: Array<u8>,
    skip_loop: felt252
}

trait ProgramStateTrait {
    fn new(input: Array<u8>) -> ProgramState;
    fn read(ref self: ProgramState) -> u8;
    fn write(ref self: ProgramState, x: u8);
    fn tick(ref self: ProgramState, instr: u8);
}

impl ProgramStateImpl of ProgramStateTrait {
    fn new(input: Array<u8>) -> ProgramState {
        ProgramState {
            input: input,
            pc: 0,
            data_ptr: 0,
            memory: Felt252DictTrait::new(),
            jump_locs: StackTrait::new(),
            output: ArrayTrait::new(),
            skip_loop: 0
        }
    }

    fn read(ref self: ProgramState) -> u8 {
        self.memory.get(self.data_ptr.into())
    }
    
    fn write(ref self: ProgramState, x: u8) {
        self.memory.insert(self.data_ptr.into(), x);
    }

    fn tick(ref self: ProgramState, instr: u8) {
        
        if *(@self).skip_loop != 0 {
            if (instr == '[') {
                self.skip_loop += 1; 
            } else if (instr == ']') { 
                self.skip_loop -= 1; 
            }
            self.pc += 1;
            return ();
        }

        if instr == '>' {
            // Increment data pointer
            self.data_ptr = u8_wrapping_add(self.data_ptr, 1);
        } else if instr == '<' {
            // Decrement data pointer
            self.data_ptr = u8_wrapping_sub(self.data_ptr, 1);

        } else if instr == '+' {
            // Increment data
            let incremented = u8_wrapping_add(self.read(), 1);
            self.write(incremented);

        } else if instr == '-' {
            // Decrement data
            let old_data = self.read();
            let decremented = if old_data == 0 { 255 } else { old_data - 1 };
            self.write(decremented);

        } else if instr == '.' {
            // Copy data to output
            let data = self.read();
            self.output.append(data);

        } else if instr == ',' {
            // Consume input
            let input = self.input
                .pop_front().expect('INPUT_OUT_OF_BOUNDS');
            self.write(input);

        } else if instr == '[' {
            if self.read() == 0 {
                // If data == 0, skip loop block
                self.skip_loop += 1;
            } else {
                // Start loop otherwise
                self.jump_locs.push(self.pc);
            }

        } else if instr == ']' {
            if self.read() == 0 {
                // If data == 0, break
                self.jump_locs.pop();
            } else {
                // Loop back otherwise
                self.pc = (@self).jump_locs.peek();
            }
        }
        self.pc += 1;
    }
}

// ╔════════════════════════════════════════╗
// ║           Helper Class: Stack          ║
// ╚════════════════════════════════════════╝

#[derive(Drop)]
struct StackNode {
    item: usize,
    next: usize
}

#[derive(Drop)]
struct Stack {
    top: usize,
    nodes: Array<StackNode>
}

trait StackTrait {
    fn new() -> Stack;
    fn push(ref self: Stack, item: usize);
    fn pop(ref self: Stack) -> usize;
    fn peek(self: @Stack) -> usize;
    fn is_empty(self: @Stack) -> bool;
}

impl StackImpl of StackTrait {

    fn new() -> Stack {
        let mut nodes: Array<StackNode> = ArrayTrait::new();
        nodes.append(StackNode { item: 0, next: 0 });

        Stack { top: 0, nodes: nodes }
    }

    fn push(ref self: Stack, item: usize) {
        let mut nodes = self.nodes;
        nodes.append(StackNode { item: item, next: self.top });

        self = Stack {
            top: nodes.len() - 1,
            nodes: nodes
        };
    }

    fn pop(ref self: Stack) -> usize {
        assert(!self.is_empty(), 'STACK_EMPTY');

        let self_snapshot = @self;
        let top_node = self_snapshot.nodes[*self_snapshot.top];
        self.top = *top_node.next;

        *top_node.item
    }

    fn peek(self: @Stack) -> usize {
        assert(!self.is_empty(), 'STACK_EMPTY');

        let top_node = self.nodes[*self.top];
        *top_node.item
    }

    fn is_empty(self: @Stack) -> bool {
        *self.top == 0
    }
}