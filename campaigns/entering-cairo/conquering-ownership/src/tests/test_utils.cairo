fn pow2(mut exponent: u8) -> u32 {
    let mut result: u32 = 1;

    while exponent > 0 {
        result *= 2;
        exponent -= 1;
    };

    result
}

fn checksum(str: ByteArray, mut expected_sum: u32) -> (u32, u32) {

    let mut i = 0;
    let mut missing = 0;
    let mut unexpected = 0;

    while i < str.len() {
        let char = str.at(i).unwrap();
        let index = char - 65;

        assert!(i < 26, "Unexpected character! Use only A-Z");
        let mask = pow2(index);

        if expected_sum & mask == 0 {
            unexpected += 1;
        } else {
            expected_sum = expected_sum ^ mask;
        }

        i += 1;
    };

    while expected_sum > 0 {
       missing += expected_sum % 2;
       expected_sum /= 2;
    };

    (missing, unexpected)
}