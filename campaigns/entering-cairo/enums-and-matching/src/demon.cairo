// RULE: Do not modify this enum!
#[derive(Drop, PartialEq)]
enum Demon {
    Bush,
    Cactus: u256,
    Tree: Array<u256>
}

#[generate_trait]
impl DemonImpl of DemonTrait {

    // Returns true if `self` is evil:
    //  * Bush demons are never evil.
    //  * Cactus demons are evil if their inner `u256` is a cube number greater than 1.
    //  * Tree demons are evil if their inner `Array<u256>` only have integers of the same parity.
    fn is_evil(self: @Demon) -> bool {
        false
    }

    // Modify the given demon:
    //  * Bush demons are unchanged.
    //  * Cactus demons have their inner `u256` set to 0.
    //  * Tree demons have all elements in their inner `Array<u256>` set to `0`.
    fn cleanse(ref self: Demon) {
        
    }

}
