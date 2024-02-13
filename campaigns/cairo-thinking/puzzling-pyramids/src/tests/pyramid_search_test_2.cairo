use array::ArrayTrait;
use option::OptionTrait;

use src::pyramid::Pyramid;
use src::pyramid_traits::PyramidSearchTrait;

use src::tests::test_utils::{
    new_node,
    new_bottom_node,
    assert_array
};

#[test]
#[available_gas(520000)]
fn test_search() {
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

    let mut expected_path = ArrayTrait::new();
    expected_path.append('h');
    expected_path.append('l');
    expected_path.append('j');
    expected_path.append('k');

    let actual_path = pyramid.search('k');
    assert_array(
       actual_path.expect('Search path empty'), 
       expected_path
    );
    
}

#[test]
#[available_gas(500000)]
fn test_search_inexistent_element() {
    let mut chambers = ArrayTrait::new();
    chambers.append(new_bottom_node('0'));
    chambers.append(new_bottom_node('1'));
    chambers.append(new_bottom_node('2'));
    chambers.append(new_bottom_node('3'));
    chambers.append(new_bottom_node('4'));
    chambers.append(new_bottom_node('5'));
    chambers.append(new_bottom_node('6'));
    chambers.append(new_bottom_node('7'));
    chambers.append(new_node('8', 0, 1));
    chambers.append(new_node('9', 2, 3));
    chambers.append(new_node('10', 4, 5));
    chambers.append(new_node('11', 6, 7));
    chambers.append(new_node('12', 8, 9));
    chambers.append(new_node('13', 10, 11));
    chambers.append(new_node('14', 12, 13));

    let pyramid = Pyramid {
        top: 14,
        chambers: chambers
    };

    let actual_path = pyramid.search('k');
    assert(actual_path.is_none(), 'Unexpected path');
    
}