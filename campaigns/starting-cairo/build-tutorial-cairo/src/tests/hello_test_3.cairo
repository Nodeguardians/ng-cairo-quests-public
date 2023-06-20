use src::hello::hello_guardian;

#[test]
fn test_hello_guardian() {
    assert(hello_guardian() == 'Hello Guardian', 'Unexpected return value')
}