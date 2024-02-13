use array::ArrayTrait;
use option::OptionTrait;

use src::pyramid::Chamber;

fn new_node<T>(item: T, left: usize, right: usize) -> Chamber<T> {
    Chamber {
        item: item,
        lower_chambers: Option::Some((left, right))
    }
}

fn new_bottom_node<T>(item: T) -> Chamber<T> {
    Chamber {
        item: item,
        lower_chambers: Option::None(())
    }
}

fn assert_array<T, impl TPartialEq: PartialEq<T>, impl TDrop: Drop<T>>(
    mut actual: Array<T>, 
    mut expected: Array<T>
) {
    assert(
        actual.len() == expected.len(), 
        'Unexpected array length' 
    );
    while (actual.len() > 0) {

        let actual_item = actual.pop_front().unwrap();
        let expected_item = expected.pop_front().unwrap();

        assert(
            actual_item == expected_item, 
            'Unexpected item'
        );
    }
}