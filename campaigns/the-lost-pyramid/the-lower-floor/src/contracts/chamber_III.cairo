#[starknet::interface]
trait IChamberIII<TContractState> {
    fn is_exit_open(self: @TContractState) -> bool;
    fn defeat_eye(ref self: TContractState, scheme: u16);
}

#[starknet::contract]
mod ChamberIII {

    use array::ArrayTrait;

    #[storage]
    struct Storage {
        is_exit_open: bool
    }

    #[abi(embed_v0)]
    impl ChamberIII_Impl of super::IChamberIII<ContractState> {
        
        fn is_exit_open(self: @ContractState) -> bool {
            self.is_exit_open.read()
        }

        fn defeat_eye(ref self: ContractState, mut scheme: u16) {

                      let mut s: 
                  Array<bool> = ArrayTrait::
               new();                       let mut i 
            = 16;          loop { if                (i == 0) 
                     {break;}s.append(scheme               %2== 
                0);(       scheme/=2);    i-=1;
               };();       let b=(*s[        15]&&*s
            [14]            &&!*s[13              ]&&(*s[3] 
            ^*s[            12]))^((              *s[6]||!*s[11]
                )^(!*        s[1]&&          *s[12]                           )^(
                    *s[4]                 &&*s[9                          +0])   ^(
                         !*s[3]^*s[0]))&&                                        (*s
                   [11  ]^!(  *s[14]&&*s[                                      10])
                     &&((!*s[            9]&&                                *s[8])
                        ^!*s                [7]))&&((!*s             [2]^!*s[6])
                          &&                      ((!*s[5]^*s[13])||*s[0])
                          &&                         (!*s[1]&&*s[10]
                           ))
                            ;

            self.is_exit_open.write(b);
        }
    }
}