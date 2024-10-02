use src::answer::answer_2;
use src::tests::test_utils::checksum;

#[test]
fn test_answer_2() {
    let (missing, unexpected) = checksum(answer_2(), 1578);
    assert!(missing == 0, "Missing Characters: {missing}");
    assert!(unexpected == 0, "Unexpected Characters: {unexpected}");
}