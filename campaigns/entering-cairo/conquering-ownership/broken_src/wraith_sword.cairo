#[derive(Drop)]
struct Sword {
    name: ByteArray,
    damage: u128
}

/////////////////////////////////////
//         Helper Functions        //
//    (there are no errors here)   //     
/////////////////////////////////////

fn swing_sword(sword_snapshot: @Sword) {
    // Do something...
}

fn thrust_sword(ref Sword: Sword) {
    // Do something else...
}

/////////////////////////////////////
//          Bad Functions          //
//     (there are errors here)     //
/////////////////////////////////////

fn fight_wraith_1(sword: Sword) {

    swing_sword(@sword);
    let sword_name_1: ByteArray = sword.name; // (A)
    let sword_name_2: @ByteArray = sword.name; // (B)

    let sword_snapshot = @sword;
    let sword_name_3: @ByteArray = sword_snapshot.name; // (C)

}

fn fight_wraith_2(sword_snapshot: @Sword) {

    sword_snapshot.damage += 5; // (D)

    swing_sword(sword_snapshot);
    let sword_damage = *sword_snapshot.damage; // (E)

    thrust_sword(ref sword_snapshot); // (F)

}

fn fight_wraith_3(ref sword: Sword) {

    sword.damage += 5; // (G)
    thrust_sword(ref sword);
    sword.damage += 5; // (H)

}

fn fight_wraith_4(swords: @Array<Sword>) {

    let sword_1: @Sword = swords[0]; // (I)
    let sword_2: Sword = swords[0]; // (J)

    let sword_3: Sword = *sword_1; // (K)

}
