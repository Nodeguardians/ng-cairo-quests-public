use src::answer::answer_1;
use src::tests::test_utils::checksum;

#[test]
fn test_answer_1() {
    let (missing, unexpected) = checksum(answer_1(), 3204);
    assert!(missing == 0, "Missing Characters: {missing}");
    assert!(unexpected == 0, "Unexpected Characters: {unexpected}");
}