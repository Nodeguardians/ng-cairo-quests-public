use src::demon::{ 
    Demon,
    DemonTrait
};

#[test]
fn bush_demon_is_evil_test() {
    let demon = Demon::Bush;
    assert!(!demon.is_evil(), "Unexpected result!");
}

#[test]
fn cactus_demon_is_evil_test() {
    let demon = Demon::Cactus(0);
    assert!(!demon.is_evil(), "Unexpected result!");

    let demon = Demon::Cactus(1);
    assert!(!demon.is_evil(), "Unexpected result!");

    let demon = Demon::Cactus(11);
    assert!(!demon.is_evil(), "Unexpected result!");

    let demon = Demon::Cactus(8);
    assert!(demon.is_evil(), "Unexpected result!");

    let demon = Demon::Cactus(16);
    assert!(!demon.is_evil(), "Unexpected result!");

    let demon = Demon::Cactus(125);
    assert!(demon.is_evil(), "Unexpected result!");
}

#[test]
fn tree_demon_is_evil_test() {
    let demon = Demon::Tree(array![1, 3, 5, 7, 9]);
    assert!(demon.is_evil(), "Unexpected result!");

    let demon = Demon::Tree(array![2, 4, 6, 8, 10]);
    assert!(demon.is_evil(), "Unexpected result!");

    let demon = Demon::Tree(array![]);
    assert!(demon.is_evil(), "Unexpected result!");

    let demon = Demon::Tree(array![20]);
    assert!(demon.is_evil(), "Unexpected result!");

    let demon = Demon::Tree(array![1, 3, 5, 8, 9]);
    assert!(!demon.is_evil(), "Unexpected result!");

    let demon = Demon::Tree(array![9, 6, 7, 5, 2]);
    assert!(!demon.is_evil(), "Unexpected result!");
}

#[test]
fn bush_demon_cleanse_test() {
    let mut demon = Demon::Bush;
    demon.cleanse();

    let is_bush = match demon {
        Demon::Bush => true,
        _ => false
    };

    assert!(is_bush, "Unexpected demon!");
}

#[test]
fn cactus_demon_cleanse_test() {
    let mut demon = Demon::Cactus(11);
    demon.cleanse();

    let is_zero_cactus = match demon {
        Demon::Cactus(x) => x == 0,
        _ => false
    };

    assert!(is_zero_cactus, "Unexpected demon!");
}

#[test]
fn tree_demon_cleanse_test() {
    let mut demon = Demon::Tree(array![1, 1, 1]);
    demon.cleanse();

    let expected_demon = Demon::Tree(array![0, 0, 0]);

    assert!(demon == expected_demon, "Unexpected demon!");

    let mut demon = Demon::Tree(array![1, 1]);
    demon.cleanse();

    let expected_demon = Demon::Tree(array![0, 0]);

    assert!(demon == expected_demon, "Unexpected demon!");
}
