#[abi]
trait IElixir {
    #[view]
    fn brewed() -> bool;

    #[external]
    fn try_to_brew();
}