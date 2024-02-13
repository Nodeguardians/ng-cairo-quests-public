use array::ArrayTrait;
use traits::Into;

use src::pyramid::Pyramid;
use src::pyramid_traits::PyramidIntoArray;

use src::tests::test_utils::{
    new_node,
    new_bottom_node,
    assert_array
};

#[test]
#[available_gas(560000)]
fn test_into() {
    let mut chambers = ArrayTrait::new();
    chambers.append(new_node('l', 4, 9));
    chambers.append(new_bottom_node('m'));
    chambers.append(new_bottom_node('e'));
    chambers.append(new_node('f', 2, 6));
    chambers.append(new_node('j', 14, 5));
    chambers.append(new_bottom_node('k'));
    chambers.append(new_bottom_node('g'));
    chambers.append(new_bottom_node('c'));
    chambers.append(new_node('d', 13, 3));
    chambers.append(new_node('n', 1, 10));
    chambers.append(new_bottom_node('o'));
    chambers.append(new_node('h', 8, 0));
    chambers.append(new_bottom_node('a'));
    chambers.append(new_node('b', 12, 7));
    chambers.append(new_bottom_node('i'));

    let pyramid = Pyramid {
        top: 11,
        chambers: chambers
    };

    let mut expected_items = ArrayTrait::new();
    expected_items.append('a');
    expected_items.append('b');
    expected_items.append('c');
    expected_items.append('d');
    expected_items.append('e');
    expected_items.append('f');
    expected_items.append('g');
    expected_items.append('h');
    expected_items.append('i');
    expected_items.append('j');
    expected_items.append('k');
    expected_items.append('l');
    expected_items.append('m');
    expected_items.append('n');
    expected_items.append('o');

    let actual_items = pyramid.into();
    assert_array(actual_items, expected_items)
}
