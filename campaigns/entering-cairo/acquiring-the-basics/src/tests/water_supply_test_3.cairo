use src::water_supply::is_prime;

#[test]
fn test_is_prime() {

    assert(!is_prime(0), '0 is not prime!');
    assert(!is_prime(1), '1 is not prime!');
    assert(!is_prime(4), '4 is not prime!');
    assert(!is_prime(6), '16 is not prime!');
    assert(!is_prime(10), '10 is not prime!');
    assert(!is_prime(18), '18 is not prime!');

    assert(is_prime(2), '2 is prime!');
    assert(is_prime(3), '3 is prime!');
    assert(is_prime(7), '7 is prime!');
    assert(is_prime(11), '11 is prime!');
    assert(is_prime(13), '13 is prime!');

}