use submission::level_2::tribonacci;

#[test]
#[available_gas(1000000)]
fn test_tribonacci() {
    assert(tribonacci(9) == 44, 'Incorrect Result');
    assert(tribonacci(13) == 504, 'Incorrect Result');
    assert(tribonacci(0) == 0, 'Incorrect Result');
    assert(tribonacci(1) == 0, 'Incorrect Result');
    assert(tribonacci(2) == 1, 'Incorrect Result');
}
