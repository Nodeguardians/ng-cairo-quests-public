fn tribonacci(n: u32) -> u128 {

    let mut a = 0;
    let mut b = 0;
    let mut c = 1;

    if (n == 0 | n == 1) { return 0; }
    else if (n == 2) { return 1; }

    let mut ctr = 3;
    loop {
        if (ctr > n) { break c; }

        let sum = a + b + c;
        a = b;
        b = c;
        c = sum;

        ctr += 1;
        
    }

}
