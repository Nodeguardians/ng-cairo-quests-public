fn play_flute_1(note: ByteArray) -> Array<ByteArray> {
    array![
        note.clone(), // (A)
        note, // (B)
        note.clone()  // (C)
    ]
}

fn play_flute_2(mut notes: Array<u256>) -> Array<u256> {
    let x = 42;

    notes.append(x); // (D)
    notes.append(x); // (E)

    notes
}

fn play_flute_3() {
    let mut notes_0 = array![1, 2, 3];

    let mut notes = play_flute_2(notes_0);

    let x = *notes[0]; // (F)
    notes.append(x); // (G)

    let y = *notes_0[0]; // (H)
    notes.append(y); // (I)
}

fn play_flute_4() {

    let last_note = "D";
    let mut notes = play_flute_1(last_note); // (J)
    notes.append(last_note.clone()); // (K)
    notes.append(last_note); // (L)

}