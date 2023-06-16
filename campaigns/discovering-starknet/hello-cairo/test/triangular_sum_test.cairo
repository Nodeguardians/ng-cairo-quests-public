use array::ArrayTrait;

use submission::level_3::triangular_sum;

#[test]
#[available_gas(1000000)]
fn test_triangular_sum() {
    let mut a = ArrayTrait::new();
    a.append(77);
    a.append(121);
    a.append(9191);
    a.append(11);
    a.append(41);
    assert(
        triangular_sum(a) == 55792, 
        'Incorrect sum'
    );

    a = ArrayTrait::new();
    a.append(77);
    a.append(121);
    a.append(9191);
    a.append(11);
    a.append(41);
    a.append(1912);
    a.append(1341);
    assert(
        triangular_sum(a) == 152316, 
        'Incorrect sum'
    );
}