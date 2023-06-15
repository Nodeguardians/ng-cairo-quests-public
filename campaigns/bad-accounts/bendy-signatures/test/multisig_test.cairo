use test::utils::signer;

const PRIVATE_KEY: felt252 = 'PR1V4T3_K37';
const TEST_HASH: felt252 = 0x000DEADC0FFEEDEADC0FFEEDEADC0FFEEDEADC0FFEEDEADC0FFEEDEADC0FFEE;

#[test]
#[available_gas(100000000000)]
fn test_malleability_attack() {
    let (r, s) = signer::sign(PRIVATE_KEY, TEST_HASH);
    let (pub_x, _) = signer::compute_public_key(PRIVATE_KEY);

    let is_valid = ecdsa::check_ecdsa_signature(
        message_hash: TEST_HASH,
        public_key: pub_x,
        signature_r: r,
        signature_s: s
    );
    assert(is_valid, 'INVALID_SIGNATURE');

    let is_malleable = ecdsa::check_ecdsa_signature(
        message_hash: TEST_HASH,
        public_key: pub_x,
        signature_r: r,
        signature_s: ec::StarkCurve::ORDER - s
    );
    assert(is_malleable, 'INVALID_SIGNATURE');
}