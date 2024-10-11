use src::hawk_spirit::HawkSpirit;

// RULE: Do not modify trait!
trait HawkSpiritTrait {
    // Return a new `HawkSpirit` with same speed and new position:
    //   * new_position = position + speed
    fn fly(self: @HawkSpirit) -> HawkSpirit;

    // Returns true if hawk spirit is at an oasis:
    //   * At position `x` and `oasis_map[x] == true` 
    fn is_at_oasis(self: @HawkSpirit, oasis_map: @Array<bool>) -> bool;
}

impl HawkSpiritImpl of HawkSpiritTrait {

    fn fly(self: @HawkSpirit) -> HawkSpirit {
        HawkSpirit {
            position: 0,
            speed: 0
        }
    }

    fn is_at_oasis(self: @HawkSpirit, oasis_map: @Array<bool>) -> bool {
        true
    }

}

// Repeatedly call `fly` for every hawk, until one hawk reaches an oasis.
// Returns the index of the first oasis found.
// You can assume that at least one hawk will eventually reach an oasis.
fn find_oasis(
    hawks: Array<HawkSpirit>, 
    oasis_map: @Array<bool>
) -> u32 {
    0
}
